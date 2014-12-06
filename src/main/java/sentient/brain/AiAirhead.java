package sentient.brain;

public class AiAirhead implements Brain {
    /**
     * Constructor.
     */
    public AiAirhead() {
    }
    
    /**
     * Copy constructor.
     */
    private AiAirhead(Brain original) {
    }
    
    //Clone it
    public Brain clone() {
      return new AiAirhead(this);
    }
    
    public float[] think(float[] inputSignal) {
      float[] outputSignal = new float[2];
      return outputSignal;
    }
}
