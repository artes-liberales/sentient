package sentient.food;

import sentient.Thing;

public class Candy extends Thing {
    public float CANDY_SIZE = 20;
    public int baseColor;
    
    /**
     * Constructor.
     */
    public Candy(int color) {
      size = CANDY_SIZE;
      baseColor = color;
    }
}
