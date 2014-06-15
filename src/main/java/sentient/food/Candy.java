package sentient.food;

import sentient.Thing;

public class Candy extends Thing {
    private static float CANDY_SIZE = 20;
    public int baseColor;
    
    /**
     * Constructor.
     */
    public Candy(int color) {
      size = CANDY_SIZE;
      baseColor = color;
    }
}
