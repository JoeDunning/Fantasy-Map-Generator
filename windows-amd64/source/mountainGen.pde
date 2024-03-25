/*********************
---- Code Section ----
*/////////////////////

// mountainGen - Class Definition
class mountainGen {
  PVector position;      // PVector - x, y position.
  PImage image;          // PImage - Stored image/tree type.

  mountainGen(PVector position, PImage image) {
    this.position = position;
    this.image = image;
  }
}

// Place Mountain - Function for placing mountain depending on type and available space
void placeMountain(PImage image, float overlap, float elevation, int x, int y) {

  boolean canSpawnMountain = true;

  for (mountainGen mountain : mountains) {

    float distance = dist(x, y, mountain.position.x, mountain.position.y);
    float minDistance = (mountain.image.width + mountain.image.height) / 2 * overlap;
    if (distance < minDistance) {
      canSpawnMountain = false;
      println("MountainGen: Error! Cannot Place " + mountain.toString() + " at " + x + ", " + y + ". Distance: " + distance + " MinDistance: " + minDistance);
      break;
    }
  }
  
  // Image Manipulation (Resize: width & height & transparency
  PImage imgCopy = image.copy();
  
  float elevationCheckWidth = map(elevation, minElevation, maxElevation, 0.9f, 1.2f); 
  float elevationCheckHeight = map(elevation, minElevation, maxElevation, 0.6f, 2.3f); 
  
  int newWidth = int(imgCopy.width * elevationCheckWidth);
  int newHeight = int(imgCopy.height * elevationCheckHeight);
  int newTransparency = int(map(elevation, minElevation, maxElevation, 140, 245));
  
  imgCopy.resize(newWidth, newHeight);
  tint(255, newTransparency);
  
  // PVector Array Storage - x & y represent the related co-ordinates, z represents mountain type.
  if (canSpawnMountain ) {
    mountains.add(new mountainGen(new PVector(x, y), imgCopy));
    println("MountainGen: Successfully placed " + imgCopy.toString() + " at " + x + ", " + y);
  }
}
