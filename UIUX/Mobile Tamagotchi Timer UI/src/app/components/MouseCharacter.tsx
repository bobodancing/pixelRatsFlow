import { useState, useEffect } from "react";

export function MouseCharacter() {
  const [pos, setPos] = useState({ x: 38, y: 48 });
  const [flip, setFlip] = useState(false);
  const [bobPhase, setBobPhase] = useState(0);

  useEffect(() => {
    // Gentle wandering animation
    const interval = setInterval(() => {
      setPos((prev) => {
        const dx = (Math.random() - 0.5) * 6;
        const dy = (Math.random() - 0.5) * 4;
        const nx = Math.max(15, Math.min(70, prev.x + dx));
        const ny = Math.max(35, Math.min(68, prev.y + dy));
        if (dx > 0.5) setFlip(false);
        if (dx < -0.5) setFlip(true);
        return { x: nx, y: ny };
      });
    }, 2000);

    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const bobInterval = setInterval(() => {
      setBobPhase((p) => (p + 1) % 4);
    }, 400);
    return () => clearInterval(bobInterval);
  }, []);

  const bobY = bobPhase < 2 ? 0 : -2;

  return (
    <div
      className="absolute pointer-events-none"
      style={{
        left: `${pos.x}%`,
        top: `${pos.y}%`,
        transform: `translate(-50%, -50%) scaleX(${flip ? -1 : 1}) translateY(${bobY}px)`,
        transition: "left 2s ease-in-out, top 2s ease-in-out",
        width: "22%",
        zIndex: 10,
        imageRendering: "pixelated",
      }}
    >
      <img
        src="/pixelrats.png"
        alt="Pixel rat"
        className="w-full h-auto relative"
        style={{ imageRendering: "pixelated", zIndex: 1 }}
        draggable={false}
      />
      {/* Tiny shadow underneath */}
      <div
        className="absolute mx-auto rounded-full"
        style={{
          bottom: "-6%",
          left: "15%",
          width: "70%",
          height: "10%",
          background: "rgba(0,0,0,0.2)",
          filter: "blur(3px)",
          zIndex: -1,
        }}
      />
    </div>
  );
}
