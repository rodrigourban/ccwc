#! /usr/bin/env python
import codecs
import sys
import pathlib

"""
This is a copy of unix command wc
created for https://codingchallenges.fyi/challenges/challenge-wc/
"""


def arg_parser() -> tuple[str, str]:
    args = sys.argv

    if len(args) <= 1:
        raise SyntaxError("Invalid syntax")
    
    if '.txt' in args[1]:
        command_name = '-a'
        file_name = args[1]

    elif (len(args) < 3):
        # no file name
        file_name = None
        command_name = args[1]
    else:
        file_name = args[2]
        command_name = args[1]
    
    return (file_name, command_name)


def with_file_name(func):
    def wrapper(file_name: str | None):
        if (file_name is None):
            print("Please enter a valid file name.")
            return
        try:
            working_dir = pathlib.Path().absolute()
            return func(file_name, working_dir)

        except FileNotFoundError:
            print(f"File {file_name} does not exist")
        
    return wrapper

@with_file_name
def count_binary(file_name: str, working_dir: str) -> int:
    with open(working_dir / file_name, 'rb') as f:
        # First we need to read the io.BufferedReader
        # once we have the data, we can use len on it.
        content = f.read()
        binary_count = len(content) 
        return binary_count
    


def count_lines(file_name: str) -> int:
    try:
        if file_name is None:
            standard_input = sys.stdin.read()
            line_count = standard_input.count('\n')
            return line_count
        else:
            working_dir = pathlib.Path().absolute()
            with open(working_dir / file_name, 'r', encoding="utf-8") as f:
                content = f.read()
                line_count = content.count('\n')
                return line_count

    except FileNotFoundError:
        print(f"File {file_name} does not exist")
    

@with_file_name
def count_words(file_name: str, working_dir: str) -> int:
    with open(working_dir / file_name, 'r', encoding="utf-8") as f:
        content = f.read()
        word_count = content.split()
        return len(word_count)


@with_file_name
def count_characters(file_name: str, working_dir: str) -> int:
    with codecs.open(working_dir / file_name, 'rb') as f:
        content = f.read()
        decoded = content.decode('utf-8')
        return len(decoded)



def main():
    """
        Possible flags:
        -c fileName: outputs number of bytes in file
        -l optional(fileName): outputs number of lines in file
            should also support standard input
        -w fileName: outputs number of words in file
        -c fileName: outputs number of characters in file
        -h: show list of commands.
        -*: all others should return an error message.

        Approach:
            Have a command reader that matches each command with the appropiate
            functionality.
    """
    try:
        file_name, command = arg_parser()

        match command:
            case '-c':
                binary_c = count_binary(file_name)
                print(f'{binary_c} {file_name}')
            case '-l':
                line_c = count_lines(file_name)
                print(f'{line_c} {str(file_name)}')
            case '-w':
                word_c = count_words(file_name)
                print(f'{word_c} {file_name}')
            case '-m':
                char_c = count_characters(file_name)
                print(f'{char_c} {file_name}')
            case '-h':
                print("""
                    Usage: ./ccwc.sh [OPTION]... [FILE]...
                        or ./ccwc.sh [OPTION]
                    The current list of command:
                        -c      outputs number of bytes in file
                        -l      outputs number of lines in file
                                Also supports standard input.
                        -w      outputs number of words in file
                        -m      outputs number of characters in file
                        -h:     show list of commands.
                    """)
            case '-a':
                # all
                binary_c = count_binary(file_name)
                word_c = count_words(file_name)
                line_c = count_lines(file_name)

                print(f'{line_c} {word_c} {binary_c} {file_name}')
            case _:
                print("Command not found. Use -h to get the list of available commands")

    except:
        print("Invalid syntax, please try again.")



main()
