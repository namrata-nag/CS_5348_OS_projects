#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h> // for system call
#include <unistd.h>
#include <sys/wait.h>
#include <stdbool.h> // Header-file for boolean data-type.
#include <fcntl.h>
#include <ctype.h>
#include <signal.h>
#include <errno.h>

// store the path to the command dirs
struct Path
{
    char *path;
    struct Path *next;
};

struct Path *path_addrs = NULL;

// print the error message whenever an error occurs
void printError()
{
    char error_message[30] = "An error has occurred\n";
    write(STDERR_FILENO, error_message, strlen(error_message));
}

// Free the memory allocated to path
void freePath(struct Path *list)
{
    struct Path *tmp;

    while (list != NULL)
    {
        tmp = list;
        list = list->next;
        free(tmp);
    }
}

// Free the memory and mark the head to path as NULL
void resetPath(struct Path *node)
{
    if (node == NULL)
        return;
    freePath(node);
    path_addrs = NULL;
}

// Create a Link List to store the argument passed in the path command
void createPath(char *token)
{

    struct Path *tmp_path = (struct Path *)malloc(sizeof(struct Path));
    tmp_path->path = token;
    tmp_path->next = NULL;
    if (path_addrs == NULL)
    {
        path_addrs = tmp_path;
    }
    else
    {
        tmp_path->next = path_addrs;
        path_addrs = tmp_path;
    }
}

// check using access command if path exists
char *checkIfCommandPresent(char *command, struct Path *node)
{
    if (node == NULL)
        return NULL;
    int command_len = strlen(command);
    int path_len = strlen(node->path);
    char *complete_path = malloc(command_len + path_len + 2);
    int i, j;
    for (i = 0; i < path_len; i++)
    {
        complete_path[i] = node->path[i];
    }
    if (i > 0 && complete_path[i - 1] == '/')
    {
        i = i - 1;
    }
    else
    {
        complete_path[i] = '/';
    }

    for (i = i + 1, j = 0; i <= path_len + command_len + 1; i++, j++)
    {
        complete_path[i] = command[j];
    }
    complete_path[i] = '\0';
    if (access(complete_path, X_OK) == 0)
        return complete_path;
    if (node->next == NULL)
        return complete_path;
    free(complete_path);
    return checkIfCommandPresent(command, node->next);
}

struct Token
{
    bool redirection;
    struct Token *next;
    char *command;
    char *fileName;
    int argCount;
};

struct Token *head = NULL;

void freeList(struct Token *list)
{
    struct Token *tmp;

    while (list != NULL)
    {
        tmp = list;
        list = list->next;
        free(tmp);
    }
}

struct build_in_functions
{
    int key;
    char *value;
};
const char *build_in_commands[3] = {"exit", "cd", "path"};

bool checkIfBuildIn(char *command)
{
    bool value = false;
    int i;
    for (i = 0; i < 3; i++)
    {
        if (!strcmp(build_in_commands[i], command))
        {
            value = true;
            break;
        }
    }
    return value;
}

void callBuildInFunction(char *token_array[], int token_count)
{

    if (!strcmp(token_array[0], "exit"))
    {
        if (token_count == 1)
        {
            exit(0);
        }
        else
        {
            printError(); // Throw error for bad exit command
            exit(0);
        }
    }
    else if (!strcmp(token_array[0], "path"))
    {
       
        resetPath(path_addrs);  // remove the existing path
        while (token_count > 1)
        {
            createPath(token_array[token_count - 1]);
            token_count = token_count - 1;
        }
    }
    else if (!strcmp(token_array[0], "cd"))
    {

        if (token_count == 2)
        {
            int isSuccess = chdir(token_array[1]);
            if (isSuccess != 0)

                if (isSuccess != 0)
                    printError();
        }
        else
        {
            printError();
        }
    }
}

void traverseToken(struct Token *tmp, int x)
{
    if (tmp == NULL)
        return;
    printf("\nToken data command : %s, fileNamw: %s, %d %d %d\n", tmp->command, tmp->fileName, x, getpid(), getppid());
    traverseToken(tmp->next, x++);
}

