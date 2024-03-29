package y2023.day17

import util.Direction
import util.Direction.RIGHT
import util.Point
import util.println
import util.readLines
import util.withinBounds
import java.util.PriorityQueue

private const val DAY = "day17" // https://adventofcode.com/2023/day/17

fun main() {
    solveDay17()
}

fun solveDay17() {
    val input = "y2023/$DAY/input_example.txt".readLines()
    val solutionPart1 = solve(input)
    check(solutionPart1 == 102)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = solve(input, 4, 10)
    check(solutionPart2 == 94)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

internal data class State(val point: Point, val direction: Direction, val length: Int)

fun solve(input: List<String>, minSteps: Int = 1, maxSteps: Int = 3): Int {
    val matrix = input.map { line -> line.map { c -> c.code - 48 } }

    val visited = mutableSetOf<State>()
    val start = State(Point.ZERO, RIGHT, 0)
    val end = Point(matrix[0].size - 1, matrix.size - 1)
    val toVisit =
        PriorityQueue(compareBy<Pair<Int, State>> { it.second.point.manhattanDistanceTo(start.point) }.thenBy { it.first })

    toVisit.add(0 to start)

    while (toVisit.isNotEmpty()) {
        val (energy, current) = toVisit.poll() ?: break
        if (current.point == end) return energy
        if (!visited.add(current)) continue

        if (current.length < maxSteps) {
            stepsInDirection(current, current.direction, energy, matrix, current.length)?.let {
                toVisit.add(it)
            }
        }

        var direction = current.direction.clockwise()
        stepsInDirection(current, direction, energy, matrix, 0, minSteps)?.let {
            toVisit.add(it)
        }
        direction = current.direction.counterClockwise()
        stepsInDirection(current, direction, energy, matrix, 0, minSteps)?.let {
            toVisit.add(it)
        }
    }

    throw IllegalStateException("No solution found")
}

internal fun stepsInDirection(
    from: State,
    direction: Direction,
    energy: Int,
    matrix: List<List<Int>>,
    length: Int = 0,
    steps: Int = 1,
): Pair<Int, State>? {
    var pos = from.point
    var nrgy = energy
    repeat(steps) {
        if (pos != Point(matrix[0].size - 1, matrix.size - 1)) {
            pos = pos.move(direction)
            if (!pos.withinBounds(matrix[0].size, matrix.size)) return null
            nrgy += matrix[pos.y.toInt()][pos.x.toInt()]
        }
    }
    return nrgy to State(pos, direction, length + steps)
}
