package day23

import util.Direction.DOWN
import util.Direction.LEFT
import util.Direction.RIGHT
import util.Point
import util.println
import util.readLines
import util.withinBounds

private const val DAY = "day23" // https://adventofcode.com/2023/day/23

fun main() {
    solveDay23()
}

fun solveDay23() {
    val input = "$DAY/input_example.txt".readLines()
    val solutionPart1 = solvePart1(input)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = solvePart2(input)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun solvePart1(input: List<String>): Int {
    val matrix = input.map { it.toCharArray().toList() }
    val width = matrix.first().size
    val height = matrix.size
    val start = Point(matrix.first().indexOf('.'), 0)
    val end = Point(matrix.last().indexOf('.'), matrix.size - 1)

    fun allPaths(from: Point, visited: List<Point>): List<List<Point>> {
        val visitedFromHere = mutableListOf<Point>()
        visitedFromHere.addAll(visited)
        visitedFromHere.add(from)
        val results = mutableListOf<List<Point>>()

        fun Point.neighbours(): List<List<Point>> {
            val neighbours = mutableListOf<List<Point>>()
            adjacent(false).forEach { point ->
                if (point.withinBounds(width, height)) {
                    val c = matrix[point.y.toInt()][point.x.toInt()]
                    if (c == '.' && point !in visitedFromHere) {
                        neighbours.add(listOf(point))
                    } else if (c == '>' && point.move(RIGHT) !in visitedFromHere) {
                        neighbours.add(listOf(point, point.move(RIGHT)))
                    } else if (c == 'v' && point.move(DOWN) !in visitedFromHere) {
                        neighbours.add(listOf(point, point.move(DOWN)))
                    } else if (c == '<' && point.move(LEFT) !in visitedFromHere) {
                        neighbours.add(listOf(point, point.move(LEFT)))
                    }
                }
            }
            return neighbours
        }

        if (from == end) {
            results.add(visitedFromHere)
        } else {
            val neighbours = from.neighbours()
            if (neighbours.isEmpty()) throw Throwable("No neighbours")
            try {
                neighbours.forEach { neighbour ->
                    if (neighbour.size == 2) {
                        results.addAll(
                            allPaths(
                                neighbour.last(), visitedFromHere + neighbour.first()
                            )
                        )
                    } else {
                        results.addAll(allPaths(neighbour.last(), visitedFromHere))
                    }
                }
            } catch (ignore: Throwable) {
            }
        }
        if (results.isEmpty()) throw Throwable("No results")
        return results
    }

    val results = allPaths(start, emptyList())
    return results.maxOf { it.size - 1 }
}

fun solvePart2(input: List<String>): Int {
    val trail = buildList {
        input.forEachIndexed { y, line ->
            line.forEachIndexed { x, c ->
                if (c != '#') add(Point(x, y))
            }
        }
    }
    val start = trail.first()
    val end = trail.last()
    val junctions: List<Point> = trail.filter { p ->
        p.adjacent(false).count { trail.contains(it) } > 2
    }

    // A maximum path length is easy to find in straight lines
    // However, the interesting parts are the start, end, and all the points on the map where we
    // can go more than one way (junctions). So we build a map of all these points and
    // remember all distances.
    val pointsToRemember = (junctions + start + end)
    val maxPathChunks = buildMap {
        pointsToRemember.forEach { from ->
            this[from] = buildMap {
                val queue = mutableListOf<Pair<Point, Int>>()
                val visited = mutableSetOf(from)
                queue.add(from to 0)
                while (queue.isNotEmpty()) {
                    val (current, distance) = queue.removeFirst()
                    current.adjacent(false)
                        .filter { trail.contains(it) && !visited.contains(it) }.forEach {
                            visited.add(it)
                            if (pointsToRemember.contains(it)) {
                                // This is a distance worth remembering
                                this[it] = distance + 1
                            } else {
                                queue.add(it to distance + 1)
                            }
                        }
                }
            }
        }
    }

    // Now we can find the longest path by combining the start, end and various junction
    // points in the map to try and build up a path from start to end using all these parts.
    fun combineMaxPathChunks(from: Point, visited: List<Point>): Int {
        if (from == end) return 0
        var maxDistance = 0
        maxPathChunks[from]?.forEach { (next, distance) ->
            if (!visited.contains(next)) {
                if (next == end) return distance
                val chunkDistance = combineMaxPathChunks(next, visited + next)
                if (distance + chunkDistance > maxDistance) maxDistance = distance + chunkDistance
            }
        }
        return maxDistance
    }

    return combineMaxPathChunks(start, listOf(start))
}
