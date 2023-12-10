package day10

import println
import readLines
import kotlin.time.measureTime

private const val DAY = "day10" // https://adventofcode.com/2023/day/10

fun main() {
    solveDay10()
}

fun solveDay10() {
    val input = "$DAY/input_example.txt".readLines()

    var solutionPart1 = 0
    val matrix = input.map { it.toCharArray().toList() }
    val startPos = matrix.mapIndexed { y, row ->
        row.mapIndexed { x, c ->
            if (c == 'S') Pair(
                x, y
            ) else null
        }
    }.flatten().filterNotNull().first()
    val loop = mutableSetOf(startPos)
    measureTime {
        // In my real input for S we can go up or down. Replace this with whatever is needed for your input!
        var path1 = startPos.first to startPos.second - 1
        var path2 = startPos.first to startPos.second + 1
        while (path1 != path2) {
            path1 = findNextPosition(matrix, path1, loop)
            path2 = findNextPosition(matrix, path2, loop)
            loop.add(path1)
            loop.add(path2)
            solutionPart1++
        }
    }.also { println("Processing time part 1: $it") }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val visited = mutableSetOf<Pair<Int, Int>>()
    measureTime {
        var newPositions = findPathOuterBorderPositions(matrix, loop)
        while (newPositions.isNotEmpty()) {
            visited.addAll(newPositions)
            newPositions = findNewPositions(matrix, loop, visited, newPositions)
        }
    }.also { println("Processing time part 2: $it") }
    val width = matrix[0].size
    val height = matrix.size

    val solutionPart2 = width * height - loop.size - visited.size
    "The solution for $DAY part2 is: $solutionPart2".println()
}

enum class Direction {
    UP, RIGHT, DOWN, LEFT;
}

fun findPathOuterBorderPositions(
    matrix: List<List<Char>>, loop: MutableSet<Pair<Int, Int>>
): Set<Pair<Int, Int>> {
    val newPositions = mutableSetOf<Pair<Int, Int>>()
    val startPos = loop.filter { matrix[it.second][it.first] == 'F' }
        .fold(matrix[0].size to matrix.size) { min, pair ->
            if (pair.first < min.first && pair.second <= min.second) {
                pair
            } else if (pair.second < min.second && pair.first <= min.first) {
                pair
            } else min
        }
    // Top most F
    var currentPos = startPos.first to startPos.second
    // We traverse the loop to the right, clockwise
    var currentDirection = Direction.UP
    while (true) {
        val x = currentPos.first
        val y = currentPos.second
        val charAtPos = matrix[y][x]
        if (charAtPos == 'F') {
            if (currentDirection == Direction.UP) {
                // Add all positions to the left, top-left and top
                if (x > 0 && !loop.contains(x - 1 to y)) newPositions.add(x - 1 to y)
                if (x > 0 && y > 0 && !loop.contains(x - 1 to y - 1)) newPositions.add(x - 1 to y - 1)
                if (y > 0 && !loop.contains(x to y - 1)) newPositions.add(x to y - 1)
                currentPos = x + 1 to y
                currentDirection = Direction.RIGHT
            } else {
                // Only add positions to the bottom right
                if (x < matrix[0].size - 1 && y < matrix.size - 1 && !loop.contains(x + 1 to y + 1)) {
                    newPositions.add(x + 1 to y + 1)
                }
                currentPos = x to y + 1
                currentDirection = Direction.DOWN
            }
        } else if (charAtPos == '7') {
            if (currentDirection == Direction.UP) {
                // Only add positions to the bottom left
                if (x > 0 && y < matrix.size - 1 && !loop.contains(x - 1 to y + 1)) {
                    newPositions.add(x - 1 to y + 1)
                }
                currentPos = x - 1 to y
                currentDirection = Direction.LEFT
            } else {
                // Add all positions to the top, top-right and right
                if (x < matrix[0].size - 1 && !loop.contains(x + 1 to y)) newPositions.add(x + 1 to y)
                if (x < matrix[0].size - 1 && y > 0 && !loop.contains(x + 1 to y - 1)) newPositions.add(
                    x + 1 to y - 1
                )
                if (y > 0 && !loop.contains(x to y - 1)) newPositions.add(x to y - 1)
                currentPos = x to y + 1
                currentDirection = Direction.DOWN
            }
        } else if (charAtPos == 'L') {
            if (currentDirection == Direction.DOWN) {
                // Only add positions to the top right
                if (x < matrix[0].size - 1 && y > 0 && !loop.contains(x + 1 to y - 1)) {
                    newPositions.add(x + 1 to y - 1)
                }
                currentPos = x + 1 to y
                currentDirection = Direction.RIGHT
            } else {
                // Add all positions to the left, bottom-left and bottom
                if (x > 0 && !loop.contains(x - 1 to y)) newPositions.add(x - 1 to y)
                if (x > 0 && y < matrix.size - 1 && !loop.contains(x - 1 to y + 1)) newPositions.add(
                    x - 1 to y + 1
                )
                if (y < matrix.size - 1 && !loop.contains(x to y + 1)) newPositions.add(x to y + 1)
                currentPos = x to y - 1
                currentDirection = Direction.UP
            }
        } else if (charAtPos == 'J') {
            if (currentDirection == Direction.DOWN) {
                // Add all positions to the right, bottom-right and bottom
                if (x < matrix[0].size - 1 && !loop.contains(x + 1 to y)) newPositions.add(x + 1 to y)
                if (x < matrix[0].size - 1 && y < matrix.size - 1 && !loop.contains(x + 1 to y + 1)) newPositions.add(
                    x + 1 to y + 1
                )
                if (y < matrix.size - 1 && !loop.contains(x to y + 1)) newPositions.add(x to y + 1)
                currentPos = x - 1 to y
                currentDirection = Direction.LEFT
            } else {
                // Only add the position to the top left
                if (x > 0 && y > 0 && !loop.contains(x - 1 to y - 1)) {
                    newPositions.add(x - 1 to y - 1)
                }
                currentPos = x to y - 1
                currentDirection = Direction.UP
            }
        } else if (charAtPos == '-') {
            currentPos = if (currentDirection == Direction.RIGHT) {
                // Add all positions to the top
                if (y > 0 && !loop.contains(x to y - 1)) newPositions.add(x to y - 1)
                x + 1 to y
            } else {
                // Add all positions to the bottom
                if (y < matrix.size - 1 && !loop.contains(x to y + 1)) newPositions.add(x to y + 1)
                x - 1 to y
            }
        } else if (charAtPos == '|' || charAtPos == 'S') {
            currentPos = if (currentDirection == Direction.DOWN) {
                // Add all positions to the right
                if (x < matrix[0].size - 1 && !loop.contains(x + 1 to y)) newPositions.add(x + 1 to y)
                x to y + 1
            } else {
                // We're moving up
                // Add all positions to the left
                if (x > 0 && !loop.contains(x - 1 to y)) newPositions.add(x - 1 to y)
                x to y - 1
            }
        }
        if (currentPos == startPos) break
    }
    return newPositions
}

