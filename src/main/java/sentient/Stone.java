package sentient;

public class Stone extends Thing {
    private static float STONE_SIZE = 20;
    public int baseColor;
    
    public Stone(int color) {
        this.size = STONE_SIZE;
        this.angle = 0;
        this.baseColor = color;
    }
}
