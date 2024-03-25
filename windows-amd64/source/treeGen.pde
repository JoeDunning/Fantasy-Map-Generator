/*********************
---- Code Section ----
*/////////////////////


// treeGen - Class Definition
class treeGen {
  PVector position;   // PVector - x, y position.
  PImage image;       // PImage - Stored image/tree type.

  treeGen(PVector position, PImage image) {
    this.position = position;
    this.image = image;
  }
}

// Place Tree - Function for preparing and storing trees depending on call circumstances.
void placeTree(PImage image, float overlap, int x, int y, float startRange, float endRange, float noiseVal) {
  
  boolean canSpawnTree = true;
  for (treeGen tree : trees) {
    float distance = dist(x, y, tree.position.x, tree.position.y);
    float minDistance = (tree.image.width + tree.image.height) / 2 * overlap;
    
    if (distance < minDistance) {
      canSpawnTree = false;
      println("TreeGen: Error! Cannot Place " + tree.toString() + " at " + x + ", " + y + ". Distance: " + distance + " MinDistance: " + minDistance);
      break;
    }
  }
  
  PImage imgCopy = image.copy();
  float elevationCheckWidth = map(noiseVal, startRange, endRange, 0.95f, 1.1f); 
  float elevationCheckHeight = map(noiseVal, startRange, endRange, 0.85f, 1.1f); 
  
  int newWidth = int(imgCopy.width * elevationCheckWidth);
  int newHeight = int(imgCopy.height * elevationCheckHeight);
  int newTransparency = int(map(noiseVal, startRange, endRange, 190, 0));

  imgCopy.resize(newWidth, newHeight);
  tint(255, newTransparency);

  // PVector Array Storage - x & y represent the related co-ordinates, z represents mountain type.
  if (canSpawnTree) {
   trees.add(new treeGen(new PVector(x, y), imgCopy));
   println("TreeGen: Successfully placed at " + x + ", " + y);
  }
}
