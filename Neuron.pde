abstract class Neuron {
  ArrayList<Connection> connections;
  int sum;
  
  //Constructor
  Neuron() {
    connections = new ArrayList<Connection>();
    sum = 0;
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
      c.feedForward(sum);
    }
  }

  //Get the output
  float collectSum() {
    float temp = sum;
    sum = 0;
    return temp;
  }
}



class InputNeuron extends Neuron {
  //Constructor
  InputNeuron() {
    super();
  }
}



class BiasNeuron extends Neuron {
  //Constructor
  BiasNeuron(int sum) {
    super();
    this.sum = sum;
  }
  
  void feedForward(float input) {
    fire();
  }
}



class OutputNeuron extends Neuron {
  //Constructor
  OutputNeuron() {
    super();
  }
  
  @Override
  void feedForward(float input) {
    sum += input;
  }
  
  //Dont do anything,
  //just wait for someone to collect value of sum
  @Override
  void fire() {
  }
}

