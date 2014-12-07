package sentient.body;

import processing.core.PVector;

public class Mouth {
    public PVector location;
    public float width;
    public float height;
    
    /**
     * Constructor.
     */
    public Mouth(float faceSize) {
        updateProportions(faceSize);
    }
    
    public void updateProportions(float faceSize) {
        location = new PVector(faceSize / 2.5f, 0);
        width = faceSize / 15;
        height = faceSize / 5;
    }
}
