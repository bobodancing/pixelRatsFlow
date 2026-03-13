# PixelRats Pixel Art Pipeline — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create 8 animation states for the rat protagonist + 6 demo accessories as .ase files, establishing a repeatable pixel art pipeline.

**Architecture:** Use pixel-plugin MCP tools (mcp__aseprite__*) for canvas creation, pixel drawing, layer management, and animation frames. Fall back to Aseprite CLI + Lua scripts if MCP unavailable. Use Python PIL for accessory extraction from composite images. All outputs are 64x64 RGBA .ase files.

**Tech Stack:** pixel-plugin (Aseprite MCP), Aseprite v1.3.17 CLI, Python PIL, Lua scripting

---

## Execution Progress

| Task | 狀態 | 備註 |
|------|------|------|
| Task 1: Directory structure | ✅ Done | `sprites/{rat,items/head,items/back,anchors}` |
| Task 2: Base rat sprite | ✅ Done | `sprites/rat/rat_base.png` 64x64 transparent |
| Task 3: Idle animation | ✅ Done | `rat_idle.ase` 4f/250ms, MCP+Lua verified |
| Task 4: Walking animation | ⬜ Pending | |
| Task 5: Eating animation | ⬜ Pending | |
| Task 6: Studying animation | ⬜ Pending | |
| Task 7: Emotional animations | ⬜ Pending | |
| Task 8: Sleeping animation | ⬜ Pending | |
| Task 9: Head accessories | ⬜ Pending | |
| Task 10: Back accessories | ⬜ Pending | |
| Task 11: Anchor points JSON | ⬜ Pending | |
| Task 12: Composite verification | ⬜ Pending | |

---

## Verified Workflow (from Task 1-2 execution)

### CFA (Controlled Folder Access) Confirmed Rules

Windows Defender CFA rules (updated 2026-03-07 after user added allowlist):

| Method | Write to Documents/ | Notes |
|--------|---------------------|-------|
| `py -3` (Python) | ✅ Works | Whitelisted by CFA |
| Claude Code Write tool | ✅ Works | Direct file write |
| `bash cp/mv` | ✅ Works | Added to CFA allowlist |
| `node fs` | ✅ Works | Added to CFA allowlist |
| Aseprite `saveAs()` | ✅ Works | Added to CFA allowlist |
| PowerShell | ❌ Blocked | Not yet added — discuss with user first |

> ⚠️ If new tools are blocked in future, discuss with user before workarounding — they can add to CFA allowlist.

**Animation workflow (Tasks 3-8) — simplified:**
1. Write Lua script anywhere (Write tool or direct)
2. Run `Aseprite.exe --batch --script script.lua` → save .ase **directly** to `sprites/rat/`
3. ~~Copy step no longer needed~~

### Rat Base Sprite — Verified Details

- **Source:** `items/pixelRats_64x64.png` (64x64, had light green background)
- **Output:** `sprites/rat/rat_base.png` (64x64, transparent background)
- **Background color removed:** RGBA(202-218, 254-255, 192-216, 255) — G channel ≥ 250
- **Rat pixels:** 1411 (34.4% of 64x64 canvas)
- **Orientation:** Rat faces **left**, ears at top-left, tail extends right, legs at bottom

### Verified Color Palette (75 unique colors, 5 groups)

| Color Group | Hex | RGB | Usage | Pixel % |
|-------------|-----|-----|-------|---------|
| Black | `#000000` | (0, 0, 0) | Outlines | 32% |
| Medium Gray | `#ACACA8` | (172, 172, 168) | Body (main) | ~28% |
| Light Gray | `#AAAAA6` | (170, 170, 166) | Body (highlight) | ~23% |
| Dark Gray | `#81837E` | (129, 131, 126) | Body (shadow) | ~7% |
| Brown | `#592F03` | (89, 47, 3) | Eye | 3.5% |
| Pink Light | `#FFBCC8` | (255, 188, 200) | Ears | ~2% |
| Pink Medium | `#FFB7C5` | (255, 183, 197) | Nose/inner ear | ~2% |
| Pink Dark | `#FFB2C3` | (255, 178, 195) | Tail | ~1% |

> Note: 75 unique colors due to interpolation from upscaling (320→64). Animation tasks should work with pixel data as-is.

---

## Pre-requisites

