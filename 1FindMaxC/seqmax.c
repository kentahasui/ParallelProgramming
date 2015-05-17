#include <stdio.h>
#include <stdlib.h>

/* Program: seqmax.c
 * Author: Kenta Hasui
 * Course: CS 337
 * Date: 02/07/15
 *
 * Description: 
 * A program that finds the max of N numbers.
 * The program prompts the user for a list of numbers,
 * which is read from stdin using scanf().
 * This version uses array indexing (subscripts) to access the 
 * elements of the array. 
 */

void get_size();
void init_numbers(int n, int* numbers);
void read_numbers(int* numbers);
void print_numbers(int n, int* numbers);
int find_max(int n, int* numbers);
static int SIZE; // Static variable to hold the size of the input array

/* Fill an array of int values, prompting the user from stdin;
 * echo the list of numbers entered, then find the max and print it
 */ 
int main()
{ // Prompt the user for the size of the array
  // Store the size in the static integer SIZE
  get_size();
  if(SIZE<=0){
    fprintf(stderr, "Error! The size must be greater than 0!\n");
    exit(-1);
  }
  // Create a new array of numbers, of size "SIZE".
  int numbersArray[SIZE];
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
  int i;
  // Loop through all n spaces in the numbers array
  for(i = 0; i<SIZE; i++){
    numbers[i] = -1;
  }
}

void read_numbers(int* numbers)
{ 
  printf("Please input numbers. Press enter after each number\n");
  // scans input numbers and places them in an array
  int i; // Declare i to use in the for loop
  for (i = 0; i<SIZE; i++){
    // Places the input number at each index of the array
    scanf("%d", &numbers[i]);
  }
}

/*
 * print n elements of given array
 */
void print_numbers(int n, int* numbers)
{
  printf("Numbers: [");
  int i; // Initialize i for the loop
  for(i=0; i<n; i++){
    printf("%d ", numbers[i]);
  }
  printf("]\n");
}

/*
 * Find max from first n numbers in given array
 */
int find_max(int n, int* numbers)
{ 
  // Declare counter variable and max variable
  int i, max;
  // max holds the maximum number of values seen so far
  // max is initialized to the first element in the array
  max = numbers[0];
  for(i = 1; i<n; i++){
    // current variable holds the element at position i in the array
    int current = numbers[i];
    // If the current number is larger than the max so far, update the max variable
    if(current > max){
      max = current;
    }
  }
  // Returns the max seen so far
  return max;
}
