#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <pthread.h>
#include <stdbool.h>
#include <ctype.h>


#define MAX_FILENAME_LENGTH 129
#define MAX_TIMESTAMP_LENGTH 21
#define MAX_FILES 100000000
#define THREAD_COUNT 8
#define LAZY_THRESHOLD 42
#define NUM_PROCESSES 8
#define MAX_LEVEL_MERGE_SORT 5



// Structure to represent a file
typedef struct {
    char name[MAX_FILENAME_LENGTH];
    int id;
    char timestamp[MAX_TIMESTAMP_LENGTH];
} File;

// Structure for thread arguments
typedef struct {
    File**files;
    int start;
    int end;
    int level;
    int max_level;
    int sort_way;
} ThreadArgs;

typedef struct {
    int start;
    int end;
    int process_id;
    int delete;
    int*positions;
    int elements_to_take;
    int where_to_start_in_first_list;
} ProcessArgs;

typedef struct node{
    File*file_pointer;
    struct node*next;
}node;

typedef struct{
    int frequency;
    int fileid;
    char filename[MAX_FILENAME_LENGTH];
    char filestamp[MAX_TIMESTAMP_LENGTH];
    node*head;
    pthread_mutex_t lock;
    int size;
}file_count;


// Global variables for distributed sorting
File** files;
File** testfiles;
int total_files;
char sort_column[20];
file_count** global_count;
file_count** new_global_count;
File** output;
int sort_column_flag = 1; // 0 for name 1 for id and 2 for timestamp .... by default 1
int max_value;
int min_value;
int offset;
int size_of_new_global_count =0 ;
char min_filename[MAX_FILENAME_LENGTH];
char max_filename[MAX_FILENAME_LENGTH];
char min_timestamp[MAX_TIMESTAMP_LENGTH];
char max_timestamp[MAX_TIMESTAMP_LENGTH];



int convert_timestamp_to_seconds(char *timestamp) {
    struct tm tm_timestamp, tm_min_timestamp;
    memset(&tm_timestamp, 0, sizeof(tm_timestamp));
    memset(&tm_min_timestamp, 0, sizeof(tm_min_timestamp));

    // Parse the timestamp string into struct tm
    strptime(timestamp, "%Y-%m-%dT%H:%M:%S", &tm_timestamp);

    // Parse the min_timestamp string into struct tm
    strptime(min_timestamp, "%Y-%m-%dT%H:%M:%S", &tm_min_timestamp);

    // Convert the struct tm to seconds since the epoch
    time_t timestamp_seconds = mktime(&tm_timestamp);
    time_t min_seconds = mktime(&tm_min_timestamp);

    // Calculate the difference in seconds
    return (int)(timestamp_seconds - min_seconds);
}

int convert_to_index(const char* filename) {
    int index = 0;
    int base = 26;
    int max_length = 4;

    // Start after "file" and ignore ".txt"
    const char *base26_part = filename + 4;
    int length = strlen(base26_part) - 4;

    // Process each character in the string (up to 4 characters)
    for (int i = 0; i < max_length; i++) {
        int value;

        if (i < length) {
            // Assign 'a' = 1, 'b' = 2, ..., 'z' = 26
            value = toupper(base26_part[i]) - 'A' + 1;
        } else {
            // Treat empty spaces as 0
            value = 0;
        }

        // Accumulate index with decreasing weights for each character position
        index = index * base + value;
    }
    
    return index;
}

int convert_filename_to_file_index(char* filename) {
    // Get the base-26 indices of filename and min_filename
    int filename_index = convert_to_index(filename);
    int min_filename_index = convert_to_index(min_filename);
    
    // Return the difference
    return filename_index - min_filename_index;
}


