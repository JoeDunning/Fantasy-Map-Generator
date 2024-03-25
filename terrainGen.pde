/***********************
---- Code Section ----
*/////////////////////

// Draw Terrain - Function for drawining initial canvas, landmasses and elevation generation
void drawTerrain() {
  terrain.beginDraw();                 // Begins terrain draw call
  terrainOutline.beginDraw();
  shallowWater.beginDraw(); 
  deepSea.beginDraw();
  dangerousSea.beginDraw();

  for (int x = 0; x < mapWidth; x++) {
    for (int y = 0; y < mapHeight; y++) {
      
      // -- Noise Logic & Definitions --
      float noiseVal = noiseMap[x][y]; // Float - Current noiseMap Value
      float colorFactor = map(noiseVal, 0.4, terrainScale, 0, 0.8);
      //float colorFactorDangerous = map(noiseVal, 0.1, 0.3, 0, 1); 
      
      if (noiseMap[x][y] < noiseMin) {
        noiseMin = noiseMap[x][y]; // Update the minValue if a smaller value is found
      }
      
      /************************
      ---- Land Generation ----
      *////////////////////////
      
      if (noiseVal > terrainScale) {
        // --- Coastline Tile Distance Calculation ---
        float coastTileDistance = calculateCoastDistance(x, y);
        coastTileDistance = min(coastTileDistance, searchRadius);
        
        float coastCalcFactor = map(coastTileDistance, 0, searchRadius, 0.5, 1);
        
        // --- Elevation Logic ---
        elevation = map(noiseVal, 0.6, 1, minElevation, maxElevation) * coastCalcFactor;
        
        // --- Terrain Logic ---
        terrain.set(x, y, landColour);
        terrainMap.add(new PVector(x, y));
        //shallowWater.set(x, y, debugColour3); // test
        
        // --- Coastline Generation ---
        if (noiseVal < 0.51) {
          terrain.set(x, y, coastColour);
        }
        
        if (hasWaterNeighbour(x, y, mapWidth, mapHeight)) {
          shallowWater.strokeWeight(2);
          shallowWater.stroke(shallowWaterCol); // Set shallow water color (blue with transparency)
          shallowWater.noFill();
          shallowWater.rect(x, y, 1, 1);  
          
          terrainOutline.stroke(debugColour1);     // Set Terrain outline RGBA
          terrainOutline.strokeWeight(1);        // Set Terrain outline (Stroke) thickness
          terrainOutline.noFill();                 // Disable fill - stops Terrain object being filled, but rather built upon.
          terrainOutline.rect(x, y, 1, 1);    
        } 
        
        // --- Mountain Generation ---
        
        // -- Threshold Logic
        if (elevation >= peakMountainThreshold) {
          PImage currentMountain = null;
          int subType = int(round(random(1, maxPMSubtype)));
          
          switch(subType) {
            case 1: 
              currentMountain = peakMountain1;
              break;
            case 2:
              currentMountain = peakMountain2;
              break;
          }
          
          placeMountain(currentMountain, maxPMOverlap, elevation, x, y);
          
          println("\n---------------------------------------------------------");
          println("drawTerrain: MountainGen - Peak Mountain Call");
          println("---------------------------------------------------------");
        
        } else if (elevation >= largeMountainThreshold) {
          PImage currentMountain = null;
          int subType = int(round(random(1, maxLMSubtype)));
          
          switch(subType) {
            case 1: 
              currentMountain = largeMountain1;
              break;
            case 2:
              currentMountain = largeMountain2;
              break;
            case 3:
              currentMountain = largeMountain3;
              break;
            case 4:
              currentMountain = largeMountain4;
              break;
          }
          
          placeMountain(currentMountain, maxLMOverlap, elevation, x, y);
          
          println("\n---------------------------------------------------------");
          println("drawTerrain: MountainGen - Large Mountain Call");
          println("---------------------------------------------------------");
          
        } else if (elevation >= mediumMountainThreshold) {
          PImage currentMountain = null;
          int subType = int(round(random(1, maxMMSubtype)));
          
          switch(subType) {
            case 1: 
              currentMountain = mediumMountain1;
              break;
            case 2:
              currentMountain = mediumMountain2;
              break;
            case 3:
              currentMountain = mediumMountain3;
              break;
            
          }
          
          placeMountain(currentMountain, maxMMOverlap, elevation, x, y);
          
          println("---------------------------------------------------------");
          println("drawTerrain: MountainGen - Medium Mountain Call");
          println("---------------------------------------------------------");
          
        } else if (elevation >= smallMountainThreshold && elevation <= mediumMountainThreshold) {
          PImage currentMountain = null;
          int subType = int(round(random(1, maxSMSubtype)));
          
          switch(subType) {
            case 1: 
              currentMountain = smallMountain1;
              break;
            case 2:
              currentMountain = smallMountain2;
              break;
            case 3:
              currentMountain = smallMountain3;
              break;
          }
          
          placeMountain(currentMountain, maxSMOverlap, elevation, x, y);

          println("---------------------------------------------------------");
          println("drawTerrain: MountainGen - Small Mountain Call");
          println("---------------------------------------------------------");
        } 
        
        // --- Treeline Generation ---
        
        // --  Low Mountain Treeline --
        if (noiseVal > 0.60f && noiseVal < 0.62f) {
          PImage currentTree = null;
          
          float startRange = 0.6f;
          float endRange = 0.62f;
          
          int subType = int(round(random(1, maxSTSubtype)));
          float overlapCalc = random(maxSTMOverlap - 0.25f, maxSTMOverlap + 0.2f);
         
          switch(subType) {
            case 1: 
              currentTree = smallTree1;
              break;
            case 2:
              currentTree = smallTree2;
              break;
            case 3:
              currentTree = smallTree3;
              break;
          }
          placeTree(currentTree, overlapCalc, x, y, startRange, endRange, noiseVal);
        }    
      }
      
      // Mid Land Tree Range -- NEEDS WORK TOMORROW
      if (noiseVal > 0.545f && noiseVal < 0.565f) {
        PImage currentTree = null;
          
        float startRange = 0.545f;
        float endRange = 0.56f;
        
        float overlapCalc;
        
        if (noiseVal > endRange - 0.05f) {
          currentTree = largeTree1;
          overlapCalc = random(maxLTOverlap - 0.2f, maxLTOverlap + 0.3f);
        } else if (noiseVal > startRange + 0.35f) {
          currentTree = mediumTree1;
          overlapCalc = random(maxMTOverlap - 0.1f, maxMTOverlap + 0.5f);
        } else {
          currentTree = smallTree1;
          overlapCalc = random(maxSTOverlap - 0.1f, maxSTOverlap + 0.6f);
        }
        
        placeTree(currentTree, overlapCalc, x, y, startRange, endRange, noiseVal);
        //terrain.set(x, y, debugColour1);
      }
      
      // --- Sea Generation ---
      if (noiseVal < terrainScale && noiseVal > noiseMin) {
        color blendedColor = lerpColor(deepWaterCol, shallowWaterCol, colorFactor);
        deepSea.set(x, y, blendedColor);
        seaMap.add(new PVector(x, y));
      }
      
      if (noiseVal < noiseMin * 1.2f) {
        //seaDangerMap.add(new PVector(x, y));
        //color blendedColor = lerpColor(debugColour1, debugColour3, colorFactorDangerous * 3.0f);
        //dangerousSea.set(x, y, debugColour1);
      }
    }
  }
  
  terrain.endDraw();
  terrainOutline.endDraw();
  shallowWater.endDraw();
  deepSea.endDraw();
  dangerousSea.endDraw();
  
  //decideThreat();
}


