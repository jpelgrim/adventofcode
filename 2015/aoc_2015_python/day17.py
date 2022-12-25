# https://adventofcode.com/2015/day/17


def part1():
    print('--- Day 17: No Such Thing as Too Much ---')
    with open('input/day17.txt') as f:
        containers = []
        lines = f.readlines()
        for line in lines:
            containers.append(int(line))

    combinations = _find_all_combinations(containers, 150)

    answer_part_1 = len(combinations)

    print(f'    Part 1: {answer_part_1}')

    length_of_combinations = list(map(lambda x: len(x), combinations))
    minimum_length = min(length_of_combinations)

    combinations_with_minimal_length = list(filter(lambda x: len(x) == minimum_length, combinations))
    answer_part_2 = len(combinations_with_minimal_length)

    print(f'    Part 2: {answer_part_2}')


def part2():
    pass


def _find_all_combinations(containers, total):
    if len(containers) == 0 or total <= 0:
        return []

    containers_copy = containers.copy()
    combinations = []
    while len(containers_copy) > 0:
        container = containers_copy.pop()
        if container > total:
            # there are no combinations with this container possible
            continue

        if container == total:
            # if we have an exact match we're done as well. No reason to find other combinations with this container
            combinations.append([container])
            continue

        # If both previous cases aren't true we'll try to find more combinations
        other_combinations = _find_all_combinations(containers_copy, total - container)
        if len(other_combinations) > 0:
            for other_combination in other_combinations:
                if other_combination is not None:
                    other_combination.append(container)
                    combinations.append(other_combination)

    return combinations