- pixel-plugin MCP server must be connected (restart Claude Code if `mcp__aseprite__*` tools unavailable)
- Aseprite: `C:\Users\user\Documents\pixelRats\Aseprite-v1.3.17-x64\Aseprite.exe`
- Python PIL: `py -3 -c "from PIL import Image"` (verified working)
- **CFA workaround:** All file writes to Documents/ must use `py -3` or Claude Code Write tool

## Environment Constants

```
ASEPRITE = C:\Users\user\Documents\pixelRats\Aseprite-v1.3.17-x64\Aseprite.exe
PROJECT  = C:\Users\user\Documents\pixelRats
ITEMS    = C:\Users\user\Documents\pixelRats\items
PXO      = C:\Users\user\Documents\pixelRats\pixellabPxo
SPRITES  = C:\Users\user\Documents\pixelRats\sprites       (to create)
TEMP     = C:\Users\user\AppData\Local\Temp                 (writable by all)
```

---

### Task 1: Create Sprite Output Directory Structure

**Files:**
- Create: `sprites/rat/` (animation .ase files)
- Create: `sprites/items/head/` (head accessories)
- Create: `sprites/items/back/` (back accessories)
- Create: `sprites/anchors/` (anchor JSON files)

**Step 1: Create directories via Python**

```python
py -3 -c "
import os
base = 'C:/Users/user/Documents/pixelRats/sprites'
for d in ['rat', 'items/head', 'items/back', 'anchors']:
    os.makedirs(os.path.join(base, d), exist_ok=True)
    print(f'Created: {os.path.join(base, d)}')
"
```

Expected: 4 directories created under `sprites/`

**Step 2: Verify structure**

```bash
ls -R /c/Users/user/Documents/pixelRats/sprites/
```

Expected: `rat/`, `items/head/`, `items/back/`, `anchors/`

---

### Task 2: Prepare Base Rat Sprite (64x64 reference)

**Files:**
- Read: `items/pixelRats.png` (320x320 source)
- Read: `items/pixelRats_64x64.png` (already converted)
- Create: `sprites/rat/rat_base.png` (clean 64x64 base with transparent background)

**Step 1: Remove green background and create clean base**

```python
py -3 -c "
from PIL import Image
import numpy as np

img = Image.open('C:/Users/user/Documents/pixelRats/items/pixelRats_64x64.png').convert('RGBA')
data = np.array(img)

# Identify the light green background color (approx RGB 200,240,200)
# Replace with transparent
r, g, b, a = data[:,:,0], data[:,:,1], data[:,:,2], data[:,:,3]
bg_mask = (r > 180) & (g > 220) & (b > 180) & (r < 230) & (g < 255) & (b < 230)
data[bg_mask] = [0, 0, 0, 0]

result = Image.fromarray(data)
result.save('C:/Users/user/Documents/pixelRats/sprites/rat/rat_base.png')
print('Saved rat_base.png:', result.size)
"
```

**Step 2: Verify the base sprite visually**

Read `sprites/rat/rat_base.png` to confirm transparent background, rat intact.

**Step 3: Extract the PixelRats color palette**

```python
py -3 -c "
from PIL import Image
from collections import Counter

img = Image.open('C:/Users/user/Documents/pixelRats/sprites/rat/rat_base.png').convert('RGBA')
pixels = list(img.getdata())
# Filter out transparent pixels
colors = [p for p in pixels if p[3] > 0]
palette = Counter(colors).most_common(20)
print('PixelRats Palette (top 20 colors):')
for color, count in palette:
    r, g, b, a = color
    print(f'  RGBA({r:3d},{g:3d},{b:3d},{a:3d}) - {count} pixels')
"
```

Expected: List of 10-20 distinct colors used in the rat sprite.
Save this palette reference for later consistency checks.

---

### Task 3: Create Rat Idle Animation (4 frames)

**Files:**
- Create: `sprites/rat/rat_idle.ase`

**Concept:** Rat in resting pose, subtle breathing animation (body rises/falls 1px), occasional ear twitch.

**Step 1: Create Aseprite file with 4 frames via MCP or Lua**