/**********************************
---- Noise & Utility Functions ----
*//////////////////////////////////


// Octave Noise - Function for generating additional fractal noise ontop of Perlin noise
float octaveNoise(float x, float y, int octaves, float persistence, float lacunarity) {
  float total = 0;  // Float - Return total
  float frequency = 1; // Float - Frequency of varience
  float amplitude = 1; // Float - Amplitude
  float maxValue = 0; // //Float - Max Value (Used for normalizing)

  for (int i = 0; i < octaves; i++) {
    total += noise(x * frequency, y * frequency) * amplitude;
    maxValue += amplitude;
    amplitude *= persistence;
    frequency *= lacunarity;
  }
  return total / maxValue;
}

// Get Neighbours - Gets and checks nearby neighbouring cells, used for border checking mostly in system
ArrayList<PVector> getNeighbours(int x, int y) {
  ArrayList<PVector> neighbours = new ArrayList<PVector>();
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      if (i == 0 && j == 0) continue;
      int newX = x + i;
      int newY = y + j;
      if (newX >= 0 && newX < mapWidth && newY >= 0 && newY < mapHeight) {
        neighbours.add(new PVector(newX, newY));
      }
    }
  }
  return neighbours;
}


/********************************
---- Terrain Check Functions ----
*////////////////////////////////


