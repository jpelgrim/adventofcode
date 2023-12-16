package day01

import util.println
import util.readLines

private const val DAY = "day01" // https://adventofcode.com/2023/day/1

fun main() {
    solveDay1()
}

fun solveDay1() {

    val inputPart1 = "$DAY/part1_example.txt".readLines()
    val solutionPart1 = solvePart1(inputPart1)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val inputPart2 = "$DAY/part2_example.txt".readLines()
    val solutionPart2 = solvePart2(inputPart2)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun solvePart1(input: List<String>): Int {
    var runningSum = 0
    for (line in input) {
        val firstDigit = line.firstOrNull { it.isDigit() }
        val lastDigit = line.lastOrNull { it.isDigit() }
        runningSum += "$firstDigit$lastDigit".toInt()
    }
    return runningSum
}

fun solvePart2(input: List<String>): Int {
    var runningSum = 0
    for (line in input) {
        val firstDigitIndex = line.indexOfFirst { it.isDigit() }
        val firstDigit = line.firstOrNull { it.isDigit() }
        val lastDigitIndex = line.indexOfLast { it.isDigit() }
        val lastDigit = line.lastOrNull { it.isDigit() }
        val (firstStringDigitIndex, firstStringDigit) = findFirstStringDigitIndex(line)
        val (lastStringDigitIndex, lastStringDigit) = findLastStringDigitIndex(line)
        val firstNumber = if (firstDigitIndex == -1 || firstStringDigitIndex < firstDigitIndex) {
            firstStringDigit
        } else {
            firstDigit
        }
        val lastNumber = if (lastDigitIndex == -1 || lastStringDigitIndex > lastDigitIndex) {
            lastStringDigit
        } else {
            lastDigit
        }
        runningSum += "$firstNumber$lastNumber".toInt()
    }
    return runningSum
}

val stringDigitsToNumber = mapOf(
    "zero" to 0,
    "one" to 1,
    "two" to 2,
    "three" to 3,
    "four" to 4,
    "five" to 5,
    "six" to 6,
    "seven" to 7,
    "eight" to 8,
    "nine" to 9,
)

fun findFirstStringDigitIndex(line: String): Pair<Int, Int> {
    var smallestIndex = Int.MAX_VALUE
    var stringDigitAtSmallestIndex = -1
    for (stringDigit in stringDigitsToNumber.keys) {
        val index = line.indexOf(stringDigit)
        if (index in 0..<smallestIndex) {
            smallestIndex = index
            stringDigitAtSmallestIndex = stringDigitsToNumber[stringDigit]!!
        }
    }
    return Pair(smallestIndex, stringDigitAtSmallestIndex)
}

fun findLastStringDigitIndex(line: String): Pair<Int, Int> {
    var largestIndex = -1
    var stringDigitAtLargestIndex = -1
    for (stringDigit in stringDigitsToNumber.keys) {
        val index = line.lastIndexOf(stringDigit)
        if (index > largestIndex) {
            largestIndex = index
            stringDigitAtLargestIndex = stringDigitsToNumber[stringDigit]!!
        }
    }
    return Pair(largestIndex, stringDigitAtLargestIndex)
}
