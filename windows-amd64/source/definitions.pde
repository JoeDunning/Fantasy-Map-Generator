/***************************************************************************************************

---- System Definitions ----

*///////////////////////////////////////////////////////////////////////////////////////////////////

// --- Section/Terrain Definitions ---
PGraphics terrain;                      // PGraphics Object - General Terrain
PGraphics terrainOutline;               // PGraphics Object - Terrain Outline 
PGraphics shallowWater;                 // PGraphics Object - Shallow Water (Coast & Sea Spacer)
PGraphics deepSea;                      // PGraphics Object - Deep Sea (Water Area/Sea)

PGraphics dangerousSea;                 // PGraphics Object - Dangerous Sea (Deep Sea Danger Areas)
PGraphics dangerousLand;                // PGraphics Object - Dangerous Land (Land Danger Areas)

// --- System Variables ---
int searchRadius = 10;                  // int - Tile search radius ?????????
boolean isTerrainDrawn = false;         // Boolean - Terrain draw check

// -- Populace Outlook Variables -- 
boolean hostility;                      // Populace Hostility - Determined by ruins threshold fitness value (hostilityThreshold)
int hostilityThreshold;                 // Int - Ruins fitness value
int raceType;                           // Int - Race Type (1 - Human, 2 - Halfing, 3 - Dwarf, 4 - Elf)

// --- Canvas Variables ---
int mapWidth = 1200;                    // Int - Map Generation Height (Seperate to canvas)
int mapHeight = 720;                    // Int - Map Generation Width (Seperate to canvas)

PImage BG;                              // PImage - Background Image for Blending
PImage ruinsBG;                         // PImage - Ruins background
PFont drawFont;                         // PFont - Main drawing font for map title and lore

// --- Border Images ---
PImage borderBackground;                // PImage - Background image for border - blending
PImage loadingImage;                    // PImage - Overlay image for loading - awaiting likeness prompt for lore gen
PImage nameBanner;                      // PImage - Header banner used for map name, distance & icon key
PImage footerBanner;                    // PImage - Footer banner outline
PImage loreBorder;                      // PImage - Lore area border

// --- Race Type Images / Variables ---
PImage currentRaceImage;                // PImage - Current Race Image
PImage currentRaceInfoImage;            // PImage - Current Race Info Image

PImage humanImage;                      // PImage - Human race image
PImage humanInfoImg;                    // PImage - Human info image

PImage dwarfImage;                      // PImage - Dwarf race image
PImage dwarfInfoImg;                    // PImage - Dwarf info image

PImage elfImage;                        // PImage - Elf race image
PImage elfInfoImg;                      // PImage - Elf info image

PImage halflingImage;                   // PImage - Halfling race image
PImage halflingInfoImg;                 // PImage - Halfling info image

// -- Intro String Definitions --
String introString1;                    // String - Intro String 1
String introString2;                    // String - Intro String 1
String introString3;                    // String - Intro String 1
String introString4;                    // String - Intro String 1
String introString5;                    // String - Intro String 1

// -- Small Zone Images --
PImage ruins1;                          // PImage - Ruins Image 1
PImage ruins2;                          // PImage - Ruins Image 2
PImage ruins3;                          // PImage - Ruins Image 3
PImage ruins4;                          // PImage - Ruins Image 4
PImage ruins5;                          // PImage - Ruins Image 5

PImage watchTower;                      // PImage - Ruins Image 1
PImage guardTower;                      // PImage - Ruins Image 1
PImage wizardTower;                     // PImage - Ruins Image 1
PImage smallHouse;                      // PImage - Ruins Image 1
PImage smallChurch;                     // PImage - Ruins Image 1

// -- Medium Zone Images --
PImage mediumVillage1;                  // PImage - Medium Village 1
PImage mediumVillage2;                  // PImage - Medium Village 2
PImage mediumVillage3;                  // PImage - Medium Village 3

// --- Large Zone Images ---
PImage dwarfTown;                       // PImage - Dwarf capital
PImage halflingTown;                    // PImage - Halfling capital
PImage humanTown;                       // PImage - Human capital
PImage elfTown;                         // PImage - Elf capital

