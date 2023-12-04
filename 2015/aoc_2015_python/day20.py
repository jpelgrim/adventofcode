import numpy as np

# Create int arrays with 800K entries for both part1 and part 2. That is enough to find the answer
part1_houses = np.zeros(800000)
part2_houses = np.zeros(800000)

for elf in range(1, 800000):
    part1_houses[elf::elf] += 10 * elf
    part2_houses[elf:(elf + 1) * 50:elf] += 11 * elf

print(f'    Part 1: {np.nonzero(part1_houses >= 33100000)[0][0]}')
print(f'    Part 2: {np.nonzero(part2_houses >= 33100000)[0][0]}')
