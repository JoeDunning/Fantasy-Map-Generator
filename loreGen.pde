/*********************
---- Code Section ----
*/////////////////////

// Generate Town Names - Function for generating town names depending on the populace's hostility and race.
String generateTownName(int raceType, boolean populaceFriendly, boolean isCoastal, boolean isChurch, boolean isRuins, boolean isTower) {
  int randPrefix, randSuffix, randCoast;
  String townName = "";
  
  // Type Check - Ruins
  if (isRuins) {
    randPrefix = (int) random(ruinsPrefixes.length);
    randSuffix = (int) random(ruinsSuffixes.length);
    
    townName = ruinsPrefixes[randPrefix] + " " + ruinsSuffixes[randSuffix];
  }
  
  // Type Check - Church
  if (isChurch) {
    randPrefix = (int) random(churchGoodPrefixes.length);
    randSuffix = (int) random(churchGoodSuffixes.length);
    
    townName = churchGoodPrefixes[randPrefix] + " " + churchGoodSuffixes[randSuffix];
  } 
  
  // Type Check - Tower
  if (isTower) {
    randPrefix = (int) random(towerPrefixes.length);
    randSuffix = (int) random(towerSuffixes.length);
    
    townName = towerPrefixes[randPrefix] + " " + towerSuffixes[randSuffix];
  }
  
  else if (isChurch && !populaceFriendly) {
    randPrefix = (int) random(churchBadPrefixes.length);
    randSuffix = (int) random(churchBadSuffixes.length);
    
    townName = churchBadPrefixes[randPrefix] + " " + churchBadSuffixes[randSuffix];
  }  
  // Check for hostility
  if (hostility) {
    
    // Race Check - Determined by generateMapType (loreGen)
    switch(raceType) {
      
      case 1:
        randPrefix = (int) random(humanGoodPrefixes.length);
        randSuffix = (int) random(humanGoodSuffixes.length);
        if (isCoastal) {
          randCoast = (int) random(commonCoastNames.length);
          townName = humanGoodPrefixes[randPrefix] + " " + humanGoodSuffixes[randSuffix] + commonCoastNames[randCoast];
        } else {
          townName = humanGoodPrefixes[randPrefix] + " " + humanGoodSuffixes[randSuffix];
        }
        break;
        
      case 2:
        randPrefix = (int) random(halflingPrefixes.length);
        randSuffix = (int) random(halflingSuffixes.length);
        if (isCoastal) {
          randCoast = (int) random(commonCoastNames.length);
          townName = halflingPrefixes[randPrefix] + " " + halflingSuffixes[randSuffix] + commonCoastNames[randCoast];
        } else {
          townName = halflingPrefixes[randPrefix] + " " + halflingSuffixes[randSuffix];
        }
        break;
        
      case 3:
        randPrefix = (int) random(dwarfGoodPrefixes.length);
        randSuffix = (int) random(dwarfGoodSuffixes.length);
        townName = dwarfGoodPrefixes[randPrefix] + " " + dwarfGoodSuffixes[randSuffix];
        break;
        
      case 4:
        randPrefix = (int) random(elfGoodPrefixes.length);
        randSuffix = (int) random(elfGoodSuffixes.length);
        townName = elfGoodPrefixes[randPrefix] + " " + elfGoodSuffixes[randSuffix];
        break;
        
      default:
        townName = "Unknown"; // ISSUE HERE
    }
  } 
  
  // Check for hostility
  else if (!hostility) {
    
    // Race Check - Determined by generateMapType (loreGen)
    switch(raceType) {
      case 1:
        randPrefix = (int) random(humanBadPrefixes.length);
        randSuffix = (int) random(humanBadSuffixes.length);
        townName = humanBadPrefixes[randPrefix] + " " + humanBadSuffixes[randSuffix];
        break;
        
      case 3:
        randPrefix = (int) random(dwarfBadPrefixes.length);
        randSuffix = (int) random(dwarfBadSuffixes.length);
        townName = dwarfBadPrefixes[randPrefix] + " " + dwarfBadSuffixes[randSuffix];
        break;
        
      case 4:
        randPrefix = (int) random(elfBadPrefixes.length);
        randSuffix = (int) random(elfBadSuffixes.length);
        townName = elfBadPrefixes[randPrefix] + " " + elfBadSuffixes[randSuffix];
        break;
        
      default:
        townName = "Unknown";
    }
  }
  return townName;
}

