package monitors;

/** This class is an implementation of a waiter for the dining philosophers problem.
 * The waiter makes sure that only four philosophers are seated at the table at a time. 
 * This restriction avoids deadlock, no matter what order the philosophers pick up their forks 
 * (as long as the philosophers don't hold onto the forks forever)
 * 
 * @author Kenta Hasui
 */
public class WaiterMon {
	private int numSeated;		// Number of philosophers at the table 
	private int capacity;		// Max number of philosophers that can be seated at the table WITHOUT causing deadlock
	
	/** Constructor */
	public WaiterMon(){
		// initialize instance variables
		numSeated = 0;
		capacity = TableMon.getTableSize() - 1;
	}
	
	/** Method to simulate the waiter seating a philosopher at the table. 
	 *  Since this method is synchronized, only one philosopher thread has access to the waiter 
	 *  at any one time. In this way, we can avoid race conditions when updating the number of 
	 *  philosophers at the table
	 */
	public synchronized void sitDown(int id){
		// If four philosophers are already seated, wait for someone to leave the table
		while(numSeated == capacity){
			System.out.println("Philosopher " + id + ": Table is full. Will wait until someone leaves");
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		System.out.println("Philosopher " + id + " sitting at table.");
		// Sit at the table
		numSeated++;
	}
	
	/** Method to simulate a philosopher getting the check and leaving the table. 
	 * This method is synchronized, meaning only one philosopher thread can have access 
	 * to the waiter at any one time. This avoids race conditions when decrementing the 
	 * number of philosophers at the table.
	 * @param id
	 */
	public synchronized void standUp(int id){
		// Leave the table
		numSeated--;
		System.out.println("Philosopher " + id + " leaving table");
		// If the table was full, let other philosophers know that the table opened up
		if(numSeated == capacity - 1){
			System.out.println("Table is no longer full! Somebody else can sit now");
			notifyAll();
		}
	}

}
