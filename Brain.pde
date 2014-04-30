interface Brain {
  abstract float[] think(float[] inputSignal);
  abstract Brain clone();
}



class AiRandomFlapping implements Brain {
  float flapLikelihood;
  
  //Constructor
  AiRandomFlapping() {
    flapLikelihood = random(0.005, 0.02);
  }
  
  //Copy constructor
  AiRandomFlapping(Brain original) {
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



class AiEmptyHead implements Brain {
  //Constructor
  AiEmptyHead() {
  }
  
  //Copy constructor
  AiEmptyHead(Brain original) {
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



class AiHomingIn implements Brain {
  //Constructor
  AiHomingIn() {
    
  }
  
  //Copy constructor
  AiHomingIn(Brain original) {
    
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

