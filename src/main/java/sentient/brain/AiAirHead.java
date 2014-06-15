package sentient.brain;

public class AiAirHead implements Brain {
    /**
     * Constructor.
     */
    public AiAirHead() {
    }
    
    /**
     * Copy constructor.
     */
    private AiAirHead(Brain original) {
    }
    
    //Clone it
    public Brain clone() {
      return new AiAirHead(this);
    }
    
    public float[] think(float[] inputSignal) {
      float[] outputSignal = new float[2];
      return outputSignal;
    }
}
