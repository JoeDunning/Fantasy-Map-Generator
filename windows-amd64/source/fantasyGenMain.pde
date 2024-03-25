/*******************************************************************************************************************************************************************************************
---- fantasyGenMain - Main File ----

// System Functions
- void setup()
- void draw()

*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*************************
---- System Functions ----
*/////////////////////////


void setup() {
  // --- System / Canvas Setup ---
  println("-----------------------------");
  println("-- SYSTEM Startup...");
  println("-----------------------------");
  
  size(1200, 1000);                                          // Canvas Size - Image is downscaled to size this resolution
  background(deepWaterCol);                                  // Default Background - Colour of deep water used for uniform scheme
  
  drawFont = loadFont("fonts/Chiller-Regular-48.vlw");
  textFont(drawFont, 48);
  textAlign(CENTER, CENTER);                                 // Text Alignment - Defaulted to centre alignment
  textSize(24);                                              // Text Size - Defaulted to 24pt
  noStroke();                                                // Disables Default Stroke/Outline
  
  BG = loadImage("images/background.jpg");                   // Background Blend Image

  // --- noiseMap Setup ---
  noiseMap = new float[mapWidth][mapHeight];                 // noiseMap - Used for terrain and elevation with Perlin noise
  
  // --- Generative Graphics Setup ---
  mountains = new ArrayList<mountainGen>();                  // mountainGen - Mountains Array
  trees = new ArrayList<treeGen>();                          // treeGen - Trees Array
  
  terrain = createGraphics(mapWidth, mapHeight);             // PGraphics Definition - Terrain
  terrainOutline = createGraphics(mapWidth, mapHeight);      // PGraphics Definition - Terrain Outline
  shallowWater = createGraphics(mapWidth, mapHeight);        // PGraphics Definition - Shallow Water (Coast border)
  deepSea = createGraphics(mapWidth, mapHeight);             // PGraphics Definition - Deep Sea
  dangerousSea = createGraphics(mapWidth, mapHeight);        // PGraphics Definition - Dangerous Sea
 
  // -- Race Type Graphics Setup
  humanInfoImg = loadImage("images/lore-images/races/humanInfo.png"); 
  humanImage = loadImage("images/lore-images/races/human.jpg");
  
  dwarfImage = loadImage("images/lore-images/races/dwarf.jpg");
  dwarfInfoImg = loadImage("images/lore-images/races/dwarfInfo.png");
  
  elfImage = loadImage("images/lore-images/races/elf.jpg");
  elfInfoImg = loadImage("images/lore-images/races/elfInfo.png");
  
  halflingImage = loadImage("images/lore-images/races/halfling.jpg");
  halflingInfoImg = loadImage("images/lore-images/races/halflingInfo.png");
  
  // -- UI Graphics Setup --
  loadingImage = loadImage("images/ui-images/loading-image.jpg");
  borderBackground = loadImage("images/ui-images/border.jpg");
  nameBanner = loadImage("images/ui-images/nameBanner.png");
  footerBanner = loadImage("images/ui-images/footerBanner.png");
  
  zoneNameBorder = loadImage("images/ui-images/zoneName.jpg");
  ruinsBG = loadImage("images/ui-images/ruinsName.jpg");  
  loreBorder = loadImage("images/ui-images/loreArea.png");   
  
  // -- Mountain Graphics Setup --
  smallMountain1 = loadImage("images/mountain-images/small/small_mountain1.png");
  smallMountain2 = loadImage("images/mountain-images/small/small_mountain2.png");
  smallMountain3 = loadImage("images/mountain-images/small/small_mountain3.png");
  
  mediumMountain1 = loadImage("images/mountain-images/medium/medium_mountain1.png");
  mediumMountain2 = loadImage("images/mountain-images/medium/medium_mountain2.png");
  mediumMountain3 = loadImage("images/mountain-images/medium/medium_mountain3.png");
  
  largeMountain1 = loadImage("images/mountain-images/large/large_mountain1.png");  
  largeMountain2 = loadImage("images/mountain-images/large/large_mountain2.png");  
  largeMountain3 = loadImage("images/mountain-images/large/large_mountain3.png");  
  largeMountain4 = loadImage("images/mountain-images/large/large_mountain4.png");  
  
  peakMountain1 = loadImage("images/mountain-images/peak/peak_mountain1.png");  
  peakMountain2 = loadImage("images/mountain-images/peak/peak_mountain2.png"); 
  
  // -- Tree Graphics Setup --
  smallTree1 = loadImage("images/tree-images/small/tree_small1.png");
  smallTree2 = loadImage("images/tree-images/small/tree_small2.png");
  smallTree3 = loadImage("images/tree-images/small/tree_small3.png");
  
  mediumTree1 = loadImage("images/tree-images/medium/tree_medium1.png");
  //mediumTree1 = loadImage("tree_medium1.png");
  //mediumTree1 = loadImage("tree_medium1.png");
  
  largeTree1 = loadImage("images/tree-images/large/tree_large1.png");  
  
  // -- Small Zone Graphics Setup -- 
  watchTower = loadImage("images/zone-images/smallZones/lookoutTower.png");
  guardTower = loadImage("images/zone-images/smallZones/guardTower.png");
  wizardTower = loadImage("images/zone-images/smallZones/wizardTower.png");
  smallChurch = loadImage("images/zone-images/smallZones/church.png");
  
  // -- Medium Zone Graphics Setup -- 
  mediumVillage1 = loadImage("images/zone-images/mediumZones/medium-village1.png");
  mediumVillage2 = loadImage("images/zone-images/mediumZones/medium-village2.png");
  mediumVillage3 = loadImage("images/zone-images/mediumZones/medium-village3.png");
  
  // -- Large Zone Graphics Setup -- 
  dwarfTown = loadImage("images/zone-images/largeZones/dwarf-town.png");
  elfTown = loadImage("images/zone-images/largeZones/elf-town.png");
  halflingTown = loadImage("images/zone-images/largeZones/halfling-town.png");
  humanTown = loadImage("images/zone-images/largeZones/human-town.png");
  
  // -- Ruins Graphics Setup --
  ruins1 = loadImage("images/zone-images/smallZones/ruins/ruins1.png");
  ruins2 = loadImage("images/zone-images/smallZones/ruins/ruins2.png");
  ruins3 = loadImage("images/zone-images/smallZones/ruins/ruins3.png");
  ruins4 = loadImage("images/zone-images/smallZones/ruins/ruins4.png");
  ruins5 = loadImage("images/zone-images/smallZones/ruins/ruins5.png");

  // --- Terrain Method Calls ---
  getElevationLimits();              // Calculate elevation limits from noiseMap
  getThresholds();                   // Calculate thresholds based on elevation limits
  
  drawTerrain();                     // Main function call for drawing terrain
  isTerrainDrawn = true;             // Boolean flag for successful terrain drawing
  
  selectStrategicPoints();           // Called prior to map type calculation to determine amount of strategic points on map for towns, cities and landmarks
  
  generateMapType();                 // Determines populace and hostility of map
  
  drawStrategicPoints(raceType);     // Draws race specific landmarks and towns depending on generateMapType outcome
  
  getLandName();                     // Ensure land name is generated by calling external function
  getSeaName();                      // Ensure sea name is generated by calling external function
  
  generateLore(hostility);                    // Call generate lore
  // --- Post-Run Output Log ---
  println("-----------------------------"); 
  println("-- SYSTEM: Successful Run!");
  println("-----------------------------\n");

  println("---------- Debug ------------");
  
  println("Elevation Max: " + terrainMaxElevation);
  println("Elevation Min: " + terrainMinElevation);
  println("LM THRESH: " + largeMountainThreshold);
  println("MM THRESH: " + mediumMountainThreshold);
  println("SM THRESH: " + smallMountainThreshold);
  println("Noise Min: " + noiseMin);
  println("Noise Min * 1.1: " + noiseMin * 1.1);
  println("\n-- Mountain Debug --");
  
  println("Large Mountain Chance: " + largeMountainChance);
  println("Medium Mountain Chance: " + mediumMountainChance);
  println("Small Mountain Chance: " + smallMountainChance);
  
  println("\n-- Tree Debug --");
  println("Trees Spawned: " + trees.size());
  println("Mountains Spawned: " + mountains.size());
  
  println("\n-- Terrain Debug --");
  println("Sea Map Size: " + seaMap.size());
  println("Terrain Map Size: " + terrainMap.size());
  
  println("\n-- Zone Debug --");
  
  println("Final Strategic Points Size: " + strategicZones.size());
  
  println("Small Zones Max: " + maxSmallZones);
  println("Medium Zones Max: " + maxMediumZones);
  println("Large Zones Max: " + maxLargeZones);
  
  println("Small Zones Count: " + smallZoneCount);
  println("Medium Zones Count: " + mediumZoneCount);
  println("Large Zones Count: " + largeZoneCount);
  
  println("\n-- Populace Debug --");
  
  println("Populace Type: " + raceType);
  println("Hostility Setting: " + hostility);
  println("Hostility Threshold: " + hostilityThreshold);
  println("Ruins Count: " + ruinsCount);
  println("Zone Null Count: " + zoneNullCount);
  println(introString1);
}


