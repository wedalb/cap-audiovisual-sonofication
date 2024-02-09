
/**
 * CircularShapeGenerator class for generating a spherical shape within the miPhysics engine.
 */
public class CircularShapeGenerator extends ShapeGenerator {
  
  int radius = 100; 
  int numberOfPoints = 100; // Adjust this value based on desired density
  int factorX = 1; 
  int factorY = 1; 
  int factorZ = 1; 


    /**
     * Constructor for the CircularShapeGenerator class.
     * 
     * @param name The name of the spherical shape generator instance.
     * @param m The medium in which the spherical shape exists.
     */
    public CircularShapeGenerator(String name, Medium m) {
        super(name, m);
    }
    
    public void setRadius(int radius){
        this.radius = radius; 
    }
    
    public void setNumberOfPoints(int numberOfPoints){
        this.numberOfPoints = numberOfPoints; 
    }
    
    public void setFactorX(int factorX){
      this.factorX = factorX; 
    }
    
    public void setFactorY(int factorY){
      this.factorY = factorY; 
    }
    
    public void setFactorZ(int factorZ){
      this.factorZ = factorZ; 
    }
    
    public void setDimensions(int radius, int numberOfPoints, int factorX, int factorY, int factorZ){
      this.radius = radius;
      this.numberOfPoints = numberOfPoints; 
      this.factorX = factorX; 
      this.factorY = factorY;
      this.factorZ = factorZ;
    }

    @Override
    public void generate() {
      
      String masName = "";
      Vect3D U1;

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
        
        
        String mas_Name = m_mLabel + "_" +(x+"_"+y+"_"+z);
        this.changeToFixedPoint(mas_Name);
        
        
        //System.out.println("Created shape at"+x+", "+y+", "+z); 
     }
        
        System.out.println(this.getName() + ": creating interaction elements with naming pattern: "
                + m_iLabel + "_[X1]_[Y1]_[Z1]_[X2]_[Y2]_[Z2]");


        m_generated = true;


    }
    
    public void addBoundaryCondition(Bound b) {
        bCond.add(b);
    }
    
        // add boundary condition, adding x_left, sets all the masses on the left side of the model to fixed, only for cubic model for pyramid we only 
    // may need edges 
    // define boundary conditions different
    private void applyBoundaryConditions() {

        if (bCond.contains(Bound.X_LEFT)) {
            for (int j = 0; j < width; j++) {
                for (int k = 0; k < height; k++) {
                    String name = m_mLabel + ("_0_"+j+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }
        if (bCond.contains(Bound.X_RIGHT)) {
            for (int j = 0; j < width; j++) {
                for (int k = 0; k < height; k++) {
                    String name = m_mLabel + ("_" + (width-1) + "_"+j+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }

        if (bCond.contains(Bound.Y_LEFT)) {
            for (int i = 0; i < width; i++) {
                for (int k = 0; k < height; k++) {
                    String name = m_mLabel + ("_" + i + "_"+0+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }
        if (bCond.contains(Bound.Y_RIGHT)) {
            for (int i = 0; i < width; i++) {
                for (int k = 0; k < height; k++) {
                    String name = m_mLabel + ("_" + i + "_"+(width-1)+"_"+k);
                    this.changeToFixedPoint(name);
                }
            }
        }

        if (bCond.contains(Bound.Z_LEFT)) {
            for (int i = 0; i < width; i++) {
                for (int j = 0; j < height; j++) {
                    String name = m_mLabel + ("_" + i + "_"+j+"_"+0);
                    this.changeToFixedPoint(name);
                }
            }
        }
        if (bCond.contains(Bound.Z_RIGHT)) {
            for (int i = 0; i < width; i++) {
                for (int j = 0; j < width; j++) {
                    String name = m_mLabel + ("_" + i + "_"+j+"_"+(height-1));
                    this.changeToFixedPoint(name);
                }
            }
        }

        if (bCond.contains(Bound.FIXED_CORNERS)) {

            for (int i = 0; i < 2; i++) {
                for (int j = 0; j < 2; j++) {
                    for (int k = 0; k < 2; k++) {
                        String name = m_mLabel + ("_" + (i*(width-1)) + "_"+(j*(width-1))+"_"+(k*(height-1)));
                        this.changeToFixedPoint(name);
                    }
                }
            }
        }

        if (bCond.contains(Bound.FIXED_CENTRE)) {

            String name = m_mLabel + ("_" + (Math.floor(width/2)) + "_"+(Math.floor(width/2))+"_"+(Math.floor(height/2)));
            this.changeToFixedPoint(name);
        }
    }
}
