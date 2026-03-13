-- idle_animation.lua
-- Creates rat_idle.ase: 4-frame breathing + ear twitch animation
-- Sprite: 64x64, RGBA, 250ms per frame

local sprite = Sprite(64, 64, ColorMode.RGB)
local layer = sprite.layers[1]
layer.name = "rat"

-- Load base rat
local base = Image{ fromFile="C:/Users/user/Documents/pixelRats/sprites/rat/rat_base.png" }

-- Frame 1: base pose (resting)
sprite.cels[1].image = base:clone()

-- Frame 2: breathing in (shift body up 1px)
sprite:newEmptyFrame()
sprite:newCel(layer, 2, base:clone(), Point(0, -1))

-- Frame 3: breathing out (back to base)
sprite:newEmptyFrame()
sprite:newCel(layer, 3, base:clone(), Point(0, 0))

-- Frame 4: ear twitch (left ear perks up slightly)
sprite:newEmptyFrame()
local f4img = base:clone()
-- Left ear tip: extend outline up by 1px at ear peaks (y=12 -> y=11)
f4img:drawPixel(14, 11, Color(0, 0, 0, 255))
f4img:drawPixel(15, 11, Color(0, 0, 0, 255))
-- Pink inner ear where outline was
f4img:drawPixel(15, 12, Color(255, 183, 197, 255))
-- Right ear twitch
f4img:drawPixel(33, 11, Color(0, 0, 0, 255))
f4img:drawPixel(34, 11, Color(0, 0, 0, 255))
f4img:drawPixel(33, 12, Color(255, 188, 200, 255))
sprite:newCel(layer, 4, f4img, Point(0, 0))

-- Set frame durations: 250ms each (4fps idle loop)
for i = 1, #sprite.frames do
    sprite.frames[i].duration = 0.25
end

-- Add animation tag
local tag = sprite:newTag(1, #sprite.frames)
tag.name = "idle"

-- Save directly to sprites/rat/
sprite:saveAs("C:/Users/user/Documents/pixelRats/sprites/rat/rat_idle.ase")
print("Saved rat_idle.ase - 4 frames, 250ms each, idle tag")