void get_max_min_values() {

    max_value = files[0]->id;
    min_value = files[0]->id;
    strcpy(min_filename,files[0]->name);
    strcpy(max_filename,files[0]->name);
    strcpy(min_timestamp,files[0]->timestamp);
    strcpy(max_timestamp,files[0]->timestamp);

    for (int i = 1; i < total_files; i++) {
        if(sort_column_flag == 0){
            if(strcmp(files[i]->name , min_filename) < 0){
                strcpy(min_filename,files[i]->name);
            }
            if(strcmp(files[i]->name , max_filename) > 0){
                strcpy(max_filename,files[i]->name);
            }  
        }
        else if(sort_column_flag == 2){
            if(strcmp(files[i]->timestamp , min_timestamp) < 0){
                strcpy(min_timestamp,files[i]->timestamp);
            }
            if(strcmp(files[i]->timestamp , max_timestamp) > 0){
                strcpy(max_timestamp,files[i]->timestamp);
            }  
        }
        else{ // sort_column_flag = 1 // id
            if (files[i]->id > max_value) {
                max_value = files[i]->id;
            }
            if(files[i]->id < min_value){
                min_value = files[i]->id;
            }
        }
    }
    if(sort_column_flag == 0){
        // find min and max value and develop appropriate hashing ..
        min_value = convert_filename_to_file_index(min_filename);
        max_value = convert_filename_to_file_index(max_filename);
    }
    else if(sort_column_flag == 2){
        min_value = convert_timestamp_to_seconds(min_timestamp);
        max_value = convert_timestamp_to_seconds(max_timestamp);
    }
    offset = min_value;
   
}

// Comparison functions for different sorting criteria
int compare_by_name(const void* a, const void* b) {
    return strcmp((*(File**)a)->name, (*(File**)b)->name);
}

int compare_by_id(const void* a, const void* b) {
    // printf("1\n");
    return (*(File**)a)->id - (*(File**)b)->id;
}

int compare_by_timestamp(const void* a, const void* b) {

    return strcmp((*(File**)a)->timestamp, (*(File**)b)->timestamp);
}

// Helper function to get comparison function based on sort column
int (*get_comparison_function())(const void*, const void*) {

    if (sort_column_flag == 0) return compare_by_name;
    if ( sort_column_flag==1 ) return compare_by_id;
    if ( sort_column_flag==2 ) return compare_by_timestamp;
    return NULL;
}

// count local will take a chunk of array and populate count global with the counts of these chunks
void*count_local( void*arg ){
    ProcessArgs* parg = arg;

    int s  = parg->start;
    int e = parg->end;
    int index;
    for(int i=s;i<=e;i++){
        if(sort_column_flag == 0){
            index = convert_filename_to_file_index(files[i]->name);
        }
        else if(sort_column_flag == 2){
            index = convert_timestamp_to_seconds(files[i]->timestamp);
        }
        else {
            index = files[i]->id - min_value;
            
        }
        pthread_mutex_lock(&global_count[index]->lock);
        global_count[index]->frequency++;
        node*head = global_count[index]->head;
        node*new_node = malloc(sizeof(node));
        new_node->next = head;
        new_node->file_pointer = files[i];
        global_count[index]->head = new_node;
        pthread_mutex_unlock(&global_count[index]->lock);
    }


    return NULL;

}

// populate output will take a chunk of files and find out positions for them in the final output array
void* populate_output(void* arg) {

    ProcessArgs* parg = arg;
    
    int s  = parg->start;
    int elements = parg->elements_to_take;
    int list_offset = parg->where_to_start_in_first_list; // elements before me in the list
    int index_adder = list_offset;
    // printf("elements %d\n",elements);
    while(elements){
        node*head = new_global_count[s]->head;
        while(list_offset && head){
            head =head->next;
            list_offset--;
        }
        int index = new_global_count[s]->frequency -1 - index_adder;
        while(head!=NULL && elements){
            output[index] = head->file_pointer;
            head = head->next;
            // printf("index %d curr_list %d thread_id %d\n",index,s,parg->process_id);
            index--;
            elements--;
        }
        s++;
        index_adder = 0;
    }
    // printf("bye\n");

    return NULL;
}

