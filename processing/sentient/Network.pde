class Network {
  final float MUTATION_RATE = 0.01;
  
  ArrayList<Neuron> neurons;

  Network() {
    neurons = new ArrayList<Neuron>();
    
    //Create neurons
    Neuron input0 = new InputNeuron();
    Neuron input1 = new InputNeuron();
    Neuron bias = new BiasNeuron(1);
    Neuron hungerSensor = new InputNeuron();
    Neuron output0 = new OutputNeuron();
    Neuron output1 = new OutputNeuron();

    //Make connections between the neurons
    connect(input0, output0);
    connect(input0, output1);
    connect(input1, output0);
    connect(input1, output1);
    connect(bias, output0);
    connect(bias, output1);
    connect(hungerSensor, output0);
    connect(hungerSensor, output1);
 
    //Add the neurons to the network
    addNeuron(input0);
    addNeuron(input1);
    addNeuron(bias);
    addNeuron(hungerSensor);
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
    Neuron hungerSensor = new InputNeuron();
    Neuron output0 = new OutputNeuron();
    Neuron output1 = new OutputNeuron();
    
    //Get connection weights
    float weights[][] = new float[4][2];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 2; j++) {
        //Check for mutation
        if (random(1) < MUTATION_RATE) {
          weights[i][j] = random(1);
        } else {
          weights[i][j] = original.neurons.get(i).connections.get(j).weight;
        }
      }
    }
    
    //Make connections between the neurons
    Connection c;
    c = new Connection(output0, weights[0][0]);
    input0.addConnection(c);
    c = new Connection(output1, weights[0][1]);
    input0.addConnection(c);
    c = new Connection(output0, weights[1][0]);
    input1.addConnection(c);
    c = new Connection(output1, weights[1][1]);
    input1.addConnection(c);
    c = new Connection(output0, weights[2][0]);
    bias.addConnection(c);
    c = new Connection(output1, weights[2][1]);
    bias.addConnection(c);
    c = new Connection(output0, weights[3][0]);
    hungerSensor.addConnection(c);
    c = new Connection(output1, weights[3][1]);
    hungerSensor.addConnection(c);
 
    //Add the neurons to the network
    addNeuron(input0);
    addNeuron(input1);
    addNeuron(bias);
    addNeuron(hungerSensor);
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
    neurons.get(3).feedForward(inputSignal[2]);
    
    float[] outputSignal = new float[2];
    outputSignal[0] = neurons.get(4).collectSum();
    outputSignal[1] = neurons.get(5).collectSum();
    return outputSignal;
  }
}

