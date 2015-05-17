package blocks;

/**
 * This class implements a dining philosopher, using synchronized code blocks.
 * Has instance variables for an integer id, and a Chopsticks object
 * 
 * @author Kenta Hasui
 * @version 1.0
 */
public class Philosopher1 extends Thread
{
    // instance variables 
    private int id;          		// Philosopher's unique identifier
    private Chopsticks chopsticks; // Chopsticks that philosopher eats with
    
    /** Constructor for Philosopher objects, using chopsticks rather than tables */
    public Philosopher1(int id, Chopsticks chopsticks)
    {
      // initialize instance variables
      this.id = id;
      this.chopsticks = chopsticks;
    }

    /*
     * A dining philosopher's behavior 
     * is to eat and think -- forever!
     */ 
    public void run()
    {
    	// don't all start in order of creation!
    	this.delay( this.randomInt() );

    	while (true) {
    		// eat
    		eat();
    		// think
    		think();
    	}
    }
    
    /** Method for a philosopher to pick up both chopsticks, eat, and then release the chopsticks. 
     * There are synchronized code blocks contained in the method to avoid race conditions. Only 
     * one thread can hold each chopstick at one time. 
     * Even numbered philosophers pick up the left chopstick first, then the right chopstick. 
     * Odd numbered philosophers pick up the right chopstick first, then the left one. 
     * This is done to avoid deadlock*/
    private void eat(){
    	/* Pick up chopsticks! */
    	
    	if(id % 2 == 0){
    		/* Getting left chopstick. It is a synchronized code block, so only one philosopher can pick up a chopstick at a time. */
        	synchronized(chopsticks.getLeft(id)){
        		System.out.println("Philosopher " + id + " got left chopstick");
        		// simulate time to pick up fork
        		this.delay(this.randomInt()); 
        		/* Getting right chopstick. Again, this block of code is synchronized */
        		synchronized(chopsticks.getRight(id)){
        			System.out.println("Philosopher " + id + " got right chopstick");
        			// simulate time to pick up fork
        			this.delay(this.randomInt()); 

        			/* Eating */
        			System.out.println("Philosopher " + id + " eating...");
        			this.delay( this.randomInt() ); // chew your food!
        			System.out.println("BURP! (Philosopher " + this.id + ")");
        			
        			/* Put down right chopstick */
        			System.out.println("Philosopher " + id + " releasing right chopstick");
        			this.delay( this.randomInt() );   // simulate time to put down fork
        		}
        		/* Put down left chopstick */
        		System.out.println("Philosopher " + id + " releasing left chopstick");
        		this.delay( this.randomInt() );   // simulate time to put down fork
        	}
    	}
    	
    	else{
    		/* Getting right chopstick. It is a synchronized code block, so only one philosopher can pick up a chopstick at a time. */
        	synchronized(chopsticks.getRight(id)){
        		System.out.println("Philosopher " + id + " got right chopstick");
        		// simulate time to pick up fork
        		this.delay(this.randomInt()); 
        		/* Getting right chopstick. Again, this block of code is synchronized */
        		synchronized(chopsticks.getLeft(id)){
        			System.out.println("Philosopher " + id + " got left chopstick");
        			// simulate time to pick up fork
        			this.delay(this.randomInt()); 

        			/* Eating */
        			System.out.println("Philosopher " + id + " eating...");
        			this.delay( this.randomInt() ); // chew your food!
        			System.out.println("BURP! (Philosopher " + this.id + ")");
        			
        			/* Put down right chopstick */
        			System.out.println("Philosopher " + id + " releasing left chopstick");
        			this.delay( this.randomInt() );   // simulate time to put down fork
        		}
        		/* Put down left chopstick */
        		System.out.println("Philosopher " + id + " releasing right chopstick");
        		this.delay( this.randomInt() );   // simulate time to put down fork
        	}
    	}
    	
    	
    }
    
    /** Simulates a philosopher eating */
    private void think(){
    	System.out.println("Philosopher " + id + " thinking...");
    	this.delay( this.randomInt() ); // can't rush genius!
    }

    /**
     * Returns a random integer.
     */
    public int randomInt() {
      double r = Math.random();
      return (int) Math.floor( r * 100 ) + 1;
    }

    /**
     * Simulates a philosopher pausing for a given amount of time.
     */
    public void delay(int mSec) {
      try {
        Thread.sleep(mSec);
      } catch (InterruptedException ex) {}
    }
}

