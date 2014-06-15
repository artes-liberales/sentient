package sentient.brain.network;

public class BiasNeuron extends Neuron {
    /**
     * Constructor.
     */
    public BiasNeuron(int sum) {
      super();
      this.sum = sum;
    }
    
    public void feedForward(float input) {
      fire();
    }
}
