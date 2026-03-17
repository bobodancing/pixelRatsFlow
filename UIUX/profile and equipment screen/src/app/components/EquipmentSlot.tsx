interface EquipmentSlotProps {
  label: string;
  position: { x: number; y: number };
  isEquipped: boolean;
}

export function EquipmentSlot({ label, position, isEquipped }: EquipmentSlotProps) {
  return (
    <div
      className="absolute flex items-center gap-2"
      style={{ left: `${position.x}px`, top: `${position.y}px` }}
    >
      <div className={`
        w-10 h-10 rounded-full border-2 
        ${isEquipped ? 'border-purple-400' : 'border-dashed border-purple-400/40'}
        flex items-center justify-center
        bg-purple-950/30
      `}>
        {isEquipped && (
          <div className="w-2 h-2 rounded-full bg-purple-400 animate-pulse" />
        )}
      </div>
      <span className="text-xs text-purple-200/80 font-medium whitespace-nowrap">
        {label}
      </span>
    </div>
  );
}
