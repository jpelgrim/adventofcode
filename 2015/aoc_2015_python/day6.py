# https://adventofcode.com/2015/day/6
from functools import reduce
import points


def _fetch_point_range(line, start):
    coords = line[start:].split(' through ')
    point_from = points.Point2D(list(map(int, coords[0].split(','))))
    point_to = points.Point2D(list(map(int, coords[1].split(','))))
    return point_from, point_to


def _create_matrix():
    matrix = []
    for _ in range(1000):
        row = []
        for _ in range(1000):
            row.append(0)
        matrix.append(row)

    return matrix


def part1():
    print('--- Day 6: Probably a Fire Hazard ---')
    matrix = _create_matrix()
    with open('input/day6.txt') as f:
        lines = f.readlines()

    for line in lines:
        if str.startswith(line, 'turn on'):
            point_range = _fetch_point_range(line, 7)
            for x in range(point_range[0].x, point_range[1].x + 1):
                for y in range(point_range[0].y, point_range[1].y + 1):
                    matrix[y][x] = 1
        elif str.startswith(line, 'turn off'):
            point_range = _fetch_point_range(line, 8)
            for x in range(point_range[0].x, point_range[1].x + 1):
                for y in range(point_range[0].y, point_range[1].y + 1):
                    matrix[y][x] = 0
        else:  # it must be 'toggle'
            point_range = _fetch_point_range(line, 6)
            for x in range(point_range[0].x, point_range[1].x + 1):
                for y in range(point_range[0].y, point_range[1].y + 1):
                    if matrix[y][x] == 1:
                        matrix[y][x] = 0
                    else:
                        matrix[y][x] = 1

    answer = 0

    for c in range(1000):
        answer += reduce(lambda _x, _y: _x + _y, matrix[c])

    print(f'    Part 1: {answer}')


def part2():
    matrix = _create_matrix()
    with open('input/day6.txt') as f:
        lines = f.readlines()

    for line in lines:
        if str.startswith(line, 'turn on'):
            point_range = _fetch_point_range(line, 7)
            for x in range(point_range[0].x, point_range[1].x + 1):
                for y in range(point_range[0].y, point_range[1].y + 1):
                    matrix[y][x] += 1
        elif str.startswith(line, 'turn off'):
            point_range = _fetch_point_range(line, 8)
            for x in range(point_range[0].x, point_range[1].x + 1):
                for y in range(point_range[0].y, point_range[1].y + 1):
                    if matrix[y][x] > 0:
                        matrix[y][x] -= 1
        else:  # it must be 'toggle'
            point_range = _fetch_point_range(line, 6)
            for x in range(point_range[0].x, point_range[1].x + 1):
                for y in range(point_range[0].y, point_range[1].y + 1):
                    matrix[y][x] += 2

    answer = 0

    for c in range(1000):
        answer += reduce(lambda _x, _y: _x + _y, matrix[c])

    print(f'    Part 2: {answer}')
