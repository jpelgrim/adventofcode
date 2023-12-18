package util

enum class Direction {
    LEFT, UP, RIGHT, DOWN;

    fun clockwise(): Direction {
        return entries[(ordinal + 1) % entries.size]
    }

    fun counterClockwise(): Direction {
        return entries[(ordinal + entries.size - 1) % entries.size]
    }

    fun opposite(): Direction {
        return entries[(ordinal + 2) % entries.size]
    }

    companion object {
        fun parse(input: Char): Direction {
            when (input) {
                'L', '<' -> return LEFT
                'U', '^' -> return UP
                'R', '>' -> return RIGHT
                'D', 'v', 'V' -> return DOWN
            }
            throw IllegalArgumentException("Invalid char=$input")
        }
    }
}