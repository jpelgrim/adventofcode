package day06

import println
import readLines

private const val DAY = "day06"

fun main() {
    solveDay6()
}

fun solveDay6() {
    val input = "$DAY/input_example.txt".readLines()
    val raceTimes = input[0].substringAfter(":").trim().split(" +".toRegex()).map { it.toInt() }
    val distancesToBeat =
        input[1].substringAfter(":").trim().split(" +".toRegex()).map { it.toInt() }
    val solutionPart1 = raceTimes.foldIndexed(1) { index, acc, raceTime ->
        acc * (1..raceTime).map { holdTime ->
            (raceTime - holdTime) * holdTime
        }.count {
            it > distancesToBeat[index]
        }
    }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val raceTime = input[0].substringAfter(":").replace(" +".toRegex(), "").toLong()
    val distanceToBeat = input[1].substringAfter(":").replace(" +".toRegex(), "").toLong()
    val solutionPart2 = (1..raceTime).map { holdTime ->
        (raceTime - holdTime) * holdTime
    }.count {
        it > distanceToBeat
    }
    "The solution for $DAY part2 is: $solutionPart2".println()
}