// to initialise all the structs in global_count
void init_global_count(){
    for(int i=0;i<=max_value-min_value;i++){
        global_count[i] = malloc(sizeof(file_count));
        global_count[i]->frequency =0;
        global_count[i]->head = NULL;
        pthread_mutex_init(&global_count[i]->lock, NULL);
        if(sort_column_flag == 0){

        }
        else if(sort_column_flag == 1){

        }
        else{
            global_count[i]->fileid = i;
        }
    }

}


// Distributed count sort will divide the array into NUM_PROCESSES threads and each thread will be first given a chunk of the array
// to count the number of occurences of a particular entity and then again make threads to find the final positions of these elements
void distributed_count_sort() {
  
    pthread_t threads[NUM_PROCESSES];
    ProcessArgs process_args[NUM_PROCESSES];
    get_max_min_values();

   
    output = malloc(total_files * sizeof(File*));
    // int*global_count = calloc((max_value - min_value + 2),sizeof(int));
    // so i have n files and 8 threads so each thread should get n/8 files;
    global_count = malloc(sizeof(file_count*)*(max_value - min_value+2));
    init_global_count();
    

    int chunck_size[NUM_PROCESSES];
    int base_size = total_files/NUM_PROCESSES;
    int left_over = total_files%NUM_PROCESSES;
    for(int i=0;i<NUM_PROCESSES;i++){
        chunck_size[i] = base_size ;
        if(left_over!=0){
            chunck_size[i]++;
            left_over--;
        }
    }

    int elements_covered =0;
    int threads_used =0;
    

    for (int i = 0; i < NUM_PROCESSES; i++) {    
        process_args[i].start = elements_covered;
        process_args[i].end = elements_covered + chunck_size[i] - 1;
        process_args[i].process_id = i;

        pthread_create(&threads[i], NULL, count_local, &process_args[i]);
        elements_covered+=chunck_size[i];
        threads_used++;
        if(elements_covered  == total_files) break;
    }
    // printf("threads_used %d elements covered %d\n",threads_used,elements_covered);
    
    for (int i = 0; i < NUM_PROCESSES && i<threads_used; i++) {
        pthread_join(threads[i], NULL);
    }
    

    for(int j=0;j<=max_value-min_value;j++){
        if(global_count[j]->frequency!=0)size_of_new_global_count++;
    }
   

    new_global_count = malloc(sizeof(file_count*)*(size_of_new_global_count+2));
    int iter=0;
   
    for(int j=0 ; j<=max_value-min_value ; j++){
        if(global_count[j]->frequency!=0)new_global_count[iter++] = global_count[j];
    }
   if(size_of_new_global_count >0) new_global_count[0]->size = new_global_count[0]->frequency;
    for(int i= 1 ;i<size_of_new_global_count ;i++){
   
        new_global_count[i]->size = new_global_count[i]->frequency;
        new_global_count[i]->frequency+=new_global_count[i-1]->frequency;
    }
    
    
    int previous_list_elements_covered = 0;
    int curr_list = 0;

    for (int i = 0; i < NUM_PROCESSES && i<threads_used; i++){
        // printf("this is i %d\n",i);
        process_args[i].elements_to_take = chunck_size[i];
        process_args[i].where_to_start_in_first_list = previous_list_elements_covered;
        process_args[i].start = curr_list;
        pthread_create(&threads[i], NULL, populate_output, &process_args[i]);
        // printf("%d %d %d \n",chunck_size[i],previous_list_elements_covered,curr_list);
        while(chunck_size[i] > 0 ){
            if(chunck_size[i] < (new_global_count[curr_list]->size) - previous_list_elements_covered){
                previous_list_elements_covered+=chunck_size[i];
                chunck_size[i] = 0;
            }
            else{
               
                chunck_size[i]-= ((new_global_count[curr_list]->size) - previous_list_elements_covered);
                curr_list++;
                previous_list_elements_covered = 0;
            }
        }
        // printf("previous list elements %d\n",previous_list_elements_covered);
        
    }


    for (int i = 0; i < NUM_PROCESSES && i<threads_used; i++) {
        
        pthread_join(threads[i], NULL);
    }
    
    
    memcpy(files, output, total_files * sizeof(File*));
   
    // Cleanup
    free(output);
    for(int i=0;i<=max_value-min_value;i++){
        free(global_count[i]);
    }
    free(global_count);
    free(new_global_count);
    
}

