# https://adventofcode.com/2015/day/14
from tools import map_many


def part1():
    print('--- Day 14: Reindeer Olympics ---')
    reindeer = _parse_input()

    answer = 0
    pit = 2503

    for r in reindeer:
        name, total_distance = _total_distance_point_in_time(pit, r)

        if total_distance > answer:
            answer = total_distance

    print(f'    Part 1: {answer}')


def part2():
    reindeer = _parse_input()
    reindeer_names = list(map(lambda x: x[0], reindeer))

    scores = dict()
    for r in reindeer_names:
        scores[r] = 0

    for pit in range(1, 2504):
        distances = dict()
        for r in reindeer:
            name, total_distance = _total_distance_point_in_time(pit, r)

            distances[name] = total_distance

        max_distance = max(distances.values())

        for name in reindeer_names:
            if distances[name] == max_distance:
                scores[name] = scores[name] + 1

        # print(f'After {pit} seconds: {scores} {distances}')

    answer = max(scores.values())

    print(f'    Part 2: {answer}')


def _total_distance_point_in_time(pit, r):
    name = r[0]
    km_sec = int(r[1])
    fly_time = int(r[2])
    rest_time = int(r[3])
    nr_of_total_cycles = int(pit / (fly_time + rest_time))
    remainder = pit % (fly_time + rest_time)
    if remainder >= fly_time:
        nr_of_total_cycles += 1
        remainder = 0
    total_distance = nr_of_total_cycles * fly_time * km_sec
    if remainder > 0:
        total_distance += remainder * km_sec
    return name, total_distance


def _parse_input():
    with open('input/day14.txt') as f:
        # Example "Dancer can fly 27 km/s for 5 seconds, but then must rest for 132 seconds."
        lines = list(map_many(f.readlines(),
                              lambda x: x.strip(),
                              lambda x: x.replace(' can fly', ''),
                              lambda x: x.replace(' km/s for', ''),
                              lambda x: x.replace(' seconds, but then must rest for', ''),
                              lambda x: x.replace(' seconds.', ''),
                              ))
    reindeer = []
    for line in lines:
        reindeer.append(line.split(' '))

    return reindeer
