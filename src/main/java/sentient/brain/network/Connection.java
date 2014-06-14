package sentient.brain.network;


public class Connection {
    // The Connectionís data
    public Neuron toNeuron;
    public float weight;
    
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