void non_distributed_count_sort(){

    ProcessArgs process_args[NUM_PROCESSES];
    get_max_min_values();

   
    output = malloc(total_files * sizeof(File*));
    // int*global_count = calloc((max_value - min_value + 2),sizeof(int));
    // so i have n files and 8 threads so each thread should get n/8 files;
    global_count = malloc(sizeof(file_count*)*(max_value - min_value+2));
    init_global_count();
    

    int chunck_size[NUM_PROCESSES];
    int base_size = total_files/NUM_PROCESSES;
    int left_over = total_files%NUM_PROCESSES;
    for(int i=0;i<NUM_PROCESSES;i++){
        chunck_size[i] = base_size ;
        if(left_over!=0){
            chunck_size[i]++;
            left_over--;
        }
    }

    int elements_covered =0;
    int threads_used =0;
    

    for (int i = 0; i < NUM_PROCESSES; i++) {    
        process_args[i].start = elements_covered;
        process_args[i].end = elements_covered + chunck_size[i] - 1;
        process_args[i].process_id = i;

        
        count_local(&process_args[i]);
        elements_covered+=chunck_size[i];
        threads_used++;
        if(elements_covered  == total_files) break;
    }
    // printf("threads_used %d elements covered %d\n",threads_used,elements_covered);
    
   
    

    for(int j=0;j<=max_value-min_value;j++){
        if(global_count[j]->frequency!=0)size_of_new_global_count++;
    }
   

    new_global_count = malloc(sizeof(file_count*)*(size_of_new_global_count+2));
    int iter=0;
   
    for(int j=0 ; j<=max_value-min_value ; j++){
        if(global_count[j]->frequency!=0)new_global_count[iter++] = global_count[j];
    }
   if(size_of_new_global_count >0) new_global_count[0]->size = new_global_count[0]->frequency;
    for(int i= 1 ;i<size_of_new_global_count ;i++){
   
        new_global_count[i]->size = new_global_count[i]->frequency;
        new_global_count[i]->frequency+=new_global_count[i-1]->frequency;
    }
    
    
    int previous_list_elements_covered = 0;
    int curr_list = 0;

    for (int i = 0; i < NUM_PROCESSES && i<threads_used; i++){
        // printf("this is i %d\n",i);
        process_args[i].elements_to_take = chunck_size[i];
        process_args[i].where_to_start_in_first_list = previous_list_elements_covered;
        process_args[i].start = curr_list;
        populate_output(&process_args[i]);
        // printf("%d %d %d \n",chunck_size[i],previous_list_elements_covered,curr_list);
        while(chunck_size[i] > 0 ){
            if(chunck_size[i] < (new_global_count[curr_list]->size) - previous_list_elements_covered){
                previous_list_elements_covered+=chunck_size[i];
                chunck_size[i] = 0;
            }
            else{
               
                chunck_size[i]-= ((new_global_count[curr_list]->size) - previous_list_elements_covered);
                curr_list++;
                previous_list_elements_covered = 0;
            }
        }
        // printf("previous list elements %d\n",previous_list_elements_covered);
        
    }
    
    
    memcpy(files, output, total_files * sizeof(File*));
   
    // Cleanup
    free(output);
    for(int i=0;i<=max_value-min_value;i++){
        free(global_count[i]);
    }
    free(global_count);
    free(new_global_count);

}

