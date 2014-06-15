package sentient.brain.network;

import java.util.ArrayList;
import java.util.List;

public abstract class Neuron {
    public List<Connection> connections;
    public int sum;
    
    /**
     * Constructor.
     */
    public Neuron() {
        connections = new ArrayList<Connection>();
        sum = 0;
    }
    
    public void addConnection(Connection c) {
        connections.add(c);
    }
    
    public void feedForward(float input) {
        sum += input;
        // Activate the neuron and fire the outputs?
        if (1 < sum) {
            fire();
            // If we’ve fired off our output,
            // we can reset our sum to 0.
            sum = 0;
        }
    }
    
    // Send the sum out through all connections
    public void fire() {
        for (Connection c : connections) {
            c.feedForward(sum);
        }
    }
    
    // Get the output
    public float collectSum() {
        if (1 < sum) {
            float temp = sum;
            sum = 0;
            return temp;
        }
        
        return 0;
    }
}
