package miPhysics.Engine;
import java.util.*;
import java.lang.*; 

/**
 * Topology Creator Model class. This allows to procedurally generate regular topologies.
 */
public class newMiTopo extends PhyModel {
  
    private int m_dimX = 1;
    private int m_dimY = 1;
    private int m_dimZ = 1;

    private double m_mass = 1;
    private double m_stiffness = 0.01; 
    private double m_damping = 0.001;
    private double m_size = 1;

    private double m_dist = 1; //distanceBetweenPoints
    private double m_l0 = 1;

    private int m_neighbors = 1;
    private String m_mLabel = "m";
    private String m_iLabel = "i";

    //private String matSubName;
    //private String linkSubName;

    private boolean plane2D = false;
    private EnumSet<Bound> bCond;

    // generated is set to false before it is generated
    private boolean m_generated = false;

    // Medium = Defines a physical medium context (friction, gravity, etc.) That will be applied to material points
    public newMiTopo(String name, Medium m){
        super(name, m);
        bCond = EnumSet.noneOf(Bound.class);
        
        System.out.println(bCond);
    }
   

    public void init(){
        super.init();
        if(!m_generated){
            System.out.println("The TopoCreator model has not yet been generated !");
            System.exit(-1);
        }
    }


    public void setMassRadius(double s){
        this.m_size = s;
    }

    public void setDim(int dx, int dy, int dz, int span) {
        m_dimX = dx;
        m_dimY = dy;
        m_dimZ = dz;
        m_neighbors = span;
    }

    public void set2DPlane(boolean val){
        plane2D = val;
    }

    public void setParams(double mass, double stiffness, double damping){
        m_mass = mass;
        m_stiffness = stiffness;
        m_damping = damping;
    }
    
    public void setMass(double mass){
        m_mass = mass; 
    }
    public void setStiffness(double stiffness){
        m_stiffness = stiffness; 
    }
    public void setDamping(double damping){
        m_damping = damping; 
    }

    public void setGeometry(double d, double l) {
        m_dist = d;
        m_l0 = l;
    }

// ------------------------------------------------------------------------------------------------------------------------------------------------

    public void generate() {

        String masName = "";
        Vect3D U1;
       

        //int nbBefore = mdl.getNumberOfMasses();

        /*
        if(!matSubName.isEmpty())
            mdl.createMassSubset(matSubName);

        if(!linkSubName.isEmpty())
            mdl.createInteractionSubset(linkSubName);
        */

        //System.out.println(this.getName() + ": creating mass elements with naming pattern: "
        //        + m_mLabel + "_[X]_[Y]_[Z]");

        // create definition for these functions
        // for triangle if i is odd then this and if i is even then that
        // maybe distance needs to be redefined, first try with size of 1,
        // if they re too close then set to zoom & focus, if we do it at 1 then we need to zoom

        // this.createPyramidShape(50, 10, 100);  // width, height, distancebettweenpoints
         
        this.createCubicShape(10,10,10, "hello");  
        this.makeCubicConnections(10,10,10); 
         //for(int i = 5; i<30; i+=5){
         //  this.createSphereShape(i, i*10); 
         //}
         
         //this.addNodeAt(0,0,0);
         
         //this.createCone(10,10);  
         //this.createSphereShape(200, 100, 1,1,1); 

         
         


        System.out.println(this.getName() + ": creating interaction elements with naming pattern: "
                + m_iLabel + "_[X1]_[Y1]_[Z1]_[X2]_[Y2]_[Z2]");

        //this.makeCubicConnections(m_dimX, m_dimZ, m_dimY); 
        //this.makeTriangularConnections(m_dimX, m_dimZ, m_dimY); 
        
        //this.applyBoundaryConditions();

        m_generated = true;
    }
    
// ------------------------------------------------------------------------------------------------------------------------------------------------


    public void addBoundaryCondition(Bound b) {
        bCond.add(b);
    }

