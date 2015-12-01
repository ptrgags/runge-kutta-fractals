/**
 * Pickover Attractor
 *
 * Demo of the Pickover Strange Attractor
 *
 * @author Peter Gagliardi
 * @version 1.0.0
 * @copyright 2014 Peter Gagliardi
 */
 
//Constants
static final int MAX_POINTS = 50000;
static final float A = 2.24;
static final float B = 0.43;
static final float C = -0.65;
static final float D = -2.43;
static final float E = 1.0;

//Variables
ArrayList<PVector> points = new ArrayList<PVector>();
CylinderCamera camera;
PVector current = new PVector(1, 1, 1);

void setup() {
    size(640, 480, OPENGL);
    
    points.add(current);
    
    camera = new CylinderCamera();
    camera.lookAt(0, 0, 0);
    camera.setZoomBounds(1, 10, 1);
    camera.setCamHeightBounds(-4, 4, 0.5);
    camera.setAzimuthBounds(-TAU, TAU, PI / 24);
}

void draw() {
    for (int i = 0; i < 100; i++)
        calculatePoint();
    
    background(#000000);
    
    camera.calculatePosition();
    camera.start();
    noFill();
    box(10);
    stroke(#FF0000);
    for (PVector p : points)
        point(p.x, p.y, p.z);
    
}

void mouseWheel(MouseEvent event) {
    //Zoom in and out
    camera.zoom(event.getCount());
}

/**
 * Add a point to the list of points
 */
void calculatePoint() {
    current = next(current);
    points.add(current);
    
    if (points.size() > MAX_POINTS)
        points.remove(0);
}

/**
 * Get the next position
 */
PVector next(PVector current) {
    float x = sin(A * current.y) - current.z * cos(B * current.x);
    float y = current.z * sin(C * current.x) - cos(D * current.y);
    float z = sin(current.x);
    return new PVector(x, y, z);
}
