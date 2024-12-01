package y2024

import y2024.day01.solveDay1
import util.println
import kotlin.time.measureTime

private val solvers = listOf(
    { solveDay1() },
)

fun main() = solvers.forEachIndexed { index, solver ->
    "Day ${index + 1} took ${measureTime { solver() }}\n".println()
}
