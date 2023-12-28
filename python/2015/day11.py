# https://adventofcode.com/2015/day/11


# noinspection SpellCheckingInspection
def part1():
    print('--- Day 11: Corporate Policy ---')
    puzzle_input = 'vzbxkghb'

    while True:
        puzzle_input = _increment_string(puzzle_input, len(puzzle_input) - 1)
        if _is_valid_password(puzzle_input):
            break

    print(f'    Part 1: {puzzle_input}')


# noinspection SpellCheckingInspection
def part2():
    puzzle_input = 'vzbxxyzz'

    while True:
        puzzle_input = _increment_string(puzzle_input, len(puzzle_input) - 1)
        if _is_valid_password(puzzle_input):
            break

    print(f'    Part 2: {puzzle_input}')


def _increment_string(string, index):
    next_char = _next_char_map[string[index]]
    if index == len(string) - 1:
        new_string = string[0:index] + next_char
    else:
        new_string = string[0:index] + next_char + string[index + 1:]

    if next_char == 'a':
        return _increment_string(new_string, index - 1)
    else:
        return new_string


def _has_triple_char(password):
    found_triple_char = False

    for i in range(len(password) - 2):
        char_i = password[i]
        ord_i = ord(char_i)
        if not found_triple_char \
                and ord_i <= 120 \
                and password[i + 1] == chr(ord_i + 1) \
                and password[i + 2] == chr(ord_i + 2):
            found_triple_char = True

        if found_triple_char:
            return True

    return False


def _has_2_double_chars(password):
    double_char_count = 0

    i = 0
    while i < len(password) - 1:
        char_i = password[i]
        if password[i + 1] == char_i:
            double_char_count += 1
            i += 1  # <- This is why we can't combine the double and the triple char check functions easily

        if double_char_count == 2:
            return True

        i += 1

    return False


def _is_valid_password(password):
    return _has_triple_char(password) and _has_2_double_chars(password)


_next_char_map = {
    'a': 'b',
    'b': 'c',
    'c': 'd',
    'd': 'e',
    'e': 'f',
    'f': 'g',
    'g': 'h',
    'h': 'j',
    'j': 'k',
    'k': 'm',
    'm': 'n',
    'n': 'p',
    'p': 'q',
    'q': 'r',
    'r': 's',
    's': 't',
    't': 'u',
    'u': 'v',
    'v': 'w',
    'w': 'x',
    'x': 'y',
    'y': 'z',
    'z': 'a',
}
