package y2025

import util.println
import y2025.day01.solveDay1
import y2025.day02.solveDay2
import y2025.day03.solveDay3
import kotlin.time.measureTime

private val solvers = listOf(
    { solveDay1() },
    { solveDay2() },
    { solveDay3() },
)

fun main() = solvers.forEachIndexed { index, solver ->
    "Day ${index + 1} took ${measureTime { solver() }}\n".println()
}
