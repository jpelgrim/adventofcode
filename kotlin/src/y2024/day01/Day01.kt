package y2024.day01

import util.flipped
import util.ints
import util.println
import util.readLines
import kotlin.math.abs

private const val DAY = "day01" // https://adventofcode.com/2024/day/1

fun main() {
    solveDay1()
}

fun solveDay1() {
    val input = "y2024/$DAY/sample.txt".readLines()
    val (left, right) = input.ints().flipped().map { it.sorted() }
    val solutionPart1 = left.zip(right).map { (l, r) -> abs(l - r) }.sum()
    "The solution for $DAY part1 is: $solutionPart1".println()
    val solutionPart2 = left.sumOf { l -> right.count { it == l } * l }
    "The solution for $DAY part2 is: $solutionPart2".println()
}
