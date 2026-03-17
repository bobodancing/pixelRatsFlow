interface PixelRatProps {
  withCrown?: boolean;
}

export function PixelRat({ withCrown = false }: PixelRatProps) {
  return (
    <div className="relative inline-block">
      {withCrown && (
        <svg
          width="24"
          height="10"
          viewBox="0 0 24 10"
          className="absolute -top-2 left-1/2 -translate-x-1/2"
          style={{ imageRendering: 'pixelated', zIndex: 2 }}
        >
          <rect x="4" y="4" width="16" height="4" fill="#FFD700" />
          <rect x="4" y="0" width="4" height="4" fill="#FFD700" />
          <rect x="10" y="0" width="4" height="4" fill="#FFD700" />
          <rect x="16" y="0" width="4" height="4" fill="#FFD700" />
          <rect x="11" y="2" width="2" height="2" fill="#FF0000" />
        </svg>
      )}
      <img
        src="/pixelrats.png"
        alt="Pixel rat"
        width={24}
        height={24}
        style={{ imageRendering: 'pixelated' }}
        draggable={false}
      />
    </div>
  );
}
