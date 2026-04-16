# built-in
import inspect
import types
from enum import Enum
from math import asin, atan2, cos, degrees, pi, radians, sin
from typing import Self

from traceback_with_variables import (
    activate_by_import,  # PyPI: traceback-with-variables
)


class RotationSequence(Enum):
    XYZ = 0
    XZY = 1
    YXZ = 2
    YZX = 3
    ZXY = 4
    ZYX = 5


def clamp(value, min_value, max_value):
    return max(min_value, min(value, max_value))


class Vector:
    x: float
    y: float
    z: float

    def __init__(self, x: float, y: float, z: float):
        self.x = float(x)
        self.y = float(y)
        self.z = float(z)

    def __str__(self):
        return f"({self.x}, {self.y}, {self.z})"

    def __repr__(self):
        return f"Vector(x={self.x}, y={self.y}, z={self.z})"

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y, self.z + other.z)

    def __sub__(self, other):
        return Vector(self.x - other.x, self.y - other.y, self.z - other.z)

    def __mul__(self, other):
        return Vector(self.x * other, self.y * other, self.z * other)

    def __truediv__(self, other):
        return Vector(self.x / other, self.y / other, self.z / other)

    def dot(self, other):
        return self.x * other.x + self.y * other.y + self.z * other.z

    def cross(self, other):
        x = self.y * other.z - self.z * other.y
        y = self.z * other.x - self.x * other.z
        z = self.x * other.y - self.y * other.x
        return Vector(x, y, z)

    def normalize(self):
        mag = (self.x**2 + self.y**2 + self.z**2) ** 0.5
        return Vector(self.x / mag, self.y / mag, self.z / mag)

    def rotate(self, quaternion):
        return quaternion.rotate(self)

    def to_list(self):
        return [self.x, self.y, self.z]


