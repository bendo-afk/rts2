import gdext
import gdext/classes/[gdRefCounted, gdTileMapLayer]
import hex_grid_math


type LOS* {.gdsync.} = ptr object of RefCounted
  s_margin, l_margin: float
  heights: seq[int]
  map: TileMapLayer
  n_x: int


proc setup*(self: LOS, map: TileMapLayer, s_margin, l_margin, vsize, hsize: float, n_x, n_y: int) {.gdsync.} =
  self.map = map
  (self.s_margin, self.l_margin) = (s_margin, l_margin)
  hex_grid_math.setup(vsize, hsize)

  self.heights = newSeq[int](n_x * n_y)
  self.n_x = n_x
  for y in 0..<n_y:
    for x in 0..<n_x:
      self.heights[x + y * (n_x - 1)] = map.get_cell_source_id(vector2i(int32(x), int32(y)))



proc get_height(self: LOS, tile: Vector2i): int =
  self.heights[tile.x + tile.y * (self.n_x - 1)]


proc first_step(self: LOS, last1, last2, cur1, cur2: var Vector2i, pos1, pos2: Vector2) =
  cur1 = self.map.local_to_map(pos1)
  let to_tile = self.map.local_to_map(pos2)
  last1 = cur1

  var cand11 = Vector2i.MIN
  var cand12 = Vector2i.MIN
  var cand21 = Vector2i.MIN
  var cand22 = Vector2i.MIN

  for i in 0..5:
    let turn1 = hex_grid_math.turn(pos1, pos2,
        hex_grid_math.get_vertex_pos(self.map.map_to_local(cur1), i))
    let turn2 = hex_grid_math.turn(pos1, pos2,
        hex_grid_math.get_vertex_pos(self.map.map_to_local(cur1), (i + 1) mod 6))
    
    if turn1 == 0 and turn2 == 0:
      last2 = hex_grid_math.get_adjacent_tile(cur1, i)
      let tile1 = hex_grid_math.get_adjacent_tile(cur1, (i+1) mod 6)
      let tile5 = hex_grid_math.get_adjacent_tile(cur1, (i+5) mod 6)
      if hex_grid_math.calc_dist(to_tile, tile1) < hex_grid_math.calc_dist(to_tile, tile5):
        cur1 = tile1
      else:
        cur1 = tile5
      return

    elif turn1 * turn2 == -1:
      if cand11 == Vector2i.MIN:
        cand11 = hex_grid_math.get_adjacent_tile(cur1, i)
      else:
        cand21 = hex_grid_math.get_adjacent_tile(cur1, i)
    
    elif turn1 == 0:
      if cand11 == Vector2i.MIN:
        cand11 = hex_grid_math.get_adjacent_tile(cur1, (i+5) mod 6)
        cand12 = hex_grid_math.get_adjacent_tile(cur1, i)
      else:
        cand21 = hex_grid_math.get_adjacent_tile(cur1, (i+5) mod 6)
        cand22 = hex_grid_math.get_adjacent_tile(cur1, i)

  if hex_grid_math.calc_dist(to_tile, cand11) < hex_grid_math.calc_dist(to_tile, cand21):
    cur1 = cand11
    if cand12 != Vector2i.MIN:
      cur2 = cand12
  else:
    cur1 = cand21
    if cand22 != Vector2i.MIN:
      cur2 = cand22


proc next_hexas(self: LOS, last1, last2, cur1, cur2: Vector2i, next1, next2: var Vector2i, pos1, pos2: Vector2) =
  var tile: Vector2i
  
  for i in 0..5:
    let turn1 = hex_grid_math.turn(pos1, pos2,
        hex_grid_math.get_vertex_pos(self.map.map_to_local(cur1), i))
    let turn2 = hex_grid_math.turn(pos1, pos2,
        hex_grid_math.get_vertex_pos(self.map.map_to_local(cur1), (i + 1) mod 6))

    if turn1 == 0 or turn2 == 0 or turn1 != turn2:
      tile = hex_grid_math.get_adjacent_tile(cur1, i)
      if tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2:
        if next1 == Vector2i.MIN:
          next1 = tile
        elif next2 == Vector2i.MIN:
          next2 = tile

      if turn1 == 0:
        tile = hex_grid_math.get_adjacent_tile(cur1, (i + 5) mod 6)
        if tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2:
          if next1 == Vector2i.MIN:
            next1 = tile
          elif next2 == Vector2i.MIN:
            next2 = tile

      if turn2 == 0:
        tile = hex_grid_math.get_adjacent_tile(cur1, (i + 1) mod 6)
        if tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2:
          if next1 == Vector2i.MIN:
            next1 = tile
          elif next2 == Vector2i.MIN:
            next2 = tile


proc is_visible*(self: LOS, from_pos, to_pos: Vector2, unit_height1, unit_height2: float): int {.gdsync.} =
  let
    from_tile = self.map.local_to_map(from_pos)
    to_tile = self.map.local_to_map(to_pos)
  if from_tile == to_tile:
    return 2

  let
    height1 = unit_height1 + self.get_height(from_tile)
    height2 = unit_height2 + self.get_height(to_tile)
    slope = (height2 - height1) / hex_grid_math.calc_dist(from_tile, to_tile)
  
  var min_margin = system.Inf

  var
    last1, last2, cur1, cur2, next1, next2 = Vector2i.MIN
  
  first_step(self, last1, last2, cur1, cur2, from_pos, to_pos)

  while true:
    if cur1 == to_tile or cur2 == to_tile:
      break


    for t in [cur1, cur2]:
      if t == Vector2i.MIN:
        break
      let
        t_height = self.get_height(t)
        t_dist = hex_grid_math.calc_dist(from_tile, t)
        t_margin = (slope * t_dist) + height1 - t_height
      if t_margin < min_margin:
        if t_margin < self.l_margin:
          return 0
        min_margin = t_margin
    
    next1 = Vector2i.MIN
    next2 = Vector2i.MIN
    next_hexas(self, last1, last2, cur1, cur2, next1, next2, from_pos, to_pos)
    next_hexas(self, last1, last2, cur2, cur1, next1, next2, from_pos, to_pos)
    (last1, last2) = (cur1, cur2)
    (cur1, cur2) = (next1, next2)

  if min_margin + self.s_margin < 0:
    return 1
  else:
    return 2


  
  