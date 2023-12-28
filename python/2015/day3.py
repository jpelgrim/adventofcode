# https://adventofcode.com/2015/day/3
from points import Point2D


def part1():
    print('--- Day 3: Perfectly Spherical Houses in a Vacuum ---')
    with open('input/day3.txt') as f:
        line = f.readline()

    last_pos = Point2D([0, 0])
    visited = {last_pos}

    for i in range(len(line)):
        last_pos = determine_new_point(line[i], last_pos)
        visited.add(last_pos)

    print(f'    Part 1: {len(visited)}')


def part2():
    with open('input/day3.txt') as f:
        line = f.readline()

    last_pos_santa = Point2D([0, 0])
    last_pos_bot = Point2D([0, 0])
    visited = {last_pos_santa}

    for i in range(len(line)):
        if i % 2 == 0:
            last_pos_santa = determine_new_point(line[i], last_pos_santa)
            visited.add(last_pos_santa)
        else:
            last_pos_bot = determine_new_point(line[i], last_pos_bot)
            visited.add(last_pos_bot)

    print(f'    Part 2: {len(visited)}')


def determine_new_point(step, previous_point):
    if step == '<':
        new_point = Point2D([previous_point.x - 1, previous_point.y])
    elif step == '>':
        new_point = Point2D([previous_point.x + 1, previous_point.y])
    elif step == 'v':
        new_point = Point2D([previous_point.x, previous_point.y - 1])
    else:
        new_point = Point2D([previous_point.x, previous_point.y + 1])

    return new_point


