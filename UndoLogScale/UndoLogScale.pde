///////////////////////////
//  By Matthew Fala    ////
//      for Sanjole    ////
///////////////////////////
///////////////////////////

// Settings
final String input_image = "LogAM3025.PNG";
final String output_image = "unscaledLog_output.jpg";
final double calVal1 = 0.1;
final double calVal2 = 10;
final int pwr = 10;

// init
PImage log_img;
PImage lin_img; 
//int linScale = 3;
int pixel1 = 500;
int click;
boolean calibration_done = false;
boolean output_img = false;
int onPoint = 1;
int calX1, calX2;


void setup() {
  size(2000, 1000);
  log_img = loadImage(input_image);
  textAlign(CENTER, CENTER);

}

void draw() {
  background(51);
  image(log_img, 0, 0);
  
  // Wait for collection
  
  // Status update
  int ban_height = height/10;
  fill(21,27,31);
  rect(0, height - ban_height, width, ban_height);
  if (!calibration_done & onPoint == 1)
  {  
    fill(255);
    textSize(ban_height-40);
    text("Select X-Axis Handle 1: " + calVal1, width/2, height - ban_height/2);
  }
  else if (!calibration_done & onPoint == 2) {
    fill(200, 20, 20);
    rect(calX1, 0, 4, height - ban_height);
    fill(255);
    textSize(ban_height-40);
    text("Select X-Axis Handle 2: " + calVal2, width/2, height - ban_height/2);
  }
  else if (calibration_done & output_img) {
    // complete
    fill(200, 20, 20);
    rect(calX1, 0, 4, height - ban_height);
    rect(calX2, 0, 4, height - ban_height);
    fill(255);
    textSize(ban_height-40);
    text("Saved", width/2, height - ban_height/2);
  }
    
  // Input complete
  if (calibration_done & !output_img)
  {
    
    // status
    fill(200, 20, 20);
    rect(calX1, 0, 4, height - ban_height);
    rect(calX2, 0, 4, height - ban_height);
    fill(255);
    textSize(ban_height-40);
    text("Working...", width/2, height - ban_height/2);
    
    // Graph fit
    double b;
    double c;
    
    // Fit base 10 graph ( Checked ) 
    b = (calX1-calX2)/Math.log10(calVal1/calVal2);
    c = Math.log10(calVal1) - calX1/b;
    
    println("GraphFit:");
    println("B = " + b);
    println("C = " + c);
    
    // Create image and set transparent
    lin_img = createImage(log_img.width, log_img.height, ARGB);
    lin_img.loadPixels();
    for (int i = 0; i < lin_img.pixels.length; i++) {
      lin_img.pixels[i] = color(0,0,0,0); 
    }
    lin_img.updatePixels();
    
    double ratio = log_img.width/Math.log10(lin_img.width);
    
    for (int log_imgx = 0; log_imgx < log_img.width; log_imgx++) {
      
      // Get log value by pixel
      double correspExpoVal = Math.pow(10, (float(log_imgx)/b + c));
      int lin_imgx = (int) (calX1 + (correspExpoVal - calVal1)/(calVal2 - calVal1) * (calX2 - calX1)); 
        
      for (int log_imgy = 0; log_imgy < log_img.height; log_imgy++) {
             int lin_imgy = log_imgy;
             lin_img.set(lin_imgx,lin_imgy, log_img.get(log_imgx,log_imgy));  
      }
       
    }
    for (int lin_imgx = 0; lin_imgx < lin_img.width; lin_imgx++) {
      
      for (int lin_imgy = 0; lin_imgy < lin_img.height; lin_imgy++) {
         if (lin_imgx < calX1 || lin_imgx > calX2){
             lin_img.set(lin_imgx,lin_imgy, log_img.get(lin_imgx,lin_imgy));  
         }
         else {
           color mycolor = lin_img.get(lin_imgx,lin_imgy);
           // get nearest color;
           if (alpha(mycolor) == 0) {
             boolean done = false;
             int myx = lin_imgx-1;
              while (!done) {
                mycolor = lin_img.get(myx,lin_imgy);
                if (alpha(mycolor) != 0) {
                  done = true;
                }
              }
           }
           
           // Set
           lin_img.set(lin_imgx, lin_imgy, mycolor);
         }
      }
      
       
    }
    
    
    println(log_img.width);
    println(lin_img.width);
    lin_img.save(output_image);
    println("saved");
    output_img = true;
  }
}


void mousePressed() 
{
   
     if (onPoint == 1) {
       calX1 = mouseX;
       onPoint = 2;
       println("Point 1. Pixel Location: " + mouseX + ", Value: " + calVal1 + ".");
     }
     else if (onPoint == 2) {
       calX2 = mouseX;
       calibration_done = true;
       println("Point 2. Pixel Location: " + mouseX + ", Value: " + calVal2 + ".");
       onPoint = 3;  
   }
   
}
