package sentient;

import static org.junit.Assert.*;

import org.junit.Test;

public class UtilTest {
    @Test
    public void valueWithinInterval() throws Exception {
        float min = 0.01f;
        float max = 0.02f;
        
        float result = Util.getRandomInterval(min, max);
        
        boolean withinInterval = min <= result && result <= max;
        assertTrue(withinInterval);
    }
}
