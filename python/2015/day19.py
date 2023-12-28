# https://adventofcode.com/2015/day/19
replacements = dict()
origins = dict()
very_large_number = 9999999999999999


def part1():
    print('--- Day 19: Medicine for Rudolph ---')
    with open('input/day19.txt') as f:
        lines = list(map(lambda x: x.strip(), f.readlines()))

    for line in lines:
        if not line:
            break
        atom, replacement = line.split(' => ')
        if atom in replacements.keys():
            replacements[atom].append(replacement.strip())
        else:
            replacements[atom] = [replacement.strip()]

    molecule = lines[-1]

    distinct_molecules = _do_replacement(molecule)

    answer = len(distinct_molecules)

    print(f'    Part 1: {answer}')


def part2():
    with open('input/day19.txt') as f:
        lines = list(map(lambda x: x.strip(), f.readlines()))

    for line in lines:
        if not line:
            break
        atom, replacement = line.split(' => ')
        origins[replacement] = atom

    molecule = lines[-1]

    running_max = 0

    def _find_shortest_path(local_molecule: str, count: int):
        nonlocal running_max
        if local_molecule == 'e' or running_max > 0:
            return

        for local_atom in origins.keys():
            if local_atom in local_molecule:
                if local_atom == local_molecule and origins[local_atom] == 'e':
                    running_max = count + 1

                new_molecule = local_molecule[:].replace(local_atom, origins[local_atom], 1)

                if 'e' in new_molecule and new_molecule != 'e':
                    continue

                _find_shortest_path(new_molecule, count + 1)

    _find_shortest_path(molecule, 0)

    print(f'    Part 2: {running_max}')


def _do_replacement(molecule):
    i = 0
    new_molecules = set()
    while i < len(molecule):
        if molecule[i] in replacements.keys():
            for r in replacements[molecule[i]]:
                new_molecules.add(molecule[:i] + r + molecule[i + 1:])
        elif i < len(molecule) - 1 and f'{molecule[i]}{molecule[i + 1]}' in replacements.keys():
            for r in replacements[f'{molecule[i]}{molecule[i + 1]}']:
                new_molecules.add(molecule[:i] + r + molecule[i + 2:])
        i += 1

    return new_molecules
