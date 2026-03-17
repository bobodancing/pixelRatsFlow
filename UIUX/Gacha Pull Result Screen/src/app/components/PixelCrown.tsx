export function PixelCrown() {
  return (
    <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
      {/* Crown outline in golden yellow */}
      <rect x="4" y="20" width="24" height="4" fill="#FFD700" />
      <rect x="6" y="24" width="20" height="4" fill="#FFA500" />
      
      {/* Crown points */}
      <rect x="6" y="16" width="4" height="4" fill="#FFD700" />
      <rect x="14" y="12" width="4" height="4" fill="#FFD700" />
      <rect x="22" y="16" width="4" height="4" fill="#FFD700" />
      
      {/* Crown peaks */}
      <rect x="6" y="12" width="4" height="4" fill="#FFD700" />
      <rect x="14" y="8" width="4" height="4" fill="#FFD700" />
      <rect x="22" y="12" width="4" height="4" fill="#FFD700" />
      
      {/* Jewels */}
      <rect x="8" y="14" width="2" height="2" fill="#FF0000" />
      <rect x="15" y="10" width="2" height="2" fill="#0000FF" />
      <rect x="24" y="14" width="2" height="2" fill="#FF0000" />
      
      {/* Highlights */}
      <rect x="6" y="20" width="2" height="2" fill="#FFFF00" />
      <rect x="14" y="12" width="2" height="2" fill="#FFFF00" />
      <rect x="22" y="20" width="2" height="2" fill="#FFFF00" />
      
      {/* Shadow/depth */}
      <rect x="6" y="26" width="20" height="2" fill="#CC8400" />
      <rect x="10" y="22" width="2" height="2" fill="#CC8400" />
      <rect x="20" y="22" width="2" height="2" fill="#CC8400" />
    </svg>
  );
}
