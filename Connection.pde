class Connection {
  // The Connection’s data
  float weight;
  Neuron a;
  Neuron b;

  Connection(Neuron from, Neuron to, float w) {
    weight = w;
    a = from;
    b = to;
  }

  // The Connection is active with data traveling from a to b.
  void feedforward(float val) {
    float output = val * weight;
    b.feedForward(output);
  }
}