Option A (MCP — if available):
```
mcp__aseprite__create_canvas(width=64, height=64, color_mode="rgba")
# Copy base rat to frame 1
# Frame 2: shift body up 1px (inhale)
# Frame 3: same as frame 1 (exhale)
# Frame 4: ear twitch variant
# Set frame duration: 250ms each (4fps idle)
# Save as sprites/rat/rat_idle.ase
```

Option B (Aseprite CLI + Lua):
```lua
-- idle_animation.lua
local sprite = Sprite(64, 64, ColorMode.RGB)
sprite.filename = "rat_idle.ase"

-- Load base rat as reference
local base = Image{ fromFile="C:/Users/user/Documents/pixelRats/sprites/rat/rat_base.png" }

-- Frame 1: base pose
sprite.cels[1].image = base:clone()

-- Frame 2: body shift up 1px (breathing in)
sprite:newEmptyFrame()
local f2 = base:clone()
-- shift pixels up by 1
sprite.cels[2].image = f2
sprite.cels[2].position = Point(0, -1)

-- Frame 3: back to base (breathing out)
sprite:newEmptyFrame()
sprite.cels[3].image = base:clone()

-- Frame 4: ear twitch (slight pixel change on ears)
sprite:newEmptyFrame()
sprite.cels[4].image = base:clone()
-- Modify ear pixels slightly

-- Set timing
for i = 1, #sprite.frames do
    sprite.frames[i].duration = 0.25
end

sprite:saveAs("C:/Users/user/AppData/Local/Temp/rat_idle.ase")
```

Run: `Aseprite.exe --batch --script idle_animation.lua`
Then copy to sprites/rat/ via Python.

**Step 2: Verify animation visually**

Open the .ase in Aseprite or read the file to confirm 4 frames exist.

---

### Task 4: Create Rat Walking Animation (4-6 frames)

**Files:**
- Reference: `pixellabPxo/pixelrat_walk.pxo` (existing test frames)
- Create: `sprites/rat/rat_walking.ase`

**Concept:** Rat walking cycle — legs alternate, body bobs, tail sways.

**Step 1: Check existing walk animation for reference**

```bash
Aseprite.exe --batch pixellabPxo/pixelrat_walk.pxo --list-tags --data temp_walk_info.json
```

**Step 2: Create 4-frame walk cycle**

Same pattern as Task 3: create via MCP or Lua script.
- Frame 1: left legs forward
- Frame 2: mid stride
- Frame 3: right legs forward
- Frame 4: mid stride (mirror)
- Duration: 150ms per frame (faster than idle)

**Step 3: Verify walk cycle**

---

### Task 5: Create Rat Eating Animation (6 frames)

**Files:**
- Reference: `pixellabPxo/eatting.pxo`, `pixellabPxo/eatting2.pxo`
- Create: `sprites/rat/rat_eating.ase`

**Concept:** Rat eating — head bobs down to food, chewing motion, happy expression.

- Frame 1: looking at food
- Frame 2: head down (eating)
- Frame 3: chewing (mouth open)
- Frame 4: chewing (mouth closed)
- Frame 5: head up
- Frame 6: satisfied expression (eyes happy)
- Duration: 200ms per frame

---

### Task 6: Create Rat Studying Animation (4 frames)

**Files:**
- Create: `sprites/rat/rat_studying.ase`

**Concept:** Rat at desk with book — page turning, occasional head tilt.

- Frame 1: reading pose (head down)
- Frame 2: page turn (paw extended)
- Frame 3: reading pose
- Frame 4: head tilt (thinking)
- Duration: 500ms per frame (slow, focused)

---

### Task 7: Create Rat Emotional Animations (sad, confused, happy)

**Files:**
- Create: `sprites/rat/rat_sad.ase` (3 frames)
- Create: `sprites/rat/rat_confused.ase` (2 frames)
- Create: `sprites/rat/rat_happy.ase` (4 frames)

**sad (3 frames):**
- Frame 1: hunched, ears down
- Frame 2: slight tremble
- Frame 3: tears pixel (one pixel drop)
- Duration: 400ms

**confused (2 frames):**
- Frame 1: head tilted, question mark pixel above head
- Frame 2: head straight, question mark blink
- Duration: 500ms

**happy (4 frames):**
- Frame 1: normal pose, smile
- Frame 2: small jump (shift up 2px)
- Frame 3: peak jump, tail wag
- Frame 4: landing back
- Duration: 200ms

---

