#include <stdio.h>
#include <stdlib.h>

/* Program: seqmaxDynamic.c
 * Author: Kenta Hasui
 * Course: CS 337
 * Date: 02/07/15
 *
 * Description: 
 * A program that finds the max of N numbers.
 * The program prompts the user for a list of numbers,
 * which is read from stdin using scanf().
 * This version uses dynamic memory allocation.
 */
void get_size();
void init_numbers(int n, int* numbers);
void read_numbers(int* numbers);
void print_numbers(int n, int* numbers);
int find_max(int n, int* numbers);
static int SIZE; // Static variable to hold the size of the input array

/* Fill an array of int values, prompting the user from stdin;
 * dcho the list of numbers entered, then find the max and print it
 */ 
int main()
{ // Prompt the user for the size of the array
  // Store the size in the static integer SIZE
  get_size();
  // Prints an error message and quits the program if 
  // the size is less than or equal to 0. 
  if(SIZE<=0){
    fprintf(stderr, "Error! The size must be greater than 0!\n");
    exit(-1);
  }
  // Create a pointer to a new array of numbers.
  int *numbersArray;
  /* Allocate memory for the array. The amount of memory needed 
   * is the size of the array (SIZE) times the amount of memory
   * needed to store an int 
   */
  numbersArray = (int *) malloc(SIZE * sizeof(int)); 
  // Pass the pointer to the array into these functions
  // Initialize all elements in the array to -1
  init_numbers(SIZE, numbersArray);
  // Read the user input
  read_numbers(numbersArray);
  // Print all values in the array
  print_numbers(SIZE, numbersArray);
  // Print the max values, evaluated by our functions
  printf("Max number: %d\n", find_max(SIZE, numbersArray));
  printf("Max number out of first half: %d\n", 
      find_max(SIZE/2, numbersArray));
  // Free the memory allocated by malloc
  free(numbersArray);
}

/* 
 * Prompts the user for the size of the array we will be using
 * Stores this number in the static integer "SIZE"
 */
void get_size()
{ 
  printf("Please enter array size:\n");
  // Retrieves the size of the array we will be building
  scanf("%d", &SIZE);
  printf("The size is %d\n", SIZE);
}

/*
 * initialize n elements of numbers array to -1
 */
void init_numbers(int n, int* numbers){
  // Loop through all n spaces in the numbers array
  while(n > 0){
    // Set the value at the current array index to -1
    *numbers = -1;
    // increment the array pointer
    numbers++;
    // decrement n, so we will eventually terminate the loop
    n--;
  }
}

void read_numbers(int* numbers)
{ 
  printf("Please input %d numbers. Press enter after each number\n",
      SIZE);
  // scans input numbers and places them in an array
  int i; // Declare i to use in the for loop
  for (i = 0; i<SIZE; i++)
  { // Places the input number where the array pointer is pointing to
    scanf ("%d", numbers);
    // Increment the pointer
    numbers++;
  }
}

/*
 * print n elements of given array
 */
void print_numbers(int n, int* numbers)
{
  printf("[");
  int i; // Initialize i for the loop
  for(i=0; i<n; i++){
    printf("%d ", *numbers++);
  }
  printf("]\n");
}

/*
 * Find max from first n numbers in given array
 */
int find_max(int n, int* numbers)
{
  int max, *upperLimit;
  // upperLimit variable represents the highest value the pointer can go up to.
  // This insures we only look at the first n numbers
  // upperLimit is a pointer in order to compare it to numbers
  upperLimit = numbers + n;
  // max is initialized to the first element in the array 
  max = *numbers;
  // the pointer now points to the second element (position 1)
  numbers++;
  // Loop through the n elements in the array
  for(; numbers<upperLimit; numbers++){
    // current holds the value of element pointed to by numbers pointer
    int current = *numbers;
    // Update the max variable if the current number  
    // is larger than the max so far
    if(current > max){
      max = current;
    }
  }
  // return the maximum value in the array
  return max;
}
