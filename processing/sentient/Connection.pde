class Connection {
  // The Connection’s data
  Neuron toNeuron;
  float weight;

  Connection(Neuron to, float w) {
    toNeuron = to;
    weight = w;
  }

  // The Connection is active with data traveling from a to b.
  void feedForward(float val) {
    float output = val * weight;
    toNeuron.feedForward(output);
  }
}

