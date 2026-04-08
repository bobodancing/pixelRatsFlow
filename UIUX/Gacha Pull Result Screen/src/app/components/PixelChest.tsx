export function PixelChest() {
  return (
    <svg width="80" height="64" viewBox="0 0 80 64" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Chest body - wooden */}
      <rect x="8" y="24" width="64" height="40" fill="#8B4513" />
      <rect x="12" y="28" width="56" height="32" fill="#A0522D" />
      
      {/* Chest lid - open position */}
      <rect x="8" y="8" width="64" height="20" fill="#8B4513" />
      <rect x="12" y="12" width="56" height="12" fill="#A0522D" />
      
      {/* Golden bands */}
      <rect x="8" y="32" width="64" height="4" fill="#FFD700" />
      <rect x="8" y="52" width="64" height="4" fill="#FFD700" />
      <rect x="36" y="24" width="8" height="40" fill="#FFD700" />
      
      {/* Lock detail */}
      <rect x="38" y="44" width="4" height="8" fill="#FFA500" />
      <rect x="36" y="42" width="8" height="4" fill="#FFA500" />
      
      {/* Wood texture lines */}
      <rect x="16" y="30" width="48" height="2" fill="#654321" opacity="0.3" />
      <rect x="16" y="38" width="48" height="2" fill="#654321" opacity="0.3" />
      <rect x="16" y="46" width="48" height="2" fill="#654321" opacity="0.3" />
      <rect x="16" y="54" width="48" height="2" fill="#654321" opacity="0.3" />
      
      {/* Highlights */}
      <rect x="14" y="28" width="4" height="4" fill="#D2691E" />
      <rect x="8" y="32" width="4" height="2" fill="#FFFF00" />
      <rect x="8" y="52" width="4" height="2" fill="#FFFF00" />
    </svg>
  );
}
