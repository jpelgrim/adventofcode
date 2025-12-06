package y2025.day06

import util.flipped
import util.println
import util.readLines
import util.transposed
import util.verify

private const val DAY = "day06" // https://adventofcode.com/2025/day/6

fun main() {
    solveDay6()
}

fun solveDay6() {
    val input = "y2025/$DAY/sample.txt".readLines()
    verify(4277556, "Day 6 Part 1") { part1(input) }
    verify(3263827, "Day 6 Part 2") { part2(input) }
}

private fun part1(input: List<String>): Long {
    val matrix = input.map { it.trim().split(Regex(" +")) }
    val solution = matrix.flipped().sumOf {
        val operator = it.last()
        val numbers = it.dropLast(1).map { it.toLong() }
        when (operator) {
            "+" -> numbers.sum()
            else -> numbers.reduce { acc, i -> acc * i }
        }
    }
    "The solution for $DAY part 1 is: $solution".println()
    return solution
}

private fun part2(input: List<String>): Long {
    val transposed = input.transposed()
    var operator = '+'
    var solution = 0L
    var runningSolution = 0L
    transposed.forEach {
        if (!it.isBlank()) {
            var number: Long
            if (it.trim().last() == '+' || it.trim().last() == '*') {
                solution += runningSolution
                operator = it.trim().last()
                when (operator) {
                    '+' -> runningSolution = 0
                    else -> runningSolution = 1
                }
                number = it.trim().dropLast(1).trim().toLong()
            } else {
                number = it.trim().toLong()
            }
            when (operator) {
                '+' -> runningSolution += number
                else -> runningSolution *= number
            }
        }
    }
    solution += runningSolution
    "The solution for $DAY part 2 is: $solution".println()
    return solution
}
