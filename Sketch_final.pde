import processing.serial.*;
import camera3D.Camera3D;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.volume.*;
import toxi.processing.*;

Serial myPort;
Camera3D camera3D;
PGraphics axe;

//ToxiclibsSupport gfx;
VolumetricBrush brush;
VolumetricSpaceArray volume;
IsoSurface surface;
TriangleMesh mesh;

float x=0, y=0, z=0;
float joy_x, joy_y, joy_B;
float rot_x, rot_y;
float tx, ty, tz;
int nbre = 1;
int i=0;
int taille = 400;
float period = 1000/3.0;
float bout_mesh, bout_addPoint, bout_save, clear1, clear2;

ArrayList<coord> pos=new ArrayList<coord>(); 
ArrayList<coord> meshpt=new ArrayList<coord>();

String str = ("S,0,0,0,000,000,0,0,0,0,0,0,E") ,input;

float density=0.5;
float iso_threshold = 0.5;
Vec3D SCALE = new Vec3D(taille, taille, taille).scale(10);

boolean boolmeshage =false;

void setup()
{
  myPort = new Serial(this, Serial.list()[4], 115200);
  myPort.buffer(30);
  fullScreen(P3D);
  noLights();
  camera3D = new Camera3D(this);
  camera3D.setBackgroundColor(color(192));
  camera3D.renderDefaultAnaglyph().setDivergence(1);
  pos.add(new coord(0, 0, 0));
  axe = createGraphics(300, 300, P3D);

  //gfx=new ToxiclibsSupport(this);
  volume=new VolumetricSpaceArray(SCALE, taille, taille, taille);
  brush=new RoundBrush(volume, 0.1);
  surface=new ArrayIsoSurface(volume);
  mesh=new TriangleMesh();
}

void draw()
{
  background(0);
  axes();
  translate(width/2, height/2);
  joystick();
  noFill();
  stroke(255);
  strokeWeight(5);
  box(taille);
  update();
  drawCloud();   
  pointeur();
  meshage();
  clearPos();
  if (bout_save == 1)
  {
    saveSTL();
  }
  //gfx.mesh(mesh);
}
