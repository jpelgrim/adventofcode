package y2025

import util.println
import y2025.day01.solveDay1
import y2025.day02.solveDay2
import y2025.day03.solveDay3
import y2025.day04.solveDay4
import y2025.day05.solveDay5
import y2025.day06.solveDay6
import kotlin.time.measureTime

private val solvers = listOf(
    { solveDay1() },
    { solveDay2() },
    { solveDay3() },
    { solveDay4() },
    { solveDay5() },
    { solveDay6() },
)

fun main() = solvers.forEachIndexed { index, solver ->
    "Day ${index + 1} took ${measureTime { solver() }}\n".println()
}
