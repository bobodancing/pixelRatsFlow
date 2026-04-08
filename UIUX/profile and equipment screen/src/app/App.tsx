import { Heart, Handshake, Flame, Clock } from 'lucide-react';
import { PixelRat } from './components/PixelRat';
import { EquipmentSlot } from './components/EquipmentSlot';
import { InventoryGrid } from './components/InventoryGrid';
import { StatCard } from './components/StatCard';

export default function App() {
  // Mock inventory data with pixel-art accessory icons
  const inventoryItems = [
    { id: 1, icon: '👑', rarity: 'legendary' as const },
    { id: 2, icon: '🎩', rarity: 'epic' as const },
    { id: 3, icon: '🎀', rarity: 'rare' as const },
    { id: 4, icon: '👒', rarity: 'common' as const },
    { id: 5, icon: '🦇', rarity: 'epic' as const },
    { id: 6, icon: '😈', rarity: 'rare' as const },
    null, // empty slot
    { id: 8, icon: '⭐', rarity: 'legendary' as const },
    { id: 9, icon: '🌙', rarity: 'rare' as const },
    { id: 10, icon: '🔮', rarity: 'epic' as const },
    null, // empty slot
    { id: 12, icon: '💫', rarity: 'common' as const },
  ];

  return (
    <div 
      className="min-h-screen flex items-center justify-center p-4"
      style={{ backgroundColor: '#2D1B2E' }}
    >
      {/* Mobile Container */}
      <div 
        className="relative w-full max-w-[400px] h-[867px] flex flex-col overflow-hidden"
        style={{ aspectRatio: '9/19.5' }}
      >
        {/* Top Bar */}
        <div className="px-6 pt-6 pb-3 space-y-2">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <h1 className="text-xl font-bold" style={{ color: '#F5F1E8' }}>
                Player
              </h1>
              <div className="
                px-3 py-1 rounded-full text-xs font-medium
                bg-blue-500/20 text-blue-200
                shadow-[0_0_15px_rgba(59,130,246,0.3)]
                border border-blue-400/30
              ">
                🤝 Friend
              </div>
            </div>
            <div className="flex items-center gap-1.5 px-3 py-1 rounded-full bg-amber-500/20 border border-amber-400/30">
              <span className="text-base">🧀</span>
              <span className="text-sm font-bold text-amber-100">1,240</span>
            </div>
          </div>
          
          {/* Trust Progress Bar */}
          <div className="space-y-1">
            <div className="flex justify-between text-[10px] text-purple-200/60">
              <span>Trust</span>
              <span>245/1000 to Partner</span>
            </div>
            <div className="h-2 rounded-full bg-purple-950/50 overflow-hidden">
              <div 
                className="h-full rounded-full bg-gradient-to-r from-purple-500 to-pink-500"
                style={{ width: '24.5%' }}
              />
            </div>
          </div>
        </div>

        {/* Main Content Area */}
        <div className="flex-1 flex flex-col px-4 gap-4">
          {/* Rat Display Section */}
          <div className="relative flex items-center justify-center py-6">
            {/* Platform */}
            <div className="absolute bottom-6 w-48 h-4 rounded-full bg-purple-500/20 blur-xl" />
            <div className="absolute bottom-6 w-40 h-3 rounded-full bg-purple-600/30 blur-md" />
            
            {/* Rat with Equipment */}
            <div className="relative z-10">
              <PixelRat />
            </div>

            {/* Equipment Slots */}
            <EquipmentSlot 
              label="Head" 
              position={{ x: -60, y: 20 }} 
              isEquipped={true}
            />
            <EquipmentSlot 
              label="Back" 
              position={{ x: 180, y: 50 }} 
              isEquipped={true}
            />
            <EquipmentSlot 
              label="Background" 
              position={{ x: 40, y: 160 }} 
              isEquipped={false}
            />
          </div>

          {/* Inventory Panel */}
          <div className="
            rounded-2xl backdrop-blur-xl
            bg-purple-900/20 border border-purple-400/20
            shadow-lg
          ">
            <div className="px-4 py-3 border-b border-purple-400/20">
              <h2 className="text-sm font-semibold text-purple-100">Inventory</h2>
            </div>
            <InventoryGrid items={inventoryItems} />
          </div>

          {/* Stats Grid */}
          <div className="grid grid-cols-2 gap-2 pb-6">
            <StatCard 
              icon={Heart} 
              label="Mood" 
              value="72/100"
            />
            <StatCard 
              icon={Handshake} 
              label="Trust" 
              value="245/1000"
            />
            <StatCard 
              icon={Flame} 
              label="Streak" 
              value="5 days"
            />
            <StatCard 
              icon={Clock} 
              label="Total Focus" 
              value="12.5 hrs"
            />
          </div>
        </div>
      </div>
    </div>
  );
}
