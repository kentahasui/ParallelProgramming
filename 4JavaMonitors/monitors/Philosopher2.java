package monitors;

/** 
 * This class implements a dining philosopher, using monitors and synchronized methods 
 * Makes use of monitors representing tables (TableMon) and monitors representing Waiters (WaiterMon). 
 * @author kehasui
 *
 */
public class Philosopher2 extends Thread
{
    // instance variables 
    private int id;          // Philosopher's unique identifier
    private TableMon table;  // Table where philosopher eats
    private WaiterMon waiter;	// Waiter to seat the philosophers

    /**
     * Constructor for Philosopher objects 
     */    
    public Philosopher2(int id, TableMon table, WaiterMon waiter){
    	// Initialize instance vars
    	this.id = id;
    	this.table = table;
    	this.waiter = waiter;
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

    	  // get seated by the waiter
    	  waiter.sitDown(id);
    	  
    	  // pick up forks
    	  this.getForks();

    	  // eat
    	  System.out.println("Philosopher " + this.id + " eating...");
    	  this.delay( this.randomInt() ); // chew your food!

    	  // finished eating, so put down forks
    	  this.putDownForks();
    	  System.out.println("BURP! (Philosopher " + this.id + ")");
    	  
    	  // Leave the table
    	  waiter.standUp(id);
    	  
    	  // think
    	  System.out.println("Philosopher " + id + " thinking...");
    	  this.delay( this.randomInt() ); // can't rush genius!
      }
    }

    /**
     * Unsafe way to pick up both forks. However, we can use this method because our waiter ensures
     * that there will always be AT MOST 4 philosophers at the table. Thus we can avoid deadlock
     */
    private void getForks()
    {
      this.table.getLeftFork(this.id);
      this.delay( this.randomInt() );   // simulate time to pick up fork
      this.table.getRightFork(this.id);
      this.delay( this.randomInt() );   // simulate time to pick up fork
    }
	
    /**
     * Philosopher puts down forks.
     */
    private void putDownForks()
    {
      this.table.putDownLeftFork(this.id);
      this.delay( this.randomInt() );   // simulate time to put down fork
      this.table.putDownRightFork(this.id);
      this.delay( this.randomInt() );   // simulate time to put down fork
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