/***********************
---- Draw Functions ----
*///////////////////////


// Main Draw - Processing Function Used for Draw 
void draw() {
  // -- Sea & Shallow Border Draw --
  image(deepSea, 0, 100, mapWidth, mapHeight);
  image(dangerousSea, 0, 100, mapWidth, mapHeight);
  image(shallowWater, 0, 100, mapWidth, mapHeight);
 
  // -- Terrain & Outline Draw --
  image(terrainOutline, 0, 100, mapWidth, mapHeight);
  image(terrain, 0, 100, mapWidth, mapHeight);
  
  // -- Tree Drawing --
  for (treeGen tree : trees) {
    image(tree.image, tree.position.x - 5, tree.position.y + 90);
  }
  
  // -- Mountain Drawing --
  for (mountainGen mountain : mountains) {
    image(mountain.image, mountain.position.x - 10, mountain.position.y + 90);
  } 

  // -- Map Blending --
  blendMode(MULTIPLY);
  image(BG, 0, 99, width, 721);
  blendMode(BLEND);  

  // -- Banner Definitions --
  // Header declaration
  image(nameBanner, 0, 0, width, 100);
  textFont(drawFont, 38);
  text(landName, 770, 49);
  fill(0);
  
  // -- Footer Declaration & Blending -- 
  image(footerBanner, 0, 820, width, 180);

  // -- Race Information -- 
  image(currentRaceImage, 14, 837, 260, 146);
  image(currentRaceInfoImage, 285, 837, 220, 146);  
  
  // -- Lore Image Generation --
  image(loreBorder, 546, 830, 630, 160);  
  
  // -- Text Generation --
  text("Area Attitude: " + (hostility ? "hostile" : "friendly"), 687, 865); 
  text("Area Population: " + (round(int(terrainMap.size() * 0.005))), 685, 910); 
  text("POI Count: " + totalZones, 647, 955); 
  
  textSize(24);  
  text(introString1, 985, 860);
  text(introString2, 985, 880);
  text(introString3, 985, 920);
  text(introString4, 985, 940);
  text(introString5, 985, 965);
}
