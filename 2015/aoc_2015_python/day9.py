# https://adventofcode.com/2015/day/9
_distances = dict()


def part1():
    print('--- Day 9: All in a Single Night ---')
    with open('input/day9.txt') as f:
        lines = f.readlines()

    cities = set()

    # Example line: "London to Dublin = 464"
    for line in lines:
        (route, distance) = line.strip().split(' = ')
        (city1, city2) = route.split(' to ')
        route_reversed = f'{city2} to {city1}'
        cities.add(city1)
        cities.add(city2)
        _distances[route] = int(distance)
        _distances[route_reversed] = int(distance)

    cities_list = list(cities)
    cities_list.sort()
    all_routes = _all_routes(cities_list)
    answer = min(map(lambda x: x[1], all_routes))

    print(f'    Part 1: {answer}')
    answer = max(map(lambda x: x[1], all_routes))

    print(f'    Part 2: {answer}')


def part2():
    pass


# Returns a list of tuples of route (list of city strings) and its distance
def _all_routes(cities):
    result = []
    if len(cities) == 2:
        route1_distance = _distances[f'{cities[0]} to {cities[1]}']
        route2_distance = _distances[f'{cities[1]} to {cities[0]}']
        result.append(([cities[0], cities[1]], route1_distance))
        result.append(([cities[1], cities[0]], route2_distance))

    else:
        for city in cities:
            other_cities = cities.copy()
            other_cities.remove(city)
            all_other_routes = _all_routes(other_cities)
            for other_route in all_other_routes:
                new_route_distance = _distances[f'{city} to {other_route[0][0]}']
                total_route_distance = new_route_distance + other_route[1]
                other_route[0].insert(0, city)
                result.append((other_route[0], total_route_distance))

    return result
