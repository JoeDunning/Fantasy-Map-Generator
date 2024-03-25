/*********************
---- Code Section ----
*/////////////////////

// ZoneGen - Class Definition
class ZoneGen {
  int zoneWidth;
  int zoneHeight;
  PVector position;
  boolean coastCheck;
  PImage type;
  boolean ruinsCheck;
  boolean churchCheck;
  boolean towerCheck;
  
  ZoneGen(int zoneWidth, int zoneHeight, PVector position, boolean coastCheck, PImage type, boolean ruinsCheck, boolean churchCheck, boolean towerCheck) {
    this.zoneWidth = zoneWidth;
    this.zoneHeight = zoneHeight;
    this.position = position;
    this.coastCheck = coastCheck;
    this.type = type;
    this.ruinsCheck = ruinsCheck;
    this.churchCheck = churchCheck;
    this.towerCheck = towerCheck;
  }
}

// Select Strategic Points
void selectStrategicPoints() {
  println("selectStrategicPoints: Checking Points...");
  
  int[][] landZoneSizes = {{70, 30}, {40, 25}, {20, 20}};
  //int[][] seaZoneSizes = {{100, 60}, {70, 40}, {40, 30}};
  
  for (int[] size : landZoneSizes) {
    int zoneWidth = size[0];
    int zoneHeight = size[1];

    // Loop over the terrainMap instead of the entire map
    for (int i = 0; i < terrainMap.size(); i += 2) {
      PVector point = terrainMap.get(i);
      int x = (int) point.x;
      int y = (int) point.y;
      if (x > width || y > height) {
        continue;
      }
      
      boolean isCoastal = isNearCoast(x, y);
      boolean isRuins = false;
      boolean isChurch = false;
      boolean isTower = false;
      int zoneTypeRand = round(random(1, 3));
      
      // Verify if the point is on a suitable spot on the terrain
      if (isSuitableSpot(x, y, zoneWidth, zoneHeight) && (!isCoastal || coastalZoneCount < minimumCoastalZones)) {
        if (isCoastal) {
          coastalZoneCount++;
        }
        
        // Small Zone Handling
        if (zoneTypeRand == 3 && smallZoneCount < maxSmallZones) {
          PImage currentSpawn = null;               // Variable for current used spawn/image ID
          
          float ruinsChance = random(0, 1); // Random float for ruins spawn chance
          float ruinsThreshold = random(0.5, 1); // Random float for ruins spawn chance
          
          if (ruinsChance > ruinsThreshold) {
            ruinsCount++;
            isRuins = true;
            int ruinsType = int(round(random(1, 5)));
            switch(ruinsType) {
            
              // Ruins Selection
            case 1: 
              currentSpawn = ruins1;
              break;
            case 2:
              currentSpawn = ruins2;
              break;
            case 3:
              currentSpawn = ruins3;
              break;
            case 4:
              currentSpawn = ruins4;
              break;
            case 5:
              currentSpawn = ruins5;
              break;
            }
          } 
          
          // Small Zone Selection
          else {
            int zoneType = int(round(random(1, 4)));
            switch(zoneType) {
            
            case 1:
              currentSpawn = smallChurch;
              isChurch = true;
              break;
            case 2:
              currentSpawn = wizardTower;
              isTower = true;
              break;
           
            case 3:
              currentSpawn = watchTower;
              isTower = true;
              break;
           
            case 4:
              currentSpawn = guardTower;
              isTower = true;
              break;
            }
          }
          
          
          strategicZones.add(new ZoneGen(zoneWidth, zoneHeight, new PVector(x, y), isCoastal, currentSpawn, isRuins, isChurch, isTower));
          finalStrategicPoints.add(new PVector(x, y));
          smallZoneCount++;
          totalZones++;
        } 
        
        // Large Zone Handling - Priority for city spawn behind map landmarks (small) // fix town
        else if (zoneTypeRand == 1 && largeZoneCount < maxLargeZones) {
          PImage currentSpawn = null;               // Variable for current used spawn/image ID
          switch(raceType) {
            case 1:
              currentSpawn = humanTown;
              break;
            case 2:
              currentSpawn = halflingTown;
              break;
            case 3:
              currentSpawn = dwarfTown;
              break;
            case 4:
              currentSpawn = elfTown;
              break;
          }
          strategicZones.add(new ZoneGen(zoneWidth, zoneHeight, new PVector(x, y), isCoastal, currentSpawn, isRuins, isChurch, isTower));
          finalStrategicPoints.add(new PVector(x, y));
          
          largeZoneCount++;
          totalZones++;
        } 
        
        // Medium Zone Handling
        else if (zoneTypeRand == 2 && mediumZoneCount < maxMediumZones) {
          PImage currentSpawn = null;               // Variable for current used spawn/image ID
          int zoneType = int(round(random(1, 3)));
          switch(zoneType) {
            case 1:
              currentSpawn = mediumVillage1;
              break;
            case 2:
              currentSpawn = mediumVillage2;
              break;
            case 3:
              currentSpawn = mediumVillage3;
              break;
          }
          strategicZones.add(new ZoneGen(zoneWidth, zoneHeight, new PVector(x, y), isCoastal, currentSpawn, isRuins, isChurch, isTower));
          finalStrategicPoints.add(new PVector(x, y));
          mediumZoneCount++;
          totalZones++;
        }
        
      }
    }
  }
}

