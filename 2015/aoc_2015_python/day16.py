# https://adventofcode.com/2015/day/16
import re

_checks = [
    'children: 3',
    'cats: 7',
    'samoyeds: 2',
    'pomeranians: 3',
    'akitas: 0',
    'vizslas: 0',
    'goldfish: 5',
    'trees: 3',
    'cars: 2',
    'perfumes: 1',
]


def part1():
    print('--- Day 16: Aunt Sue ---')
    with open('input/day16.txt') as f:
        lines = f.readlines()

    for line in lines:
        found_match = True
        for check in _checks:
            check_characteristic = check.split(': ')[0]
            if line.find(check_characteristic) > -1 and line.find(check) == -1:
                found_match = False
                break

        if found_match:
            answer = line.split(': ')[0]
            break

    print(f'    Part 1: {answer}')


def _get_value(characteristic, line):
    p = re.compile(f'.*{characteristic}: (\\d+).*')
    m = p.match(line.strip())
    return int(m.group(1))


def part2():
    with open('input/day16.txt') as f:
        lines = f.readlines()

    for line in lines:
        found_match = True
        for check in _checks:
            check_characteristic, check_characteristic_value = check.split(': ')
            if line.find(check_characteristic) > -1:
                if check_characteristic in 'catstrees':
                    # cats and trees readings indicates that there are greater than that many
                    value_in_line = _get_value(check_characteristic, line)
                    if value_in_line <= int(check_characteristic_value):
                        found_match = False
                        break
                elif check_characteristic in 'pomeraniansgoldfish':
                    # pomeranians and goldfish readings indicate that there are fewer than that many
                    value_in_line = _get_value(check_characteristic, line)
                    if value_in_line >= int(check_characteristic_value):
                        found_match = False
                        break
                elif line.find(check) == -1:
                    found_match = False
                    break

        if found_match:
            answer = line.split(': ')[0]
            break

    print(f'    Part 2: {answer}')
