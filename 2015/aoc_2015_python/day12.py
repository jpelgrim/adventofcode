# https://adventofcode.com/2015/day/12


def part1():
    print('--- Day 12: JSAbacusFramework.io ---')
    with open('input/day12.txt') as f:
        line = f.readline()

    answer = _calculate_total_sum(line, False)

    print(f'    Part 1: {answer}')


def part2():
    with open('input/day12.txt') as f:
        line = f.readline()

    answer = _calculate_total_sum(line, True)

    print(f'    Part 2: {answer}')


def _calculate_total_sum(line, is_part2):
    total_sum = 0
    i = 0
    negative_number = False
    number_string = ''
    while i < len(line):
        if line[i] == '-':
            negative_number = True
        elif line[i].isdigit():
            number_string += line[i]
        else:
            if number_string:
                composite_number = int(number_string) * (-1 if negative_number else 1)
                total_sum += composite_number
                number_string = ''
            negative_number = False
            if is_part2 and line[i] == '{':
                found_red_value = False
                bracket_count = 1
                j = i + 1
                while j < len(line):
                    if line[j] == '{' or line[j] == '[':
                        bracket_count += 1
                    elif line[j] == '}' or line[j] == ']':
                        bracket_count -= 1
                        if bracket_count == 0:
                            break
                    elif bracket_count == 1 and line[j] == 'r' and line[j + 1] == 'e' and line[j + 2] == 'd':
                        found_red_value = True
                    j += 1

                if found_red_value:
                    i = j
                else:
                    i += 1
                continue

        i += 1

    return total_sum
