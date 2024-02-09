import java.util.EnumSet;

/**
 * Abstract class for shape generation within the physics engine.
 */
public abstract class ShapeGenerator extends PhyModel {


    public double m_mass = 1;
    public double m_stiffness = 0.01; 
    public double m_damping = 0.001;
    public double m_size = 1;

    public double m_dist = 1;
    public double m_l0 = 1;

    public int m_neighbors = 2;
    public String m_mLabel = "m";
    public String m_iLabel = "i";

    //private String matSubName;
    //private String linkSubName;

    public boolean plane2D = false;
    public EnumSet<Bound> bCond;

    // generated is set to false before it is generated
    public boolean m_generated = false;

    public ShapeGenerator(String name, Medium m) {
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

    // Method to initiate shape generation
    public abstract void generate();
    
    public void setMassRadius(double s){
        this.m_size = s;
    }

    // Common functionality can be added here, such as setters and getters for common properties

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

    public void set2DPlane(boolean val) {
        this.plane2D = val;
    }
    
    
    // ------------------------------------------------------------------------------------------------------------------------------------------
    


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
    
    // ------------------------------------------------------------------------------------------------------------------------------------------


   /***
    * Add nodes at x,y,z position
    */
   public void addNodeAt(int x, int y, int z){
     Vect3D X0 = new Vect3D(x, y , z );
     String masName = m_mLabel + "_" + (x + "_" + y + "_" + z);
     System.out.println("added this to list "+masName); 
     this.addMass(masName, new Mass2DPlane(m_mass, m_size, X0)); 
   }
   
   /***
    * Adds a connection for 2 nodes
    */
   public void addConnectionFor(String masName1, String masName2){
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
   public void addConnectionFor(int x1, int y1, int z1, int x2, int y2, int z2){
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
    
}
