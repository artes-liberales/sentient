package sentient;

import static org.junit.Assert.*;

import org.junit.Test;

public class ThingTest {
    private static final float delta = 0.000001f;
    
    @Test
    public void applyAngularForce() throws Exception {
        Thing thing = new Thing();
        thing.mass = 2.0f;
        
        thing.applyAngularForce(4.0f);
        
        assertEquals(2.0f, thing.angularAcc, delta);
    }
}
