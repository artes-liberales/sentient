package sentient.brain.network;


public class Connection {
    // The Connection’s data
    public Neuron toNeuron;
    public float weight;
    
    /**
     * Constructor.
     */
    public Connection(Neuron to, float w) {
      toNeuron = to;
      weight = w;
    }
    
    // The Connection is active with data traveling from a to b.
    public void feedForward(float val) {
      float output = val * weight;
      toNeuron.feedForward(output);
    }
}
