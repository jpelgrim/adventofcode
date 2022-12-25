# https://adventofcode.com/2015/day/4
import hashlib


def part1():
    print('--- Day 4: The Ideal Stocking Stuffer ---')
    i = 1
    while True:
        if str.startswith(hashlib.md5(f'ckczppom{i}'.encode()).hexdigest(), '00000'):
            answer = i
            break

        i += 1

    print(f'    Part 1: {answer}')


def part2():
    i = 1
    while True:
        if str.startswith(hashlib.md5(f'ckczppom{i}'.encode()).hexdigest(), '000000'):
            answer = i
            break

        i += 1

    print(f'    Part 2: {answer}')
