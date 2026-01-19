import gdext
import std/math

var vertex_offsets: array[6, Vector2]

const
  odd_offsets: array[6, Vector2i] = [
    vector2i(1, -1),
    vector2i(1, 0),
    vector2i(1, 1),
    vector2i(0, 1),
    vector2i(-1, 0),
    vector2i(0, -1)
  ]
  even_offsets: array[6, Vector2i] = [
    vector2i(0, -1),
    vector2i(1, 0),
    vector2i(0, 1),
    vector2i(-1, 1),
    vector2i(-1, 0),
    vector2i(-1, -1)
  ]


proc setup*(vsize, hsize: float) =
  vertex_offsets = [
    vector2(0, -vsize / 2),
    vector2(hsize / 2, -vsize / 4),
    vector2(hsize / 2, vsize / 4),
    vector2(0, vsize / 2),
    vector2(-hsize / 2, vsize / 4),
    vector2(-hsize / 2, -vsize / 4)
  ]


proc oddr_to_axial(tile: Vector2i): Vector2i =
  let
    parity = tile.y and 1
    q = tile.x - (tile.y - parity) div 2
    r = tile.y
  return vector2i(q, r)


proc axial_dist(a, b: Vector2i): int =
  (abs(a.x - b.x) + abs(a.x + a.y - b.x - b.y) + abs(a.y - b.y)) div 2


proc calc_dist*(a, b: Vector2i): int  =
  let
    ac = oddr_to_axial(a)
    bc = oddr_to_axial(b)
  return axial_dist(ac, bc)


proc get_adjacent_tile*(tile: Vector2i, index: int): Vector2i {.gdsync.} =
  if (tile.y mod 2) == 1:
    return tile + odd_offsets[index]
  else:
    return tile + even_offsets[index]


proc get_vertex_pos*(center_pos: Vector2, index: int): Vector2  =
  center_pos + vertex_offsets[index]


proc turn*(pos0, pos1, pos2: Vector2): int =
  cross(pos1 - pos0, pos2 - pos0).sgn