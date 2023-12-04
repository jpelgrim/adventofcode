package day08

import println
import readLines

private const val DAY = "day08"

fun main() {
    solveDay8()
}

fun solveDay8() {
    val inputPart1 =
        "$DAY/part1_example.txt"
//        "$DAY/part1.txt"
            .readLines()
    val solutionPart1 = solvePart1(inputPart1)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val inputPart2 =
        "$DAY/part2_example.txt"
//        "$DAY/part2.txt"
            .readLines()
    val solutionPart2 = solvePart2(inputPart2)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun solvePart1(input: List<String>): Int {
    TODO()
}

fun solvePart2(input: List<String>): Int {
    TODO()
}
