#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <stdbool.h>
#define MAX_COUNT 10000

void generate_random_data_to_file(const char *filename, int n) {
    FILE *fp = fopen(filename, "w");
    if (fp == NULL) {
        perror("Unable to open file");
        return;
    }

    const char name_chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    const int name_chars_len = sizeof(name_chars) - 1;

    // Write the number of files at the beginning
    fprintf(fp, "%d\n", n);

    // Seed the random number generator
    srand(time(NULL));

    for (int i = 0; i < n; i++) {
        // Generate random name
        char name[128 + 1];
        for (int j = 0; j < 128; j++) {
            name[j] = name_chars[rand() % name_chars_len];
        }
        name[128] = '\0';

        // Generate random ID
        int id = rand() % 1000000 + 1;

        // Generate random timestamp
        int year = rand() % 10 + 2022;
        int month = rand() % 12 + 1;
        int day = rand() % 28 + 1;
        int hour = rand() % 24;
        int minute = rand() % 60;
        int second = rand() % 60;

        char timestamp[20];
        snprintf(timestamp, sizeof(timestamp),
                 "%04d-%02d-%02dT%02d:%02d:%02d",
                 year, month, day, hour, minute, second);

        // Write data to the file in the required format
        fprintf(fp, "%s %d %s\n", name, id, timestamp);
    }

    // Write the last ID on a new line
    fprintf(fp, "%d\n", rand() % 1000000 + 1);

    fclose(fp);
}

int main(){
    generate_random_data_to_file("input.txt",100000);
}