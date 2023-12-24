package day24

import util.readLines

// Credit Roman Elizarov @ https://github.com/elizarov/AdventOfCode2023/blob/main/src/Day24_2_golf.kt
// Renamed variables and functions to make it more readable
const val POS = 0
const val VEL = 1
fun main() {
    val input = "day24/input_example.txt".readLines().map { line ->
        line.split("@").map { pointWithVelocity ->
            pointWithVelocity.split(",").map {
                it.trim().toLong()
            }
        }
    }
    val time = (0..2).firstNotNullOf { xyz ->
        input.indices.firstNotNullOfOrNull { index ->
            input.indices.map { j ->
                if (input[j][VEL][xyz] == input[index][VEL][xyz]) {
                    if (input[j][POS][xyz] == input[index][POS][xyz]) {
                        0L
                    } else {
                        -1L
                    }
                } else {
                    val posDiffK = input[j][POS][xyz] - input[index][POS][xyz]
                    val velDiffK = input[index][VEL][xyz] - input[j][VEL][xyz]
                    if (posDiffK % velDiffK == 0L) {
                        posDiffK / velDiffK
                    } else {
                        -1L
                    }
                }
            }.takeIf { tm -> tm.all { it >= 0 } }
        }
    }
    val (index1, index2) = time.withIndex().filter { it.value > 0 }.map { it.index }
    fun positionOfAxisInTime(index: Int, xyz: Int, time: Long) = input[index][POS][xyz] + input[index][VEL][xyz] * time
    println((0..2).sumOf { xyz -> positionOfAxisInTime(index1, xyz, time[index1]) - (positionOfAxisInTime(index1, xyz, time[index1]) - positionOfAxisInTime(index2, xyz ,time[index2])) / (time[index1] - time[index2]) * time[index1]})
}