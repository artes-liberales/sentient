class Network {
  ArrayList<Neuron> neurons;

  Network() {
    neurons = new ArrayList<Neuron>();
 
    //Create neurons
    Neuron input0 = new InputNeuron();
    Neuron input1 = new InputNeuron();
    Neuron bias = new BiasNeuron(1);
    Neuron output0 = new OutputNeuron();
    Neuron output1 = new OutputNeuron();

    //Make connections between the neurons
    connect(input0, output0);
    connect(input0, output1);
    connect(input1, output0);
    connect(input1, output1);
    connect(bias, output0);
    connect(bias, output1);
 
    //Add the neurons to the network
    addNeuron(input0);
    addNeuron(input1);
    addNeuron(bias);
    addNeuron(output0);
    addNeuron(output1);
  }

  //Copy constructor
  private Network(Network original) {
    neurons = new ArrayList<Neuron>();
 
    //Create neurons
    Neuron input0 = new InputNeuron();
    Neuron input1 = new InputNeuron();
    Neuron bias = new BiasNeuron(1);
    Neuron output0 = new OutputNeuron();
    Neuron output1 = new OutputNeuron();

    //Make connections between the neurons
    Connection c = new Connection(output0, original.neurons.get(0).connections.get(0).weight);
    input0.addConnection(c);
    c = new Connection(output1, original.neurons.get(0).connections.get(1).weight);
    input0.addConnection(c);
    c = new Connection(output0, original.neurons.get(1).connections.get(0).weight);
    input1.addConnection(c);
    c = new Connection(output1, original.neurons.get(1).connections.get(1).weight);
    input1.addConnection(c);
    c = new Connection(output0, original.neurons.get(2).connections.get(0).weight);
    bias.addConnection(c);
    c = new Connection(output1, original.neurons.get(2).connections.get(1).weight);
    bias.addConnection(c);
 
    //Add the neurons to the network
    addNeuron(input0);
    addNeuron(input1);
    addNeuron(bias);
    addNeuron(output0);
    addNeuron(output1);
  }
  
  //Clone it
  Network clone() {
    return new Network(this);
  }

  void addNeuron(Neuron n) {
    neurons.add(n);
  }

  void connect(Neuron a, Neuron b) {
    Connection c = new Connection(b, random(1));
    a.addConnection(c);
  }

  float[] fire(float[] inputSignal) {
    neurons.get(0).feedForward(inputSignal[0]);
    neurons.get(1).feedForward(inputSignal[1]);
    neurons.get(2).feedForward(0);
    
    float[] outputSignal = new float[2];
    outputSignal[0] = neurons.get(3).collectSum();
    outputSignal[1] = neurons.get(4).collectSum();
    return outputSignal;
  }
}

