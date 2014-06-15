package sentient.brain;

import sentient.RandomGenerator;

public class AiRandomFlapping implements Brain {
    public float flapLikelihood;
    
    /**
     * Constructor.
     */
    public AiRandomFlapping() {
      flapLikelihood = RandomGenerator.getRandomInterval(0.005f, 0.02f);
    }
    
    /**
     * Copy constructor.
     */
    private AiRandomFlapping(Brain original) {
      flapLikelihood = ((AiRandomFlapping)original).flapLikelihood;
    }
    
    //Clone it
    public Brain clone() {
      return new AiRandomFlapping(this);
    }
    
    public float[] think(float[] inputSignal) {
      float[] outputSignal = new float[2];
      
      if (Math.random() < flapLikelihood) {
        outputSignal[0] = 1;
      }
      
      if (Math.random() < flapLikelihood) {
        outputSignal[1] = 1;
      }
      
      return outputSignal;
    }
}