void merge(int s,int e,int sort_way){

    int s1 = s;
    int s2 = ((s+e)/2) + 1;
    int e1 = (s+e)/2;
    int e2 = e;
    int k =0;
    File** tempfiles = malloc((e - s + 2) * sizeof(File*));
    while(s1 <= e1 && s2 <= e2){
        if(sort_way == 0){
            if(strcmp(files[s1]->name,files[s2]->name) <= 0){
                tempfiles[k++] = files[s1++];
            }
            else tempfiles[k++] = files[s2++];
        }
        else if(sort_way == 1){
            if(files[s1]->id <= files[s2]->id){
                tempfiles[k++] = files[s1++];
            }
            else tempfiles[k++] = files[s2++];
        }
        else if(sort_way == 2){
            if(strcmp(files[s1]->timestamp , files[s2]->timestamp) <= 0){
                tempfiles[k++] = files[s1++];
            }
            else tempfiles[k++] = files[s2++];
        }
    }

    while(s1 <= e1){
        tempfiles[k++] = files[s1++];
    }
    while(s2 <= e2){
        tempfiles[k++] = files[s2++];
    }

    for(int i=s;i<=e;i++){
        files[i] = tempfiles[i-s];
    }

    free(tempfiles);

}

void merge_sort_non_distributed(int s,int e,int sort_way){
    if(s == e)return;

    int mid = (s+e)/2;
    merge_sort_non_distributed(s,mid,sort_way);
    merge_sort_non_distributed(mid+1,e,sort_way);
    merge(s,e,sort_way);

}


// Distributed merge sort implementation
void* merge_sort(void* arg) {
    ThreadArgs* args = (ThreadArgs*)arg;
    int s = args->start;
    int e = args->end;
    if(s == e) return NULL;

    
    if(args->level < args->max_level){
        ThreadArgs args1[2];
        pthread_t threads[2];
        // Create threads for distributed merge sort
        args1[0] = (ThreadArgs){files, s, (s+e) / 2, args->level+1, args->max_level,args->sort_way};
        args1[1] = (ThreadArgs){files, ((s+e) / 2) + 1, e, args->level+1, args->max_level,args->sort_way};
        
        for(int i=0;i<2;i++){
            pthread_create(&threads[i],NULL, merge_sort ,&args1[i]);
        }

        
        
        // Wait for all threads to complete
        for (int i = 0; i < 2; i++) {
            pthread_join(threads[i], NULL);
        }

        // now merge the sorted arrays
        merge(s,e,args->sort_way);

    }
    else{
       
        // merge_sort_non_distributed(s,e,args->sort_way);
    
        qsort(files + s, e - s + 1, sizeof(File *), get_comparison_function());
        
    }
  
    
    return NULL;
}


// Main sorting function that decides which algorithm to use
void lazy_sort(int sort_way) {
    if (total_files < LAZY_THRESHOLD) {
        // Distributed count sort
        distributed_count_sort();
    } else {
        // Distributed Merge Sort
        if(total_files == 1)return;
        // pthread_t threads[2];
        ThreadArgs args[2];
        // Create threads for distributed merge sort
        args[0] = (ThreadArgs){files, 0, (total_files-1), 0, MAX_LEVEL_MERGE_SORT,sort_way};
        merge_sort(&args[0]);
    }
}


