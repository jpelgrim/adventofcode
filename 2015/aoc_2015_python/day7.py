# https://adventofcode.com/2015/day/7
_operations = {}
_results = {}


def part1():
    print('--- Day 7: Some Assembly Required ---')
    with open('input/day7.txt') as f:
        lines = f.readlines()

    for operation in lines:
        (operands, target) = operation.split(' -> ')
        _operations[target.strip()] = operands.split(' ')

    answer = _calculate('a')

    print(f'    Part 1: {answer}')


def part2():
    with open('input/day7.txt') as f:
        lines = f.readlines()

    _operations.clear()
    _results.clear()
    _results['b'] = 16076  # This is the answer from part 1

    for command in lines:
        (operands, target) = command.split('->')
        _operations[target.strip()] = operands.strip().split(' ')

    answer = _calculate('a')

    print(f'    Part 2: {answer}')


def _calculate(name):
    try:
        return int(name)
    except ValueError:
        pass

    if name not in _results:
        # Do the calculation once
        ops = _operations[name]
        if len(ops) == 1:
            # Simple assignment. Note, this can be a key as well as an int
            res = _calculate(ops[0])
        else:
            op = ops[-2]
            if op == 'AND':
                res = _calculate(ops[0]) & _calculate(ops[2])
            elif op == 'OR':
                res = _calculate(ops[0]) | _calculate(ops[2])
            elif op == 'NOT':
                res = ~_calculate(ops[1]) & 0xffff
            elif op == 'RSHIFT':
                res = _calculate(ops[0]) >> _calculate(ops[2])
            else:  # op must be 'LSHIFT':
                res = _calculate(ops[0]) << _calculate(ops[2])
        _results[name] = res

    return _results[name]
