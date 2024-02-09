public class CubicShapeGenerator extends ShapeGenerator {
  
    private int m_dimX = 1;
    private int m_dimY = 1;
    private int m_dimZ = 1;
    private int m_neighbors = 1; // Defines the span of connections

    /**
     * Constructor for the CubicShapeGenerator class.
     * 
     * @param name The name of the cubic shape generator instance.
     * @param m The medium in which the cubic shape exists.
     */
    public CubicShapeGenerator(String name, Medium m) {
        super(name, m);
    }

    public void setDimensions(int dimX, int dimY, int dimZ, int span) {
        this.m_dimX = dimX;
        this.m_dimY = dimY;
        this.m_dimZ = dimZ;
        this.m_neighbors = span;
    }

    @Override
    public void generate() {
        // Generate nodes for the cubic shape
        for (int i = 0; i < m_dimX; i++) {
            for (int j = 0; j < m_dimY; j++) {
                for (int k = 0; k < m_dimZ; k++) {
                    addNodeAt(i * (int) m_dist, j * (int) m_dist, k * (int) m_dist);
                }
            }
        }

        // Call the method to make connections
        makeCubicConnections(m_dimX, m_dimZ, m_dimY);

        System.out.println(this.getName() + ": creating interaction elements with naming pattern: "
                + m_iLabel + "_[X1]_[Y1]_[Z1]_[X2]_[Y2]_[Z2]");

        m_generated = true;
    }

    private void makeCubicConnections(int m_dimX, int m_dimZ, int m_dimY) {
        String masName1, masName2;
        Vect3D U1;
        int idx, idy, idz;

        for (int i = 0; i < m_dimX; i++) {
            for (int j = 0; j < m_dimY; j++) {
                for (int k = 0; k < m_dimZ; k++) {
                    i = i*(int) m_dist;
                    masName1 = m_mLabel + "_" + (i + "_" + j + "_" + k);

                    for (int l = 0; l <= m_neighbors; l++) {
                        for (int m = -m_neighbors; m <= m_neighbors; m++) {
                            for (int n = -m_neighbors; n <= m_neighbors; n++) {
                                idx = i + l;
                                idy = j + m;
                                idz = k + n;

                                if ((l == 0 && m < 0 && n < 0) || (idx == i && idy == j && idz == k))
                                    continue;

                                if ((idx < m_dimX) && (idy < m_dimY) && (idz < m_dimZ) && (idx >= 0) && (idy >= 0) && (idz >= 0)) {
                                    U1 = new Vect3D(l, m, n);
                                    double distance = U1.norm() * m_l0;
                                    masName2 = m_mLabel + "_" + (idx + "_" + idy + "_" + idz);
                                    String ln = m_iLabel + "_" + masName1 + "_" + masName2;
                                    addInteraction(ln, new SpringDamper3D(distance, m_stiffness, m_damping), masName1, masName2);
                                }
                            }
                        }
                    }
                }
            }
        }
    }




    /**
     * Helper method to generate a standardized node name based on its coordinates.
     * 
     * @param x The x-coordinate of the node.
     * @param y The y-coordinate of the node.
     * @param z The z-coordinate of the node.
     * @return The generated node name.
     */
    private String getNodeName(int x, int y, int z) {
        return m_mLabel + "_" + x + "_" + y + "_" + z;
    }
    
        
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
}
