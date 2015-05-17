package blocks;
/**
 * This is the main program to demonstrate 
 * a monitor solution to the Dining Philosophers 
 * problem in Java.  It uses threads, chopstick objects and 
 * synchronized code blocks (rather than synchronized methods)
 * 
 * To compile: javac MainVer1.java Chopsticks.java Philosopher1.java (within the blocks directory)
 * To run: java blocks/MainVer1 (within the assignment4 directory)
 * 
 * @author Kenta Hasui
 * @version 1.0
 */
public class MainVer1
{
    /*
     * The main method for the Main class
     */
    public static void main(String[] arg)
    {
      // Create the chopsticks
      Chopsticks chopsticks = new Chopsticks();

      // Create and start the philosophers (threads)
      for (int i=0; i < 5; i++) {
        new Philosopher1(i, chopsticks).start();
      }
    }
}
