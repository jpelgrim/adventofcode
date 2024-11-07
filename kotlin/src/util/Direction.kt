package util

enum class Direction {
    LEFT, UP, RIGHT, DOWN;

    /**
     * Returns the direction after a clockwise rotation of the current direction.
     *
     * Example:
     * LEFT.clockwise() == UP
     * UP.clockwise() == RIGHT
     * RIGHT.clockwise() == DOWN
     * DOWN.clockwise() == LEFT
     */
    fun clockwise(): Direction {
        return entries[(ordinal + 1) % entries.size]
    }

    /**
     * Returns the direction after a counter-clockwise rotation of the current direction.
     *
     * Example:
     * LEFT.counterClockwise() == DOWN
     * UP.counterClockwise() == LEFT
     * RIGHT.counterClockwise() == UP
     * DOWN.counterClockwise() == RIGHT
     */
    fun counterClockwise(): Direction {
        return entries[(ordinal + entries.size - 1) % entries.size]
    }

    /**
     * Returns the opposite direction of the current direction.
     *
     * Example:
     * LEFT.opposite() == RIGHT
     * UP.opposite() == DOWN
     * RIGHT.opposite() == LEFT
     * DOWN.opposite() == UP
     */
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

fun Char.toDirection(): Direction = Direction.parse(this)
