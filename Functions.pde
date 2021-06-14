void meshage()
{
  if (bout_mesh == 1)
  {
    fill(0);
    stroke(255);
    beginShape(TRIANGLE_STRIP);
    for (int j=0; j<(pos.size())/2; j++)
    {
      int compt = pos.size()-1-j;
      coord tmp1;
      coord tmp2;
      tmp1=pos.get(j);
      tmp2=pos.get(compt);
      vertex(tmp1.getX(), tmp1.getY(), tmp1.getZ());
      vertex(tmp2.getX(), tmp2.getY(), tmp2.getZ());
    }
    endShape();
    
    if (boolmeshage==true)
    {
      meshpt.clear();
      addPoint();
      boolmeshage = false;
    }
  }
}

void clearPos()
{
  if (clear1 == 0 && clear2 == 0)
  {
    pos.clear();
    meshpt.clear();
    x = 0;
    y = 0;
    z = 0;
  }
}


void pointeur()
{
  pushMatrix(); 
  long t = millis();
  if (((int)(t / period)) % 2==1)
  {
    translate(x, y, z);
    sphere(3);
  }
  popMatrix();
}

void drawLine() {
  beginShape();
  for (int k = 0; k<pos.size(); k++)
  {
    coord tmp;
    tmp=pos.get(k);
    vertex(tmp.getX(), tmp.getY(), tmp.getZ());
  }
  endShape();
}

void drawCloud() {
  for (int k = 0; k<pos.size(); k++)
  {
    coord tmp;
    tmp=pos.get(k);
    point(tmp.getX(), tmp.getY(), tmp.getZ());
  }
}

void joystick() {

  float angle = PI/256;

  if (joy_x>432&&joy_x<438)
    joy_x=451.5;
  joy_x=map(joy_x, 0.0, 903, angle, -angle);
  if (joy_y>440&&joy_y<448)
    joy_y=451.5;
  joy_y=map(joy_y, 0.0, 903, angle, -angle);

  rot_x+=joy_x;
  rot_y+=joy_y;

  rotateX(rot_x);
  rotateY(rot_y);

  if (joy_B == 1)
  {
    rot_x = 0;
    rot_y = 0;
  }
}


void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {

    inString = trim(inString); 
    str += inString;
    input = str.substring(str.indexOf("S"), 29);
    float inputs[] = float(split(input, ','));
    
    //inputs[0] = NaN car c'est S
    tx = inputs[1];
    ty = inputs[2];
    tz = inputs[3];
    joy_x = inputs[4];
    joy_y = inputs[5];
    joy_B = inputs[6];
    bout_mesh = inputs[7];
    bout_addPoint = inputs[8];
    clear1 = inputs[9];
    clear2 = inputs[10];
    bout_save = inputs[11];
    //inputs[12] = NaN car c'est E

    str= str.substring(str.indexOf("S")+29);
  }
}

void update()
{

  boolean mouv = false;
  //println(tx, ty, tz);
  if (tx == 1 && x<taille/2)
  {
    mouv = true;
    x+=5;
  }

  if (tx == 2 && x>-taille/2)
  {
    mouv = true;
    x-=5;
  }

  if (ty == 1 && y<taille/2)
  {
    mouv = true;
    y+=5;
  }

  if (ty == 2 && y>-taille/2)
  {
    mouv = true;
    y-=5;
  }

  if (tz == 1 && z<taille/2)
  {
    mouv = true;
    z+=5;
  }

  if (tz == 2 && z>-taille/2)
  {
    mouv = true;
    z-=5;
  }


  if (mouv)
  {
    boolmeshage = true;
    if (bout_addPoint == 0)
      pos.add(new coord(x, y, z));
  }
}

