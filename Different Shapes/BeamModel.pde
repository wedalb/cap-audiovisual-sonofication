import peasy.*;

import miPhysics.Renderer.*;
import miPhysics.Engine.*;
import miPhysics.Engine.Sound.*;

import java.math.RoundingMode;
import java.text.DecimalFormat;


int baseFrameRate = 60;
float currAudio = 0;

PeasyCam cam;

PhysicsContext phys; 

Observer3D listener;
Driver3D driver;
CubicShapeGenerator triangle;

ModelRenderer renderer;
miPhyAudioClient audioStreamHandler;

boolean showInstructions = true;

///////////////////////////////////////

void setup()
{
  //size(1000, 700, P3D);
  fullScreen(P3D,2);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5500);


  phys = new PhysicsContext(44100);
  phys.setGlobalFriction(0.00001);
  
  
  // k = stiffnes und dämpfung = z
  // 45 ist das minimum bei setDim und rest ist größe, das letzte ist verbindungen 1,2
  triangle = new CubicShapeGenerator("topo", phys.getGlobalMedium());
  triangle.setDimensions(5,5,5,2);  //wir müssen die masse ändern, span = verbindungen
  //triangle.setDistanceBetweenPoints(20);
  triangle.setGeometry(10, 10); // abstand
  triangle.setParams(500, 0.005, 0.05); //standard einstellungen
  triangle.setMassRadius(1);  //wie dick die Kreise sind)
  
  triangle.addBoundaryCondition(Bound.X_LEFT);
  triangle.addBoundaryCondition(Bound.X_RIGHT);
  triangle.generate();
  triangle.translate(-25*22, 0, 0);
  
  driver = triangle.addInOut("driver", new Driver3D(), "m_0_0_0");
  listener = triangle.addInOut("listener1", new Observer3D(filterType.HIGH_PASS), "m_0_0_0");
  triangle.addInOut("listener2", new Observer3D(filterType.HIGH_PASS), "m_0_0_0");
  
  phys.mdl().addPhyModel(triangle);

  phys.init();

  renderer = new ModelRenderer(this);  
  renderer.displayMasses(true);  
  renderer.setColor(massType.MASS3D, 140, 140, 240);
  renderer.setColor(interType.SPRINGDAMPER3D, 135, 70, 70, 255);
  renderer.setStrainGradient(interType.SPRINGDAMPER3D, true, 0.1);
  renderer.setStrainColor(interType.SPRINGDAMPER3D, 105, 100, 200, 255);
  
  renderer.displayIntersectionVolumes(true);
  renderer.displayForceVectors(false);

  audioStreamHandler = miPhyAudioClient.miPhyClassic(44100, 128, 0, 2, phys);
  audioStreamHandler.setListenerAxis(listenerAxis.Y);
  audioStreamHandler.setGain(0.03);
  audioStreamHandler.start();

  cam.setDistance(500);  // distance from looked-at point

  frameRate(baseFrameRate);
}

void draw()
{
  noCursor();
  background(0, 0, 25);
  directionalLight(126, 126, 126, 100, 0, -1);
  ambientLight(182, 182, 182);

  if(showInstructions)
    displayModelInstructions();

  renderer.renderScene(phys);
}

void keyPressed(){
  
  int forceRampSteps = 200;//(int)(0.1 * 44100);
  
  switch(key){
    case 'a':
      driver.moveDriver(triangle.getMass("m_0_0_0"));
      driver.triggerForceRamp(0, 0.1, 0, forceRampSteps);
      break;
    
    case 'z':
      driver.moveDriver(triangle.getMass("m_0_0_0"));
      driver.triggerForceRamp(0, 0.2, 0, forceRampSteps);
      break;
    case 'e':
      driver.moveDriver(triangle.getMass("m_0_0_0"));
      driver.triggerForceRamp(0, 0.4, 0, forceRampSteps);
      break;
    case 'r':
      driver.moveDriver(triangle.getMass("m_0_0_0"));
      driver.triggerForceRamp(0, 0.7, 0, forceRampSteps);
      break;
    case 't':
      driver.moveDriver(triangle.getMass("m_0_0_0"));
      driver.triggerForceRamp(0, 0.9, 0, forceRampSteps);
      break;
    case 'y':
      driver.moveDriver(triangle.getMass("m_0_0_0"));
      driver.triggerForceRamp(0, 1.3, 0, forceRampSteps);
      break;
    case 'h':
      showInstructions = !showInstructions;
  }
}


void displayModelInstructions(){
  cam.beginHUD();
  textMode(MODEL);
  textSize(16);
  fill(255, 255, 255);
  text("Use the [a, z, e, r, t, y] keys to pluck the beam.", 10, 30);
  text("Plucking from soft to hard and from central to near one end.", 10, 55);
  text("Press 'h' to hide help", 10, 105);
  text("FrameRate : " + frameRate, 10, 130);
  DecimalFormat df = new DecimalFormat("#.####");
  df.setRoundingMode(RoundingMode.CEILING);
  text("Curr Audio: " + df.format(listener.observePos().y), 10, 155);
  cam.endHUD();
}
