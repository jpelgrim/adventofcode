# https://adventofcode.com/2015/day/2
from typing import List


def part1():
    print('--- Day 2: I Was Told There Would Be No Math ---')
    with open('input/day2.txt') as f:
        lines = f.readlines()

    dimensions = map(lambda line: _Dimension(list(map(int, line.split('x')))), lines)

    answer = sum(map(lambda d: d.surface_area(), dimensions))

    print(f'    Part 1: {answer}')


def part2():
    with open('input/day2.txt') as f:
        lines = f.readlines()

    dimensions = map(lambda line: _Dimension(list(map(int, line.split('x')))), lines)

    answer = sum(map(lambda d: d.bow_length(), dimensions))

    print(f'    Part 2: {answer}')


class _Dimension:
    height: int
    width: int
    length: int

    def __init__(self, elements: List[int]):
        self.length = elements[0]
        self.width = elements[1]
        self.height = elements[2]

    def surface_area(self):
        side1 = self.length * self.width
        side2 = self.width * self.height
        side3 = self.height * self.length
        return 2 * side1 + 2 * side2 + 2 * side3 + min(side1, side2, side3)

    def bow_length(self):
        dimensions = [self.length, self.width, self.height]
        max_dimension = max(self.length, self.width, self.height)
        dimensions.remove(max_dimension)

        shortest_distance = 2 * dimensions[0] + 2 * dimensions[1]

        length_of_bow = self.length * self.width * self.height

        return shortest_distance + length_of_bow
