import gdext
import gdext/classes/[gdTileMapLayer]
import hex_grid_math


type LOSTileMapLayer = ptr object of TileMapLayer
  vsize, hsize: float
  hex_grid_math: HexGridMath


proc setup*(self: LOSTileMapLayer) {.gdsync.} =
  self.hex_grid_math.setup(self.vsize, self.hsize)


proc first_step(self: LOSTileMapLayer, last1, last2, cur1, cur2: var Vector2i, pos1, pos2: Vector2) =
  cur1 = self.local_to_map(pos1)
  let to_tile = self.local_to_map(pos2)
  last1 = cur1

  var cand11 = Vector2i.Min
  var cand12 = Vector2i.Min
  var cand21 = Vector2i.Min
  var cand22 = Vector2i.Min

  for i in 0..5:
    let turn1 = self.hex_grid_math.turn(pos1, pos2,
        self.hex_grid_math.get_vertex_pos(self.map_to_local(cur1), i))
    let turn2 = self.hex_grid_math.turn(pos1, pos2,
        self.hex_grid_math.get_vertex_pos(self.map_to_local(cur1), (i + 1) mod 6))
    
    if turn1 == 0 and turn2 == 0:
      last2 = self.hex_grid_math.get_adjacent_tile(cur1, i)
      let tile1 = self.hex_grid_math.get_adjacent_tile(cur1, (i+1) mod 6)
      let tile5 = self.hex_grid_math.get_adjacent_tile(cur1, (i+5) mod 6)
      if self.hex_grid_math.calc_dist(to_tile, tile1) < self.hex_grid_math.calc_dist(to_tile, tile5):
        cur1 = tile1
      else:
        cur1 = tile5
      return

    elif turn1 * turn2 == -1:
      if cand11 == Vector2i.MIN:
        cand11 = self.hex_grid_math.get_adjacent_tile(cur1, i)
      else:
        cand21 = self.hex_grid_math.get_adjacent_tile(cur1, i)
    
    elif turn1 == 0:
      if cand11 == Vector2i.MIN:
        cand11 = self.hex_grid_math.get_adjacent_tile(cur1, (i+5) mod 6)
        cand12 = self.hex_grid_math.get_adjacent_tile(cur1, i)
      else:
        cand21 = self.hex_grid_math.get_adjacent_tile(cur1, (i+5) mod 6)
        cand22 = self.hex_grid_math.get_adjacent_tile(cur1, i)

  if self.hex_grid_math.calc_dist(to_tile, cand11) < self.hex_grid_math.calc_dist(to_tile, cand21):
    cur1 = cand11
    if cand12 != Vector2i.MIN:
      cur2 = cand12
  else:
    cur1 = cand21
    if cand22 != Vector2i.MIN:
      cur2 = cand22


proc nex_hexas(self: LOSTileMapLayer, last1, last2, cur1, cur2: Vector2i, next1, next2: var Vector2i, pos1, pos2: Vector2) =
  var tile: Vector2i
  
  for i in 0..5:
    let turn1 = self.hex_grid_math.turn(pos1, pos2,
        self.hex_grid_math.get_vertex_pos(self.map_to_local(cur1), i))
    let turn2 = self.hex_grid_math.turn(pos1, pos2,
        self.hex_grid_math.get_vertex_pos(self.map_to_local(cur1), (i + 1) mod 6))

    if turn1 == 0 or turn2 == 0 or turn1 != turn2:
      tile = self.hex_grid_math.get_adjacent_tile(cur1, i)
      if tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2:
        if next1 == Vector2i.MIN:
          next1 = tile
        elif next2 == Vector2i.MIN:
          next2 = tile

      if turn1 == 0:
        tile = self.hex_grid_math.get_adjacent_tile(cur1, (i + 5) mod 6)
        if tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2:
          if next1 == Vector2i.MIN:
            next1 = tile
          elif next2 == Vector2i.MIN:
            next2 = tile

      if turn2 == 0:
        tile = self.hex_grid_math.get_adjacent_tile(cur1, (i + 1) mod 6)
        if tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2:
          if next1 == Vector2i.MIN:
            next1 = tile
          elif next2 == Vector2i.MIN:
            next2 = tile


proc is_visible(self: LOSTileMapLayer, from_pos, to_pos: Vector2, unit_height1, unit_height2: float): int =
  let from_tile = self.local_to_map(from_pos)
  let to_tile = self.local_to_map(to_pos)
  if from_tile == to_tile:
    return 2

  let height1 = 
  