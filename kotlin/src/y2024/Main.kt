package y2024

import util.println
import y2024.day01.solveDay1
import y2024.day02.solveDay2
import y2024.day03.solveDay3
import y2024.day04.solveDay4
import y2024.day05.solveDay5
import y2024.day06.solveDay6
import y2024.day07.solveDay7
import kotlin.time.measureTime

private val solvers = listOf(
    { solveDay1() },
    { solveDay2() },
    { solveDay3() },
    { solveDay4() },
    { solveDay5() },
    { solveDay6() },
    { solveDay7() },
)

fun main() = solvers.forEachIndexed { index, solver ->
    "Day ${index + 1} took ${measureTime { solver() }}\n".println()
}
