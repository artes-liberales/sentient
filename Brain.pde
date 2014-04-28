interface Brain {
  abstract float[] think(float[] inputSignal);
  abstract Brain clone();
}



class RandomFlapping implements Brain {
  float flapLikelihood;
  
  //Constructor
  RandomFlapping() {
    flapLikelihood = random(0.005, 0.02);
  }
  
  //Copy constructor
  RandomFlapping(Brain original) {
    flapLikelihood = ((RandomFlapping)original).flapLikelihood;
  }
  
  //Clone it
  Brain clone() {
    return new RandomFlapping(this);
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



class EmptyHead implements Brain {
  //Constructor
  EmptyHead() {
  }
  
  //Copy constructor
  EmptyHead(Brain original) {
  }
  
  //Clone it
  Brain clone() {
    return new EmptyHead(this);
  }
  
  float[] think(float[] inputSignal) {
    float[] outputSignal = new float[2];
    return outputSignal;
  }
}



class HomingIn implements Brain {
  //Constructor
  HomingIn() {
    
  }
  
  //Copy constructor
  HomingIn(Brain original) {
    
  }
  
  //Clone it
  Brain clone() {
    return new HomingIn(this);
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

