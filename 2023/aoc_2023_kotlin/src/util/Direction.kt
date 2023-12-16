package util

enum class Direction(var char: Char) {
    LEFT('L'),
    UP('U'),
    RIGHT('R'),
    DOWN('D'),
    ;

    fun clockwise(): Direction {
        return entries[(ordinal + 1) % entries.size]
    }

    fun counterClockwise(): Direction {
        return entries[(ordinal + entries.size - 1) % entries.size]
    }

    companion object {
        private val byChar = entries.associateBy { it.char }
        fun parse(input: Char): Direction {
            return byChar[input] ?: throw IllegalArgumentException("Invalid char=$input")
        }
    }
}