// --- Zone Generation Defininitions ---
int strategicPointSize = 30;                            // Int - Point Size
int minDistanceBetweenPoints = strategicPointSize * 3;  // Int - Min distance between points

PImage zoneNameBorder;                                  // PImage - Border for zone name tag

ZoneGen largeZone;                           // ZoneGen - Large zone
int zoneNullCount;                           // Int - Zone debug check
int totalZones;                              // Int - Total zones count

int smallZoneCount = 0;                      // Int - Small zone count
int mediumZoneCount = 0;                     // Int - Medium zone count
int largeZoneCount = 0;                      // Int - Large zone count

int maxSmallZones = round(random(10, 15));   // Int - Threshold for max small zones
int maxMediumZones = round(random(6, 8));    // Int - Threshold for max medium zones
int maxLargeZones = 1;                       // Int - Threshold for max large zones

int ruinsCount;                              // Int - Ruins count

int coastalZoneCount = 0;                    // Int - Coast zone count
int cityCoastProximity = 15;                 // Int - Minimum coast proximity for zone
int minimumCoastalZones = 5;                 // Int - Minimum ideal coastal zones

ArrayList<PVector> terrainMap = new ArrayList<PVector>();            // Array Def - terrainMap
ArrayList<PVector> seaMap = new ArrayList<PVector>();                // Array Def - seaMap

ArrayList<PVector> strategicPoints = new ArrayList<PVector>();       // Array Def - strategicPoints
ArrayList<PVector> finalStrategicPoints = new ArrayList<PVector>();  // Array Def - finalStrategicPoints
ArrayList<ZoneGen> strategicZones = new ArrayList<ZoneGen>();        // Array Def - strategicZones

// --- Colour Variables (Used in Map Generation & Debug)---
int landColour = color(187, 146, 96); 
int coastColour = color(175, 135, 85); 

int waterColour = color(0, 130, 130); 
int waterDebug = color(0, 140, 140);

int shallowWaterCol = color(219, 200, 179);
int deepWaterCol = color(178, 149, 117);
int dangerousWaterCol = color(160, 121, 89);

int debugColour1 = color(0, 0, 0, 100); 
int debugColour2 = color(128, 128, 128); 
int debugColour3 = color(255, 255, 255); 

// -- Zone Names --
String seaName;           // String - Sea name
String landName;          // String - Land (Map) name
String townName;          // String - Town Name

String mapType;           // String - Map Type (Races)

// -- Race Subtypes --
int commonSubType;        // Human Subtype
int halflingSubType;      // Hobbit Subtype
int dwarfSubType;         // Dwarf Subtype
int elfSubType;           // Elf Subtype

// -- Land Naming Definitions -- 
String[] landGoodPrefixes = {"Golden", "Shimmering", "Moonlit", "Pyre"};
String[] landGoodSuffixes = {"Cove", "Bay", "Sands", "Shores"};

String[] landBadPrefixes = {"Dead", "Formidable"};
String[] landBadSuffixes = {"Marshes", "Crag"};

// -- Sea Naming Definitions -- 
String[] seaGoodPrefixes = {"Tranquil", "Golden", "Plentiful", "Calm", "Resplendent", "Majestic", "Enchanting", "Serene", ""} ;
String[] seaGoodSuffixes = {"Waters", "Seas"};

String[] seaBadPrefixes = {"Cursed", "Turbulent", "Foaming", "Foul", "Torrential", "Doomed", "Overcumbent", "Destructive", "Poisoned", "Devil's", "Ravaging", "Deadly", "Wrecked"};
String[] seaBadSuffixes = {"Waters", "Seas", "Rapids", "Unknown", "Death"};

// -- Church Naming Definitions --
String[] churchGoodPrefixes = {"Holy", "Blessed", "Divine", "Revered", "Ancient"};
String[] churchGoodSuffixes = {"Church", "Site", "Grounds"};

String[] churchBadPrefixes = {"Ruined", "Profaned", "Corrupted", "Destroyed", "Cultist","Blasphemous", "Plagued", "Demonic"};
String[] churchBadSuffixes = {"Church", "Site", "Grounds", "Ruins"}; 

