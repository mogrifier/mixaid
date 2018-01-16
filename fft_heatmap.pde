import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT fft;
int xOffset = 0;

void setup()
{
//app window size
size(1600, 600);
minim = new Minim(this);
//CHANGEME choose an audio file from your system or the web
player = minim.loadFile("//Users//eizdepski//processing_sketchbook//techno-ise.wav");
player.play();

//setup the FFT to process this audio file
fft = new FFT(player.bufferSize(), player.sampleRate());

/*
EACH BIN IS ABOUT 43 Hz wide. there are 512. 22050Hz / 512 = 43. 
I think I need a way to "blow up" the view of the bands down in the key region (< 8kz)
Log view?
Magnify it?

*/


fft.window(FFT.BARTLETTHANN);

println("audio buffer size = " + player.bufferSize());
println("sample rate = " + player.sampleRate());

}

//for storing the real and imaginary components of a frequency band
float[] real;
float[] img;

void draw()
{
//background(#cccccc); // reset the display window
//rgba format

strokeWeight(3); // Thicker

//perform a forward fft on a buffer of audio
fft.forward(player.mix);
real = fft.getSpectrumReal();
img = fft.getSpectrumImaginary();

//use for centering the rendering in the window
xOffset++;
//float amplitude = 0.0f;  expect spectrum size = 513
//get the number of frequency bands and draw each one
for (int i = 0; i < fft.specSize(); i++)
{
//I want the spectrum stack up on the y axis. each value with color by amplitude.
  
//stroke sets the color based on amplitude
stroke(real[i] * 25, img[i] * 25, fft.getBand(i)*7, 170);

//line API is for point to point drawing using these coordniates:
//x1, y1, x2, y2

//getBand returns the amplitude. What a stupid method name. No need to calcul;ate it.
//amplitude = (float)(4* Math.sqrt(Math.pow(real[i], 2) + Math.pow(img[i], 2)));
//line (i , height, i , height - (fft.getBand(i) *4));
if (xOffset + 10 > width)
{
  xOffset = 0;
}
point (10 + xOffset, i);

}

}