// Calculate Coast Distance - Logic function for checking current cell's distance from the nearest coastal tile.
float calculateCoastDistance(int x, int y) {
  float minDistance = Float.MAX_VALUE;

  for (int i = -searchRadius; i <= searchRadius; i++) {
    for (int j = -searchRadius; j <= searchRadius; j++) {
      int newX = x + i;
      int newY = y + j;
      if (newX >= 0 && newX < mapWidth && newY >= 0 && newY < mapHeight) {
        if (noiseMap[newX][newY] <= 0.6 && hasWaterNeighbour(newX, newY, mapWidth, mapHeight)) { 
          float distance = dist(x, y, newX, newY);
          minDistance = min(minDistance, distance);
        }
      }
    }
  }
  return minDistance;
}

// Has Water Neighbour - Function for checking if direct neighbour is a water tile
boolean hasWaterNeighbour(int x, int y, int mapWidth, int mapHeight) {
  ArrayList<PVector> neighbours = getNeighbours(x, y);
  coastal = false;
  for (PVector neighbour : neighbours) {
    int nx = (int) neighbour.x;
    int ny = (int) neighbour.y;
    if (noiseMap[nx][ny] <= 0.5) {
      if (nx == 0 || nx == mapWidth - 1 || ny == 0 || ny == mapHeight - 1) {
        coastal = true;
        break;
      }
      ArrayList<PVector> landNeighbours = getNeighbours(nx, ny);
      boolean foundLand = false;
      for (PVector landNeighbour : landNeighbours) {
        int lnX = (int) landNeighbour.x;
        int lnY = (int) landNeighbour.y;
        if (noiseMap[lnX][lnY] > 0.5) {
          foundLand = true;
          break;
        }
      }
      if (foundLand) {
        coastal = true;
        break;
      }
    }
  }
  return coastal;
}

// Get Elevation Max - Function for determining highest elevation point on a generated noiseset 
void getElevationLimits() {
  for (int x = 0; x < mapWidth; x++) {
    for (int y = 0; y < mapHeight; y++) {
      noiseMap[x][y] = octaveNoise(x * noiseScale, y * noiseScale, octaves, persistence, lacunarity);
      if (noiseMap[x][y] > terrainMaxElevation) {
        terrainMaxElevation = noiseMap[x][y];
      }
      if (noiseMap[x][y] < terrainMinElevation) {
        terrainMinElevation = noiseMap[x][y];
      }
    }
  }

  println("---------------------------------------------------------");
  println("getElevationLimits: Elevation Max: " + terrainMaxElevation);
  println("getElevationLimits: Elevation Max: " + terrainMinElevation);
  println("---------------------------------------------------------");
}

// Get Thresholds - Calculate mountainThresholds based on fitness values and elevation
void getThresholds() {
  peakMountainThreshold = terrainMaxElevation + peakMountainChance;        // Spawn Chance - Peak Mountain Threshold
  largeMountainThreshold = terrainMaxElevation * largeMountainChance;      // Spawn Chance - Large Mountain
  mediumMountainThreshold = terrainMaxElevation * mediumMountainChance;    // Spawn Chance - Medium Mountain
  smallMountainThreshold = terrainMaxElevation * smallMountainChance;      // Spawn Chance - Small Mountain
}