// -- Ruins Naming Definitions --
String[] ruinsPrefixes = {"Cursed", "Poisoned", "Forbidden", "Evil", "Ancient", "Crumbling", "Sinful", "Venomous", "Malignant", "Malefic"};
String[] ruinsSuffixes = {"Ruins", "Grounds", "Relic", "Burial Grounds", "Citadel"};

// – Watchtower Naming Definitions –
String[] towerPrefixes = {"Cursed", "Poisoned", "Forbidden", "Evil", "Ancient", "Rotten"};
String[] towerSuffixes = {"Ruins", "Grounds", "Relic", "Burial Grounds"};

// -- Common Town Combinations (Good & Bad Orientation) -- 
String[] humanGoodPrefixes = {"Green", "Dark", "Light", "Iron", "Silver", "Golden", "Copper", "Lockwood", "White", "Riven", "Storm", "Spring"};
String[] humanGoodSuffixes = {"Haven", "Gate", "Vale", "Hill", "Fort"};

String[] humanBadPrefixes = {"Forbidden", "Dark", "Cursewood", "Ghastly", "Desolate", "Forsaken","Wrecked", "Barren"};
String[] humanBadSuffixes = {"Vale", "Fell", "Hill", "Village", "Edge"};

String[] commonCoastNames = {"-On-The-Water", "-By-" + seaName, " Upon-" + seaName, };

// -- Halfing Town Combinations (Good Orientation Only) -- 
String[] halflingPrefixes = {"Brandywine", "Tookborough", "Northfarthing", "Bracegirdle", "Hardbottle", "Bullroarer", "Whitfurrow", "Withywindle", "Crickhollow"};
String[] halflingSuffixes = {"Gate", "Hill", "Village", "Hedge", "Bucks", "Grove"};

// -- Dwarf Town Combinations (Good & Cursed Orientation) -- 
String[] dwarfGoodPrefixes = {"Rock", "Iron", "Axe", "Broadaxe", "Cleaver", "Stout", "Anvil", "Deeprock", "Hammer", "Hearthstone"};
String[] dwarfGoodSuffixes = {"Isle", "Mining Town", "Ironfort", "Mining Village"};

String[] dwarfBadPrefixes = {"Fallen", "Cursed", "Overrun", "Burned"};
String[] dwarfBadSuffixes = {"Battlegrounds", "Mining Town", "Mining Village"};

String[] dwarfCoastNames = {" Crag", " Cliffhold", " Stonebay", " Ironport"};

// -- Elvish Town Combinations (Good & Cursed Orientation) -- 
String[] elfGoodPrefixes = {"Heavenly", "Serene", "Blessed", "Moonlit"};
String[] elfGoodSuffixes = {"Isle", "City", "Village"};

String[] elfBadPrefixes = {"Fallen", "Cursed", "Overrun", "Burned"};
String[] elfBadSuffixes = {"City", "Site", "Shrine"};

String[] elfCoastNames = {" Harbours", " Beaches", " Breezes", " Moonshores", " Sands"};

// --- Terrain Thresholds & Definitions ---
float terrainScale = 0.5f;                      // Float - Terrain generation limit

// --- Noise - Thresholds & Definitions ---
float[][] noiseMap;                             // Float - NoiseMap (Perlin Noise storage)

float noiseScale = 0.002f;                      // Float - Max noise generated
float noiseMin = Float.MAX_VALUE;               // Float - Min noise generated

int octaves = 6;                                // Int - Layers of noise
float persistence = 0.5f;                       // Float - Amplitude control
float lacunarity = 2.2f;                        // Float - Frequency from each successisive layer

// --- Landmark & Terrain - Thresholds & Definitions ---
float elevation;                                          // Float - Elevation store
float terrainMaxElevation = 0f;                           // Float - Max elevation generated
float terrainMinElevation = Float.MAX_VALUE;              // Float - Min elevation generated

float minElevation = 0.0f;                                // Float - Maximum elevation amount
float maxElevation = 1.0f;                                // Float - Minimum elevation amount

