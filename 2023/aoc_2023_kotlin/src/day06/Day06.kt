package day06

import util.println
import util.readLines

private const val DAY = "day06" // https://adventofcode.com/2023/day/6

fun main() {
    solveDay6()
}

fun solveDay6() {
    val input = "$DAY/input_example.txt".readLines()
    val raceTimes = input[0].substringAfter(":").trim().split(" +".toRegex()).map { it.toLong() }
    val distancesToBeat = input[1].substringAfter(":").trim().split(" +".toRegex()).map { it.toLong() }
    val solutionPart1 = raceTimes.foldIndexed(1) { index, acc, raceTime ->
        acc * calculateNrOfWinners(raceTime, distancesToBeat[index])
    }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val raceTime = input[0].substringAfter(":").replace(" +".toRegex(), "").toLong()
    val distanceToBeat = input[1].substringAfter(":").replace(" +".toRegex(), "").toLong()
    "The solution for $DAY part2 is: ${calculateNrOfWinners(raceTime, distanceToBeat)}".println()
}

private fun calculateNrOfWinners(raceTime: Long, distanceToBeat: Long) =
    (1..raceTime).count { holdTime -> (raceTime - holdTime) * holdTime > distanceToBeat }
