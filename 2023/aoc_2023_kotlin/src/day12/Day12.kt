package day12

import util.println
import util.readLines

private const val DAY = "day12"

fun main() {
    solveDay12()
}

fun solveDay12() {
    val input = "$DAY/input_example.txt".readLines()
    val solutionPart1 = input.sumOf { line ->
        val (arrangement, patternString) = line.split(" ")
        val pattern = patternString.split(",").map { it.toInt() }
        findPossibleArrangements(arrangement, pattern)
    }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = input.sumOf { line ->
        val (arrangement, patternString) = line.split(" ")
        val newPatternString = "$patternString,".repeat(5).dropLast(1)
        val pattern = newPatternString.split(",").map { it.toInt() }
        // Make a new string of "arrangement" as five copies of itself, separated by a "?" character
        val newArrangement = "$arrangement?".repeat(5).dropLast(1)
        findPossibleArrangements(newArrangement, pattern)
    }
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun findPossibleArrangements(arrangement: String, pattern: List<Int>): Long {
    buildMap {
        fun possibleArrangements(arrangement: String, pattern: List<Int>): Long =
            getOrPut(arrangement to pattern) {
                if (pattern.isEmpty()) return@getOrPut if (arrangement.none { it == '#' }) 1 else 0
                val firstGroupSize = pattern.first()
                val match = Regex("([#?]+)").find(arrangement) ?: return@getOrPut 0
                val firstMatch = match.groupValues[0]
                if (firstMatch.length == firstGroupSize && firstMatch.all { it == '#' }) {
                    val newArrangement = arrangement.replaceFirst(firstMatch, "").drop(1).dropWhile { it == '.' }
                    return@getOrPut possibleArrangements(newArrangement, pattern.drop(1))
                } else if (firstMatch.length < firstGroupSize && firstMatch.contains("#")) {
                    return@getOrPut 0
                } else if (firstMatch.length > firstGroupSize && firstMatch.indexOf("#".repeat(firstGroupSize + 1)) == 0) {
                    return@getOrPut 0
                }
                return@getOrPut possibleArrangements(
                    arrangement.replaceFirst("?", "."), pattern
                ) + possibleArrangements(
                    arrangement.replaceFirst("?", "#"), pattern
                )
            }
        return possibleArrangements(arrangement, pattern)
    }
}