boolean coastal;                                          // Boolean - Coastal Check

// -- Tree Image/Type Definitions --
ArrayList<treeGen> trees;      // Array Definition - TreeGen

PImage smallTree1;             // PImage Definition - Small Tree 1
PImage smallTree2;             // PImage Definition - Small Tree 2
PImage smallTree3;             // PImage Definition - Small Tree 3

PImage mediumTree1;            // PImage Definition - Medium Tree 1
PImage mediumTree2;            // PImage Definition - Medium Tree 2
PImage mediumTree3;            // PImage Definition - Medium Tree 3

PImage largeTree1;             // PImage Definition - Large Tree 1
PImage largeTree2;             // PImage Definition - Large Tree 2
PImage largeTree3;             // PImage Definition - Large Tree 3

// -- Treeline Thresholds -- 
float maxSTOverlap = 0.6f;     // 0verlap Threshold - Small Tree
float maxSTMOverlap = 1.05f;   // 0verlap Threshold - Small Tree (Mountain Treeline Specific)
int maxSTSubtype = 3;          // Subtype Threshold - Small Tree

float maxMTOverlap = 1.0f;     // 0verlap Threshold - Medium Tree
int maxMTSubtype = 3;          // Subtype Threshold - Medium Tree

float maxLTOverlap = 1.3f;     // 0verlap Threshold - Large Tree
int maxLTSubtype = 3;          // Subtype Threshold - Large Tree

// -- Mountain Type & Array Definitions
ArrayList<mountainGen> mountains;       // ArrayList - Mountain storage for spawning

PImage peakMountain1;                    // PImage Definition - Peak Mountain 1
PImage peakMountain2;                    // PImage Definition - Peak Mountain 2 

PImage largeMountain1;                   // PImage Definition - Large Mountain 1
PImage largeMountain2;                   // PImage Definition - Large Mountain 2
PImage largeMountain3;                   // PImage Definition - Large Mountain 3
PImage largeMountain4;                   // PImage Definition - Large Mountain 4

PImage mediumMountain1;                  // PImage Definition - Medium Mountain 1 
PImage mediumMountain2;                  // PImage Definition - Medium Mountain 2
PImage mediumMountain3;                  // PImage Definition - Medium Mountain 3

PImage smallMountain1;                   // PImage Definition - Small Mountain 1
PImage smallMountain2;                   // PImage Definition - Small Mountain 2
PImage smallMountain3;                   // PImage Definition - Small Mountain 3

// -- Mountain Thresholds --
float peakMountainThreshold;            // Spawning threshold (elevation) for peak mountains
float largeMountainThreshold;           // Spawning threshold (elevation) for large mountains
float mediumMountainThreshold;          // Spawning threshold (elevation) for medium mountains
float smallMountainThreshold;           // Spawning threshold (elevation) for small mountains

float maxPMOverlap = 0.2f;              // 0verlap Threshold - Peak Mountain  
int maxPMSubtype = 2;                   // Subtype Threshold - Peak Mountain  

float maxLMOverlap = 0.6f;              // 0verlap Threshold - Large Mountain  
int maxLMSubtype = 4;                   // Subtype Threshold - Large Mountain  

float maxMMOverlap = 0.8f;              // 0verlap Threshold - Medium Mountain                 
int maxMMSubtype = 3;                   // Subtype Threshold - Medium Mountain  

float maxSMOverlap = 1.1f;              // 0verlap Threshold - Small Mountain
int maxSMSubtype = 3;                   // Subtype Threshold - Small Mountain

float peakMountainChance = 0.135f;      // Spawn Chance - Peak Mountain
float largeMountainChance = 0.13f;      // Spawn Chance - Large Mountain
float mediumMountainChance = 0.10f;     // Spawn Chance - Medium Mountain
float smallMountainChance = 0.05f;      // Spawn Chance - Small Mountain

// --- LoreGen Text Definitions
int mapLifespan = 0;                    // Int - Lifespan Default
String raceName;                        // String - Race Name
String capitalName = "";                // String - Capital city name
