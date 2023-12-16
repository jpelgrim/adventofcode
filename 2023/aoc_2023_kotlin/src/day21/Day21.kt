package day21

import util.println
import util.readLines

private const val DAY = "day21" // https://adventofcode.com/2023/day/21

fun main() {
    solveDay21()
}

fun solveDay21() {
    val input = "$DAY/input_example.txt".readLines()
    val solutionPart1 = solvePart1(input)
    check(solutionPart1 == 0)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = solvePart2(input)
    check(solutionPart2 == 0)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun solvePart1(input: List<String>): Int {
    return 0
}

fun solvePart2(input: List<String>): Int {
    return 0
}
