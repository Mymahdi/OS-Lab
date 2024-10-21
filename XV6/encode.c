#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"

#define STD_NUM1 810100134
#define STD_NUM2 810100140
#define STD_NUM3 810100199
#define MODE 26

void my_strcat(char *dest, const char *src) {
    while (*dest) {  // Move to the end of dest
        dest++;
    }
    while (*src) {  // Copy src to dest
        *dest++ = *src++;
    }
    *dest = '\0';  // Null-terminate the concatenated string
}

int calculateKey() {
    int sum = 0;

    // Sum the last two digits of each student number
    sum += (STD_NUM1 % 100) / 10 + (STD_NUM1 % 100) % 10; 
    sum += (STD_NUM2 % 100) / 10 + (STD_NUM2 % 100) % 10; 
    sum += (STD_NUM3 % 100) / 10 + (STD_NUM3 % 100) % 10; 

    return sum % MODE;
}

void encrypt(char *input, char *output) {
    int i;
    const int KEY = calculateKey();
    for (i = 0; input[i] != '\0'; i++) {
        if (input[i] >= 'a' && input[i] <= 'z') {
            output[i] = (input[i] - 'a' + KEY) % MODE + 'a';
        } else if (input[i] >= 'A' && input[i] <= 'Z') {
            output[i] = (input[i] - 'A' + KEY) % MODE + 'A';
        } else {
            output[i] = input[i]; // Non-alphabetic characters remain unchanged
        }
    }
    output[i] = '\0'; // Null-terminate the output string
}

int main(int argc, char *argv[]) {
    char input[256];    // Buffer for user input
    char output[256];   // Buffer for output

    if (argc < 2) {
        printf(2, "Usage: encode <string>\n");
        exit();
    }

    input[0] = '\0';

    // Combine all arguments into the input string
    for (int i = 1; i < argc; i++) {  // Start from index 1 to skip the program name
        if (i > 1) {
            my_strcat(input, " ");  // Add a space between words
        }
        my_strcat(input, argv[i]);
    }

    // Encrypt the input string
    encrypt(input, output);

    int fd = open("result.txt", O_CREATE | O_WRONLY);
    if (fd < 0) {
        printf(2, "Error opening file for writing.\n");
        exit();
    }

    write(fd, output, strlen(output));
    write(fd, "\n", 1);

    close(fd);

    exit();
}
