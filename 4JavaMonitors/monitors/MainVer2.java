package monitors;

/**
 * This is the main program to demonstrate 
 * a monitor solution to the Dining Philosophers 
 * problem in Java.  It uses threads, monitors (TableMon and WaiterMon) 
 * and synchronized methods. 
 * 
 * To compile: javac MainVer2.java Philosopher2.java TableMon.java WaiterMon.java (within blocks directory)
 * To run: java MainVer2 (from within assign4 directory)
 *
 * @author Kenta Hasui
 * @version 1.0
 */
public class MainVer2 {

	/*
	 * The main method for the Main class
	 */
	public static void main(String[] arg)
	{
		// Create the table
		TableMon table = new TableMon();
		// Create a waiter: IT'S ALIIIVE
		WaiterMon waiter = new WaiterMon();

		// Create and start the philosophers (threads)
		for (int i=0; i < TableMon.getTableSize(); i++) {
			new Philosopher2(i, table, waiter).start();
		}
	}

}
