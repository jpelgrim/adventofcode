package util

import java.io.File
import java.math.BigInteger
import java.security.MessageDigest

fun String.readLines(): List<String> {
    croakIfUsingSampleInput()

    return File("src", this).readLines()
}

private fun String.croakIfUsingSampleInput() {
    if (contains("example")) {
        "⚠️ WARNING 🧝‍ YOU ARE USING EXAMPLE INPUT‼️☠️".println()
    }
}

fun String.readBytes(): ByteArray {
    croakIfUsingSampleInput()

    return File("src", this).readBytes()
}

fun String.readText(): String {
    croakIfUsingSampleInput()

    return File("src", this).readText()
}

/**
 * Converts string to md5 hash.
 */
fun String.md5() = BigInteger(1, MessageDigest.getInstance("MD5").digest(toByteArray()))
    .toString(16)
    .padStart(32, '0')

/**
 * The cleaner shorthand for printing output.
 */
fun Any?.println() = println(this)

fun List<String>.transposed() = first().indices.map {
    buildString { for (line in this@transposed) append(line[it]) }
}
