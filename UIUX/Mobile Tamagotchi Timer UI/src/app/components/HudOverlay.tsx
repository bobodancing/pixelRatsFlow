import { useState } from "react";
import { Settings, User, Heart } from "lucide-react";

const CREAM = "#F0E6D3";
const GOLD = "#D4A844";
const GLASS_BG = "rgba(45, 27, 46, 0.65)";
const GLASS_BORDER = "rgba(139, 77, 139, 0.3)";

const timerOptions = [
  { label: "25 min", value: 25 },
  { label: "50 min", value: 50 },
  { label: "100 min", value: 100 },
];

function GlassPanel({
  children,
  className = "",
  style = {},
}: {
  children: React.ReactNode;
  className?: string;
  style?: React.CSSProperties;
}) {
  return (
    <div
      className={`rounded-2xl ${className}`}
      style={{
        background: GLASS_BG,
        backdropFilter: "blur(16px)",
        WebkitBackdropFilter: "blur(16px)",
        border: `1px solid ${GLASS_BORDER}`,
        ...style,
      }}
    >
      {children}
    </div>
  );
}

export function HudOverlay() {
  const [selectedTimer, setSelectedTimer] = useState(50);
  const moodPercent = 72;

  return (
    <div className="absolute inset-0 pointer-events-none flex flex-col" style={{ zIndex: 20 }}>
      {/* Top bar */}
      <div className="flex items-start justify-between p-4 pt-12 pointer-events-auto">
        {/* Cheese counter */}
        <GlassPanel className="flex items-center gap-2 px-4 py-2">
          <span className="text-[20px]" role="img" aria-label="cheese">🧀</span>
          <span style={{ color: GOLD, fontFamily: "sans-serif", fontSize: 17, letterSpacing: 0.5 }}>
            1,240
          </span>
        </GlassPanel>

        {/* Mood bar */}
        <GlassPanel className="flex items-center gap-2.5 px-4 py-2">
          <Heart size={16} fill="#E8758A" color="#E8758A" />
          <div className="flex flex-col gap-0.5">
            <div
              className="rounded-full overflow-hidden"
              style={{ width: 80, height: 8, background: "rgba(255,255,255,0.1)" }}
            >
              <div
                className="h-full rounded-full"
                style={{
                  width: `${moodPercent}%`,
                  background: "linear-gradient(90deg, #E8758A, #E85A6A)",
                }}
              />
            </div>
            <span style={{ color: CREAM, fontFamily: "sans-serif", fontSize: 11, opacity: 0.8 }}>
              Happy
            </span>
          </div>
        </GlassPanel>
      </div>

      {/* Spacer */}
      <div className="flex-1" />

      {/* Bottom area */}
      <div className="flex flex-col items-center gap-4 pb-8 px-4 pointer-events-auto">
        {/* Timer selectors */}
        <div className="flex items-center gap-3">
          {timerOptions.map((opt) => {
            const isActive = selectedTimer === opt.value;
            return (
              <button
                key={opt.value}
                onClick={() => setSelectedTimer(opt.value)}
                className="rounded-full px-5 py-2.5 transition-all duration-300 cursor-pointer"
                style={{
                  background: isActive ? "rgba(139, 77, 139, 0.45)" : GLASS_BG,
                  backdropFilter: "blur(16px)",
                  WebkitBackdropFilter: "blur(16px)",
                  border: isActive
                    ? "1.5px solid rgba(139, 77, 139, 0.8)"
                    : `1px solid ${GLASS_BORDER}`,
                  boxShadow: isActive
                    ? "0 0 16px rgba(139, 77, 139, 0.4), inset 0 0 12px rgba(139, 77, 139, 0.15)"
                    : "none",
                  color: isActive ? "#E8D0F0" : CREAM,
                  fontFamily: "sans-serif",
                  fontSize: 14,
                  letterSpacing: 0.3,
                }}
              >
                {opt.label}
              </button>
            );
          })}
        </div>

        {/* Bottom row: profile + settings */}
        <div className="flex items-center justify-between w-full px-2">
          <button
            className="rounded-full p-2.5 cursor-pointer"
            style={{
              background: GLASS_BG,
              backdropFilter: "blur(12px)",
              border: `1px solid ${GLASS_BORDER}`,
            }}
          >
            <div className="flex items-center justify-center" style={{ width: 22, height: 22 }}>
              <svg viewBox="0 0 24 24" width="20" height="20" fill="none">
                {/* Simple rat face icon */}
                <circle cx="12" cy="13" r="8" fill="#8A8A8A" stroke="#3A3A3A" strokeWidth="1.5" />
                <circle cx="6" cy="7" r="4" fill="#FFB0B0" stroke="#3A3A3A" strokeWidth="1" />
                <circle cx="18" cy="7" r="4" fill="#FFB0B0" stroke="#3A3A3A" strokeWidth="1" />
                <circle cx="9.5" cy="11.5" r="1.2" fill="#2A2A2A" />
                <circle cx="14.5" cy="11.5" r="1.2" fill="#2A2A2A" />
                <ellipse cx="12" cy="14.5" rx="1.5" ry="1" fill="#FFB0B0" />
                <line x1="5" y1="14" x2="1" y2="13" stroke="#3A3A3A" strokeWidth="0.8" />
                <line x1="5" y1="15.5" x2="1" y2="15.5" stroke="#3A3A3A" strokeWidth="0.8" />
                <line x1="19" y1="14" x2="23" y2="13" stroke="#3A3A3A" strokeWidth="0.8" />
                <line x1="19" y1="15.5" x2="23" y2="15.5" stroke="#3A3A3A" strokeWidth="0.8" />
              </svg>
            </div>
          </button>

          {/* Start button (center) */}
          <button
            className="rounded-full px-8 py-3 cursor-pointer transition-all duration-300"
            style={{
              background: "linear-gradient(135deg, #8B4D8B, #6A3A6A)",
              border: "1.5px solid rgba(180, 120, 180, 0.5)",
              boxShadow: "0 0 20px rgba(139, 77, 139, 0.4), 0 4px 12px rgba(0,0,0,0.3)",
              color: "#F0E6D3",
              fontFamily: "sans-serif",
              fontSize: 16,
              letterSpacing: 1,
            }}
          >
            START
          </button>

          <button
            className="rounded-full p-2.5 cursor-pointer"
            style={{
              background: GLASS_BG,
              backdropFilter: "blur(12px)",
              border: `1px solid ${GLASS_BORDER}`,
            }}
          >
            <Settings size={20} color={CREAM} strokeWidth={1.8} />
          </button>
        </div>
      </div>

      {/* Vignette overlay */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          background:
            "radial-gradient(ellipse at center, transparent 50%, rgba(30, 15, 30, 0.5) 100%)",
        }}
      />
    </div>
  );
}