// Is Suitable Spot - Verifies strategic spots based on three factors: placement, proximity to strategic landmarks (coast, trees or mountains) & overlap calculation
boolean isSuitableSpot(int x, int y, int zoneWidth, int zoneHeight) {
  // Verify terrain type and avoid coast or other objects
  for (int i = 0; i < zoneWidth; i++) {
    for (int j = 0; j < zoneHeight; j++) {
      
      if (x + i >= mapWidth || y + j >= mapHeight) {
        return false; // The point is outside the map, so it's not suitable
      }
      
      if (noiseMap[x + i][y + j] <= terrainScale || hasWaterNeighbour(x + i, y + j, mapWidth, mapHeight)) {
        return false; // The point is on the coast or water, so it's not suitable
      }
    }
  }

  // Check for overlaps with other terrain objects
  if (isOverlappingWithTerrainObject(x, y, zoneWidth, zoneHeight)) {
    return false; // The point is overlapping with another terrain object, so it's not suitable
  }
  
  // Check if the point is close to the coast, a mountain, or a tree
  if (!isNearCoast(x, y) && !isNearMountainOrTree(x, y, zoneWidth, zoneHeight)) {
    return false; // The point is not near a coast, mountain, or tree, so it's not suitable
  }
  
  // Check for overlaps with other strategic points
  for (PVector point : finalStrategicPoints) {
    if (dist(x, y, point.x, point.y) < minDistanceBetweenPoints) {
      return false; // The point is too close to another strategic point, so it's not suitable
    }
  }
  
  for (ZoneGen zone : strategicZones) {
    if (x >= zone.position.x && x <= zone.position.x + zone.zoneWidth &&
        y >= zone.position.y && y <= zone.position.y + zone.zoneHeight) {
      return false; // The point is within another strategic zone, so it's not suitable
    }
  }
  
  println("isSuitableSpot: Strategic Point Identified at " + x + ", " + y);
  return true; // The point is suitable
}


// Is Near Coast - Internal call function for calculateCoastDistance (terrainGen)
boolean isNearCoast(int x, int y) {
  return calculateCoastDistance(x, y) <= cityCoastProximity;
}


// Is Near Mountain of Tree - Overlap Check function for mountain and trees specifically in reference to zones.
boolean isNearMountainOrTree(int x, int y, int zoneWidth, int zoneHeight) {
  // Check if there's a mountain or tree within a certain distance
  for (mountainGen mountain : mountains) {
    if (dist(x, y, mountain.position.x, mountain.position.y) < Math.max(zoneWidth, zoneHeight)) {
      return true;
    }
  }
  
  for (treeGen tree : trees) {
    if (dist(x, y, tree.position.x, tree.position.y) < Math.max(zoneWidth, zoneHeight)) {
      return true;
    }
  }

  return false;
}

