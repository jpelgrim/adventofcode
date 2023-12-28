# https://adventofcode.com/2015/day/5


def part1():
    print('--- Day 5: Doesn`t He Have Intern-Elves For This? ---')
    with open('input/day5.txt') as f:
        lines = f.readlines()

    nice = list(filter(is_nice_part1, lines))

    print(f'    Part 1: {len(nice)}')


def part2():
    with open('input/day5.txt') as f:
        lines = f.readlines()

    nice = list(filter(is_nice_part2, lines))

    print(f'    Part 2: {len(nice)}')


def is_nice_part1(name):
    # Rules:
    # 1. Contains at least 3 vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
    vowels = 0
    vowels += name.count('a')
    vowels += name.count('e')
    vowels += name.count('i')
    vowels += name.count('o')
    vowels += name.count('u')
    if vowels < 3:
        return False

    # 2. Contains at least 1 letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
    letter_appearing_twice = False
    for i in range(len(name) - 2):
        if name[i] == name[i + 1]:
            letter_appearing_twice = True
            break

    if not letter_appearing_twice:
        return False

    # 3. It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
    if 'ab' in name or 'cd' in name or 'pq' in name or 'xy' in name:
        return False

    return True


def is_nice_part2(name):
    # New rules:
    # 1. It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy
    #    (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
    letter_pair_appearing_twice = False
    for i in range(len(name) - 4):
        letter_pair = name[i] + name[i + 1]

        if letter_pair in name[i + 2:]:
            letter_pair_appearing_twice = True
            break

    if not letter_pair_appearing_twice:
        return False

    # 2. It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe),
    #    or even aaa.
    for i in range(len(name) - 2):
        if name[i] == name[i + 2]:
            return True

    return False
