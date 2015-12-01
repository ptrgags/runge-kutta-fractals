/**
 * Cylinder Camera
 *
 * Class that controls 
 *
 * @author Peter Gagliardi
 * @verion 1.0.0
 * @copyright 2014 Peter Gagliardi
 * 
 * @mod make Stepper class
 */
class CylinderCamera {
    /** Default field of view */
    private static final float DEFAULT_FOV = PI / 3.0;
    /** Default near point */
    private static final float DEFAULT_Z_NEAR = 0.01;
    /** Default far point */
    private static final float DEFAULT_Z_FAR = 2000.0;
    /** Default minimum zoom radius */
    private static final float DEFAULT_ZOOM_MIN = 10;
    /** Default maximum zoom radius */
    private static final float DEFAULT_ZOOM_MAX = 200;
    /** Default zoom radius step size */ 
    private static final float DEFAULT_ZOOM_STEP = 10;
    /** Default maximum camera height */
    private static final float DEFAULT_CAMERA_HEIGHT_MAX = 100;
    /** Default height step size */
    private static final float DEFAULT_CAMERA_HEIGHT_STEP = 20;
    /** Default maximum azimuth angle from center */
    private static final float DEFAULT_AZIMUTH = PI;
    /** Default azimuth step size */
    private static final float DEFAULT_AZIMUTH_STEP = PI / 24;
    
    /** Camera azimuth angle */
    private float azimuth;
    /** Maximum azimuth angle */
    private float azimuthMin;
    /** Maximum azimuth angle */
    private float azimuthMax;
    /** Azimuth angle step size */
    private float azimuthStep;
    /** height of the camera */
    private float camHeight;
    /** Maximum camera height */
    private float camHeightMax;
    /** Minimum camera height */
    private float camHeightMin;
    /** Camera height step size */
    private float camHeightStep;
    /** radius from the target point, used for zooming */
    private float radius;
    /** Minimum zoom radius */
    private float zoomMin;
    /** Maximum zoom radius */
    private float zoomMax;
    /** step size per click of the mouse wheel */
    private float zoomStep;
    /** Point to look at */
    private PVector target;
    /** Up vector */
    private PVector up;
    
    /**
     * Default Constructor
     */
    CylinderCamera() {
        setPerspective(DEFAULT_FOV, width, height, DEFAULT_Z_NEAR, DEFAULT_Z_FAR);
        target = new PVector();
        up = new PVector(0, 1, 0);
        zoomMin = DEFAULT_ZOOM_MIN;
        zoomMax = DEFAULT_ZOOM_MAX;
        zoomStep = DEFAULT_ZOOM_STEP;
        camHeight = 0;
        camHeightMin = -DEFAULT_CAMERA_HEIGHT_MAX;
        camHeightMax = DEFAULT_CAMERA_HEIGHT_MAX;
        camHeightStep = DEFAULT_CAMERA_HEIGHT_STEP;
        azimuth = 0;
        azimuthMin = -DEFAULT_AZIMUTH;
        azimuthMax = DEFAULT_AZIMUTH;
        azimuthStep = DEFAULT_AZIMUTH_STEP;
        //Set the radius to halfway between zoomMin and zoomMax
        radius = (zoomMax + zoomMin) / 2;
    }
    
    /**
     * Set the perspective for the camera
     * @param fov field of view
     * @param w the width of the screen
     * @param h the height of the screen
     * @param zNear the near point
     * @param zFar the far point
     */
    void setPerspective(float fov, float w, float h, float zNear, float zFar) {
        perspective(fov, w / h, zNear, zFar);
    }
    
    /**
     * Set the bounds for the azimuth angle
     * @param minAngle the minimum angle
     * @param maxAngle the maximum angle
     * @param step the step size
     */
    void setAzimuthBounds(float minAngle, float maxAngle, float step) {
        azimuthMin = minAngle;
        azimuthMax = maxAngle;
        azimuthStep = step;
        azimuth = constrain(azimuth, azimuthMin, azimuthMax);
    }
    
    /**
     * Set the camera height boundaries
     * @param minHeight the minimum height
     * @param maxHeight the maximum height
     * @param step the step size
     */
    void setCamHeightBounds(float minHeight, float maxHeight, float step) {
        camHeightMin = minHeight;
        camHeightMax = maxHeight;
        camHeightStep = step;
        camHeight = constrain(camHeight, camHeightMin, camHeightMax);
    }
    
    /**
     * Set the boundary of the camera zoom (camera radius)
     * @param minZoom the minimum zoom radius
     * @param maxZoom the maximum zoom radius
     * @param step the zoom step size
     */
    void setZoomBounds(float minZoom, float maxZoom, float step) {
        zoomMin = minZoom;
        zoomMax = maxZoom;
        zoomStep = step;
        radius = constrain(radius, zoomMin, zoomMax);
    }
    
    /**
     * Rotate the camera by a number of steps
     * @param steps number of steps to rotate through
     * negative is clockwise, positive is counterclockwise
     */
    void rotateCamera(int steps) {
        azimuth += steps * azimuthStep;
        azimuth = constrain(azimuth, azimuthMin, azimuthMax);
    }
    
    /**
     * Change the height by a number of steps
     * @param steps the number of steps to ascend/descend.
     * negative is up, positive is down
     */
    void changeHeight(int steps) {
        camHeight += steps * camHeightStep;
        camHeight = constrain(camHeight, camHeightMin, camHeightMax);
    }
    
    /**
     * Zoom the camera in or out
     * @param steps the number of steps
     * to zoom. Negative means zoom in.
     * positive means zoom out.
     */
    void zoom(int steps) {
        radius += steps * zoomStep;
        radius = constrain(radius, zoomMin, zoomMax);
    }
    
    /**
     * Set a new point to look at
     * @param x the x coordinate of the target
     * @param y the y coordinate of the target
     * @param z the z coordinate of the target
     */
    void lookAt(float x, float y, float z) {
        target = new PVector(x, y, z);
    }
    
    /**
     * Set a new point to look at
     * @param newTarget the new target
     * point to look at
     */
    void lookAt(PVector newTarget) {
        target = newTarget;
    }
    
    /**
     * Set the positon of the camera
     * @param radius the radius from the target
     * @param angle the azimuth angle
     * @param z the height of the camera
     */
    void setPosition(float radius, float angle, float z) {
        this.radius = radius;
        this.azimuth = angle;
        this.camHeight = z;
    }
    
    /**
     * Set the position from a cylindrical
     * vector.
     * @param coords the position vector
     * in the form [radius, azimuth, height]
     */
    void setPosition(PVector coords) {
        radius = coords.x;
        azimuth = coords.y;
        camHeight = coords.z;
    }
    
    /**
     * Calculate the azimuth angle and the camera
     * height.
     */
    void calculatePosition() {
        azimuth = map(mouseX, 0, width, azimuthMin, azimuthMax);
        camHeight = map(mouseY, 0, height, camHeightMin, camHeightMax);
    }
    
    /**
     * Start using the new parameters.
     */
    void start() {
        //Convert to cartesian components
        float x = radius * sin(azimuth) + target.x;
        float z = radius * cos(azimuth) + target.z;
        camera(x, camHeight, z, target.x, target.y, target.z, up.x, up.y, up.z);
    }
    
    /**
     * Start 2D rendering mode.
     * Remember to call endHUD() after 2D
     * drawing.
     */
    void startHUD() {
        camera();
        hint(DISABLE_DEPTH_TEST);
    }
    
    /**
     * Go back to 3D rendering mode
     */ 
    void endHUD() {
        hint(ENABLE_DEPTH_TEST);
    }
}
