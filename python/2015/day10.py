# https://adventofcode.com/2015/day/10


def _look_and_say(puzzle_input):
    digit_count = 0
    current_digit = puzzle_input[0]
    result = ''
    for i in range(len(puzzle_input)):
        if current_digit != puzzle_input[i]:
            result += str(digit_count) + current_digit
            current_digit = puzzle_input[i]
            digit_count = 1
        else:
            digit_count += 1

    result += str(digit_count) + current_digit

    return result


def part1():
    print('--- Day 10: Elves Look, Elves Say ---')
    puzzle_input = '1113222113'

    for i in range(50):
        puzzle_input = _look_and_say(puzzle_input)
        if i == 39:
            answer_part_1 = len(puzzle_input)

    answer_part_2 = len(puzzle_input)

    print(f'    Part 1: {answer_part_1}')

    print(f'    Part 2: {answer_part_2}')


def part2():
    pass
