@file:Suppress("unused")

package util

fun gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)

fun lcm(a: Int, b: Int): Int = a * b / gcd(a, b)

fun lcm(numbers: List<Int>) =
    numbers.reduce { acc, l -> lcm(acc, l) } / numbers.reduce { acc, l -> gcd(acc, l) }

fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

fun lcm(a: Long, b: Long): Long = a * (b / gcd(a, b))

fun lcm(numbers: List<Long>) =
    numbers.reduce { acc, l -> lcm(acc, l) } / numbers.reduce { acc, l -> gcd(acc, l) }
