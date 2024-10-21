#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"

#define KEY 20  

// Function to concatenate two strings
void my_strcat(char *dest, const char *src) {
    while (*dest) {  // Move to the end of dest
        dest++;
    }
    while (*src) {  // Copy src to dest
        *dest++ = *src++;
    }
    *dest = '\0';  // Null-terminate the concatenated string
}

// Function to encrypt the input string using Caesar Cipher
void encrypt(char *input, char *output) {
    int i;
    for (i = 0; input[i] != '\0'; i++) {
        if (input[i] >= 'a' && input[i] <= 'z') {
            output[i] = (input[i] - 'a' + KEY) % 26 + 'a';
        } else if (input[i] >= 'A' && input[i] <= 'Z') {
            output[i] = (input[i] - 'A' + KEY) % 26 + 'A';
        } else {
            output[i] = input[i]; // Non-alphabetic characters remain unchanged
        }
    }
    output[i] = '\0'; // Null-terminate the output string
}

// Function to decrypt the input string using Caesar Cipher
void decrypt(char *input, char *output) {
    int i;
    for (i = 0; input[i] != '\0'; i++) {
        if (input[i] >= 'a' && input[i] <= 'z') {
            output[i] = (input[i] - 'a' - KEY + 26) % 26 + 'a'; // Add 26 to handle negative results
        } else if (input[i] >= 'A' && input[i] <= 'Z') {
            output[i] = (input[i] - 'A' - KEY + 26) % 26 + 'A'; // Add 26 to handle negative results
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

    // Initialize input buffer to an empty string
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
    printf(1, "%s\n", output); // Print the encrypted output

    exit();
}
