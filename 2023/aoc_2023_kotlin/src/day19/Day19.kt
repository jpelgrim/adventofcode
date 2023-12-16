package day19

import util.println
import util.readLines

private const val DAY = "day19" // https://adventofcode.com/2023/day/19

fun main() {
    solveDay19()
}

fun solveDay19() {
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
