export function PixelRat() {
  return (
    <img
      src="/pixelrats.png"
      alt="Pixel rat"
      width={128}
      height={128}
      style={{ imageRendering: 'pixelated' }}
      className="pixel-art"
      draggable={false}
    />
  );
}
