package sentient.brain;

public class AiSeeker implements Brain {
    public Brain reptileBrain;
    
    /**
     * Constructor.
     */
    public AiSeeker() {
      reptileBrain = new AiRandomFlapping();
    }
    
    /**
     * Copy constructor.
     */
    private AiSeeker(Brain original) {
      reptileBrain = ((AiSeeker)original).getReptileBrain().clone();
    }
    
    //Clone it
    public Brain clone() {
      return new AiSeeker(this);
    }
    
    public Brain getReptileBrain() {
      return reptileBrain;
    }
    
    public float[] think(float[] inputSignal) {
      if (0 == inputSignal[1] && 0 == inputSignal[2] && 0 == inputSignal[3] && 0 == inputSignal[4]) {
        return reptileBrain.think(inputSignal);
      }
      
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
