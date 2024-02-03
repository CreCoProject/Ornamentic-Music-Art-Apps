// Initalisation Function
void setup(){
  // Create a Canvas Landscaped 500*300 Pixels
  size(500, 300);
  // Set Color Mode to RGB and Range 0 to 100
  colorMode(RGB, 100);
  // Prsent the Menue
  menue();
}

// Function to Present the Menue
void menue()
{
  // Grating and Menue Function presentation 
  println(" Welcome to the Ornamentic Line Grapher");
  println(" --------------------------------------");
  println("  Press n to crate a new Image");
  println("  Press s to save the actual Image");
}

// Class for Handling the Colors in the Ornament
class colorOfUse{
  // Declaration of Memory for the Colors
  color c; // Sequence Main Color
  color cv; // Vibration derivated Color 
  
  // Sequence Main Differnce to transform
  int SeqRedDelta; // Seq Main difference Read 
  int SeqGreenDelta; // Seq Main difference Green
  int SeqBlueDelta; // Seq Main difference  Blue
  
  // Vibration Derrived Difference to transform
  int VibRedDelta; // Vib derrived Read
  int VibGreenDelta; // Vib derrived  Green
  int VibBlueDelta; // Vib derrived  Blue
  
  // Initialise Constructor for the Model of Color
  colorOfUse(){
    // Genrate a Starting Color
    c = color( random(100), random(100), random(100));
    // Set the derived vibration Color for default
    cv = c;
    
    // Generate Sequance Main Delta Transformation Values
    // from whole Range
    SeqRedDelta = int(random(100)); // Set Delta Transform for Red
    SeqGreenDelta = int(random(100)); // Set Delta Transform for Green
    SeqBlueDelta = int(random(100)); // Set Delta Transform for Blue
    
    // Generate Vibration Derived Delta Transformation Values
    // Values here are smaller then for the Sequence Main Delta Valus
    VibRedDelta = int(random(SeqRedDelta)); // Set Delta Transform forRed
    VibGreenDelta = int(random(SeqGreenDelta)); // Set Delta Transform for Green
    VibBlueDelta = int(random(SeqBlueDelta)); // Set Delta Transform for Blue
    
    
  }
  
  // Functoion to make the Color Change in the Sequence
  void colorSequenceChange()
  {
    // Derviate the Channels from the Main Sequence Coor
    float r = red(c); // Read the Red Channel
    float g = green(c); // Read the Green Channel
    float b = blue(c); // Read the Blue Channel
    
    // Calculate the Transformation on the Color
    // Add Transformation Color and Modulo Map on Color Range 
    r = (r + SeqRedDelta)%100; // Callculation for Red
    g = (g + SeqGreenDelta)%100; // Callculation for Green
    b = (b + SeqBlueDelta)%100; // Callculation for Blue
    
    // Generate new Color for the new Sequece
    c = color(r, g, b);
    cv = c; // Set also the Vibrtion Color 
    
  }
  
  // Function to make the Change in the Vibration
  void colorVibrationChange()
  {
    // 
    // Derviate the Channels from the Main Sequence Coor
    float r = red(c); // Read the Red Channel
    float g = green(c); // Read the Green Channel
    float b = blue(c); // Read the Blue Channel
    
    // Calculate the Color Change for the Vibration Color
    // Calculate the Direction Value
    int op = int(random(3))-1;
    // Calculate the Channels for the Coor
    r = (r + (VibRedDelta*op))%100; // Calculate new Red Value
    g = (g + (VibGreenDelta*op))%100; // Calculate new Green Value
    b = (b + (VibBlueDelta*op))%100; // Calculate new Blue Value
    
    // Generate new Vibration Color 
    cv = color(r, g, b);
    
  }
  
  // Getter Function to return the Vibration Color 
  color getColor()
  {
    return cv;
  }
  
}

// Function to draw the Vibration Box Element
// needs Cordinates for upper left Corner of Box and there width and height
void createVibrationBox(int x, int y, int w, int h, colorOfUse c)
{
  // Calls Change for Vibration Color
  c.colorVibrationChange();
  // Set fill to draw on new Vibration Color
  fill(c.getColor());
  // Draws Vibration Box Element
  rect(x, y, w, h);
}

// Function to build the new Sequence
// needs Cordinates for upper left Corner of Box and there width and height
void createSeqBox(int x, int y, int w, int h, colorOfUse c)
{
  // Calls Change for Sequence Main Color
  c.colorSequenceChange();
  // Choose number of Vibration Elements in the Sequence
  int n = int(random(5))+1;
  // Iterates over number of Vibrtion Elements in actual Sequence
  for( int xn = 0; xn <= n; xn++)
  {
    // Calls Funtcion to draw the Vibration Element
    // Callculate horizontal Starting Point and width of
    // each Vibration Box Element
    createVibrationBox( int(w/n*xn), 0, int(w/n), h, c);
  }
}

// Funcion to generate a new Image
void createImage(){
  // Intialise the Model of Color
  colorOfUse c = new colorOfUse();
  // Choose the Number of Sequencs
  int n = int(random(5))+1;
  // Iterrate about Elements of Sequences
  for( int x = 0; x < n; x++)
  {
    createSeqBox( int(width/n*x), 0, int(width/n), height, c);
  }
}

// Dumnmy Draw Method
void draw(){}

// Controll Menue Operation Calls
void keyPressed()
{
  // Switch about pressed Key
  switch (key){
    // If Menue Operation new Image Geneate it
    case 'n' : createImage(); break;
    // if Menue Operation save Image save it 
    case 's' : save("Output.png"); break;
}
}
