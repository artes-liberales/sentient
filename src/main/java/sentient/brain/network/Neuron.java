package sentient.brain.network;

import java.util.ArrayList;
import java.util.List;

public abstract class Neuron {
    public List<Connection> connections;
    public float sum;
    
    /**
     * Constructor.
     */
    public Neuron() {
        connections = new ArrayList<Connection>();
        sum = 0;
    }
    
    /**
     * Add a connection to the neuron.
     */
    public void addConnection(Connection c) {
        connections.add(c);
    }
    
    public void feedForward(float input) {
        sum += input;
        // Activate the neuron and fire the outputs?
        if (1 < sum) {
            fire(cap(sum));
            // If we’ve fired off our output,
            // we can reset our sum to 0.
            sum = 0;
        }
    }
    
    /**
     * Send out a signal through all connections.
     */
    protected void fire(float output) {
        for (Connection c : connections) {
            c.feedForward(output);
        }
    }
    
    /**
     * Set an upper limit to the signal strength.
     */
    private float cap(float input) {
        if (1 < input) {
            return 1;
        }
        
        return input;
    }
    
    /**
     * Get the output.
     * Mostly used for output neurons.
     */
    public float collectSum() {
        if (1 < sum) {
            float temp = sum;
            sum = 0;
            return temp;
        }
        
        sum = 0;
        return 0;
    }
}
