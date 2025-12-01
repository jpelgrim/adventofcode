package y2025

import util.println
import y2025.day01.solveDay1
import kotlin.time.measureTime

private val solvers = listOf(
    { solveDay1() },
)

fun main() = solvers.forEachIndexed { index, solver ->
    "Day ${index + 1} took ${measureTime { solver() }}\n".println()
}
