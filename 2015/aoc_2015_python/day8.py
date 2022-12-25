# https://adventofcode.com/2015/day/8
import re


def _count_chars(line):
    return len(line.strip())


def _remove_special_chars(line):
    new_line = line[1:len(line.strip()) - 1]
    hex_removed = re.sub(r'\\x[A-Fa-f0-9]{2}', 'H', new_line)
    quotes_removed = re.sub(r'\\"', '"', hex_removed)
    backslash_removed = re.sub(r'\\\\', 'B', quotes_removed)
    return len(backslash_removed)


def _encode_chars(line):
    step1 = re.sub(r'\\', '👋🏻', line.strip())
    step2 = re.sub(r'"', '💪🏻', step1)
    step3 = re.sub(r'👋🏻', r'\\\\', step2)
    step4 = re.sub(r'💪🏻', r'\\"', step3)
    step5 = f'"{step4}"'
    return step5


def part1():
    print('--- Day 8: Matchsticks ---')
    with open('input/day8.txt') as f:
        lines = f.readlines()

    number_chars = list(map(_count_chars, lines))
    memory_chars = list(map(_remove_special_chars, lines))

    answer = sum(number_chars) - sum(memory_chars)

    print(f'    Part 1: {answer}')


def part2():
    with open('input/day8.txt') as f:
        lines = f.readlines()

    number_chars = list(map(_count_chars, lines))
    encoded_chars = list(map(_encode_chars, lines))
    number_encoded_chars = list(map(_count_chars, encoded_chars))

    answer = sum(number_encoded_chars) - sum(number_chars)

    print(f'    Part 2: {answer}')