void createToken(char *formatString, size_t string_length)
{

    char *saveptr1 = NULL, *saveptr2 = NULL, *duplicate = NULL;
    char *str1 = NULL, *subtoken = NULL, *token = NULL, *str2 = NULL;
    struct Token *tmp = NULL;
    struct Token *tmpNext = NULL;
    head = NULL;

    if (formatString[0])

        for (str1 = formatString, tmp = head;; str1 = NULL)
        {
            
            token = strtok_r(str1, "&", &saveptr1); // check for parallel command
            if (token == NULL || (token != NULL && !strcmp(token, "")))
            {
                break;
            }

            //  create a node to store the command, filename etc when head is null
            if (tmp == NULL)
            {
                tmp = (struct Token *)malloc(sizeof(struct Token));
                head = tmp;
                tmp->command = token;
                tmp->redirection = false;
                tmp->next = NULL;
            }
            else // create a node to store the command, filename etc when head is not null
            {
                tmpNext = (struct Token *)malloc(sizeof(struct Token)); 
                tmpNext->command = token;
                tmpNext->redirection = false;
                tmpNext->next = NULL;
                tmp->next = tmpNext;
                tmpNext = tmp;
                tmp = tmp->next;
            }

            char *tokenDup = strdup(token);
            subtoken = strtok_r(tokenDup, ">", &saveptr2);

            // subtoken and token will only be equal when there is no redirection
            // If equal then continue as we dont have to do filevalidation
            if (!strcmp(token, subtoken))
            {
                tmp->command = token;
                tmp->redirection = false;
                continue;
            }

            // Filename validation
            // check if filename is not null or mutiple
            if (saveptr2 != NULL && strcmp(saveptr2, ""))
            {
                // command does not exist
                if (subtoken == NULL)
                {
                    printError();
                }
                str2 = strtok_r(saveptr2, " ", &duplicate);

                // if duplicate is not null than multiple file exists
                if (duplicate != NULL && strcmp(duplicate, ""))
                {
                    // multiple file  present
                    printError();

                    // Since there is error in parsing free the node
                    if (tmpNext != NULL)
                    {
                        free(tmp);
                        tmp = tmpNext;
                    }
                    else
                    {
                        free(tmp);
                        head = NULL;
                        tmp = head;
                    }

                    continue;
                }

                // No file is given
                if (str2 == NULL || !strcmp(str2, "") || !strcmp(str2, ">"))
                {
                    // Since there is error in parsing free the node
                    printError();
                    if (tmpNext != NULL)
                    {
                        free(tmp);
                        tmp = tmpNext;
                    }
                    else
                    {
                        free(tmp);
                        head = NULL;
                        tmp = head;
                    }
                    continue;
                }
                str2 = strtok_r(saveptr2, ">", &duplicate);
                tmp->command = subtoken;
                tmp->redirection = true;
                tmp->fileName = str2;
            }
            else
            {
                // Since there is error in parsing free the node
                printError();
                if (tmpNext != NULL)
                {
                    free(tmp);
                    tmp = tmpNext;
                }
                else
                {
                    free(tmp);
                    head = NULL;
                    tmp = head;
                }
                continue;
            }
        }
}

