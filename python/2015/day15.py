# https://adventofcode.com/2015/day/15
from functools import reduce
from tools import map_many


def part1():
    print('--- Day 15: Science for Hungry People ---')
    answer = _calculate_best_cookie_score(True)

    print(f'    Part 1: {answer}')


def part2():
    answer = _calculate_best_cookie_score(False)

    print(f'    Part 2: {answer}')


def _calculate_cookie_score(quantities, properties):
    totals = []

    for i in range(len(properties[0]) - 1):
        property_sum = 0
        for j in range(len(quantities)):
            property_sum += properties[j][i] * quantities[j]

        totals.append(max(property_sum, 0))

    product = reduce(lambda x, y: x * y, totals)

    return product


def _calculate_calorie_count(quantities, properties):
    calories = 0
    for j in range(len(quantities)):
        calories += properties[j][4] * quantities[j]

    return calories


def _calculate_best_cookie_score(is_part1):
    properties = _parse_input()
    best_cookie_score = 0
    for sugar in range(100):
        for sprinkles in range(100 - sugar):
            for candy in range(100 - sugar - sprinkles):
                chocolate = 100 - candy - sprinkles - sugar
                cookie_score = _calculate_cookie_score([sugar, sprinkles, candy, chocolate], properties)
                if is_part1:
                    if cookie_score > best_cookie_score:
                        best_cookie_score = cookie_score
                else:
                    calorie_count = _calculate_calorie_count([sugar, sprinkles, candy, chocolate], properties)
                    if cookie_score > best_cookie_score and calorie_count == 500:
                        best_cookie_score = cookie_score

    answer = best_cookie_score
    return answer


def _parse_input():
    result = dict()
    with open('input/day15.txt') as f:
        lines = list(map(lambda x: x.split(': '), f.readlines()))

        names = list(map(lambda x: x[0], lines))

        values = list(map_many(map(lambda x: x[1], lines),
                               lambda x: x.strip(),
                               lambda x: x.replace('capacity ', ''),
                               lambda x: x.replace(' durability ', ''),
                               lambda x: x.replace(' flavor ', ''),
                               lambda x: x.replace(' texture ', ''),
                               lambda x: x.replace(' calories ', ''),
                               lambda x: x.split(','),
                               lambda x: list(map(int, x)),
                               ))

        for i in range(len(names)):
            result[names[i]] = values[i]

    return values