### Task 8: Create Rat Sleeping Animation (2 frames)

**Files:**
- Create: `sprites/rat/rat_sleeping.ase`

**Concept:** Curled up rat, Zzz bubble.

- Frame 1: curled pose, small "z"
- Frame 2: curled pose, larger "Z"
- Duration: 800ms (very slow, peaceful)

---

### Task 9: Extract Head Accessories from Composite Images

**Files:**
- Read: `items/king.png`, `items/demon.png`, `items/angle.png`
- Create: `sprites/items/head/crown.png`
- Create: `sprites/items/head/demon_horns.png`
- Create: `sprites/items/head/halo.png`

**Step 1: Analyze accessory positions in composite images**

```python
py -3 -c "
from PIL import Image
# Open king.png and display size
for name in ['king', 'demon', 'angle']:
    img = Image.open(f'C:/Users/user/Documents/pixelRats/items/{name}.png')
    print(f'{name}.png: {img.size} mode={img.mode}')
"
```

**Step 2: Extract head region from each image**

Each composite image is ~256x256 or 320x320. The head accessory sits on top of the rat's head.
Strategy: Crop the top portion, remove rat body pixels (by comparing with base rat), keep only the accessory, resize to 64x64.

```python
py -3 << 'PYEOF'
from PIL import Image
import os

items_dir = 'C:/Users/user/Documents/pixelRats/items'
out_dir = 'C:/Users/user/Documents/pixelRats/sprites/items/head'

extractions = {
    'king.png': {'crop': (60, 0, 200, 80), 'out': 'crown.png'},
    'demon.png': {'crop': (50, 0, 210, 90), 'out': 'demon_horns.png'},
    'angle.png': {'crop': (70, 0, 200, 60), 'out': 'halo.png'},
}

for src_name, cfg in extractions.items():
    img = Image.open(os.path.join(items_dir, src_name)).convert('RGBA')
    # Crop approximate head accessory region
    cropped = img.crop(cfg['crop'])
    # Resize to 64x64 with nearest neighbor
    resized = cropped.resize((64, 64), Image.NEAREST)
    out_path = os.path.join(out_dir, cfg['out'])
    resized.save(out_path)
    print(f'Saved: {out_path}')
PYEOF
```

**Step 3: Verify extractions visually**

Read each output PNG to confirm the accessory looks correct.
**Expect:** May need manual crop coordinate adjustments per image.

**Step 4: Convert PNGs to .ase via Aseprite**

```bash
for f in crown demon_horns halo; do
    Aseprite.exe --batch sprites/items/head/${f}.png --save-as temp/${f}.ase
done
```
Then copy .ase files to sprites/items/head/ via Python.

---

### Task 10: Extract Back Accessories from Composite Images

**Files:**
- Read: `items/king.png`, `items/demon.png`, `items/angle.png`
- Create: `sprites/items/back/cape.png`
- Create: `sprites/items/back/dark_wings.png`
- Create: `sprites/items/back/white_wings.png`

**Same approach as Task 9**, but crop the back/wing region instead of head.

```python
extractions = {
    'king.png': {'crop': (120, 60, 280, 200), 'out': 'cape.png'},
    'demon.png': {'crop': (100, 40, 260, 180), 'out': 'dark_wings.png'},
    'angle.png': {'crop': (120, 40, 260, 170), 'out': 'white_wings.png'},
}
```

Verify visually, convert to .ase.

---

### Task 11: Define Anchor Points for All Animation Frames

**Files:**
- Create: `sprites/anchors/rat_anchors.json`

**Step 1: Create anchor point JSON**

