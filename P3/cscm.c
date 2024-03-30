#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>
#include <limits.h>
#include <stdio.h>
#include <assert.h>

struct student **point_student_array = NULL;
int *point_tutored_student_array = NULL;
int student_size = -1;
struct Queue **queue_addrs = NULL;
struct student **point_student_priority_queue = NULL;
int student_count = 0;
int tutor_count = 0;
int chair_count = 0;
int chair_filled_count = 0;
int help_count = 0;
int student_completed = 0;
int tutoring_sessions = 0;
int total_request = 0;
pthread_mutex_t get_chair;
pthread_mutex_t get_queue;
pthread_mutex_t get_tutored_student;
pthread_mutex_t completed_count_lock;

sem_t students_arrived_sem;

struct student
{
    int id;
    int priority;
    int help;
};

int enqueue_student(int id, int priority, int help)
{
    // if student_size is same as chair count then do not add item to queue
    if (student_size >= (chair_count - 1))
        return -1;
    student_size++;

    // Insert the element to the priority queue
    point_student_priority_queue[student_size] = (struct student *)malloc(sizeof(struct student));
    point_student_priority_queue[student_size]->id = id;

    point_student_priority_queue[student_size]->priority = priority;
    point_student_priority_queue[student_size]->help = help;
    return 0;
}

// Check the priority element and return the index
int peek_student()
{
    int highestPriority = INT_MIN;
    int ind = -1;

    for (int i = 0; i <= student_size; i++)
    {
        if (point_student_priority_queue[i] == NULL || (ind > -1 && point_student_priority_queue[ind] == NULL))
            continue;
        if (highestPriority == point_student_priority_queue[i]->help && ind > -1 && point_student_priority_queue[ind]->priority > point_student_priority_queue[i]->priority)
        {
            highestPriority = point_student_priority_queue[i]->help;
            ind = i;
        }
        else if (highestPriority < point_student_priority_queue[i]->help)
        {
            highestPriority = point_student_priority_queue[i]->help;
            ind = i;
        }
    }

    // Return position of the element
    return ind;
}

// Function to remove the element with
// the highest priority
void dequeue_student()
{
    // Find the position of the element
    // with highest priority
    int ind = peek_student();

    // Shift the element one index before
    // from the position of the element
    // with highest priority is found
    for (int i = ind; i < student_size; i++)
    {
        point_student_priority_queue[i] = point_student_priority_queue[i + 1];
    }

    // Decrease the size of the
    // priority queue by one
    student_size--;
}

void *student_thread(void *student_id)
{
    int request = 0;
    int id_student = *(int *)student_id;
    struct student *s = malloc(sizeof(struct student));
    s->help = 0;
    s->priority = 0;
    s->id = id_student;

    while (1)
    {

        if (s->help >= help_count)
        {
            pthread_mutex_lock(&completed_count_lock);
            student_completed = student_completed + 1;
            pthread_mutex_unlock(&completed_count_lock);
	    sem_post(&students_arrived_sem);
            pthread_exit(NULL);
        }
        int programTime = (int)rand() % 1000;

        // wait for sometime before accessing the chair
        while (programTime > 0)
        {
            programTime--;
        }
        pthread_mutex_lock(&get_chair);
        if (chair_filled_count >= chair_count)
        {
            printf("S: Student %d found no empty chair. Will try again later.\n", id_student);
            pthread_mutex_unlock(&get_chair);
	    sem_post(&students_arrived_sem);
            continue;
        }
        request++;
        total_request++;
        s->help = request;
        s->priority = total_request;
        point_student_array[id_student] = s;
        printf("S: Student %d takes a seat. Empty chairs = %d\n", id_student, chair_count - chair_filled_count);
        chair_filled_count++;
      
        pthread_mutex_unlock(&get_chair);
        sem_post(&students_arrived_sem);
        while (point_tutored_student_array[id_student] == -1)
            ;
        printf("S: Student %d received help from Tutor %d.\n", id_student, point_tutored_student_array[id_student]);

        point_tutored_student_array[id_student] = -1;
    }
};

