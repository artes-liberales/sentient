package sentient.brain.network;

public class OutputNeuron extends Neuron {
    //Constructor
    public OutputNeuron() {
      super();
    }
    
    @Override
    public void feedForward(float input) {
      sum += input;
    }
    
    //Dont do anything,
    //just wait for someone to collect value of sum
    @Override
    public void fire() {
    }
}
