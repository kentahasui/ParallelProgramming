/*
 * Kenta Hasui
 * CS337
 * 3/31/2015
 * Assignment 3.2: Philosophers2.upc
 * 
 * Compile: upcc -T 5 philosophers2.upc
 * Run:     upcrun philosophers2
 *
 * Description: Implementation of Dining Philosophers
 *              problem. No busy waiting: uses upc_lock(). 
 *              To avoid deadlock, even-numbered threads pick 
 *              up chopsticks left-right. Odd-numbered threads
 *              pick up chopsticks right-left. 
 *
 */

#include <stdio.h>
#include <upc_relaxed.h>

typedef enum{THINKING, STARVING, EATING} philosopher_status_t;
upc_lock_t * shared a_fork[THREADS];

/*
 * Allocate shares resources: forks (really chopsticks)
 */
void initialize(void)
{
  a_fork[MYTHREAD] = upc_global_lock_alloc();
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
  int left, right, 
      got_left, got_right;

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
    }

    // tries to lock both forks
    // Even-numbered threads pick up the left fork first, then the right
    if(MYTHREAD % 2 == 0){
	upc_lock(a_fork[left]);
	upc_lock(a_fork[right]);
    }
    // Odd-numbered threads pick  up the right fork first, then the left. 
    // This avoids deadlock. 
    else {
	upc_lock(a_fork[right]);
	upc_lock(a_fork[left]);
    }

    // got both...
    printf("Philosopher %2d: I have both forks---I start eating\n",
             MYTHREAD);
    state = EATING;
    sleep(delay_eating);
    num_meals++;

    printf("Philosopher %2d: I have both forks---I finished eating my %d meal", 
             MYTHREAD, num_meals);
    if (num_meals > 1) printf("s");
    printf("\n");

    fflush(stdout);

    // release both forks
    upc_unlock(a_fork[left]);
    upc_unlock(a_fork[right]);
 
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