    // add boundary condition, adding x_left, sets all the masses on the left side of the model to fixed, only for cubic model for pyramid we only may need edges 
    // define boundary conditions different
    private void applyBoundaryConditions() {

        if (bCond.contains(Bound.X_LEFT)) {
            for (int j = 0; j < m_dimY; j++) {
                for (int k = 0; k < m_dimZ; k++) {
                    String name = m_mLabel + ("_0_"+j+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }
        if (bCond.contains(Bound.X_RIGHT)) {
            for (int j = 0; j < m_dimY; j++) {
                for (int k = 0; k < m_dimZ; k++) {
                    String name = m_mLabel + ("_" + (m_dimX-1) + "_"+j+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }

        if (bCond.contains(Bound.Y_LEFT)) {
            for (int i = 0; i < m_dimX; i++) {
                for (int k = 0; k < m_dimZ; k++) {
                    String name = m_mLabel + ("_" + i + "_"+0+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }
        if (bCond.contains(Bound.Y_RIGHT)) {
            for (int i = 0; i < m_dimX; i++) {
                for (int k = 0; k < m_dimZ; k++) {
                    String name = m_mLabel + ("_" + i + "_"+(m_dimY-1)+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }

        if (bCond.contains(Bound.Z_LEFT)) {
            for (int i = 0; i < m_dimX; i++) {
                for (int j = 0; j < m_dimY; j++) {
                    String name = m_mLabel + ("_" + i + "_"+j+"_"+0);
                    this.changeToFixedPoint(name);
                }
            }
        }
        if (bCond.contains(Bound.Z_RIGHT)) {
            for (int i = 0; i < m_dimX; i++) {
                for (int j = 0; j < m_dimY; j++) {
                    String name = m_mLabel + ("_" + i + "_"+j+"_"+(m_dimZ-1));
                    this.changeToFixedPoint(name);
                }
            }
        }

        if (bCond.contains(Bound.FIXED_CORNERS)) {

            for (int i = 0; i < 2; i++) {
                for (int j = 0; j < 2; j++) {
                    for (int k = 0; k < 2; k++) {
                        String name = m_mLabel + ("_" + (i*(m_dimX-1)) + "_"+(j*(m_dimY-1))+"_"+(k*(m_dimZ-1)));
                        this.changeToFixedPoint(name);
                    }
                }
            }
        }

        if (bCond.contains(Bound.FIXED_CENTRE)) {

            String name = m_mLabel + ("_" + (Math.floor(m_dimX/2)) + "_"+(Math.floor(m_dimY/2))+"_"+(Math.floor(m_dimZ/2)));
            this.changeToFixedPoint(name);
        }
    }

    public int setParam(param p, double val ){
        switch(p){
            case MASS:
                this.m_mass = val;
                break;
            case RADIUS:
                this.m_size = val;
                break;
            case STIFFNESS:
                this.m_stiffness = val;
                break;
            case DAMPING:
                this.m_damping = val;
                break;
            default:
                System.out.println("Cannot apply param " + val + " for "
                        + this + ": no " + p + " parameter");
                break;
        }
        for(Mass o : m_masses)
            o.setParam(p, val);
        for(Interaction i : m_interactions)
            i.setParam(p, val);
        return 0;
    }

    public double getParam(param p){
        switch(p){
            case MASS:
                return this.m_mass;
            case RADIUS:
                return this.m_size;
            case STIFFNESS:
                return this.m_stiffness;
            case DAMPING:
                return this.m_damping;
            default:
                System.out.println("No " + p + " parameter found in " + this);
                return 0.;
        }
    }
    
// ------------------------------------------------------------------------------------------------------------------------------------------------
   
   /***
    * Add nodes at x,y,z position
    */
   private void addNodeAt(int x, int y, int z){
     Vect3D X0 = new Vect3D(x, y , z );
     String masName = m_mLabel + "_" + (x + "_" + y + "_" + z);
     System.out.println("added this to list "+masName); 
     this.addMass(masName, new Mass2DPlane(m_mass, m_size, X0)); 
   }
   
   /***
    * Adds a connection for 2 nodes
    */
   private void addConnectionFor(String masName1, String masName2){
     Vect3D U1 = new Vect3D(1, 1, 1); // 3D vector in 3d space, we define these objects geometrically in a 3d vector in any direction
     // always try to track the code & see how to use it, for example d & see documentation
     double d = U1.norm() * m_l0;

     //println("distance: " + d + ", " + l + " " + m + " " + n);

     String ln = m_iLabel + "_" + masName1.substring(1) + "_" + masName2.substring(1) ;

     addInteraction(ln, new SpringDamper3D(d, m_stiffness, m_damping), masName1, masName2);

     //if(!linkSubName.isEmpty())
     //    mdl.addInteractionToSubset(tmp, linkSubName);

     //System.out.println("Created interaction: " + ln);
   }
   
   /***
    * Adds a connection for 2 nodes but takes x,y,z
    */
   private void addConnectionFor(int x1, int y1, int z1, int x2, int y2, int z2){
     Vect3D U1 = new Vect3D(1,1,1); 
     // always try to track the code & see how to use it, for example d & see documentation
     double d = U1.norm() * m_l0;

     //println("distance: " + d + ", " + l + " " + m + " " + n);
     
     String masName1 = m_mLabel + "_" +(x1+"_"+y1+"_"+z1);

     String masName2 = m_mLabel + "_" +(x2+"_"+y2+"_"+z2);
     String ln = m_iLabel + "_" + (x1+"_"+y1+"_"+z1) + "_" + (x2+"_"+y2+"_"+z2) ;

     addInteraction(ln, new SpringDamper3D(d, m_stiffness, m_damping), masName1, masName2);

     //if(!linkSubName.isEmpty())
     //    mdl.addInteractionToSubset(tmp, linkSubName);

     //System.out.println("Created interaction: " + ln);
   }
      
// ------------------------------------------------------------------------------------------------------------------------------------------------
   private void createCubicShape(int m_dimX, int m_dimY, int m_dimZ, String masName){
      Vect3D X0;
        // wir machen ein neues Vect3d object und geben es einen namen & eine masse 
        for (int i = 0; i < m_dimX ; i++) {
            for (int j = 0; j < m_dimY ; j++) {
                for (int k = 0; k < m_dimZ; k++) { //m_dimZ; k++) {

                    X0 = new Vect3D(i*m_dist, j*m_dist, k*m_dist);

                    masName = m_mLabel + "_" +(i+"_"+j+"_"+k);

                    // we have 3d not 2d plane 
                    if(plane2D){
                        this.addMass(masName, new Mass2DPlane(m_mass, m_size, X0));
                        //if(!matSubName.isEmpty())
                        //    mdl.addMassToSubset(tmp, matSubName);
                    }
                    // IF it is 3d then we add a mass to it
                    else {
                        this.addMass(masName, new Mass3D(m_mass, m_size, X0));
                        //if(!matSubName.isEmpty())
                        //    mdl.addMassToSubset(tmp, matSubName);
                    }
                    //System.out.println("Created mass: " + masName);

                }
            }
        }
   }


  
   private void createPyramidShape(int height, int width, int distanceBetweenPoints) {
      int dbp = distanceBetweenPoints; 
        
      // Add nodes here: 
      for (int z = 0; z <= height; z++){
          for (int y=z; y<=width-z; y++){
              for (int x=z; x<=width-z; x++){         
                  this.addNodeAt(x*distanceBetweenPoints,y*distanceBetweenPoints,z*distanceBetweenPoints); 

              }
          }
      }
      
      // Add connections here: 
      for (int z1 = 0; z1 <= height; z1++){
          for (int y1=z1; y1<=width-z1; y1++){
              for (int x1=z1; x1<=width-z1; x1++){   
                for (int i = -1; i < 2; i++){ //distances of 2
                  for (int j = -1; j < 2; j++){
                    for (int k = -1; k< 2; k++){
                        this.addConnectionFor((x1+i)*dbp, (y1+j)*dbp, (z1+k)*dbp, x1*dbp,y1*dbp,z1*dbp); 

                    }
                  }
                }            
              }
          }
      }

      
      for (int zz = 0; zz <= height; zz++){
          for (int yy=zz; yy<=width-zz; yy++){
              for (int xx=zz; xx<=width-zz; xx++){ 
                if ( !(zz==0 && xx==0 && yy==0)){ // if you want all fixed remove the first condition (zz==0 || xx==0 || yy==0)
                  String masName = m_mLabel + "_" +(xx*dbp+"_"+yy*dbp+"_"+zz*dbp);

                  this.changeToFixedPoint(masName);
                }

              }
          }
      }
      
   }
   

   private void createSphereShape(int radius, int numberOfPoints) {
     
     this.addNodeAt(0,0,0); 
     String mm = m_mLabel + "_" +(0+"_"+0+"_"+0);
     this.changeToFixedPoint(mm); 
     int prevx = 0; 
     int prevy = 0; 
     int prevz = 0; 
     
     for(int i = 0; i < numberOfPoints; i++){
        float k = i + 0.5f;
        float phi = (float) Math.acos(1 - 2 * k / numberOfPoints);
        float theta = (float) (Math.PI * (1 + Math.sqrt(5)) * k);

        int x = (int) ((Math.cos(theta) * Math.sin(phi))*radius);
        int y = (int) ((Math.sin(theta) * Math.sin(phi))*radius);
        int z = (int) (Math.cos(phi)*radius);
        
        this.addNodeAt(x,y,z); 
        
        

        this.addConnectionFor(prevx,prevy,prevz,x,y,z); 
        
        prevx = x; 
        prevy = y; 
        prevz = z; 

        
        //System.out.println("Created shape at"+x+", "+y+", "+z); 
     }
   }
  
   private void createSphereShape(int radius, int numberOfPoints, int factorX, int factorY, int factorZ) {
     
     this.addNodeAt(0,0,0);  //center
    
     
     
     
     for(int i = 0; i < numberOfPoints; i++){
        float k = i + 0.5f;
        float phi = (float) Math.acos(1 - 2 * k / numberOfPoints);
        float theta = (float) (Math.PI * (1 + Math.sqrt(5)) * k);

        int x = (int) ((Math.cos(theta) * Math.sin(phi))*radius*factorX);
        int y = (int) ((Math.sin(theta) * Math.sin(phi))*radius*factorY);
        int z = (int) (Math.cos(phi)*radius*factorZ);
        
        this.addNodeAt(x,y,z);  
        
        
         
        this.addConnectionFor(x,y,z,0,1,0); 
        
        
        String masName = m_mLabel + "_" +(x+"_"+y+"_"+z);
        this.changeToFixedPoint(masName);
        
        
        //System.out.println("Created shape at"+x+", "+y+", "+z); 
     }
   }
   
   private void pointsAroundCircle(int radius, int numberOfPoints, int z ){
     for (int i = 0; i < numberOfPoints; i++) {
            float theta = (float) ((2 * Math.PI / numberOfPoints)*i); 
            int x = (int) (Math.cos(theta)*radius);
            int y = (int) (Math.sin(theta)*radius) ;
            this.addNodeAt(x*2, y*2, z*20);  // Assuming z is 0
        }
   }
   
   private void createCircle(int numberOfCircles, int z){
      for (int i = 1; i < numberOfCircles; i++){
        this.pointsAroundCircle(i*10, i*10^(i/2), z); 
      }
   }
   
   private void createCylinder(int height, int width){
      for(int i =0; i < height; i++){
        this.createCircle(width, i); 
      }
   }
   
   private void createCone(int height, int width){
     for (int i = 0; i < height; i++){
       this.createCircle(width-i, i);
     }
   }
   
   private void createWeirdShapedSphere(int radius, int numberOfPoints, int factorX, int factorY, int factorZ) {
     
     for(int i = 0; i < numberOfPoints; i++){
        float k = i + 0.5f;
        float phi = (float) Math.acos(1 - 2 * k / numberOfPoints);
        float theta = (float) (Math.PI * (1 + Math.sqrt(5)) * k);

        int x = (int) (((Math.cos(theta) * Math.sin(phi))*radius*factorX)+i);
        int y = (int) (((Math.sin(theta) * Math.sin(phi))*radius*factorY)+i);
        int z = (int) ((Math.cos(phi)*radius*factorZ)+i);
        
        this.addNodeAt(x*radius,y*radius,z*radius);  
        System.out.println("Created shape at"+x+", "+y+", "+z); 
     }
   }

      
      
      private void makeCubicConnections(int m_dimX, int m_dimZ, int m_dimY){
                // add the springs to the model: length, stiffness, connected mats
        String masName1, masName2;
        Vect3D U1;
        int idx = 0, idy = 0, idz = 0;

        for (int i = 0; i < m_dimX; i++) {
            for (int j = 0; j < m_dimY; j++) {
                for (int k = 0; k <= m_dimZ; k++) {

                    //println("Looking at: " + mLabel +(i+"_"+j+"_"+k));
                    masName1 = m_mLabel + "_" +(i+"_"+j+"_"+k);

                    // here we go over the neighbours, m_neighbors = 1 -> wie weit die connections mit allen gehen
                    for (int l = 0; l < m_neighbors; l++) { // l = wie weit es nach hinten geht mit den verbindungen
                        for (int m = - m_neighbors; m < m_neighbors+1; m++) { // 0 bis 2 also von 0 connections bis 2 reihe connections
                            for (int n = -m_neighbors; n < m_neighbors+1; n++) { // 0 bis 2
                                idx = i+l; // index von dimension x 
                                idy = j+m; // index von dimension y 
                                idz = k+n; // index von dimension z

                                if((l==0) && (m<0) && (n < 0))
                                    break;

                                else if ((idx < m_dimX) && (idy < m_dimY) && (idz < m_dimZ)) {
                                    if ((idx>=0) && (idy>=0) && (idz>=0)) {
                                        if ((idx==i) && (idy == j) && (idz == k)) {
                                            //println("Superposed at same point" + idx + " " + idy + " " + idz);
                                            break;
                                        } else {

                                            U1 = new Vect3D(l, m, n); //3d vector, shows direction of the mass, in which direction the vector should go
 
                                            double distance = U1.norm() * m_l0; // normal vector, m_l0 = unit vector, creates a normal vector of that, orthogonal to this shape

                                            //println("distance: " + d + ", " + l + " " + m + " " + n);

                                            masName2 = m_mLabel + "_" +(idx+"_"+idy+"_"+idz);
                                            String ln = m_iLabel + "_" + (i+"_"+j+"_"+k) + "_" + (idx+"_"+idy+"_"+idz) ; // coordinate first to second point

                                            addInteraction(ln, new SpringDamper3D(distance, m_stiffness, m_damping), masName1, masName2);

                                            //if(!linkSubName.isEmpty())
                                            //    mdl.addInteractionToSubset(tmp, linkSubName);

                                            //System.out.println("Created interaction: " + ln);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
      }
      
      
      
      
}
