import { motion } from "motion/react";
import { PixelCrown } from "./PixelCrown";
import { PixelChest } from "./PixelChest";
import { PixelRat } from "./PixelRat";
import { Sparkles } from "lucide-react";

export function GachaReveal() {
  return (
    <div className="relative w-full h-full overflow-hidden flex flex-col">
      {/* Top bar with cheese balance */}
      <div className="absolute top-6 right-6 z-50">
        <div className="px-4 py-2 rounded-full bg-white/10 backdrop-blur-md border border-white/20 shadow-lg">
          <span className="text-[#F5DEB3] font-bold text-sm">🧀 1,120</span>
        </div>
      </div>

      {/* Main content container */}
      <div className="flex-1 flex flex-col items-center justify-center relative px-6 pt-20 pb-8">
        {/* Radial glow effect from center */}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-gradient-radial from-amber-400/30 via-amber-600/10 to-transparent rounded-full blur-3xl pointer-events-none" />
        
        {/* Floating sparkle particles */}
        {[...Array(12)].map((_, i) => (
          <motion.div
            key={i}
            className="absolute"
            initial={{ 
              opacity: 0,
              x: 0,
              y: 0,
              scale: 0
            }}
            animate={{
              opacity: [0, 1, 0],
              x: [0, Math.cos(i * 30 * Math.PI / 180) * (80 + i * 10)],
              y: [0, Math.sin(i * 30 * Math.PI / 180) * (80 + i * 10)],
              scale: [0, 1, 0.5],
            }}
            transition={{
              duration: 2,
              delay: 0.5 + i * 0.1,
              repeat: Infinity,
              repeatDelay: 2
            }}
            style={{
              top: '35%',
              left: '50%',
            }}
          >
            {i % 3 === 0 ? (
              <div className="w-2 h-2 bg-gradient-to-br from-amber-300 to-amber-500 rotate-45" />
            ) : (
              <div className="w-1.5 h-1.5 bg-gradient-to-br from-purple-300 to-purple-500 rounded-full" />
            )}
          </motion.div>
        ))}

        {/* Treasure chest */}
        <motion.div
          className="relative z-10 mb-8"
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.5 }}
        >
          {/* Light beam from chest */}
          <motion.div
            className="absolute left-1/2 -translate-x-1/2 bottom-8 w-32 h-64 bg-gradient-to-t from-amber-200/60 via-amber-100/30 to-transparent"
            initial={{ opacity: 0, scaleY: 0 }}
            animate={{ opacity: 1, scaleY: 1 }}
            transition={{ duration: 0.8, delay: 0.3 }}
            style={{
              clipPath: "polygon(40% 100%, 0% 0%, 100% 0%, 60% 100%)",
              filter: "blur(8px)"
            }}
          />
          
          <PixelChest />
        </motion.div>

        {/* Floating crown with epic banner */}
        <motion.div
          className="relative z-20 -mt-32 mb-12"
          initial={{ y: -50, opacity: 0, scale: 0.5 }}
          animate={{ 
            y: [-8, 0, -8],
            opacity: 1,
            scale: 1,
          }}
          transition={{
            y: {
              duration: 2,
              repeat: Infinity,
              ease: "easeInOut"
            },
            opacity: { duration: 0.6, delay: 0.5 },
            scale: { duration: 0.6, delay: 0.5, type: "spring" }
          }}
        >
          {/* Glow rings */}
          <motion.div
            className="absolute inset-0 -m-12"
            animate={{
              scale: [1, 1.3, 1],
              opacity: [0.6, 0.2, 0.6]
            }}
            transition={{
              duration: 2,
              repeat: Infinity,
              ease: "easeInOut"
            }}
          >
            <div className="w-full h-full rounded-full border-4 border-amber-400/40" />
          </motion.div>
          
          <motion.div
            className="absolute inset-0 -m-8"
            animate={{
              scale: [1, 1.2, 1],
              opacity: [0.4, 0.6, 0.4]
            }}
            transition={{
              duration: 2,
              repeat: Infinity,
              ease: "easeInOut",
              delay: 0.3
            }}
          >
            <div className="w-full h-full rounded-full border-4 border-amber-300/50" />
          </motion.div>

          {/* Epic banner behind crown */}
          <div className="absolute -top-6 left-1/2 -translate-x-1/2 w-48 z-0">
            <div className="relative bg-gradient-to-r from-[#533483] via-[#6B4BA3] to-[#533483] px-6 py-2 shadow-2xl"
              style={{
                clipPath: "polygon(5% 0%, 95% 0%, 100% 50%, 95% 100%, 5% 100%, 0% 50%)"
              }}
            >
              <div className="absolute inset-0 border-2 border-amber-400/60"
                style={{
                  clipPath: "polygon(5% 0%, 95% 0%, 100% 50%, 95% 100%, 5% 100%, 0% 50%)"
                }}
              />
              <p className="text-center font-bold text-amber-300 text-sm tracking-wider drop-shadow-lg">
                ★ EPIC ★
              </p>
            </div>
          </div>

          {/* Crown item */}
          <div className="relative bg-gradient-to-br from-amber-100/20 to-amber-50/10 p-8 rounded-2xl backdrop-blur-sm border border-amber-200/30 shadow-2xl">
            <div className="absolute inset-0 bg-gradient-to-br from-amber-400/20 to-transparent rounded-2xl" />
            <PixelCrown />
          </div>

          {/* Rotating sparkles */}
          <motion.div
            className="absolute -top-2 -right-2"
            animate={{ rotate: 360 }}
            transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
          >
            <Sparkles className="w-6 h-6 text-amber-300 fill-amber-200" />
          </motion.div>
          <motion.div
            className="absolute -bottom-2 -left-2"
            animate={{ rotate: -360 }}
            transition={{ duration: 4, repeat: Infinity, ease: "linear" }}
          >
            <Sparkles className="w-5 h-5 text-purple-300 fill-purple-200" />
          </motion.div>
        </motion.div>

        {/* Info card */}
        <motion.div
          className="w-full max-w-sm bg-white/10 backdrop-blur-md rounded-3xl border border-white/20 shadow-2xl p-6 space-y-4 mb-8"
          initial={{ y: 30, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.6, delay: 0.8 }}
        >
          {/* Item name */}
          <h2 className="text-2xl font-bold text-[#F5DEB3] text-center">Royal Crown</h2>
          
          {/* Details grid */}
          <div className="grid grid-cols-2 gap-4">
            <div className="bg-white/5 rounded-xl p-3 border border-white/10">
              <p className="text-xs text-white/60 mb-1">Slot</p>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-gradient-to-br from-amber-400 to-amber-600 rounded" />
                <p className="text-sm font-semibold text-white/90">Head</p>
              </div>
            </div>
            
            <div className="bg-white/5 rounded-xl p-3 border border-white/10">
              <p className="text-xs text-white/60 mb-1">Rarity</p>
              <p className="text-sm font-bold text-[#8B4D8B] drop-shadow-[0_0_8px_rgba(139,77,139,0.8)]">Epic</p>
            </div>
          </div>

          {/* Preview comparison */}
          <div className="bg-white/5 rounded-xl p-4 border border-white/10">
            <p className="text-xs text-white/60 mb-3">Preview</p>
            <div className="flex items-center justify-center gap-6">
              <div className="text-center">
                <div className="bg-black/20 rounded-lg p-2 mb-1">
                  <PixelRat withCrown={false} />
                </div>
                <p className="text-xs text-white/50">Before</p>
              </div>
              
              <div className="text-amber-400 text-xl">→</div>
              
              <div className="text-center">
                <div className="bg-gradient-to-br from-amber-500/20 to-purple-500/20 rounded-lg p-2 mb-1 border border-amber-300/30">
                  <PixelRat withCrown={true} />
                </div>
                <p className="text-xs text-amber-300 font-semibold">After</p>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Action buttons */}
        <motion.div
          className="w-full max-w-sm space-y-3"
          initial={{ y: 20, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.6, delay: 1 }}
        >
          <button className="w-full bg-gradient-to-r from-[#8B4D8B] to-[#A357A3] text-[#F5DEB3] font-bold py-4 px-6 rounded-2xl shadow-lg border-2 border-amber-400/50 hover:scale-105 transition-transform duration-200 hover:shadow-amber-400/30 hover:shadow-2xl">
            Equip Now!
          </button>
          
          <button className="w-full bg-transparent border-2 border-white/30 text-white/90 font-semibold py-4 px-6 rounded-2xl hover:bg-white/5 transition-all duration-200 backdrop-blur-sm">
            Back to Room
          </button>
        </motion.div>
      </div>
    </div>
  );
}
