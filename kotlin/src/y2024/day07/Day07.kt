package y2024.day07

import util.longs
import util.println
import util.readLines

private const val DAY = "day07" // https://adventofcode.com/2024/day/7

fun main() {
    solveDay7()
}

fun solveDay7() {
    val input = "y2024/$DAY/sample.txt"
    val equations = input
        .readLines()
        .map { it.substringBefore(": ").toLong() to it.substringAfter(": ").longs() }

    val solutionPart1 = equations.filter { (testValue, numbers) ->
        numbers.hasSolutionPart1(agg = 0, target = testValue)
    }.sumOf { it.first }
    if (input.contains("sample")) check(solutionPart1 == 3749L)
    "The solution for $DAY part 1 is: $solutionPart1".println()

    val solutionPart2 = equations.filter { (testValue, numbers) ->
        numbers.hasSolutionPart2(agg = 0, target = testValue)
    }.sumOf { it.first }
    if (input.contains("sample")) check(solutionPart2 == 11387L)
    "The solution for $DAY part 2 is: $solutionPart2".println()
}

fun List<Long>.hasSolutionPart1(
    agg: Long,   // Aggregate of all the previous calculations
    target: Long // Target value to consider
): Boolean {
    // When the aggregate is greater than the maximum value, or we've reached the end and have not
    // found the target value then this branch is invalid.
    if (agg > target || isEmpty() && agg < target) return false

    // If there are no numbers remaining and the aggregate is the target value we've found a solution.
    if (isEmpty() && agg == target) return true

    // If the aggregate is 0 the only path we can travel is to find the solution using the first number.
    if (agg == 0L) return drop(1).hasSolutionPart1(first(), target)

    return drop(1).hasSolutionPart1(agg * first(), target) || // Find solution with multiplication
            drop(1).hasSolutionPart1(agg + first(), target)   // Find solution with addition
}

fun List<Long>.hasSolutionPart2(
    agg: Long,   // Aggregate of all the previous calculations
    target: Long // Target value to consider
): Boolean {
    // When the aggregate is greater than the maximum value, or we've reached the end and have not
    // found the target value then this branch is invalid.
    if (agg > target || isEmpty() && agg < target) return false

    // If there are no numbers remaining and the aggregate is the target value we've found a solution.
    if (isEmpty() && agg == target) return true

    // If the aggregate is 0 the only path we can travel is to find the solution using the first number.
    if (agg == 0L) return drop(1).hasSolutionPart2(first(), target)

    return drop(1).hasSolutionPart2(agg * first(), target) ||           // Find solution with multiplication
            drop(1).hasSolutionPart2(agg + first(), target) ||          // Find solution with addition
            drop(1).hasSolutionPart2("$agg${first()}".toLong(), target) // Find solution with concatenation
}