void generate_random_data_merge_sort(int sort_way)
{
    const char name_chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    const int name_chars_len = sizeof(name_chars) - 1;
    srand(time(NULL));
    // int n = rand()%(41) + 1; 
    // total_files = n;
    int n = total_files; 
    sort_column_flag = sort_way;
    files = malloc(sizeof(File*)*total_files);
    testfiles = malloc(sizeof(File*)*total_files);
 
    for (int i = 0; i < n; i++)
    {   
       
        files[i] = malloc(sizeof(File));
        testfiles[i] = malloc(sizeof(File));
        // Generate random name
        for (int j = 0; j < 128; j++)
        {
            files[i]->name[j] = name_chars[rand() % name_chars_len];
        }
        files[i]->name[128] = '\0';

        // Generate random ID
        files[i]->id = rand() % 1000000 + 1;

        // Generate random timestamp
        int year = rand() % 10 + 2015;
        int month = rand() % 12 + 1; 
        int day = rand() % 28 + 1;
        int hour = rand() % 24;       
        int minute = rand() % 60;
        int second = rand() % 60;

        snprintf(files[i]->timestamp, sizeof(files[i]->timestamp),
                 "%04d-%02d-%02dT%02d:%02d:%02d",
                 year, month, day, hour, minute, second);

        testfiles[i]->id = files[i]->id;
        strcpy(testfiles[i]->timestamp,files[i]->timestamp);
        strcpy(testfiles[i]->name,files[i]->name);
    }

    
    qsort(testfiles ,total_files, sizeof(File*), get_comparison_function());
   
}


void generate_random_data_count_sort(int sort_way) {
    const char name_chars[] =  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    const int name_chars_len = sizeof(name_chars) - 1;
    srand(time(NULL));
    // int n = rand() % 41 + 1; 
    // total_files = n;
    int n = total_files;
    sort_column_flag = sort_way;
    files = malloc(sizeof(File*) * total_files);
    testfiles = malloc(sizeof(File*) * total_files);
 
    for (int i = 0; i < n; i++) {   
        files[i] = malloc(sizeof(File));
        testfiles[i] = malloc(sizeof(File));
        
        // Generate filename in the format file____.txt with 1 to 4 characters
        int filename_len = rand() % 4 + 1;  // Between 1 and 4 characters
        snprintf(files[i]->name, sizeof(files[i]->name), "file");
        for (int j = 0; j < filename_len; j++) {
            files[i]->name[4 + j] = name_chars[rand() % name_chars_len];
        }
        files[i]->name[4 + filename_len] = '\0';
        strcat(files[i]->name, ".txt");

        // Generate random ID
        files[i]->id = rand() % 1000000 + 1;

        // Generate random timestamp within 20 days
        int base_day = rand() % 10 + 1;  // Random day within 10-day range
        int month = 1 + ((base_day + 27) / 28);  // Simple adjustment to avoid overflow
        int day = 1 + (base_day % 28);
        int hour = rand() % 24;
        int minute = rand() % 60;
        int second = rand() % 60;

        snprintf(files[i]->timestamp, sizeof(files[i]->timestamp),
                 "2023-%02d-%02dT%02d:%02d:%02d",
                 month, day, hour, minute, second);

        // Copy the generated data to testfiles
        testfiles[i]->id = files[i]->id;
        strcpy(testfiles[i]->timestamp, files[i]->timestamp);
        strcpy(testfiles[i]->name, files[i]->name);
    }

    // Sort testfiles using the specified comparison function
    qsort(testfiles, total_files, sizeof(File*), get_comparison_function());
}

void check_data(){

    int flag = 0;
    for(int i=0;i<total_files;i++){
        if(sort_column_flag == 0){
            if(strcmp(files[i]->timestamp,testfiles[i]->timestamp)!=0){
                flag=1;   
                break;  
            }
        }
        else if(sort_column_flag == 2){
            if(strcmp(files[i]->name,testfiles[i]->name)!=0){
                printf("problem %s %s\n",files[i]->name,testfiles[i]->name);
                flag =1;
                break;
            }
        }
        else{
            if(files[i]->id!=testfiles[i]->id){
                flag=1;
                break;
            }
        }
    }

    if(flag==0){
        printf("yes\n");
    }
    else printf("no\n");

}


