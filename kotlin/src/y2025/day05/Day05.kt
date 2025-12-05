package y2025.day05

import util.println
import util.readLines
import util.verify
import kotlin.math.max

private const val DAY = "day05" // https://adventofcode.com/2025/day/5

fun main() {
    solveDay5()
}

fun solveDay5() {
    val input = "y2025/$DAY/sample.txt".readLines()

    val ranges = mutableListOf<LongRange>()
    val numbersToCheck = mutableListOf<Long>()

    input.forEach { line ->
        if (line.contains('-')) {
            ranges.add(line.split('-').map { it.toLong() }.let { it[0]..it[1] })
        } else if (!line.isBlank()) {
            numbersToCheck.add(line.toLong())
        }
    }

    verify(3, "Day 5 Part 1") { part1(ranges, numbersToCheck) }
    verify(14, "Day 5 Part 2") { part2(ranges) }
}

private fun part1(ranges: MutableList<LongRange>, numbersToCheck: MutableList<Long>): Int {
    val solution = numbersToCheck.sumOf { numberToCheck ->
        if (ranges.any { numberToCheck in it }) 1 else 0
    }
    "The solution for $DAY part 1 is: $solution".println()
    return solution
}

private fun part2(ranges: MutableList<LongRange>): Long {
    val sortedRanges = ranges.sortedBy { it.first }

    val mergedRanges = mutableListOf<LongRange>()
    var currentMerge = sortedRanges.first()

    for (nextRange in sortedRanges.drop(1)) {
        // Check for overlap or adjacency (e.g., 10-14 and 15-20)
        if (nextRange.first <= currentMerge.last + 1) {
            // If they overlap/are adjacent, extend the current merge's end point.
            currentMerge = currentMerge.first..max(currentMerge.last, nextRange.last)
        } else {
            // If there's a gap there's nothing to merge. Add it to the list.
            mergedRanges.add(currentMerge)
            // Start a new merge with the next range.
            currentMerge = nextRange
        }
    }
    // We still need to add the last merge to the merged ranges
    mergedRanges.add(currentMerge)

    val solution = mergedRanges.sumOf { it.last - it.first + 1 }
    "The solution for $DAY part 2 is: $solution".println()
    return solution
}
