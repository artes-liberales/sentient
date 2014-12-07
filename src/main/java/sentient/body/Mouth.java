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
        updateProportions(faceSize, 0);
    }
    
    public void updateProportions(float faceSize, float hunger) {
        location = new PVector(faceSize / 2.5f, 0);
        width = faceSize / 8 * (0.5f + hunger / 2);
        height = faceSize / 4;
    }
}