int main(int argc, char *argv[]) {
    // // Read total number of files
    // scanf("%d", &total_files);
    // if (total_files <= 0 || total_files > MAX_FILES) {
    //     printf("Invalid number of files\n");
    //     return 1;
    // }
    
    // // Allocate memory for files
    // files = malloc(total_files * sizeof(File*));
    // if (!files) {
    //     printf("Memory allocation failed\n");
    //     return 1;
    // }
    
    // Read file data
    // for (int i = 0; i < total_files; i++) {
    //     files[i] = malloc(sizeof(File));
    //     scanf("%s %d %s", files[i]->name, &files[i]->id, files[i]->timestamp);
    // }
   
    
    // Read sorting column
    // scanf("%s", sort_column);


            FILE *input_file = fopen("input.txt", "r");
            if (input_file == NULL) {
                printf("Error: Unable to open input file\n");
                return 1;
            }
        
            fscanf(input_file, "%d", &total_files);
            if (total_files <= 0 || total_files > MAX_FILES) {
                printf("Invalid number of files\n");
                fclose(input_file);
                return 1;
            }
        
            files = malloc(total_files * sizeof(File*));
            if (!files) {
                printf("Memory allocation failed\n");
                fclose(input_file);
                return 1;
            }

            for (int i = 0; i < total_files; i++) {
                files[i] = malloc(sizeof(File));
                fscanf(input_file, "%s %d %s", files[i]->name, &files[i]->id, files[i]->timestamp);
            }

            fscanf(input_file, "%s", sort_column);
            if(strcmp(sort_column,"ID") == 0){
                sort_column_flag=1;
            }
            else if(strcmp(sort_column,"TIMESTAMP") == 0){
                sort_column_flag= 2;
            }
            else if(strcmp(sort_column,"NAME") == 0){
                sort_column_flag =0;
            }


    // total_files = 1000;
    // if(argc > 1){
    //     total_files = atoi(argv[1]);
    // }
    
    // printf("%d\n",total_files);
    // generate_random_data_merge_sort(1); // parameter passed is for sort_way
    // generate_random_data_count_sort(1); // parameter passed is for sort_way
    
 

    // struct timespec start_cpu, end_cpu;
    // struct timespec start_wall, end_wall;

    // // Start timing
    // clock_gettime(CLOCK_MONOTONIC, &start_cpu);   // For CPU time
    // clock_gettime(CLOCK_REALTIME, &start_wall);            // For wall time
    // // Start timing
  
    // merge_sort_non_distributed(0,total_files-1,sort_column_flag);
    lazy_sort(sort_column_flag);

    // non_distributed_count_sort();

    // qsort(files ,total_files, sizeof(File*), get_comparison_function());
    
    // End timing
    // clock_gettime(CLOCK_MONOTONIC, &end_cpu);
    // clock_gettime(CLOCK_REALTIME, &end_wall);

    // Calculate CPU time used (in seconds)
    // double cpu_time_used = (end_cpu.tv_sec - start_cpu.tv_sec) +
    //                        (end_cpu.tv_nsec - start_cpu.tv_nsec) / 1e9;

    // // Calculate wall time used (in seconds)
    // double wall_time_used = (end_wall.tv_sec - start_wall.tv_sec) +
    //                         (end_wall.tv_nsec - start_wall.tv_nsec) / 1e9;

    // printf("\nExecution times:\n");
    // printf("CPU time: %.9f seconds\n", cpu_time_used);
    // printf("Wall clock time: %.9f seconds\n", wall_time_used);
    // printf("%.9f\n",cpu_time_used);
     // Print results

    printf("%s\n", sort_column);
      
    for (int i = 0; i < total_files; i++) {
        printf("%s %d %s\n", files[i]->name, files[i]->id, files[i]->timestamp);
    }
    // printf("%d\n",total_files);
    // for (int i = 0; i < total_files; i++) {
    //     printf("%s %d %s\n", testfiles[i]->name, testfiles[i]->id, testfiles[i]->timestamp);
    // }
    // // checking the validity of sorting
    // check_data();
    
    // Cleanup
    free(files);
    
    return 0;
}