import decorators

_number_of_solutions = 19


@decorators.stopwatch
def run_all_days():
    # Reminds me of: https://www.youtube.com/watch?v=V-xpJRwIA-Q

    for i in range(1, _number_of_solutions + 1):
        exec(f'run_day({i})')
    print(f'Done running days 1-{_number_of_solutions}!')


@decorators.stopwatch
def run_day(day):
    exec(f'import day{day}')
    exec(f'day{day}.part1()')
    exec(f'day{day}.part2()')


#run_day(_number_of_solutions)
run_all_days()
