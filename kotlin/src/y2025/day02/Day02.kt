package y2025.day02

import util.println
import util.readLines
import util.verify

private const val DAY = "day02" // https://adventofcode.com/2025/day/2

fun main() {
    solveDay2()
}

fun solveDay2() {
    val input = "y2025/$DAY/sample.txt".readLines().flatMap { it.split(",") }.map { it.split("-") }
    verify(1227775554, "Day 2 Part 1") { part1(input) }
    verify(4174379265, "Day 2 Part 2") { part2(input) }
}

private fun part1(input: List<List<String>>) : Long {
    val solution = input.sumOf {
        var sum = 0L
        val (min, max) = it[0] to it[1]
        val minInt = min.toLong()
        val maxInt = max.toLong()

        var currentMin = min

        if (min.length % 2 == 1) currentMin = "1${"0".repeat(min.length)}"

        var min1 = currentMin.take(currentMin.length / 2).toLong()

        var currentNumber = "$min1$min1".toLong()
        while (currentNumber <= maxInt) {
            if (currentNumber >= minInt) sum += currentNumber
            min1++
            currentNumber = "$min1$min1".toLong()
        }

        if (min.length > max.length) return@sumOf sum

        return@sumOf sum
    }
    "The solution for $DAY part 1 is: $solution".println()
    return solution
}

private fun part2(input: List<List<String>>) : Long {
    val invalidIds = mutableSetOf<Long>()
    input.forEach {
        val (min, max) = it[0] to it[1]
        val minLong = min.toLong()
        val maxLong = max.toLong()

        for (currentDivider in 2..max.length) {

            var currentMin = min

            if (min.length % currentDivider != 0) currentMin = "1${"0".repeat(min.length)}"

            var min1 = currentMin.take(currentMin.length / currentDivider).toLong()

            var currentNumber = "$min1".repeat(currentDivider).toLong()
            while (currentNumber <= maxLong) {
                if (currentNumber >= minLong) invalidIds.add(currentNumber)
                min1++
                currentNumber = "$min1".repeat(currentDivider).toLong()
            }
        }
    }
    val solution = invalidIds.sum()
    "The solution for $DAY part 2 is: $solution".println()
    return solution
}