private fun findNewPositions(
    matrix: List<List<Char>>,
    loop: Set<Pair<Int, Int>>,
    visited: Set<Pair<Int, Int>>,
    lastVisited: Set<Pair<Int, Int>>,
): Set<Pair<Int, Int>> {
    val toVisit = mutableSetOf<Pair<Int, Int>>()
    for (position in lastVisited) {
        val potentialNewPositions = potentialNewPositions(matrix, position, loop)
        for (newPosition in potentialNewPositions) {
            if (visited.contains(newPosition)) continue
            if (loop.contains(newPosition)) continue
            if (lastVisited.contains(newPosition)) continue
            toVisit.add(newPosition)
        }
    }
    return toVisit
}

private fun potentialNewPositions(
    matrix: List<List<Char>>, position: Pair<Int, Int>, loop: Set<Pair<Int, Int>>
): Set<Pair<Int, Int>> {
    val newPositions = mutableSetOf<Pair<Int, Int>>()
    val width = matrix[0].size
    val height = matrix.size
    val x = position.first
    val y = position.second
    // Look left
    if (x > 0) {
        val left = x - 1 to y
        if (!loop.contains(left)) newPositions.add(left)
    }
    // Look right
    if (x < width - 1) {
        val right = x + 1 to y
        if (!loop.contains(right)) newPositions.add(right)
    }
    // Look up
    if (y > 0) {
        val up = x to y - 1
        if (!loop.contains(up)) newPositions.add(up)
    }
    // Look down
    if (y < height - 1) {
        val down = x to y + 1
        if (!loop.contains(down)) newPositions.add(down)
    }
    if (x > 0 && y > 0) {
        val upLeft = x - 1 to y - 1
        if (!loop.contains(upLeft)) newPositions.add(upLeft)
    }
    if (x > 0 && y < height - 1) {
        val downLeft = x - 1 to y + 1
        if (!loop.contains(downLeft)) newPositions.add(downLeft)
    }
    if (x < width - 1 && y > 0) {
        val upRight = x + 1 to y - 1
        if (!loop.contains(upRight)) newPositions.add(upRight)
    }
    if (x < width - 1 && y < height - 1) {
        val downRight = x + 1 to y + 1
        if (!loop.contains(downRight)) newPositions.add(downRight)
    }
    return newPositions
}

private fun findNextPosition(
    matrix: List<List<Char>>, path1: Pair<Int, Int>, visited: MutableSet<Pair<Int, Int>>
): Pair<Int, Int> {
    when (matrix[path1.second][path1.first]) {
        '|' -> {
            val option1 = path1.first to path1.second - 1
            val option2 = path1.first to path1.second + 1
            return if (visited.contains(option1)) option2 else option1
        }

        '-' -> {
            val option1 = path1.first + 1 to path1.second
            val option2 = path1.first - 1 to path1.second
            return if (visited.contains(option1)) option2 else option1
        }

        'F' -> {
            val option1 = path1.first + 1 to path1.second
            val option2 = path1.first to path1.second + 1
            return if (visited.contains(option1)) option2 else option1
        }

        'J' -> {
            val option1 = path1.first to path1.second - 1
            val option2 = path1.first - 1 to path1.second
            return if (visited.contains(option1)) option2 else option1
        }

        'L' -> {
            val option1 = path1.first to path1.second - 1
            val option2 = path1.first + 1 to path1.second
            return if (visited.contains(option1)) option2 else option1
        }

        '7' -> {
            val option1 = path1.first to path1.second + 1
            val option2 = path1.first - 1 to path1.second
            return if (visited.contains(option1)) option2 else option1
        }
    }
    throw IllegalArgumentException("Unknown path: $path1")
}
