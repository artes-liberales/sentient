interface Brain {
  abstract Brain clone();
  abstract float[] think(float[] inputSignal);
}



//Does nothing
class AiEmptyHead implements Brain {
  //Constructor
  AiEmptyHead() {
  }
  
  //Copy constructor
  private AiEmptyHead(Brain original) {
  }
  
  //Clone it
  Brain clone() {
    return new AiEmptyHead(this);
  }
  
  float[] think(float[] inputSignal) {
    float[] outputSignal = new float[2];
    return outputSignal;
  }
}



//Swims randomly
class AiRandomFlapping implements Brain {
  float flapLikelihood;
  
  //Constructor
  AiRandomFlapping() {
    flapLikelihood = random(0.005, 0.02);
  }
  
  //Copy constructor
  private AiRandomFlapping(Brain original) {
    flapLikelihood = ((AiRandomFlapping)original).flapLikelihood;
  }
  
  //Clone it
  Brain clone() {
    return new AiRandomFlapping(this);
  }
  
  float[] think(float[] inputSignal) {
    float[] outputSignal = new float[2];
    
    if (random(1) < flapLikelihood) {
      outputSignal[0] = 1;
    }
    
    if (random(1) < flapLikelihood) {
      outputSignal[1] = 1;
    }
    
    return outputSignal;
  }
}



//Swims towards food that is in field of vision
class AiHomingIn implements Brain {
  //Constructor
  AiHomingIn() {
    
  }
  
  //Copy constructor
  private AiHomingIn(Brain original) {
    
  }
  
  //Clone it
  Brain clone() {
    return new AiHomingIn(this);
  }
  
  float[] think(float[] inputSignal) {
    float[] outputSignal = new float[2];
    
    if (1 == inputSignal[0]) {
      outputSignal[1] = 1;
    }
    
    if (1 == inputSignal[1]) {
      outputSignal[0] = 1;
    }
    
    return outputSignal;
  }
}



//If there is no food in sight, swim randomly
class AiSeeker implements Brain {
  Brain reptileBrain;
  
  //Constructor
  AiSeeker() {
    reptileBrain = new AiRandomFlapping();
  }
  
  //Copy constructor
  private AiSeeker(Brain original) {
    reptileBrain = ((AiSeeker)original).getReptileBrain().clone();
  }
  
  //Clone it
  Brain clone() {
    return new AiSeeker(this);
  }
  
  Brain getReptileBrain() {
    return reptileBrain;
  }
  
  float[] think(float[] inputSignal) {
    if (0 == inputSignal[0] && 0 == inputSignal[1]) {
      return reptileBrain.think(inputSignal);
    }
    
    
    float[] outputSignal = new float[2];
    
    if (1 == inputSignal[0]) {
      outputSignal[1] = 1;
    }
    
    if (1 == inputSignal[1]) {
      outputSignal[0] = 1;
    }
    
    return outputSignal;
  }
}



class AiNetwork implements Brain {
  Network network;

  //Constructor
  AiNetwork() {
    network = new Network();
  }

  //Copy constructor
  private AiNetwork(AiNetwork original) {
    network = original.network.clone();
  }

  //Clone it
  Brain clone() {
    return new AiNetwork(this);
  }

  float[] think(float[] inputSignal) {
    return network.fire(inputSignal);
  }
}

