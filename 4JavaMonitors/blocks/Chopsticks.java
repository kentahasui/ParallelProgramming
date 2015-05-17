package blocks;

/** This class implements Chopsticks, which contains an array of individual Chopstick objects 
 * 
 *  @author Kenta Hasui
 *  */
public class Chopsticks {
	// Number of chopsticks at the table
	public static final int SIZE = 5;
	// Array of chopsticks for the philosophers to use
	public Chopstick[] chopsticks;
	
	/** Constructor */
	public Chopsticks(){
		// Initialize the array
		chopsticks = new Chopstick[SIZE];
		for(int i = 0; i<chopsticks.length; i++){
			chopsticks[i] = new Chopstick();
		}
	}
	
	// Method to get left chopstick
	public Chopstick getLeft(int id){
		return chopsticks[id];
	}
	// Method to get right chopstick
	public Chopstick getRight(int id){
		return chopsticks[getRightIndex(id)];
	}
	
	/** Gets the index of the right chopstick. */
	private int getRightIndex(int id){
		return (id+1)%SIZE;
	}
	
	/** Inner chopstick Class
	 * 
	 * @author Kenta Hasui
	 *
	 */
	public class Chopstick {
		boolean available;
		
		public Chopstick(){
			available = true;
		}
		
		public boolean isAvailable(){
			return available;
		}
		
		public void setAvailable(boolean bool){
			available = bool;
		}
	}
	

}