// Draw Strategic Points - Function for drawing strategic zones (cities, towns and landmark generation)
void drawStrategicPoints(int raceType) { // adjust for zone type spawning / naming then done 
  
  boolean isChurch = false;
  boolean isRuins = false;
  boolean isTower = false;
  PImage borderBG;

  terrain.beginDraw();// Call begin draw for drawing stategic zone images (towns, ruins, etc)
  
  if (strategicZones.size() == 0) {
    println("drawStrategicZones: No Zones Available, returning..");
    return;
  }
  // Loop over generated zones
  for (ZoneGen zone : strategicZones) {
    
    
    String zoneName = ""; // String - Zone Name Storage
    float textY = zone.position.y;
    
    // Capital Name Storage / Large Zone Check
    if (zone.zoneWidth == 70) {
      zoneName = generateTownName(raceType, hostility, zone.coastCheck, isChurch, isRuins, isTower); 
      switch(raceType) {
        case 1:
          zone.type = humanTown;
          break;
        case 2:
          zone.type = halflingTown;
          break;
        case 3:
          zone.type = dwarfTown;
          break;
        case 4:
          zone.type = elfTown;
          break;
      }
      capitalName = zoneName;
    } 
    
    if (zone.zoneWidth == 40) {
      zoneName = generateTownName(raceType, hostility, zone.coastCheck, isChurch, isRuins, isTower); 
      int zoneType = int(round(random(1, 3)));
      
      switch(zoneType) {
        case 1:
          zone.type = mediumVillage1;
          break;
        case 2:
          zone.type = mediumVillage2;
          break;
        case 3:
          zone.type = mediumVillage3;
          break;
        
      }
    } 
    
    terrain.image(zone.type, zone.position.x, zone.position.y);
    // Church Check
    if (zone.churchCheck) {
      isChurch = true;
      zoneName = generateTownName(raceType, hostility, zone.coastCheck, isChurch, isRuins, isTower);
    } 
    
    // Ruins Check
    if (zone.ruinsCheck) {
      isRuins = true;
      borderBG = ruinsBG;
      zoneName = generateTownName(raceType, hostility, zone.coastCheck, isChurch, isRuins, isTower);
    } else {
      borderBG = zoneNameBorder;
    }
    
    // Tower Check
    if (zone.towerCheck) {
      isTower = true;
      zoneName = generateTownName(raceType, hostility, zone.coastCheck, isChurch, isRuins, isTower);
    } else {
      borderBG = zoneNameBorder;
    }
    // Text Image Definition - Town Name
    
    
    
    
    // Zone Positioning
    textY = zone.position.y + 3;

    if (zoneName == "") {
      zoneNullCount++;
      zoneName = generateTownName(raceType, hostility, zone.coastCheck, isChurch, isRuins, isTower); // get names working correctly
    }
    
    terrain.fill(0); // Text Colour Fill
    
    float textWidth = terrain.textWidth(zoneName);
    float textX = zone.position.x + (zone.zoneWidth / 2) - (textWidth / 2) ;
    int textPadding = 5; // Adjust this value to move text and border further from the zone
    
    terrain.image(borderBG, textX - 2, textY - 10 - textPadding, textWidth + 4, 12); // Add 4 to account for the 2 pixel padding on each side
    terrain.text(zoneName, textX, textY - textPadding); // map string length to use for scale of image
  }
  terrain.endDraw();
}

// Terrain Overlap Check - Local zone overlap function, checks overlap against other zones anmd terrain objects.
boolean isOverlappingWithTerrainObject(int x, int y, int zoneWidth, int zoneHeight) {
  int mountainSize = largeMountain1.width; // Use Large Mountain Overlap to Ensure no bounding issues
  int treeSize = largeTree1.width; // Use Large Tree Overlap to Ensure no bounding issues
  
  // Overlap Check - Zones
  for (ZoneGen zone : strategicZones) {
    if (x < zone.position.x + zone.zoneWidth &&
        x + zoneWidth > zone.position.x &&
        y < zone.position.y + zone.zoneHeight &&
        y + zoneHeight > zone.position.y) {
      println("drawStrategicPoints: Overlapping with another strategic zone at " + x + ", " + y);
      return true;
    }
  }
  
  // Overlap Check - Mountains
  for (mountainGen mountain : mountains) {
    if (x < mountain.position.x + mountainSize &&
        x + zoneWidth > mountain.position.x &&
        y < mountain.position.y + mountainSize &&
        y + zoneHeight > mountain.position.y) {
      return true; 
    }
  }

  // Overlap Check - Trees
  for (treeGen tree : trees) {
    if (x < tree.position.x + treeSize &&
        x + zoneWidth > tree.position.x &&
        y < tree.position.y + treeSize &&
        y + zoneHeight > tree.position.y) {
      return true;
    }
  }
  return false;
}
