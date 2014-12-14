package sentient.brain.network;

import java.util.ArrayList;
import java.util.List;

public class Network {
    private static final float MUTATION_RATE = 0.02f;
    
    private List<Neuron> neurons;
    
    /**
     * Constructor.
     */
    public Network() {
        neurons = new ArrayList<Neuron>();
        
        // Create neurons
        Neuron hungerSensor = new InputNeuron();
        Neuron input1 = new InputNeuron();
        Neuron input2 = new InputNeuron();
        Neuron input3 = new InputNeuron();
        Neuron input4 = new InputNeuron();
        Neuron bias = new BiasNeuron(0);
        Neuron output0 = new OutputNeuron();
        Neuron output1 = new OutputNeuron();
        
        // Make connections between the neurons
        connect(hungerSensor, output0);
        connect(hungerSensor, output1);
        connect(input1, output0);
        connect(input1, output1);
        connect(input2, output0);
        connect(input2, output1);
        connect(input3, output0);
        connect(input3, output1);
        connect(input4, output0);
        connect(input4, output1);
        connect(bias, output0);
        connect(bias, output1);
        
        // Add the neurons to the network
        addNeuron(hungerSensor);
        addNeuron(input1);
        addNeuron(input2);
        addNeuron(input3);
        addNeuron(input4);
        addNeuron(bias);
        addNeuron(output0);
        addNeuron(output1);
    }
    
    /**
     * Copy constructor.
     */
    private Network(Network original) {
        neurons = new ArrayList<Neuron>();
        
        // Create neurons
        Neuron hungerSensor = new InputNeuron();
        Neuron input1 = new InputNeuron();
        Neuron input2 = new InputNeuron();
        Neuron input3 = new InputNeuron();
        Neuron input4 = new InputNeuron();
        Neuron bias = new BiasNeuron(1);
        Neuron output0 = new OutputNeuron();
        Neuron output1 = new OutputNeuron();
        
        // Get connection weights
        float weights[][] = new float[6][2];
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 2; j++) {
                // Check for mutation
                if (Math.random() < MUTATION_RATE) {
                    weights[i][j] = (float) Math.random();
                } else {
                    weights[i][j] = original.neurons.get(i).connections.get(j).weight;
                }
            }
        }
        
        // Make connections between the neurons
        Connection c;
        c = new Connection(output0, weights[0][0]);
        hungerSensor.addConnection(c);
        c = new Connection(output1, weights[0][1]);
        hungerSensor.addConnection(c);
        c = new Connection(output0, weights[1][0]);
        input1.addConnection(c);
        c = new Connection(output1, weights[1][1]);
        input1.addConnection(c);
        c = new Connection(output0, weights[2][0]);
        input2.addConnection(c);
        c = new Connection(output1, weights[2][1]);
        input2.addConnection(c);
        c = new Connection(output0, weights[3][0]);
        input3.addConnection(c);
        c = new Connection(output1, weights[3][1]);
        input3.addConnection(c);
        c = new Connection(output0, weights[4][0]);
        input4.addConnection(c);
        c = new Connection(output1, weights[4][1]);
        input4.addConnection(c);
        c = new Connection(output0, weights[5][0]);
        bias.addConnection(c);
        c = new Connection(output1, weights[5][1]);
        bias.addConnection(c);
        
        // Add the neurons to the network
        addNeuron(hungerSensor);
        addNeuron(input1);
        addNeuron(input2);
        addNeuron(input3);
        addNeuron(input4);
        addNeuron(bias);
        addNeuron(output0);
        addNeuron(output1);
    }
    
    /**
     * Clone the network.
     */
    public Network clone() {
        return new Network(this);
    }
    
    /**
     * Add a neuron to the network.
     */
    public void addNeuron(Neuron n) {
        neurons.add(n);
    }
    
    /**
     * Create a connection between two neurons.
     */
    public void connect(Neuron a, Neuron b) {
        Connection c = new Connection(b, (float) Math.random());
        a.addConnection(c);
    }
    
    /**
     * All neurons sends signals through their downstream connections.
     */
    public float[] fire(float[] inputSignal) {
        neurons.get(0).feedForward(inputSignal[0]);
        neurons.get(1).feedForward(inputSignal[1]);
        neurons.get(2).feedForward(inputSignal[2]);
        neurons.get(3).feedForward(inputSignal[3]);
        neurons.get(4).feedForward(inputSignal[4]);
        neurons.get(5).feedForward(0);
        
        float[] outputSignal = new float[2];
        outputSignal[0] = neurons.get(6).collectSum();
        outputSignal[1] = neurons.get(7).collectSum();
        return outputSignal;
    }
}
