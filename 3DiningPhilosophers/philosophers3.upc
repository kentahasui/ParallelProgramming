/*
 * Kenta Hasui
 * CS337
 * 3/31/2015
 * Assignment 3.3: Philosophers3.upc
 * 
 * Compile: upcc -T 5 philosophers3.upc
 * Run:     upcrun philosophers3
 *
 * Description: Implementation of Dining Philosophers
 *              problem. No busy waiting: uses upc_lock(). 
 *              To avoid deadlock, a "waiter" seats at most 
 *              four philosophers at a time at the table. 
 *              Two new states, STANDING and SITTING, are needed. 
 *
 */

#include <stdio.h>
#include <upc_relaxed.h>

typedef enum{THINKING, STARVING, EATING, STANDING, SITTING} philosopher_status_t;
upc_lock_t * shared a_fork[THREADS];
// Lock to access the number of philosophers at table
upc_lock_t * shared waiter;
// Number of philosophers at table
static shared int philCount = 0;

/*
 * Allocate shares resources: forks (really chopsticks)
 */
void initialize(void)
{
  a_fork[MYTHREAD] = upc_global_lock_alloc();
  waiter = upc_all_lock_alloc();
}

/*
 * Simulates the lifecycle of a single dining philosopher
 */
void life_cycle(void)
{
  philosopher_status_t state;
  int num_meals=0,
      delay_thinking=1,
      delay_eating=2;
  int left, right; 

  left = MYTHREAD;
  right = (MYTHREAD+1) % THREADS;
  state = THINKING;

  while (num_meals < 20) // life of each philo. is 20 meals
  { 
    if (state == THINKING) 
    {
      printf("Philosopher%2d:---I am thinking\n", MYTHREAD);
      sleep(delay_thinking);
      printf("Philosopher%2d:---I finished thinking, now I am starving\n", 
             MYTHREAD);
      state = STARVING;
		  state = STANDING;
    }

    // Tries to sit at table
    upc_lock(waiter);
    // If there are more than 1 seat still open, this thread can sit. 
    // Otherwise the thread must wait. 
    if(philCount < THREADS - 1){
	philCount++;
	state = SITTING;
	printf("Philosopher%2d:---I am now sitting. There are %d people at the table.\n", MYTHREAD, philCount);
    }
    else{
	printf("Philosopher%2d:---The table is full. I will come back later.\n", MYTHREAD);
    }
    upc_unlock(waiter);
		
    if(state == SITTING) {
	// tries to lock both forks
	upc_lock(a_fork[left]);
	upc_lock(a_fork[right]);

	// got both...
	printf("Philosopher%2d: I have both forks---I start eating\n", MYTHREAD);
	state = EATING; 
	sleep(delay_eating);
	num_meals++;

	printf("Philosopher%2d: I have both forks---I finished eating my %d meal", MYTHREAD, num_meals);
	if (num_meals > 1) printf("s");
	printf("\n");
	// release both forks
	upc_unlock(a_fork[left]);
	upc_unlock(a_fork[right]);
		
	// Leave the table
	upc_lock(waiter);
	philCount--;
	printf("Philosopher%2d: I am leaving the table.\n", MYTHREAD);
	fflush(stdout);
	state = THINKING;
	upc_unlock(waiter);
    }

    state = THINKING;
    
  }
 
  printf("Philosopher %2d:***I ate too much, I am leaving!***\n",
         MYTHREAD);
  fflush(stdout);
  upc_barrier;
}

/*
 * Begin the dining philosophers simulation.
 */
int main(void)
{
  // should be run with >=2 THREADS
  initialize();

  upc_barrier;

  printf("main(): before life_cycle() \n");

  life_cycle();
  printf("main(): after life_cycle() \n");
  fflush(stdout);

  upc_barrier;

  if (MYTHREAD == 0)
    printf("***---> all philosophers left the table <--***\n");
		fflush(stdout);

  return 0;
}
