package util

data class Rect(
    val left: Long,
    val top: Long,
    val right: Long,
    val bottom: Long,
) {

    init {
        require(right >= left)
        require(top <= bottom)
    }

    operator fun contains(point: Point) = point.x in left..right && point.y in top..bottom

    fun height(): Long = bottom - top

    fun width(): Long = right - left
}
