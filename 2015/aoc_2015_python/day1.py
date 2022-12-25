# https://adventofcode.com/2015/day/1


def part1():
    print('--- Day 1: Not Quite Lisp ---')
    with open('input/day1.txt') as f:
        line = f.read()

    answer = line.count('(') - line.count(')')
    print('    Part 1: ' + str(answer))


def part2():
    with open('input/day1.txt') as f:
        line = f.read()

    position = 1
    floor = 0
    for c in line:
        if c == '(':
            floor += 1
        elif c == ')':
            floor -= 1
        if floor == -1:
            print('    Part 2: ' + str(position))
            break
        else:
            position = position + 1