```json
{
  "version": "1.0",
  "sprite_size": 64,
  "animations": {
    "idle": {
      "frames": 4,
      "frame_duration_ms": 250,
      "anchors_per_frame": [
        { "frame": 0, "head": {"x": 38, "y": 10}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 1, "head": {"x": 38, "y": 9},  "back": {"x": 18, "y": 15}, "background": {"x": 0, "y": 0} },
        { "frame": 2, "head": {"x": 38, "y": 10}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 3, "head": {"x": 39, "y": 10}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} }
      ]
    },
    "walking": {
      "frames": 4,
      "frame_duration_ms": 150,
      "anchors_per_frame": [
        { "frame": 0, "head": {"x": 40, "y": 10}, "back": {"x": 16, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 1, "head": {"x": 40, "y": 9},  "back": {"x": 16, "y": 15}, "background": {"x": 0, "y": 0} },
        { "frame": 2, "head": {"x": 40, "y": 10}, "back": {"x": 16, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 3, "head": {"x": 40, "y": 9},  "back": {"x": 16, "y": 15}, "background": {"x": 0, "y": 0} }
      ]
    },
    "eating": {
      "frames": 6,
      "frame_duration_ms": 200,
      "anchors_per_frame": [
        { "frame": 0, "head": {"x": 38, "y": 12}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 1, "head": {"x": 38, "y": 16}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 2, "head": {"x": 38, "y": 16}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 3, "head": {"x": 38, "y": 16}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 4, "head": {"x": 38, "y": 12}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} },
        { "frame": 5, "head": {"x": 38, "y": 10}, "back": {"x": 18, "y": 16}, "background": {"x": 0, "y": 0} }
      ]
    },
    "studying":  { "frames": 4, "frame_duration_ms": 500,  "anchors_per_frame": "TBD_after_sprite_creation" },
    "sad":       { "frames": 3, "frame_duration_ms": 400,  "anchors_per_frame": "TBD_after_sprite_creation" },
    "confused":  { "frames": 2, "frame_duration_ms": 500,  "anchors_per_frame": "TBD_after_sprite_creation" },
    "happy":     { "frames": 4, "frame_duration_ms": 200,  "anchors_per_frame": "TBD_after_sprite_creation" },
    "sleeping":  { "frames": 2, "frame_duration_ms": 800,  "anchors_per_frame": "TBD_after_sprite_creation" }
  }
}
```

Save to `sprites/anchors/rat_anchors.json`.
Anchors marked "TBD" will be filled in as each animation is created.

---

### Task 12: Verification — Composite Preview

**Files:**
- Read: all `sprites/rat/*.ase`, `sprites/items/head/*.png`, `sprites/items/back/*.png`
- Create: `sprites/preview/` (composite preview images)

**Step 1: Generate composite previews with Python**

For each animation's frame 0, overlay a head accessory + back accessory at the anchor point to verify alignment.

```python
py -3 << 'PYEOF'
from PIL import Image
import json, os

base_dir = 'C:/Users/user/Documents/pixelRats/sprites'
anchors = json.load(open(f'{base_dir}/anchors/rat_anchors.json'))

# Load idle frame 0 (from exported PNG or .ase first frame)
rat = Image.open(f'{base_dir}/rat/rat_base.png').convert('RGBA')
crown = Image.open(f'{base_dir}/items/head/crown.png').convert('RGBA')
cape = Image.open(f'{base_dir}/items/back/cape.png').convert('RGBA')

idle_anchors = anchors['animations']['idle']['anchors_per_frame'][0]

# Composite: background → rat → back accessory → head accessory
canvas = Image.new('RGBA', (64, 64), (0, 0, 0, 0))
canvas.paste(rat, (0, 0), rat)
# Overlay accessories at anchor points (centered on anchor)
bx, by = idle_anchors['back']['x'], idle_anchors['back']['y']
canvas.paste(cape, (bx - 32, by - 32), cape)
hx, hy = idle_anchors['head']['x'], idle_anchors['head']['y']
canvas.paste(crown, (hx - 32, hy - 32), crown)

os.makedirs(f'{base_dir}/preview', exist_ok=True)
canvas.save(f'{base_dir}/preview/idle_king_preview.png')
print('Saved preview')
PYEOF
```

**Step 2: Verify preview visually**

Read preview image. Crown should sit on rat's head, cape on back.
If misaligned → adjust anchor coordinates in rat_anchors.json and re-run.

---

## Task Execution Order

```
Task 1  → Directory setup (immediate)
Task 2  → Base rat sprite prep (immediate)
Task 3  → Idle animation (needs MCP or Lua)
Task 4  → Walking animation
Task 5  → Eating animation
Task 6  → Studying animation
Task 7  → Emotional animations (sad, confused, happy)
Task 8  → Sleeping animation
Task 9  → Head accessories extraction (Python PIL, immediate)
Task 10 → Back accessories extraction (Python PIL, immediate)
Task 11 → Anchor points JSON
Task 12 → Composite verification
```

