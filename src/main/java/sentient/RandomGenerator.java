package sentient;

import java.util.Random;

public class RandomGenerator {
    public static Random javaRandom = new Random();
    
    /**
     * Get a random value within the given interval.
     */
    public static float getRandomInterval(float min, float max) {
        float range = (max - min);
        return (float) ((Math.random() * range) + min);
    }
    
    /**
     * Get a random value from a Gaussian distribution.
     */
    public static float gaussianCalculator(float mean, float standardDeviation) {
        float g = (float) javaRandom.nextGaussian();
        return standardDeviation * g + mean;
    }
}
