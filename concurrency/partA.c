#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <stdbool.h>
#include <errno.h>
#include <stdatomic.h>
#define MAX_COUNT 10000
#define REQUEST_TIME_ARRAY_SIZE 100
typedef struct userequest
{
    int userid;
    int fileid;
    int operation; // 1 for read 2 for write 3 for delete
    time_t requesttime;
} userrequest;

int compareByRequestTime(const void *a, const void *b)
{
    userrequest *reqA = (userrequest *)a;
    userrequest *reqB = (userrequest *)b;
    if (reqA->requesttime != reqB->requesttime){
        return reqA->requesttime - reqB->requesttime;
    }
    else return reqA->operation - reqB->operation;
}

const char *kindofoperation[] = {
    "",
    "READ",
    "WRITE",
    "DELETE"};

typedef struct fileinfo
{
    pthread_mutex_t lock;
    pthread_cond_t cond;
    int concurrent_access;
    bool deleted;
    int readercount;
    int writercount;
    bool isdeleting;
    int time_requests[REQUEST_TIME_ARRAY_SIZE];
    
} fileinfo;

userrequest *requests;
fileinfo *files;
// int reqcount = 0;
int start_time, curr_time, r, w, d, n, c, T;

void *process_req(void *arg)
{
    sleep(1);
    userrequest *req = (userrequest *)arg;
    int op = req->operation;

    // time_t operation_start_time = time(NULL) - start_time;
    // if(operation_start_time - req->requesttime >= T ){
    //     printf("User %d cancelled the request due to no response at %d seconds\n",req->userid,req->requesttime + T);
    //     return NULL;
    // }
    // printf("LAZY has taken up the request of user %d at %d seconds\n", req->userid, operation_start_time );

    fileinfo *file = &files[req->fileid - 1];
    // //
    // pthread_mutex_lock(&file->lock);
    // if (file->deleted)
    // {
    //     printf("LAZY has declined the request of user %d at %d seconds because deleted file was requested [WHITE]\n",
    //            req->userid,
    //            time(NULL) - start_time);
    //     pthread_mutex_unlock(&file->lock);
    //     return NULL;
    // }

    if (op == 1)
    {
        pthread_mutex_lock(&file->lock);
       
        // struct timespec ts;
        // clock_gettime(CLOCK_REALTIME, &ts);
        // ts.tv_sec += T-1;
        // pthread_mutex_lock(&files[req->fileid-1].time_requests_lock);
        int bullet = fork();
        if(bullet == 0){
            sleep(T - 1);
            printf("\033[31mUser %d cancelled the request due to no response at %d seconds\033[0m\n", req->userid, req->requesttime + T);
            exit(0);
        }
        atomic_fetch_sub(&(files[req->fileid - 1].time_requests[req->requesttime%REQUEST_TIME_ARRAY_SIZE]),1);
        while (file->concurrent_access >= c)
        {
            // pthread_cond_wait(&file->cond, &file->lock);
            int res = pthread_cond_wait(&file->cond, &file->lock);
            if (res == ETIMEDOUT)
                break;
        }
        time_t operation_start_time = time(NULL) - start_time;
        if (operation_start_time - req->requesttime >= T)
        {
            // printf("\033[31mUser %d cancelled the request due to no response at %d seconds\033[0m\n", req->userid, req->requesttime + T);

            pthread_cond_signal(&file->cond);
            pthread_mutex_unlock(&file->lock);
            return NULL;
        }
        else kill(bullet,9);
        // printf("LAZY has taken up the request of user %d at %d seconds\n", req->userid, operation_start_time );
        printf("\033[35mLAZY has taken up the request of user %d at %d seconds\033[0m\n", req->userid, operation_start_time);

        if (file->deleted )
        {
            printf("\033[37mLAZY has declined the request of user %d at %ld seconds because deleted file was requested\033[0m\n",
                   req->userid,
                   time(NULL) - start_time);

            pthread_cond_signal(&file->cond);
            pthread_mutex_unlock(&file->lock);
            return NULL;
        }

        file->readercount++;
        file->concurrent_access++;
        pthread_mutex_unlock(&file->lock);

        sleep(r);
        printf("\033[32mThe request for User %d was completed at %ld seconds\033[0m\n", req->userid, time(NULL) - start_time);

        pthread_mutex_lock(&file->lock);
        file->readercount--;
        file->concurrent_access--;

        pthread_cond_signal(&file->cond); // Signal to wake up waiting readers
        pthread_mutex_unlock(&file->lock);
        return NULL;
    }
    else if (op == 2)
    {
        pthread_mutex_lock(&file->lock);
        // struct timespec ts;
        // clock_gettime(CLOCK_REALTIME, &ts);
        // ts.tv_sec += T-1;
        int bullet = fork();
        if(bullet == 0){
            sleep(T - 1);
            printf("\033[31mUser %d cancelled the request due to no response at %d seconds\033[0m\n", req->userid, req->requesttime + T);
            exit(0);
        }
        // files[req->fileid - 1].time_requests[req->requesttime%REQUEST_TIME_ARRAY_SIZE]--;
        atomic_fetch_sub(&(files[req->fileid - 1].time_requests[req->requesttime%REQUEST_TIME_ARRAY_SIZE]),1);
        while (file->writercount > 0 || file->concurrent_access >= c )
        {
            int res = pthread_cond_wait(&file->cond, &file->lock);
            if (res == ETIMEDOUT)
                break;
        }
        time_t operation_start_time = time(NULL) - start_time;  
        if (operation_start_time - req->requesttime >= T)
        {
            // printf("\033[31mUser %d cancelled the request due to no response at %d seconds\033[0m\n", req->userid, req->requesttime + T);

            pthread_cond_signal(&file->cond);
            // printf("User %d cancelled the request due to no response at %d seconds\n",req->userid,req->requesttime + T);
            pthread_mutex_unlock(&file->lock);
            return NULL;
        }
        else kill(bullet,9);
        // printf("LAZY has taken up the request of user %d at %d seconds\n", req->userid, operation_start_time );
        printf("\033[35mLAZY has taken up the request of user %d at %d seconds\033[0m\n", req->userid, operation_start_time);

        if (file->deleted)
        {
            printf("\033[37mLAZY has declined the request of user %d at %ld seconds because deleted file was requested\033[0m\n",
                   req->userid,
                   time(NULL) - start_time);

            pthread_cond_signal(&file->cond);
            pthread_mutex_unlock(&file->lock);
            return NULL;
        }

        file->writercount++;
        file->concurrent_access++;
        pthread_mutex_unlock(&file->lock);

        sleep(w); // Simulate write operation
        printf("\033[32mThe request for User %d was completed at %ld seconds\033[0m\n", req->userid, time(NULL) - start_time);

        pthread_mutex_lock(&file->lock);
        file->writercount--;
        file->concurrent_access--;

        pthread_cond_signal(&file->cond);
        pthread_mutex_unlock(&file->lock);
    }
    else if (op == 3)
    {
        pthread_mutex_lock(&file->lock);
        int bullet = fork();
        if(bullet == 0){
            sleep(T - 1);
            printf("\033[31mUser %d cancelled the request due to no response at %d seconds\033[0m\n", req->userid, req->requesttime + T);
            exit(0);
        }
        int flag_checker = 0;
        if(files[req->fileid - 1].time_requests[req->requesttime%REQUEST_TIME_ARRAY_SIZE] > 0){
            pthread_mutex_unlock(&file->lock);
            flag_checker=1;
        }
        while( files[req->fileid - 1].time_requests[req->requesttime%REQUEST_TIME_ARRAY_SIZE] > 0){
            usleep(1);
        }
        if(flag_checker)pthread_mutex_lock(&file->lock);
        // struct timespec ts;
        // clock_gettime(CLOCK_REALTIME, &ts);
        // ts.tv_sec += T-1 ;
        while (file->readercount > 0 || file->writercount > 0)
        {
            // pthread_cond_wait(&file->cond, &file->lock);
            int res = pthread_cond_wait(&file->cond, &file->lock);
            if (res == ETIMEDOUT)
                break;
        }
        int op_start_time = time(NULL) - start_time;
        if (op_start_time - req->requesttime >= T)
        {
            // printf("\033[31mUser %d cancelled the request due to no response at %d seconds\033[0m\n", req->userid, req->requesttime + T);
            // printf("User %d cancelled the request due to no response at %d seconds\n",req->userid,req->requesttime + T);
            
            pthread_cond_signal(&file->cond);
            pthread_mutex_unlock(&file->lock);
            return NULL;
        }
        else kill(bullet,9);

        // printf("LAZY has taken up the request of User %d at %d seconds [PINK]\n",
        // req->userid, op_start_time);
        printf("\033[35mLAZY has taken up the request of user %d at %d seconds\033[0m\n", req->userid, op_start_time);

        if (file->deleted )
        {
            printf("\033[37mLAZY has declined the request of user %d at %ld seconds because deleted file was requested\033[0m\n",
                   req->userid,
                   time(NULL) - start_time);

            pthread_cond_signal(&file->cond);
            pthread_mutex_unlock(&file->lock);
            return NULL;
        }
        //pthread_mutex_unlock(&file->lock);
        //file->deleted = 1;
        
     
        sleep(d);
        // printf("The request for User %d was completed at %d seconds\n",req->userid,time(NULL) - start_time);
        printf("\033[32mThe request for User %d was completed at %ld seconds\033[0m\n", req->userid, time(NULL) - start_time);
        
        
        file->deleted=true;
        pthread_cond_signal(&file->cond);
        pthread_mutex_unlock(&file->lock);
    }
}