**Parallelizable:** Tasks 9-10 can run in parallel with Tasks 3-8.

---

## Verified Animation Workflow Template (Tasks 3-8)

Since MCP tools require a session restart, all animation tasks use Aseprite CLI + Lua.
Aseprite can now **write directly to `sprites/rat/`** (CFA allowlist updated).

### Step A: Write Lua Script

Use Claude Code Write tool to create the Lua script directly in the project:

**Lua Template (proven pattern):**

```lua
-- {animation_name}.lua
-- Sprite: 64x64, RGBA
local sprite = Sprite(64, 64, ColorMode.RGB)

-- Load base rat
local base = Image{ fromFile="C:/Users/user/Documents/pixelRats/sprites/rat/rat_base.png" }

-- Frame 1: base pose
sprite.cels[1].image = base:clone()

-- Frame N: variations
-- Use cel.position = Point(x, y) for shifts (e.g. breathing = Point(0, -1))
-- Use image:drawPixel(x, y, Color(r, g, b, a)) for pixel edits
sprite:newEmptyFrame()
sprite.cels[2].image = base:clone()
sprite.cels[2].position = Point(0, -1)  -- example: shift up 1px

-- Set frame durations
for i = 1, #sprite.frames do
    sprite.frames[i].duration = 0.25  -- seconds
end

-- Add animation tag
local tag = sprite:newTag(1, #sprite.frames)
tag.name = "{animation_name}"

-- Save directly to sprites/rat/ (Aseprite is CFA-whitelisted)
sprite:saveAs("C:/Users/user/Documents/pixelRats/sprites/rat/rat_{animation_name}.ase")
print("Saved rat_{animation_name}.ase")
```

### Step B: Run Aseprite

```bash
"C:/Users/user/Documents/pixelRats/Aseprite-v1.3.17-x64/Aseprite.exe" \
  --batch --script "C:/Users/user/Documents/pixelRats/sprites/rat/{animation_name}.lua"
```

No copy step needed — file is saved directly to destination.

### Animation-Specific Pixel Techniques

| Technique | How | Use Case |
|-----------|-----|----------|
| Breathing | `cel.position = Point(0, -1)` | idle, studying |
| Jumping | `cel.position = Point(0, -2)` | happy |
| Head bob | shift head pixels down | eating, confused |
| Ear twitch | `image:drawPixel()` on ear area | idle |
| Trembling | shift 1px left/right alternating | sad |
| Zzz bubble | `image:drawPixel()` above head | sleeping |
| Question mark | `image:drawPixel()` above head | confused |
| Tears | single pixel drop from eye | sad |

---

## Accessory Extraction Workflow (Tasks 9-10)

Pure Python PIL — no Aseprite needed for extraction:

```python
py -3 << 'PYEOF'
from PIL import Image
import os

items = 'C:/Users/user/Documents/pixelRats/items'
out = 'C:/Users/user/Documents/pixelRats/sprites/items/{slot}'  # head or back

img = Image.open(f'{items}/{source}.png').convert('RGBA')
cropped = img.crop((left, top, right, bottom))  # coordinates need visual tuning
resized = cropped.resize((64, 64), Image.NEAREST)
resized.save(f'{out}/{name}.png')
PYEOF
```

**Important:** Crop coordinates in plan are **estimates**. Each source image requires:
1. Read image to view it
2. Identify accessory pixel region
3. Crop, inspect, adjust if needed

---

## Notes for Implementer

1. **MCP availability:** If `mcp__aseprite__*` tools are available (after restart), prefer MCP. Otherwise use the Lua workflow above.

2. **CFA workaround:** See "Verified Workflow" section above. All writes → `py -3` or Write tool.

3. **Crop coordinates are estimates.** The accessory extraction crops (Tasks 9-10) will likely need visual inspection and adjustment. The source images vary in composition.

4. **Anchor coordinates are estimates.** All anchor points need validation via composite preview (Task 12). Expect 2-3 iterations of adjustment.

5. **Animation detail level:** The Lua scripts create frame structure and timing. For complex pixel-level animation (leg movement, facial expressions), each frame may need individual `drawPixel()` calls based on the base sprite layout.

6. **Rat orientation:** Faces LEFT. Ears top-left (~x:35-45, y:5-15). Tail extends right. Legs at bottom.