void *coordinator_thread()
{

    while (1)
    {
//      printf("coordinator \n\n\n"); 
        if (student_completed >= student_count)
        {

            // terminate tutors first
            pthread_exit(NULL);
        }
         sem_wait(&students_arrived_sem);
        pthread_mutex_lock(&get_queue);
        // pthread_mutex_lock(&get_chair);
        int i;
        if (chair_filled_count <= 0)
        {
            pthread_mutex_unlock(&get_queue);
            // pthread_mutex_unlock(&get_chair);
            continue;
        }
        for (i = 0; i < student_count; i++)
        {
            if (point_student_array[i] != NULL)
            {
                int val = enqueue_student(point_student_array[i]->id, point_student_array[i]->priority, point_student_array[i]->help);
                if (val == 0)
                {

                    int waiting_stu = chair_filled_count - student_size;
                    if (waiting_stu < 0)
                    {
                        waiting_stu = 0;
                    }
                    printf("C: Student %d with priority %d added to the queue. Waiting students now = %d. Total requests = %d \n", point_student_array[i]->id, point_student_array[i]->priority, waiting_stu, total_request);
                    point_student_array[i] = NULL;
                }
            }
        }
        // pthread_mutex_unlock(&get_chair);
        pthread_mutex_unlock(&get_queue);
    }
};

void *tutor_thread(void *tutor_id)
{
    int id_tutor = *(int *)tutor_id;
    while (1)
    {

        // if all students finish, tutors threads terminate.
        if (student_completed >= student_count)
        {
            
            pthread_exit(NULL);
        }
        pthread_mutex_lock(&get_queue);
        assert(chair_filled_count >= 0);
        if (student_size < 0 || chair_filled_count <= 0)
        {

            pthread_mutex_unlock(&get_queue);
            continue;
        }

        int index = peek_student();

        if (index < 0 || index > chair_count)
        {

            pthread_mutex_unlock(&get_queue);
            continue;
        }
        struct student *tutored_student = point_student_priority_queue[index];

        if (tutored_student == NULL)
        {
            pthread_mutex_unlock(&get_queue);
            continue;
        }
        if (tutored_student->id < 0 || tutored_student->id > student_count)
        {
            dequeue_student();
            pthread_mutex_unlock(&get_queue);
            continue;
        }

        tutoring_sessions++;
        printf("T: Student %d tutored by Tutor %d. Students tutored now = %d. Total sessions tutored = %d\n", tutored_student->id, id_tutor, student_size + 1, tutoring_sessions);
        dequeue_student();
        pthread_mutex_unlock(&get_queue);
        point_tutored_student_array[tutored_student->id] = id_tutor;
        pthread_mutex_lock(&get_chair);
        chair_filled_count--;
        pthread_mutex_unlock(&get_chair);
    }
}

int main(int argc, char *argv[])
{
    if (argc > 5)
    {
        printf("More than 5 arg not allowed. Please pass correct args. \n");
        return 0;
    }

    student_count = atoi(argv[1]);
    tutor_count = atoi(argv[2]);
    chair_count = atoi(argv[3]);
    help_count = atoi(argv[4]);
    struct student *student_array[student_count];
    struct student *student_priorit_array[chair_count];
    int tutored_student_array[student_count];
    sem_init(&students_arrived_sem, 0, 0);

    point_student_array = student_array;
    point_tutored_student_array = tutored_student_array;
    point_student_priority_queue = student_priorit_array;

    int student_id[student_count];
    int tutor_id[tutor_count];

    pthread_t *stha, ctha, *ttha;

    stha = (pthread_t *)malloc(sizeof(pthread_t) * student_count);
    ttha = (pthread_t *)malloc(sizeof(pthread_t) * tutor_count);
    ctha = (pthread_t)malloc(sizeof(pthread_t));

    pthread_mutex_init(&get_chair, NULL);
    pthread_mutex_init(&get_tutored_student, NULL);
    pthread_mutex_init(&get_queue, NULL);
    pthread_mutex_init(&completed_count_lock, NULL);

    for (int j = 0; j < student_count; j++)
    {
        student_array[j] = NULL;
        tutored_student_array[j] = -1;
    }
    for (int j = 0; j < chair_count; j++)
    {
        point_student_priority_queue[j] = NULL;
    }
    for (int j = 0; j < student_count; j++)
    {
        student_id[j] = j;
        pthread_create(&stha[j], NULL, student_thread, (void *)&student_id[j]);
    }
   assert( pthread_create(&ctha, NULL, coordinator_thread, NULL)== 0);
    for (int m = 0; m < tutor_count; m++)
    {
        tutor_id[m] = m;
        assert(pthread_create(&ttha[m], NULL, tutor_thread, (void *)&tutor_id[m])==0);
    }
    for (int i = 0; i < student_count; i++)
    {
        pthread_join(stha[i], NULL);
    }
    pthread_join(ctha, NULL);
    return 0;
}
