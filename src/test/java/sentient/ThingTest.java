package sentient;

import static org.junit.Assert.*;

import org.junit.Test;

public class ThingTest {
    private static final float DELTA = 0.000001f;
    
    @Test
    public void applyAngularForce() throws Exception {
        Thing thing = new Thing();
        thing.mass = 2.0f;
        
        thing.applyAngularForce(4.0f);
        
        assertEquals(2.0f, thing.angularAcc, DELTA);
    }
    
    @Test
    public void wrapEdgesMiddle() throws Exception {
        Thing thing = new Thing();
        thing.location.x = 1;
        thing.location.y = 1;
        thing.radius = 10;
        
        thing.wrapEdges();
        
        assertEquals(1, thing.location.x, DELTA);
        assertEquals(1, thing.location.y, DELTA);
    }
    
    @Test
    public void wrapEdgesRight() throws Exception {
        Thing thing = new Thing();
        thing.location.x = Sentient.MAP_WIDTH + 10;
        thing.location.y = 1;
        thing.radius = 10;
        
        thing.wrapEdges();
        
        assertEquals(-thing.radius, thing.location.x, DELTA);
        assertEquals(1, thing.location.y, DELTA);
    }
    
    @Test
    public void wrapEdgesLeft() throws Exception {
        Thing thing = new Thing();
        thing.location.x = -10;
        thing.location.y = 1;
        thing.radius = 10;
        
        thing.wrapEdges();
        
        assertEquals(Sentient.MAP_WIDTH + thing.radius, thing.location.x, DELTA);
        assertEquals(1, thing.location.y, DELTA);
    }
    
    @Test
    public void wrapEdgesBottom() throws Exception {
        Thing thing = new Thing();
        thing.location.x = 1;
        thing.location.y = Sentient.MAP_HEIGHT + 10;
        thing.radius = 10;
        
        thing.wrapEdges();
        
        assertEquals(1, thing.location.x, DELTA);
        assertEquals(-thing.radius, thing.location.y, DELTA);
    }
    
    @Test
    public void wrapEdgesTop() throws Exception {
        Thing thing = new Thing();
        thing.location.x = 1;
        thing.location.y = -10;
        thing.radius = 10;
        
        thing.wrapEdges();
        
        assertEquals(1, thing.location.x, DELTA);
        assertEquals(Sentient.MAP_HEIGHT + thing.radius, thing.location.y, DELTA);
    }
}
