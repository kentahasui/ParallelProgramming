#include <stdio.h>
#include <upc.h>
#include <time.h>

static shared int size;

// Function to calculate size of the array will work with
// Should only be called by Thread 0. 
void getSize(){
  printf("Please input array size: ");
  // Scans array length into the size variable
  scanf("%d", &size); 
}

// function to get the elements to store in an array
// Called by all threads
// Takes a local pointer into the shared array as an argument 
void getArrayElements(shared int * pointer){
  // Create a temporary pointer
  shared int * tempPointer = pointer;
  // pointer points to current thread's index
  tempPointer += MYTHREAD;
  int i; 
  for(i = MYTHREAD, i<size; i+= THREADS, tempPointer+= THREADS){
    printf("Please input number: ");
    scanf("%d", tempPointer);
    printf("\n");
  }
}

// Method to initialize all indices in the partial sum array to 0
void initPartialSums(shared int * partialSumPointer){
  shared int * temp = partialSumPointer;
  temp += MYTHREAD;
  *temp = 0;
}

// Method to get the partial sums from the input array. 
// Takes a pointer into the numbers array, and 
// a pointer into the partial sum array as inputs
void getPartialSums(shared int * input, shared int * partSum){
  int i;
  // Initialize the input pointer and the partial sum pointer
  // to index MYTHREAD. The partial sum pointer can stay there,
  // since there are only THREADS elements in the array
  for(i = MYTHREAD, input += MYTHREAD, partSum += MYTHREAD;
      i < size; i+=THREADS; input+=THREADS){
    // The element at index MYTHREAD is updated
    *partSum = *partSum + *input;
  }
}

// Method to calculate the mean. Should only be called by thread 0. 
double getMean(shared int * pointer){
  int i; 
  double mean = 0.0;
  for(i = 0; i<THREADS; i++, pointer++){
    mean += *pointer;
  }
  mean = mean / (double) size;
  return mean;
}

int main(){
  // Have thread 0 update the size variable
  if(MYTHREAD == 0) { getSize();}
  upc_barrier; // Make sure the variable is initialized
  // Arrays for numbers, and for partial sums
  static shared int nums[size];
  static shared int partSums[THREADS];
  // Pointers to the arrays
  shared int *numsPointer = nums;
  shared int *partSumsPointer = partSums;

  // Fills nums array with user input
  getArrayElements(numsPointer);
  // Fills partSums array with 0s
  initPartialSums(partSumsPointer);
  // Wait for both arrays to get filled
  upc_barrier; 

  getPartialSums(numsPointer, partSumsPointer);
  upc_barrier;
  
  if(MYTHREAD == 0){
    // Have pointer point to start of array again
    partSumsPointer = partSums;
    // calculate the mean
    double mean = getMean(partSumsPointer);
    printf("The mean is: %f \n", mean);
  }

  return 0;
}

