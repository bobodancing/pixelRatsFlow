import { useRef, useEffect, useCallback } from "react";

const TILE = 32;
const COLS = 10;
const ROWS = 12;

// Color palette
const FLOOR_LIGHT = "#C49A6C";
const FLOOR_DARK = "#A8844E";
const WALL_COLOR = "#3D2640";
const WALL_TRIM = "#5A3A5E";
const DESK_TOP = "#8B6843";
const DESK_LEG = "#6B4E2F";
const LAMP_BASE = "#5A4A3A";
const LAMP_SHADE = "#D4A844";
const LAMP_GLOW = "rgba(255, 210, 100, 0.15)";
const BOOK_COLORS = ["#C25454", "#5478C2", "#54A854", "#C2A854", "#A854C2", "#C27654"];
const SHELF_COLOR = "#7A5A3A";
const RUG_COLOR = "#B8727A";
const RUG_EDGE = "#9A5A62";
const PLANT_POT = "#8B5E3C";
const PLANT_GREEN_1 = "#4A8C4A";
const PLANT_GREEN_2 = "#3A7A3A";
const PLANT_GREEN_3 = "#5AA85A";

export function PixelRoom() {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  const drawRoom = useCallback((ctx: CanvasRenderingContext2D, w: number, h: number) => {
    const scale = Math.min(w / (COLS * TILE), h / (ROWS * TILE));
    const offsetX = (w - COLS * TILE * scale) / 2;
    const offsetY = (h - ROWS * TILE * scale) / 2;

    ctx.save();
    ctx.translate(offsetX, offsetY);
    ctx.scale(scale, scale);

    // Floor
    for (let r = 3; r < ROWS; r++) {
      for (let c = 0; c < COLS; c++) {
        ctx.fillStyle = (r + c) % 2 === 0 ? FLOOR_LIGHT : FLOOR_DARK;
        ctx.fillRect(c * TILE, r * TILE, TILE, TILE);
        // subtle floor grain
        ctx.fillStyle = "rgba(0,0,0,0.04)";
        for (let i = 0; i < 3; i++) {
          const gx = c * TILE + Math.random() * TILE;
          const gy = r * TILE + Math.random() * TILE;
          ctx.fillRect(gx, gy, 2, 1);
        }
      }
    }

    // Wall
    for (let c = 0; c < COLS; c++) {
      for (let r = 0; r < 3; r++) {
        ctx.fillStyle = WALL_COLOR;
        ctx.fillRect(c * TILE, r * TILE, TILE, TILE);
      }
    }
    // Wall trim
    ctx.fillStyle = WALL_TRIM;
    ctx.fillRect(0, 2.7 * TILE, COLS * TILE, TILE * 0.3);

    // Baseboard
    ctx.fillStyle = "#4A2E4E";
    ctx.fillRect(0, 3 * TILE, COLS * TILE, 4);

    // --- Rug (center) ---
    const rugCX = 5 * TILE;
    const rugCY = 8 * TILE;
    const rugRX = 2.2 * TILE;
    const rugRY = 1.6 * TILE;
    ctx.fillStyle = RUG_EDGE;
    ctx.beginPath();
    ctx.ellipse(rugCX, rugCY, rugRX + 4, rugRY + 4, 0, 0, Math.PI * 2);
    ctx.fill();
    ctx.fillStyle = RUG_COLOR;
    ctx.beginPath();
    ctx.ellipse(rugCX, rugCY, rugRX, rugRY, 0, 0, Math.PI * 2);
    ctx.fill();
    // Rug pattern - concentric ring
    ctx.strokeStyle = "rgba(255,220,200,0.2)";
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.ellipse(rugCX, rugCY, rugRX * 0.65, rugRY * 0.65, 0, 0, Math.PI * 2);
    ctx.stroke();

    // --- Bookshelf (right wall) ---
    const bx = 7.8 * TILE;
    const by = 3.2 * TILE;
    const bw = 2 * TILE;
    const bh = 3.2 * TILE;
    ctx.fillStyle = SHELF_COLOR;
    ctx.fillRect(bx, by, bw, bh);
    // Shelf dividers
    ctx.fillStyle = "#6A4A2A";
    ctx.fillRect(bx, by + bh * 0.33, bw, 3);
    ctx.fillRect(bx, by + bh * 0.66, bw, 3);
    // Shadow
    ctx.fillStyle = "rgba(0,0,0,0.15)";
    ctx.fillRect(bx, by, bw, 4);
    // Books on each shelf
    for (let shelf = 0; shelf < 3; shelf++) {
      const sy = by + shelf * bh * 0.33 + 6;
      const sh = bh * 0.33 - 9;
      let bxOff = bx + 4;
      for (let b = 0; b < 5; b++) {
        const bookW = 6 + Math.random() * 5;
        ctx.fillStyle = BOOK_COLORS[b % BOOK_COLORS.length];
        ctx.fillRect(bxOff, sy, bookW, sh);
        // Book spine line
        ctx.fillStyle = "rgba(255,255,255,0.15)";
        ctx.fillRect(bxOff + bookW / 2 - 0.5, sy + 2, 1, sh - 4);
        bxOff += bookW + 2;
      }
    }
    // Bookshelf legs
    ctx.fillStyle = DESK_LEG;
    ctx.fillRect(bx + 2, by + bh, 4, 6);
    ctx.fillRect(bx + bw - 6, by + bh, 4, 6);

    // --- Desk (left side) ---
    const dx = 0.5 * TILE;
    const dy = 3.8 * TILE;
    const dw = 3.5 * TILE;
    const dh = 2.2 * TILE;
    // Desk shadow
    ctx.fillStyle = "rgba(0,0,0,0.12)";
    ctx.fillRect(dx + 4, dy + dh + 2, dw, 6);
    // Desk top
    ctx.fillStyle = DESK_TOP;
    ctx.fillRect(dx, dy + dh - 8, dw, 8);
    // Desk surface highlight
    ctx.fillStyle = "rgba(255,255,255,0.08)";
    ctx.fillRect(dx + 2, dy + dh - 7, dw - 4, 3);
    // Desk front panel
    ctx.fillStyle = "#7A5234";
    ctx.fillRect(dx, dy + dh, dw, TILE * 0.6);
    // Drawer
    ctx.fillStyle = "#6B4829";
    ctx.fillRect(dx + dw * 0.15, dy + dh + 4, dw * 0.35, TILE * 0.4);
    ctx.fillStyle = "#D4A844";
    ctx.fillRect(dx + dw * 0.3, dy + dh + TILE * 0.2, 6, 3);
    // Desk legs
    ctx.fillStyle = DESK_LEG;
    ctx.fillRect(dx + 4, dy + dh + TILE * 0.6, 5, TILE * 0.5);
    ctx.fillRect(dx + dw - 9, dy + dh + TILE * 0.6, 5, TILE * 0.5);

    // --- Lamp on desk ---
    const lx = dx + dw * 0.7;
    const ly = dy + dh - 8;
    // Lamp glow circle
    const gradient = ctx.createRadialGradient(lx + 5, ly - 18, 4, lx + 5, ly - 18, TILE * 2.5);
    gradient.addColorStop(0, "rgba(255, 210, 100, 0.25)");
    gradient.addColorStop(0.5, "rgba(255, 200, 80, 0.08)");
    gradient.addColorStop(1, "rgba(255, 200, 80, 0)");
    ctx.fillStyle = gradient;
    ctx.beginPath();
    ctx.arc(lx + 5, ly - 18, TILE * 2.5, 0, Math.PI * 2);
    ctx.fill();
    // Lamp base
    ctx.fillStyle = LAMP_BASE;
    ctx.fillRect(lx, ly - 4, 10, 4);
    // Lamp pole
    ctx.fillStyle = "#7A6A5A";
    ctx.fillRect(lx + 4, ly - 24, 3, 20);
    // Lamp shade
    ctx.fillStyle = LAMP_SHADE;
    ctx.beginPath();
    ctx.moveTo(lx - 2, ly - 24);
    ctx.lineTo(lx + 12, ly - 24);
    ctx.lineTo(lx + 9, ly - 32);
    ctx.lineTo(lx + 1, ly - 32);
    ctx.closePath();
    ctx.fill();
    // Lamp light dot
    ctx.fillStyle = "#FFF4D0";
    ctx.fillRect(lx + 4, ly - 24, 3, 2);

    // Items on desk
    // Small paper/notebook
    ctx.fillStyle = "#E8DDD0";
    ctx.fillRect(dx + 12, dy + dh - 18, 18, 12);
    ctx.fillStyle = "#D0C4B4";
    ctx.fillRect(dx + 14, dy + dh - 16, 14, 1);
    ctx.fillRect(dx + 14, dy + dh - 13, 10, 1);
    ctx.fillRect(dx + 14, dy + dh - 10, 12, 1);
    // Small mug
    ctx.fillStyle = "#C25454";
    ctx.fillRect(dx + 36, dy + dh - 14, 8, 8);
    ctx.fillStyle = "rgba(255,255,255,0.2)";
    ctx.fillRect(dx + 37, dy + dh - 13, 2, 5);
    // Steam
    ctx.fillStyle = "rgba(255,255,255,0.15)";
    ctx.fillRect(dx + 38, dy + dh - 18, 2, 3);
    ctx.fillRect(dx + 41, dy + dh - 20, 2, 3);

    // --- Potted plant (bottom-right) ---
    const px = 8.5 * TILE;
    const py = 9.5 * TILE;
    // Pot
    ctx.fillStyle = PLANT_POT;
    ctx.fillRect(px - 8, py, 20, 16);
    ctx.fillStyle = "#7A4E2C";
    ctx.fillRect(px - 10, py - 2, 24, 4);
    // Soil
    ctx.fillStyle = "#4A3020";
    ctx.fillRect(px - 6, py, 16, 3);
    // Leaves
    const drawLeaf = (lx: number, ly: number, angle: number, size: number, color: string) => {
      ctx.save();
      ctx.translate(lx, ly);
      ctx.rotate(angle);
      ctx.fillStyle = color;
      ctx.beginPath();
      ctx.ellipse(0, -size / 2, size * 0.3, size / 2, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    };
    drawLeaf(px + 2, py - 6, -0.3, 18, PLANT_GREEN_1);
    drawLeaf(px + 6, py - 4, 0.4, 16, PLANT_GREEN_2);
    drawLeaf(px - 2, py - 8, -0.6, 14, PLANT_GREEN_3);
    drawLeaf(px + 8, py - 8, 0.2, 12, PLANT_GREEN_1);
    drawLeaf(px, py - 12, 0, 15, PLANT_GREEN_2);

    // --- Wall decorations ---
    // Small picture frame on wall
    ctx.fillStyle = "#5A3A40";
    ctx.fillRect(3.5 * TILE, 1 * TILE, TILE * 1.5, TILE * 1.2);
    ctx.fillStyle = "#3A2A38";
    ctx.fillRect(3.5 * TILE + 4, 1 * TILE + 4, TILE * 1.5 - 8, TILE * 1.2 - 8);
    // Little landscape inside
    ctx.fillStyle = "#6AA86A";
    ctx.fillRect(3.5 * TILE + 6, 1 * TILE + TILE * 0.5, TILE * 1.5 - 12, TILE * 0.5);
    ctx.fillStyle = "#88C0D0";
    ctx.fillRect(3.5 * TILE + 6, 1 * TILE + 6, TILE * 1.5 - 12, TILE * 0.35);

    // Small window on wall (right side)
    ctx.fillStyle = "#4A3050";
    ctx.fillRect(6.5 * TILE, 0.6 * TILE, TILE * 1.2, TILE * 1.8);
    ctx.fillStyle = "#2A1830";
    ctx.fillRect(6.5 * TILE + 3, 0.6 * TILE + 3, TILE * 1.2 - 6, TILE * 1.8 - 6);
    // Moonlight through window
    ctx.fillStyle = "rgba(140, 160, 200, 0.2)";
    ctx.fillRect(6.5 * TILE + 5, 0.6 * TILE + 5, TILE * 1.2 - 10, TILE * 1.8 - 10);
    // Window cross
    ctx.fillStyle = "#4A3050";
    ctx.fillRect(6.5 * TILE + TILE * 0.55, 0.6 * TILE + 3, 3, TILE * 1.8 - 6);
    ctx.fillRect(6.5 * TILE + 3, 0.6 * TILE + TILE * 0.85, TILE * 1.2 - 6, 3);
    // Stars in window
    ctx.fillStyle = "#E8E0D0";
    ctx.fillRect(6.8 * TILE, 1 * TILE, 2, 2);
    ctx.fillRect(7.3 * TILE, 0.8 * TILE, 2, 2);

    // Warm ambient light overlay from lamp
    const ambientGrad = ctx.createRadialGradient(
      dx + dw * 0.7, dy + dh - 20, 10,
      dx + dw * 0.7, dy + dh - 20, TILE * 6
    );
    ambientGrad.addColorStop(0, "rgba(255, 200, 100, 0.06)");
    ambientGrad.addColorStop(1, "rgba(255, 200, 100, 0)");
    ctx.fillStyle = ambientGrad;
    ctx.fillRect(0, 0, COLS * TILE, ROWS * TILE);

    ctx.restore();
  }, []);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const parent = canvas.parentElement;
    if (!parent) return;

    const resize = () => {
      const dpr = window.devicePixelRatio || 1;
      const w = parent.clientWidth;
      const h = parent.clientHeight;
      canvas.width = w * dpr;
      canvas.height = h * dpr;
      canvas.style.width = `${w}px`;
      canvas.style.height = `${h}px`;
      const ctx = canvas.getContext("2d");
      if (!ctx) return;
      ctx.scale(dpr, dpr);
      ctx.imageSmoothingEnabled = false;
      drawRoom(ctx, w, h);
    };

    resize();
    window.addEventListener("resize", resize);
    return () => window.removeEventListener("resize", resize);
  }, [drawRoom]);

  return (
    <canvas
      ref={canvasRef}
      className="absolute inset-0 w-full h-full"
      style={{ imageRendering: "pixelated" }}
    />
  );
}
