package day22

import util.println
import util.readLines
import kotlin.math.min

private const val DAY = "day22" // https://adventofcode.com/2023/day/22

fun main() {
    solveDay22()
}

fun solveDay22() {
    val input = "$DAY/input.txt".readLines()
    val cubes =
        input.map { line -> line.split("~").map { coords -> coords.split(",").map { it.toInt() } } }
            .mapIndexed { index, coords ->
                Cube(
                    index,
                    Point3D(coords[0][0], coords[0][1], coords[0][2]),
                    Point3D(coords[1][0], coords[1][1], coords[1][2])
                )
            }.sortedBy { min(it.start.z, it.end.z) }

    val cubesInRest = gravity(cubes)

    // Needed for part 2
    val singleCubeSupports = mutableSetOf<Cube>()
    val solutionPart1 = cubesInRest.sumOf { cube ->
        val supportedCubes =
            cubesInRest.filter { it.start.z == cube.end.z + 1 && it.xyPlanesIntersect(cube) != null }
        if (supportedCubes.isEmpty()) return@sumOf 1 as Int

        for (supportedCube in supportedCubes) {
            val supportedByCubes = cubesInRest.filter {
                it.end.z == supportedCube.start.z - 1 && it.xyPlanesIntersect(supportedCube) != null
            }
            if (supportedByCubes.size == 1) {
                singleCubeSupports.add(cube)
                return@sumOf 0 as Int
            }
        }
        return@sumOf 1 as Int
    }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = singleCubeSupports.sumOf { cube ->
        val stateWhenCubeIsRemoved = gravity(cubesInRest.filter { it != cube })
        return@sumOf stateWhenCubeIsRemoved.count { pC ->
            val first = cubesInRest.first { it.id == pC.id }
            return@count first.start.z != pC.start.z
        }
    }
    "The solution for $DAY part2 is: $solutionPart2".println()
}

// Let gravity do its work and let all cubes fall to their lowest possible position
private fun gravity(cubes: List<Cube>): List<Cube> {
    val cubesInRest = mutableSetOf<Cube>()
    for (cube in cubes.sortedBy { it.start.z }) {
        val cubeUnderneath =
            cubesInRest.filter { it.xyPlanesIntersect(cube) != null }.maxByOrNull { it.end.z }
        val newStartZ = if (cubeUnderneath != null) {
            val zStartUnderneath = cubeUnderneath.start.z
            val zEndUnderneath = cubeUnderneath.end.z
            maxOf(zStartUnderneath, zEndUnderneath) + 1
        } else 1
        cubesInRest.add(
            Cube(
                cube.id,
                Point3D(cube.start.x, cube.start.y, newStartZ),
                Point3D(cube.end.x, cube.end.y, cube.end.z - cube.start.z + newStartZ)
            )
        )
    }
    return cubesInRest.toList()
}

data class Point3D(val x: Int, val y: Int, val z: Int)
data class Cube(val id: Int, val start: Point3D, val end: Point3D) {
    private fun xyPlane() = XYPlane(start.x..end.x, start.y..end.y)
    fun xyPlanesIntersect(other: Cube): XYPlane? {
        val plane = xyPlane()
        val otherPlane = other.xyPlane()
        val xOverlap = plane.xRange intersect otherPlane.xRange
        val yOverlap = plane.yRange intersect otherPlane.yRange
        return if (xOverlap.isEmpty() || yOverlap.isEmpty()) null else XYPlane(xOverlap.first()..xOverlap.last(), yOverlap.first()..yOverlap.last())
    }
}

data class XYPlane(val xRange: IntRange, val yRange: IntRange)
