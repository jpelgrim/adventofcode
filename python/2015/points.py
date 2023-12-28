from typing import List


class Point2D:
    x: int
    y: int

    def __init__(self, elements: List[int]):
        self.x = elements[0]
        self.y = elements[1]

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def __hash__(self):
        return 31 * self.x + self.y
