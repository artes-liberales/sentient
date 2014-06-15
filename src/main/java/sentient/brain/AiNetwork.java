package sentient.brain;

import sentient.brain.network.Network;

public class AiNetwork implements Brain {
    public Network network;
    
    /**
     * Constructor.
     */
    public AiNetwork() {
        network = new Network();
    }
    
    /**
     * Copy constructor.
     */
    private AiNetwork(AiNetwork original) {
        network = original.network.clone();
    }
    
    // Clone it
    public Brain clone() {
        return new AiNetwork(this);
    }
    
    public float[] think(float[] inputSignal) {
        return network.fire(inputSignal);
    }
}
