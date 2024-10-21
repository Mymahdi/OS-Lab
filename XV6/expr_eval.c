// expr_eval.c
#include "types.h"
#include "stat.h"
#include "user.h"
#include "string.h"

void evaluate_expression(char *input) {
    char *ptr = input;
    char result[256];  // Adjust size as needed
    int res_index = 0;

    while (*ptr) {
        if (*ptr >= '0' && *ptr <= '9') {
            // Parse the first number (N)
            int N = strtol(ptr, &ptr, 10);
            char operator = *ptr++;
            
            // Parse the second number (X)
            int X = strtol(ptr, &ptr, 10);

            // Check for `=?` pattern
            if (*ptr == '=' && *(ptr + 1) == '?') {
                ptr += 2;  // Skip `=?`
                
                // Calculate the result based on the operator
                int result_value;
                switch (operator) {
                    case '+': result_value = N + X; break;
                    case '-': result_value = N - X; break;
                    case '*': result_value = N * X; break;
                    case '/': 
                        if (X != 0) {
                            result_value = N / X;
                        } else {
                            printf("Error: Division by zero.\n");
                            return;
                        }
                        break;
                    default:
                        printf("Error: Unknown operator.\n");
                        return;
                }
                
                // Append the result to the output string
                res_index += snprintf(&result[res_index], sizeof(result) - res_index, "%d", result_value);
            } else {
                // If not a valid `=?` pattern, append the parsed values as they are
                res_index += snprintf(&result[res_index], sizeof(result) - res_index, "%d%c%d", N, operator, X);
            }
        } else {
            // Append non-matching characters to the result
            result[res_index++] = *ptr++;
        }
    }
    
    // Null-terminate the result string and copy it back to input
    result[res_index] = '\0';
    memmove(input, result, strlen(result) + 1);
}