int main()
{

    scanf("%d %d %d %d %d %d", &r, &w, &d, &n, &c, &T);

    requests = malloc(sizeof(userrequest) * (MAX_COUNT));
    files = malloc(sizeof(fileinfo) * (n + 2));
    for (int i = 0; i < n; i++)
    {
        pthread_mutex_init(&files[i].lock, NULL);
        files[i].concurrent_access = 0;
        pthread_cond_init(&files[i].cond, NULL);
        files[i].deleted = false;
        files[i].readercount = 0;
        files[i].writercount = 0;
    }
    int m = 0;
    curr_time = 0;
    char input[1000];

    while (1)
    {
        scanf("%s", input);

        if (strcmp(input, "STOP") == 0)
        {
            break;
        }

        int userid, fileid, rt;
        char operation[10];

        sscanf(input, "%d", &userid);
        scanf("%d %s %d", &fileid, operation, &rt);

        int op = -1;
        if (strcmp(operation, "READ") == 0)
        {
            op = 1;
        }
        else if (strcmp(operation, "WRITE") == 0)
        {
            op = 2;
        }
        else if (strcmp(operation, "DELETE") == 0)
        {
            op = 3;
        }
        else
        {
            printf("Unknown operation: %s\n", operation);
            continue;
        }

        if (m >= MAX_COUNT)
        {
            printf("Request limit reached\n");
            break;
        }

        requests[m].fileid = fileid;
        requests[m].userid = userid;
        requests[m].operation = op;
        requests[m].requesttime = rt;
        m++;
    }

    qsort(requests, m, sizeof(userrequest), compareByRequestTime);

    printf("Lazy has woken up\n");
    start_time = time(NULL);
    pthread_t *threads = malloc(sizeof(pthread_t) * m);
    for (int i = 0; i < m; i++)
    {
        int curr_time = time(NULL) - start_time;
        int time_to_begin = requests[i].requesttime;
        if (time_to_begin - curr_time > 0) sleep(time_to_begin - curr_time);

        if(requests[i].operation < 3) atomic_fetch_add(&(files[requests[i].fileid - 1].time_requests[(requests[i].requesttime)%REQUEST_TIME_ARRAY_SIZE]),1);
        printf("\033[33mUser %d has made request for performing %s on file %d at %d seconds\033[0m\n",
               requests[i].userid,
               kindofoperation[requests[i].operation],
               requests[i].fileid,
               requests[i].requesttime);

        if (pthread_create(&threads[i], NULL, process_req, &requests[i]) != 0)
        {
            printf("Error creating thread\n");
            return 1;
        }
    }

    for (int i = 0; i < m; i++)
    {
        pthread_join(threads[i], NULL);
    }

    printf("\nLAZY has no more pending requests and is going back to sleep!\n");

    for (int i = 0; i < n; i++)
    {
        pthread_mutex_destroy(&files[i].lock);
        pthread_cond_destroy(&files[i].cond);
    }
    free(requests);
    free(files);
    free(threads);

    return 0;
}