package y2025.day03

import util.println
import util.readLines
import util.singleInts
import util.verify

private const val DAY = "day03" // https://adventofcode.com/2025/day/3

fun main() {
    solveDay3()
}

fun solveDay3() {
    val input = "y2025/$DAY/sample.txt".readLines()
    verify(357, "Day 3 Part 1") { part1(input) }
    verify(3121910778619, "Day 3 Part 2") { part2(input) }
}

private fun part1(input: List<String>): Int {
    val solution = input.sumOf { line ->
        val list = line.singleInts()
        val max = list.max()
        val maxPos = line.indexOf(max.toString())
        if (maxPos == line.length - 1) { // max is the last digit
            val list2 = line.dropLast(1).singleInts()
            val max2 = list2.max()
            return@sumOf "$max2$max".toInt()
        } else {
            val list2 = line.drop(maxPos + 1).singleInts()
            val max2 = list2.max()
            return@sumOf "$max$max2".toInt()
        }
    }
    "The solution for $DAY part 1 is: $solution".println()
    return solution
}

private fun part2(input: List<String>): Long {
    val solution = input.sumOf { line ->
        val ints = line.singleInts()
        var maxNumber = 0L

        for (i in ints.indices) {
            // We can't form a 12-digit number if there aren't 11 more digits left 🏃🏻‍♂️
            if (ints.size - 1 - i < 11) continue

            val result = findMaxSequence(ints[i].toString(), i + 1, ints, 12)
            if (result != null && result > maxNumber) maxNumber = result
        }
        return@sumOf maxNumber
    }
    "The solution for $DAY part 2 is: $solution".println()
    return solution
}

private fun findMaxSequence(
    currentSequence: String,
    startIndex: Int,
    originalInts: List<Int>,
    targetLength: Int
): Long? {
    // Success! We've reached the target length! 🙌🏻
    if (currentSequence.length == targetLength) return currentSequence.toLong()

    val remainingChoices = originalInts.size - startIndex
    val needed = targetLength - currentSequence.length
    if (remainingChoices < needed) return null // This path is a dead end ☠️

    val options = originalInts.subList(startIndex, originalInts.size)
    val uniqueSortedOptions = options.toSet().sortedDescending()
    for (digitToTry in uniqueSortedOptions) { // We start with the highest available number here
        val nextIndex = options.indexOf(digitToTry) + startIndex
        val result = findMaxSequence(
            currentSequence = currentSequence + digitToTry,
            startIndex = nextIndex + 1,
            originalInts = originalInts,
            targetLength = targetLength
        )
        if (result != null) return result
    }

    return null // This path is a dead end ☠️
}
