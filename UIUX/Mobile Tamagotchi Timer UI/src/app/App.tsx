import { PixelRoom } from "./components/PixelRoom";
import { MouseCharacter } from "./components/MouseCharacter";
import { HudOverlay } from "./components/HudOverlay";

export default function App() {
  return (
    <div
      className="w-full h-full flex items-center justify-center"
      style={{ background: "#1A0E1B" }}
    >
      {/* Mobile frame with 9:19.5 aspect ratio */}
      <div
        className="relative overflow-hidden"
        style={{
          aspectRatio: "9 / 19.5",
          maxHeight: "100vh",
          maxWidth: "100vw",
          height: "100vh",
          background: "#2D1B2E",
        }}
      >
        {/* Pixel art room scene */}
        <PixelRoom />

        {/* Animated mouse character */}
        <MouseCharacter />

        {/* Glassmorphism HUD overlay */}
        <HudOverlay />
      </div>
    </div>
  );
}
