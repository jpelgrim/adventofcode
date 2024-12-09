package y2024.day09

import util.println
import util.readLines

private const val DAY = "day09" // https://adventofcode.com/2024/day/9

fun main() {
    solveDay9()
}

fun solveDay9() {
    val input = "y2024/$DAY/sample.txt"
    val line = input.readLines().first()

    var id = 0
    val disk = buildList<Long> {
        for (i in 0 until line.length step 2) {
            val blocks = line[i].code - 48
            val freeSpace = if (i + 1 < line.length) line[i + 1].code - 48 else 0
            repeat(blocks) {
                add(id.toLong())
            }
            repeat(freeSpace) {
                add(-1L)
            }
            id++
        }
    }
    val compressedDiskPart1 = compressDiskPart1(disk)
    val solutionPart1 = calculateChecksum(compressedDiskPart1)
    "The solution for $DAY part 1 is: $solutionPart1".println()

    val compressedDiskPart2 = compressDiskPart2(disk)
    val solutionPart2 = calculateChecksum(compressedDiskPart2)
    "The solution for $DAY part 2 is: $solutionPart2".println()
}

private fun calculateChecksum(compressedDisk: List<Long>): Long =
    compressedDisk.foldIndexed(0L) { index, acc, i ->
        if (i > 0L) {
            acc + (i * index)
        } else {
            acc
        }
    }

private fun compressDiskPart1(disk: List<Long>): List<Long> {
    var compressedDisk = disk.toMutableList()
    var firstFreeSpace = compressedDisk.indexOf(-1L)
    var lastData = compressedDisk.indexOfLast { it > 0L }
    while (firstFreeSpace < lastData) {
        compressedDisk[firstFreeSpace] = compressedDisk[lastData]
        compressedDisk[lastData] = -1L
        firstFreeSpace = compressedDisk.indexOf(-1L)
        lastData = compressedDisk.indexOfLast { it > 0L }
    }
    return compressedDisk.toList()
}

private fun compressDiskPart2(disk: List<Long>): List<Long> {
    var compressedDisk = disk.toMutableList()
    var lastIndex = disk.indexOfLast { it > 0L }
    while (true) {
        if (lastIndex == -1) break
        if (disk[lastIndex] == -1L) {
            lastIndex--
            continue
        }
        val fileId = disk[lastIndex]
        var firstIndexOfBlock = disk.indexOf(fileId)
        val blockLength = lastIndex - firstIndexOfBlock + 1
        var startOfFreeSpace = -1
        for (j in 0 until firstIndexOfBlock) {
            if (compressedDisk[j] == -1L && startOfFreeSpace == -1) {
                startOfFreeSpace = j
                if (blockLength > 1) continue
            }
            if (compressedDisk[j] == -1L && j - startOfFreeSpace + 1 == blockLength) {
                // We've found a free space block that fits the file
                // Move file to free space
                for (i in startOfFreeSpace..startOfFreeSpace + blockLength - 1) {
                    compressedDisk[i] = fileId
                }
                // Overwrite original file location
                for (i in firstIndexOfBlock..firstIndexOfBlock + blockLength - 1) {
                    compressedDisk[i] = -1L
                }
                break
            } else if (compressedDisk[j] != -1L) {
                // The free space block has ended
                startOfFreeSpace = -1
            }
        }
        lastIndex = firstIndexOfBlock - 1
    }
    return compressedDisk.toList()
}
