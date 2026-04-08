interface InventoryItem {
  id: number;
  icon: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
}

interface InventoryGridProps {
  items: (InventoryItem | null)[];
}

export function InventoryGrid({ items }: InventoryGridProps) {
  const rarityStyles = {
    common: 'border-gray-500',
    rare: 'border-blue-500',
    epic: 'border-purple-500',
    legendary: 'border-yellow-500 shadow-[0_0_10px_rgba(234,179,8,0.5)]',
  };

  return (
    <div className="grid grid-cols-4 gap-2 p-4">
      {items.map((item, index) => (
        <div
          key={index}
          className={`
            aspect-square rounded-lg
            flex items-center justify-center
            transition-all duration-200
            ${item 
              ? `bg-[#3D2A3E] border-2 ${rarityStyles[item.rarity]} hover:scale-105 cursor-pointer` 
              : 'border-2 border-dashed border-purple-400/20 bg-purple-950/10'
            }
          `}
        >
          {item && (
            <span className="text-2xl" style={{ imageRendering: 'pixelated' }}>
              {item.icon}
            </span>
          )}
        </div>
      ))}
    </div>
  );
}