void runCommand(struct Token *start)
{
    if (start == NULL)
    {
        return;
    }

    if (start->command)
    {
        char *str1 = NULL, *str2 = NULL, *token = NULL;
        char *myArg[strlen(start->command)];
        int i, tokenCount;
        char *final_command = NULL;

        // storing the command in an array
        for (i = 0, str1 = start->command;; str1 = NULL, i++)
        {
           
            token = strtok_r(str1, " ", &str2);  // check for space before token

            if (token == NULL || !strcmp(token, ""))
            {
                myArg[i] = NULL;
                break;
            }

            myArg[i] = token;
        }
        tokenCount = i;

        bool is_build_in_command = checkIfBuildIn(myArg[0]); // check if the command is a buildInFunc 
        if (is_build_in_command)
        {
            callBuildInFunction(myArg, tokenCount); // calling build-in command
        }
        else
        {
            int pid = fork();  // create a child process

            //if child process then execute the if code
            if (!pid)
            {

                int fd = -1;
                if (start->redirection)
                {
                    close(STDOUT_FILENO);
                    close(STDERR_FILENO);
                    char *fileName = strtok(start->fileName, " ");
                    fd = open(fileName, O_TRUNC | O_RDWR | O_CREAT, S_IRWXU);
                    if (fd < 0)
                    {
                        printError();
                        exit(0);
                    }
                    
                    dup2(fd, 2); // Use the user file for dsaving the error message
                }

                // if path is not initialized
                if (path_addrs == NULL)
                {

                    printError();
                    exit(0);
                }
                // check if command exist in the path
                final_command = checkIfCommandPresent(myArg[0], path_addrs);

                // final_command will be NULL if the command is not found on any given path
                if (final_command == NULL)
                {
                    printError();
                    exit(0);
                }

                myArg[0] = final_command;
                execv(myArg[0], myArg);
                printError();
                exit(0);
            }
        }
    }
    return runCommand(start->next);
}

int main(int argc, char *argv[])
{
    // If more than two argument then throw error
    if (argc > 2)
    {
        printError();
        exit(0);
    }

    //Initially set path to /bin by default
    createPath("/bin");
    while (1)
    {
        char *buffer = NULL; // save user input in the buffer
        size_t bufsize = 32;
        size_t string_length;
        ssize_t read;
        char *formatString = NULL; // remove the nwline character
        buffer = (char *)malloc(bufsize * sizeof(char));
        if (buffer == NULL)
        {
            printError();
            exit(0);
        }

        // if no argument is passed then cli mode
        if (argc < 2)
        {
            wait(NULL);

            printf("dash> ");
            string_length = getline(&buffer, &bufsize, stdin); // get string from user input
            formatString = strdup(buffer);  // since strtok modify the actual string its better to copy the string to another location
            formatString = strtok(formatString, "\n"); // remove newline char from string

            // if no string given
            if (formatString == NULL || !strcmp(formatString, ""))
            {
                continue;
            }

            // Remove white space in the starting of line
            while (formatString != NULL && formatString[0] == ' ')
                formatString++;

            // if no command is given do not throw error and just continue
            if (formatString == NULL)
            {
                continue;
            }

            // if the starting of the line is a delimiter & then throw error
            if (formatString != NULL && formatString[0] == '&')

            {
                printError();
            }

            if (formatString)
            {

                createToken(formatString, string_length); // Run the command if valid

                runCommand(head);
                // wait till all child process is terminated
                while (wait(NULL) > 0);
                freeList(head);
                head = NULL;
            }
        }
        else
        {
            char *fileName = argv[1];
            FILE *filePointer = fopen(fileName, "r");
            if (filePointer == NULL)
            {
                printError();
                exit(0);
            }

            // To read file
            while ((read = getline(&buffer, &bufsize, filePointer)) != -1)
            {
                if (buffer == NULL)
                {
                    continue;
                }

                // since strtok modify the actual string its better to copy the string to another location
                formatString = strdup(buffer);
                formatString = strtok(formatString, "\n"); // remove newline char from string
                if (formatString == NULL)
                {
                    continue;
                }

                // Remove white space in the starting of line
                while (formatString != NULL && formatString[0] == ' ')
                    formatString++;
                //  if no command is given do not throw error and just continue
                if (formatString == NULL || (formatString != NULL && !strcmp(formatString, "")))
                {

                    continue;
                }

                // if the starting of the line is a delimiter & then throw error
                if (formatString != NULL && formatString[0] == '&')
                {
                    printError();
                }

                if (formatString && strcmp(formatString, ""))
                {
                    createToken(formatString, 32); // Run the command if valid
                    runCommand(head);
                    while (wait(NULL) > 0);
                    freeList(head);
                    head = NULL;
                    formatString = NULL;
                }
            }
            free(buffer);
            fclose(filePointer);
            // Exit when invalid file name is given
            exit(0);
        }
    }
}
