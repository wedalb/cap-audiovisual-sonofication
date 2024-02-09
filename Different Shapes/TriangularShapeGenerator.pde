
/**
 * TriangularShapeGenerator class for generating a pyramid shape within the miPhysics engine.
 */
public class TriangularShapeGenerator extends ShapeGenerator {
  
    private int width = 10;
    private int distanceBetweenPoints = 10; // This needs to be declared before its use in calculations
    private int height = (this.width / 2) * distanceBetweenPoints;
    
    private int highestPoint_x = (this.width / 2) * distanceBetweenPoints; 
    private int highestPoint_y = (this.width / 2) * distanceBetweenPoints;
    private int highestPoint_z = this.height * distanceBetweenPoints;

    
    
    
    public int getDistanceBetweenPoints(){
      return this.distanceBetweenPoints; 
    }
    
    public int getHighestPoint_x(){
      return this.highestPoint_x; 
    }
    
    public int getHighestPoint_y(){
      return this.highestPoint_y; 
    }
    
    public int getHighestPoint_z(){
      return this.highestPoint_z; 
    }

    /**
     * Constructor for the TriangularShapeGenerator class.
     * 
     * @param name The name of the pyramid shape generator instance.
     * @param m The medium in which the pyramid shape exists.
     */
    public TriangularShapeGenerator(String name, Medium m) {
        super(name, m);
    }
    
    public void setDimensions(int width) {
        this.width = width;
        // Recalculate dependent fields after updating width
        this.height = (this.width / 2) * this.distanceBetweenPoints;
        this.highestPoint_x = (this.width / 2) * this.distanceBetweenPoints;
        this.highestPoint_y = (this.width / 2) * this.distanceBetweenPoints;
        this.highestPoint_z = this.height * this.distanceBetweenPoints;
    }

    
    public void setDistanceBetweenPoints(int dbp){
        this.distanceBetweenPoints = dbp;
        // Recalculate dependent fields after updating distanceBetweenPoints
        this.height = (this.width / 2) * this.distanceBetweenPoints;
        this.highestPoint_x = (this.width / 2) * this.distanceBetweenPoints;
        this.highestPoint_y = (this.width / 2) * this.distanceBetweenPoints;
        this.highestPoint_z = this.height * this.distanceBetweenPoints;
    }



    @Override
    public void generate() {
      
      String masName = "";
        Vect3D U1;
        
      int dbp = distanceBetweenPoints; 
       
        // Add nodes here: 
      for (int z = 0; z <= height; z++){
          for (int y=z; y<=width-z; y++){
              for (int x=z; x<=width-z; x++){         
                  this.addNodeAt(x*dbp,y*dbp,z*dbp); 

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
                  String mas_Name = m_mLabel + "_" +(xx*dbp+"_"+yy*dbp+"_"+zz*dbp);

                  this.changeToFixedPoint(mas_Name);
                }

              }
          }
      }
        // Add the apex node of the pyramid
       // addNodeAt(baseSize / 2, baseSize / 2, height);

        // Connections between base nodes and between the base and the apex could be added here
        // For simplicity, this example does not implement connections.
        
        System.out.println(this.getName() + ": creating interaction elements with naming pattern: "
                + m_iLabel + "_[X1]_[Y1]_[Z1]_[X2]_[Y2]_[Z2]");

        //this.makeCubicConnections(m_dimX, m_dimZ, m_dimY); 
        //this.makeTriangularConnections(m_dimX, m_dimZ, m_dimY); 
        
        //this.applyBoundaryConditions();

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
