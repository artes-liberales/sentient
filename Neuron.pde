class Neuron {
  ArrayList<Connection> connections;
  int sum = 0;

  Neuron() {
    connections = new ArrayList<Connection>();
  }

  void addConnection(Connection c) {
    connections.add(c);
  }
  
  void feedForward(float input) {
    sum += input;
    // Activate the neuron and fire the outputs?
    if (1 < sum) {
      fire();
      // If we’ve fired off our output,
      // we can reset our sum to 0.
      sum = 0;
    }
  }

  //Send the sum out through all connections
  void fire() {
    for (Connection c : connections) {
      c.feedforward(sum);
    }
  }
}



class BiasNeuron extends Neuron {
  int sum;

  BiasNeuron(int sum) {
    super();
    this.sum = sum;
  }
  
  void feedforward(float input) {
    fire();
  }
}



class OutputNeuron extends Neuron {
  int sum;

  OutputNeuron() {
    super();
    this.sum = 0;
  }
  
  //Dont do anything,
  //just wait for someone to collect value of sum
  void feedforward(float input) {
  }
}

