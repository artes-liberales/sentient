package sentient.brain;

public interface Brain {
    abstract Brain clone();
    abstract float[] think(float[] inputSignal);
}