// Generate Map Type - Function for selecting populace type of generated map, and in extension the lore of the map
void generateMapType() {
  hostilityThreshold = round(smallZoneCount * 0.5);
  if (ruinsCount > hostilityThreshold) {
    hostility = true;
  }
  
  //int mapSize = terrainMap.size();
  int treesAmount = trees.size();
  int mountainsAmount = mountains.size();
  //int seaSize = seaMap.size();
  
  println("generateMapType: Selecting Type..");
  
  // Elvish Type
  if (treesAmount > 300 && mountainsAmount < 100) { 
    raceType = 4;
    raceName = "Elves";
    
    currentRaceImage = elfImage;
    currentRaceInfoImage = elfInfoImg;
  } 
  
  // Dwarvish Type
  else if (mountainsAmount > 500) {
    raceType = 3;
    raceName = "Dwarves";
    
    currentRaceImage = dwarfImage;
    currentRaceInfoImage = dwarfInfoImg;
  } 
  
  // Human/Common Type
  else if (treesAmount < 200 && mountainsAmount < 250 && mountainsAmount > 50 || treesAmount < 10 && mountainsAmount < 10) {
    raceType = 1;
    raceName = "Humans";
    
    currentRaceImage = humanImage;
    currentRaceInfoImage = humanInfoImg;
    
  } 
  
  else if (treesAmount > 200 && treesAmount < 500 && mountainsAmount < 50 && largeZoneCount == 0 || largeZoneCount == 0 && mountainsAmount < 50) {
    raceType = 2;
    raceName = "Hobbits";
    
    currentRaceImage = halflingImage;
    currentRaceInfoImage = halflingInfoImg;

  } else {
    raceType = 1;
    raceName = "Humans";
    
    currentRaceImage = humanImage;
    currentRaceInfoImage = humanInfoImg;
  }
  
  // Null Check - If the terrain isn't returning a choice under these factors, extra investigation is taken to decide orienatation and race.
  if (currentRaceImage == null) {
    int raceRandom = int(round(random(1, 2)));
    
    switch(raceRandom) {
      case 1:
        raceType = 1;
        raceName = "Humans";
        
        currentRaceImage = humanImage;
        currentRaceInfoImage = humanInfoImg;
        
        break;
      case 2:
        
        // Initial Random to Dwarf, Given Conditions
        if (mountainsAmount > 100) {
          raceType = 3;
          raceName = "Dwarves";
          
          currentRaceImage = dwarfImage;
          currentRaceInfoImage = dwarfInfoImg;
          
          dwarfSubType = 1;
          //generateDwarfLore(dwarfSubType);
        } 
        
        // Default to Human
        else {
          raceType = 1;
          raceName = "Humans";
          
          currentRaceImage = humanImage;
          currentRaceInfoImage = humanInfoImg;
        }
        break;
    }
  }
}

// Get Land Name - Function for generating land name
void getLandName() {
  int randPrefix, randSuffix;
  
  if (hostility) {
    randPrefix = (int) random(landBadPrefixes.length);
    randSuffix = (int) random(landBadSuffixes.length);
    
    landName = landBadPrefixes[randPrefix] + " " + landBadSuffixes[randSuffix];
    
  } else if (!hostility) {
    randPrefix = (int) random(landGoodPrefixes.length);
    randSuffix = (int) random(landGoodSuffixes.length);
    
    landName = landGoodPrefixes[randPrefix] + " " + landGoodSuffixes[randSuffix];
    
  } else {
    landName = "Error Island!";
    println("getLandName: Error!");
  }
}

// Get Sea Name - Function for generating sea name
void getSeaName() {
  int randPrefix, randSuffix;
  
  if (hostility) {
    randPrefix = (int) random(seaBadPrefixes.length);
    randSuffix = (int) random(seaBadSuffixes.length);
    
    seaName = seaBadPrefixes[randPrefix] + " " + seaBadSuffixes[randSuffix];
    
  } else if (!hostility) {
    randPrefix = (int) random(seaGoodPrefixes.length);
    randSuffix = (int) random(seaGoodSuffixes.length);
    
    seaName = seaGoodPrefixes[randPrefix] + " " + seaGoodSuffixes[randSuffix];
    
  } else {
    seaName = "Error Isles!";
    println("getSeaName: Error!");
  }
}


void generateLore(boolean hostility) {
  mapLifespan = int(round(random(800,7000)));
  
  introString1 = ("The islands of " + landName + " are " + (hostility ? "hostile" : "friendly") + "to travellers,"); 
  introString2 = ("take that as ye will; don't go meddling. ");
  introString3 = (raceName + " inhabit these lands and they ");
  introString4 = (" have done for " + mapLifespan + " years.");
  introString5 = (capitalName + "is the Capital, keep your noses clean.");
}
