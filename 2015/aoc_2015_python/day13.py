# https://adventofcode.com/2015/day/13
import itertools


def part1():
    print('--- Day 13: Knights of the Dinner Table ---')
    happiness, people = _parse_input()

    table_seating = _calculate_total_happiness(happiness, people)

    answer = max(table_seating.values())

    print(f'    Part 1: {answer}')


def part2():
    happiness, people = _parse_input()

    for person in people:
        happiness[f'Johan->{person}'] = 0
        happiness[f'{person}->Johan'] = 0

    people.add('Johan')

    table_seating = _calculate_total_happiness(happiness, people)

    answer = max(table_seating.values())

    print(f'    Part 2: {answer}')


def _parse_input():
    with open('input/day13.txt') as f:
        lines = list(_map_many(f.readlines(),
                               lambda x: x.replace('would gain ', ''),
                               lambda x: x.replace('would lose ', '-'),
                               lambda x: x.replace(' happiness units by sitting next to', ''),
                               lambda x: x.replace('.', ''),
                               lambda x: x.replace('\n', ''),
                               ))
    happiness = dict()
    people = set()
    for line in lines:
        (person1, units, person2) = line.split(' ')
        happiness[f'{person1}->{person2}'] = int(units)
        people.add(person1)
        people.add(person2)

    return happiness, people


def _calculate_total_happiness(happiness, people):
    table_seating = dict()

    for perm in itertools.permutations(people):
        perm_list = list(perm)
        total_happiness = 0
        for i in range(-1, len(perm_list) - 1):
            total_happiness += happiness[f'{perm_list[i]}->{perm_list[i - 1]}']
            total_happiness += happiness[f'{perm_list[i]}->{perm_list[i + 1]}']
        table_seating['->'.join(perm_list)] = total_happiness

    return table_seating


def _map_many(iterable, function, *other):
    if other:
        return _map_many(map(function, iterable), *other)
    return map(function, iterable)
