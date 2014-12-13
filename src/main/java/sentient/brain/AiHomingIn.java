package sentient.brain;

public class AiHomingIn implements Brain {
    /**
     * Constructor.
     */
    public AiHomingIn() {
      
    }
    
    /**
     * Copy constructor.
     */
    private AiHomingIn(Brain original) {
      
    }
    
    //Clone it
    public Brain clone() {
      return new AiHomingIn(this);
    }
    
    public float[] think(float[] inputSignal) {
      float[] outputSignal = new float[2];
      
      if (1 == inputSignal[1]) {
        outputSignal[1] = 1;
      }
      
      if (1 == inputSignal[2]) {
        outputSignal[1] = 1;
      }
      
      if (1 == inputSignal[3]) {
        outputSignal[0] = 1;
      }
      
      if (1 == inputSignal[4]) {
        outputSignal[0] = 1;
      }
      
      return outputSignal;
    }
}
