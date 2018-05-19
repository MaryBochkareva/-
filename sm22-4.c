#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sched.h>
#include <errno.h>
#include <string.h>
#include <stdint.h>

_Thread_local int current_thread = 0;
int count;
pthread_t *threads;
int** pipes;

void *
scan_and_send(void *arg)
{
    int number_of_thread = *(int *) arg;
    int num;

    for (;;) {
        if (read(pipes[number_of_thread][0], &current_thread, sizeof(current_thread)) == sizeof(current_thread)) {
            while (current_thread == number_of_thread) {
                if (scanf("%d", &num) != 1) {
                    for (int i = 0; i < count; ++i) {
                        if (i != number_of_thread) {
                            pthread_cancel(threads[i]);
                        }
                    }

                    return NULL;
                }

                printf("%d %d\n", number_of_thread, num);
                
                int remainder = num % count;
                current_thread = remainder >= 0 ? remainder : count + remainder;
            }

            if (write(pipes[current_thread][1], &current_thread, sizeof(current_thread)) == -1) {
                return NULL;
            }
        }
        
        sched_yield();
    }
    
    return NULL;
}

int
main(int argc, char *argv[])
{
    count = atoi(argv[1]);
    threads = calloc(count, sizeof(*threads));
    pipes = calloc(count, sizeof(*pipes));
    
    for (int i = 0; i < count; ++i) {
        pipes[i] = calloc(2, sizeof(**pipes));
    }
    for (int i = 0; i < count; ++i) {
        if (pipe(pipes[i]) == -1) {
            return 0;
        }        
    }
    
    int *thread_nums = calloc(count, sizeof(*thread_nums));
    
    for (int i = 0; i < count; ++i) {
        thread_nums[i] = i;
        pthread_create(&threads[i], NULL, scan_and_send, &thread_nums[i]);
    }
    
    if (write(pipes[current_thread][1], &current_thread, sizeof(current_thread)) == -1) {
        return 0;
    }

    for (int i = 0; i < count; ++i) {
        pthread_join(threads[i], NULL);
    }

    free(thread_nums);
    for (int i = 0; i < count; ++i) {
        free(pipes[i]);
    }
    free(pipes);
    free(threads);

    return 0;
}