class Quaternion:
    w: float
    x: float
    y: float
    z: float

    def __init__(self, w: float, x: float, y: float, z: float):
        self.w = float(w)
        self.x = float(x)
        self.y = float(y)
        self.z = float(z)

    def __mul__(self, other: Self) -> Self:
        w: float = self.w * other.w - self.x * other.x - self.y * other.y - self.z * other.z
        x: float = self.w * other.x + self.x * other.w + self.y * other.z - self.z * other.y
        y: float = self.w * other.y - self.x * other.z + self.y * other.w + self.z * other.x
        z: float = self.w * other.z + self.x * other.y - self.y * other.x + self.z * other.w
        return Quaternion(w, x, y, z)

    def difference(self, other: Self) -> Self:
        return ~self * other

    def __invert__(self) -> Self:
        return Quaternion(self.w, -self.x, -self.y, -self.z)

    def __str__(self):
        return f"({self.w}, {self.x}, {self.y}, {self.z})"

    def __repr__(self):
        return f"Quaternion(w={self.w}, x={self.x}, y={self.y}, z={self.z})"

    def rotate(self, vector):
        q = Quaternion.from_vector(vector)
        return (self * q * ~self).vector

    def conjugate(self) -> Self:
        return ~self

    def inverse(self) -> Self:
        return ~self

    def normalize(self):
        mag = (self.w**2 + self.x**2 + self.y**2 + self.z**2) ** 0.5
        return Quaternion(self.w / mag, self.x / mag, self.y / mag, self.z / mag)

    def to_matrix(self):
        w, x, y, z = self.w, self.x, self.y, self.z
        return [
            [1 - 2 * y**2 - 2 * z**2, 2 * x * y - 2 * z * w, 2 * x * z + 2 * y * w],
            [2 * x * y + 2 * z * w, 1 - 2 * x**2 - 2 * z**2, 2 * y * z - 2 * x * w],
            [2 * x * z - 2 * y * w, 2 * y * z + 2 * x * w, 1 - 2 * x**2 - 2 * y**2],
        ]

    def to_euler(self, sequence: RotationSequence) -> Vector:
        w, x, y, z = self.w, self.x, self.y, self.z

        # map quaternion components to generic p-variables and set the sign
        p0 = w
        match sequence:
            case RotationSequence.XYZ:
                p1, p2, p3, e = x, y, z, -1
            case RotationSequence.XZY:
                p1, p2, p3, e = x, z, y, 1
            case RotationSequence.YXZ:
                p1, p2, p3, e = y, x, z, 1
            case RotationSequence.YZX:
                p1, p2, p3, e = y, z, x, -1
            case RotationSequence.ZXY:
                p1, p2, p3, e = z, x, y, -1
            case RotationSequence.ZYX:
                p1, p2, p3, e = z, y, x, 1

        # create mapping between the euler angle and the rotation sequence
        match sequence:
            case RotationSequence.XYZ:
                euler_order = (0, 1, 2)
            case RotationSequence.XZY:
                euler_order = (0, 2, 1)
            case RotationSequence.YXZ:
                euler_order = (1, 0, 2)
            case RotationSequence.YZX:
                euler_order = (1, 2, 0)
            case RotationSequence.ZXY:
                euler_order = (2, 0, 1)
            case RotationSequence.ZYX:
                euler_order = (2, 1, 0)

        # calculate the value to be used to check for singularities
        singularity_check = 2.0 * (p0 * p2 - e * p1 * p3)

        euler_angle = [0.0, 0.0, 0.0]
        euler_angle[euler_order[1]] = asin(clamp(singularity_check, -1.0, 1.0))

        if abs(singularity_check) < 1.0:
            euler_angle[euler_order[0]] = atan2(2.0 * (p0 * p1 + e * p2 * p3), 1.0 - 2.0 * (p1**2 + p2**2))
            euler_angle[euler_order[2]] = atan2(2.0 * (p0 * p3 + e * p1 * p2), 1.0 - 2.0 * (p2**2 + p3**2))
        else:
            euler_angle[euler_order[0]] = atan2(2.0 * (p0 * p1 - e * p2 * p3), 1.0 - 2.0 * (p1**2 + p3**2))
            euler_angle[euler_order[2]] = 0.0

        return Vector(degrees(euler_angle[0]) % 360.0, degrees(euler_angle[1]) % 360.0, degrees(euler_angle[2]) % 360.0)

    @classmethod
    def from_vector(cls, v: Vector) -> Self:
        return cls(0, v.x, v.y, v.z)

    @classmethod
    def from_euler(cls, angles: Vector, sequence: RotationSequence) -> Self:
        x, y, z = angles.x, angles.y, angles.z
        x, y, z = radians(x), radians(y), radians(z)
        cos_x, cos_y, cos_z = cos(x / 2), cos(y / 2), cos(z / 2)
        sin_x, sin_y, sin_z = sin(x / 2), sin(y / 2), sin(z / 2)

        match sequence:
            case RotationSequence.XYZ:
                sign_w, sign_x, sign_y, sign_z = -1, 1, -1, 1
            case RotationSequence.XZY:
                sign_w, sign_x, sign_y, sign_z = 1, -1, -1, 1
            case RotationSequence.YXZ:
                sign_w, sign_x, sign_y, sign_z = 1, 1, -1, -1
            case RotationSequence.YZX:
                sign_w, sign_x, sign_y, sign_z = -1, 1, 1, -1
            case RotationSequence.ZXY:
                sign_w, sign_x, sign_y, sign_z = -1, -1, 1, 1
            case RotationSequence.ZYX:
                sign_w, sign_x, sign_y, sign_z = 1, -1, 1, -1

        return cls(
            cos_x * cos_y * cos_z + sign_w * sin_x * sin_y * sin_z,
            sin_x * cos_y * cos_z + sign_x * cos_x * sin_y * sin_z,
            cos_x * sin_y * cos_z + sign_y * sin_x * cos_y * sin_z,
            cos_x * cos_y * sin_z + sign_z * sin_x * sin_y * cos_z,
        )


def rotate_rotation(
    initial_rotation: Vector, rotation_to_apply: Vector, sequence: RotationSequence, active: bool = True
) -> Vector:
    q_initial = Quaternion.from_euler(initial_rotation, sequence)
    q_rotation = Quaternion.from_euler(rotation_to_apply, sequence)
    if active:
        q_final = ~q_initial * q_rotation * q_initial
    else:
        q_final = q_initial * q_rotation * ~q_initial
    return q_final.to_euler(sequence)


def rotate_position(initial_position: Vector, rotation_to_apply: Vector, sequence: RotationSequence) -> Vector:
    q_initial = Quaternion.from_vector(initial_position)
    q_rotation = Quaternion.from_euler(rotation_to_apply, sequence)
    q_final = q_rotation * q_initial * ~q_rotation
    return Vector(q_final.x, q_final.y, q_final.z)


def main():
    for sequence in RotationSequence:
        print(sequence)
        initial_rotation = Vector(45, 90, 270)
        initial_position = Vector(3.27, 0, -0.83)
        rotation_to_apply = Vector(270, 0, 0)
        print(rotate_rotation(initial_rotation, rotation_to_apply, sequence, True))
        print(rotate_rotation(initial_rotation, rotation_to_apply, sequence, False))
        print(rotate_position(initial_position, rotation_to_apply, sequence))
    # print(rotate_rotation(Vector(45, 90, 270), Vector(0, 270, 0), RotationSequence.ZYX, True))
    # print(rotate_rotation(Vector(45, 90, 270), Vector(0, 270, 0), RotationSequence.ZYX, False))
    # print(rotate_position(Vector(3.27, 0, -0.83), Vector(90, 0, 0), RotationSequence.ZYX))


if __name__ == "__main__":
    main()