void saveSTL()
{
  meshpt.clear();
  addPoint();
  for (int i = 0; i<pos.size(); i++)
  {
    coord ctmp = pos.get(i);
    Vec3D vtmp = new Vec3D(ctmp.getX(), ctmp.getY(), ctmp.getZ());
    brush.setSize(1);
    brush.drawAtAbsolutePos(vtmp, density);
  }
  for (int i = 0; i<meshpt.size(); i++)
  {
    coord ctmp = meshpt.get(i);
    Vec3D vtmp = new Vec3D(ctmp.getX(), ctmp.getY(), ctmp.getZ());
    brush.setSize(1);
    brush.drawAtAbsolutePos(vtmp, density);
  }
  volume.closeSides();  
  surface.reset();
  surface.computeSurfaceMesh(mesh, iso_threshold);
  println("Nombre de points = "+pos.size());
  println("SAUVERGARDE "+nbre);
  nbre++;

  mesh.saveAsSTL(sketchPath( "test.stl" ));
}


void axes() {

  int vert=color(0, 255, 0); 
  int rouge=color(255, 0, 0); 
  int bleu=color(0, 0, 255); 


  axe.beginDraw();
  axe.background(0);
  axe.translate(axe.width/2, axe.height/2);
  axe.rotateX(rot_x);
  axe.rotateY(rot_y);
  axe.textSize(20);
  axe.strokeWeight(3);

  axe.stroke(vert);
  axe.line(0, 0, 0, 110, 0, 0);
  axe.fill(vert);
  axe.text("X", 115, 0, 0);

  axe.stroke(bleu);
  axe.line(0, 0, 0, 0, 110, 0);
  axe.fill(bleu);
  axe.text("Y", 0, 115, 0);

  axe.stroke(rouge);
  axe.line(0, 0, 0, 0, 0, 110);
  axe.fill(rouge);
  axe.text("Z", 0, 0, 115);
  axe.noFill();
  axe.stroke(255);
  axe.endDraw();

  image(axe, 0, 0);
}

void addPoint() {
  Vec3D p = new Vec3D();
  Vec3D q = new Vec3D();
  for (int j=0; j<(pos.size())/2; j++)
  {
    if (j==0)
    {
      coord tmp1 = pos.get(0);
      p=new Vec3D(tmp1.getX(), tmp1.getY(), tmp1.getZ());
      coord tmp2 = pos.get(pos.size()-1);
      q=new Vec3D(tmp2.getX(), tmp2.getY(), tmp2.getZ());

      // Création de la première liaison p-q
      Vec3D vtmp = new Vec3D(q.x-p.x, q.y-p.y, q.z-p.z);

      for (int k=1; k<20; k++) 
      {
        float s = k/20f;
        print(s);
        meshpt.add(new coord(p.x+vtmp.x*s, p.y+vtmp.y*s, p.z+vtmp.z*s)); //liaison p-q
      }
    } else
    {
      int compt = pos.size()-1-j;
      coord tmp1;
      tmp1=pos.get(j);
      coord tmp2;
      tmp2=pos.get(compt);
      Vec3D a=new Vec3D(tmp1.getX(), tmp1.getY(), tmp1.getZ());
      Vec3D b=new Vec3D(tmp2.getX(), tmp2.getY(), tmp2.getZ());



      //Pour meshage a chaque iteration on ajoute des points entre a-q,p-b et a-b. La liaison p-q est réalisée à chaque précédente itération (ancienne a-b)
      Vec3D vec1 = new Vec3D(q.x-a.x, q.y-a.y, q.z-q.z); //liaison a-q
      Vec3D vec2 = new Vec3D(b.x-p.x, b.y-p.y, b.z-p.z); //liaison p-b
      Vec3D vec3 = new Vec3D(b.x-a.x, b.y-a.y, b.z-a.z); //liaison a-b


      for (int k=1; k<21; k++)
      {
        float s = k/20f;
        //k/10 retrun 0!!! 
        //s pour scale

        meshpt.add(new coord(a.x+vec1.x*s, a.y+vec1.y*s, a.z+vec1.z*s)); //liaison a-q -> vec1

        meshpt.add(new coord(p.x+vec2.x*s, p.y+vec2.y*s, p.z+vec2.z*s)); //liaison p-b -> vec2

        meshpt.add(new coord(a.x+vec3.x*s, a.y+vec3.y*s, a.z+vec3.z*s)); //liaison a-b -> vec3
      }
      // store current points for next iteration
      p=a;
      q=b;
    }
  }
}
