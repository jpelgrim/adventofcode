package day09

import util.println
import util.readLines

private const val DAY = "day09" // https://adventofcode.com/2023/day/9

fun main() {
    solveDay9()
}

fun solveDay9() {
    val input = "$DAY/input_example.txt".readLines()
    "The solution for $DAY part1 is: ${solvePart1(input)}".println()
    "The solution for $DAY part2 is: ${solvePart2(input)}".println()
}

fun solvePart1(input: List<String>) = input.sumOf {
    it.split(" ").map { number -> number.toInt() }.predictNext()
}

fun solvePart2(input: List<String>) = input.sumOf {
    it.split(" ").map { number -> number.toInt() }.predictFirst()
}

private fun List<Int>.predictNext(): Int {
    val diffs = this.differences()
    return this.last() + if (diffs.all { it == diffs[0] }) diffs[0] else diffs.predictNext()
}

private fun List<Int>.predictFirst(): Int {
    val diffs = this.differences()
    return this.first() - if (diffs.all { it == diffs[0] }) diffs[0] else diffs.predictFirst()
}

private fun List<Int>.differences() = (1..this.lastIndex).map { i -> this[i] - this[i - 1] }
