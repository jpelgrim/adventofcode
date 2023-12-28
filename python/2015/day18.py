# https://adventofcode.com/2015/day/18


def part1():
    print('--- Day 18: Like a GIF For Your Yard ---')
    run_part(False)


def part2():
    run_part(True)


def run_part(is_part2):
    with open('input/day18.txt') as f:
        lines = f.readlines()
    matrix = []
    for line in lines:
        matrix.append(list(line.strip()))
    if is_part2:
        _turn_corner_lights_on(matrix)
    for i in range(100):
        matrix = _calculate_next_state(matrix)
        if is_part2:
            _turn_corner_lights_on(matrix)

    answer = sum(map(lambda x: sum(map(lambda y: 1 if y == '#' else 0, x)), matrix))
    print(f'    Part {2 if is_part2 else 1}: {answer}')


def _turn_corner_lights_on(matrix):
    matrix[0][0] = '#'
    matrix[0][len(matrix[0]) - 1] = '#'
    matrix[len(matrix) - 1][0] = '#'
    matrix[len(matrix) - 1][len(matrix[0]) - 1] = '#'


def _count_neighbours_on(matrix, x, y):
    max_y = len(matrix) - 1
    max_x = len(matrix[0]) - 1

    result = 0
    if x > 0:
        if matrix[y][x - 1] == '#':
            result += 1
        if y > 0 and matrix[y - 1][x - 1] == '#':
            result += 1
        if y < max_y and matrix[y + 1][x - 1] == '#':
            result += 1
    if x < max_x:
        if matrix[y][x + 1] == '#':
            result += 1
        if y > 0 and matrix[y - 1][x + 1] == '#':
            result += 1
        if y < max_y and matrix[y + 1][x + 1] == '#':
            result += 1
    if y > 0 and matrix[y - 1][x] == '#':
        result += 1
    if y < max_y and matrix[y + 1][x] == '#':
        result += 1

    return result


def _calculate_next_state(matrix):
    new_matrix = []
    for y in range(len(matrix)):
        new_row = []
        for x in range(len(matrix[y])):
            new_row.append('.')
        new_matrix.append(new_row)

    for y in range(len(matrix)):
        for x in range(len(matrix[y])):
            neighbours_on = _count_neighbours_on(matrix, x, y)
            if matrix[y][x] == '#' and (neighbours_on == 2 or neighbours_on == 3):
                new_matrix[y][x] = '#'
            elif matrix[y][x] == '.' and neighbours_on == 3:
                new_matrix[y][x] = '#'

    return new_matrix
