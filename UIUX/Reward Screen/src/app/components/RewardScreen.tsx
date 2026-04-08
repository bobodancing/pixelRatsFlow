import { motion } from 'motion/react';
import { PixelRat } from './PixelRat';
import { FloatingParticles } from './FloatingParticles';
import { ArrowUp, Plus, Flame, Share2 } from 'lucide-react';
import { useEffect, useState } from 'react';

interface RewardItem {
  icon: string;
  label: string;
  value: number;
  color: string;
  emoji: string;
}

export function RewardScreen() {
  const [counters, setCounters] = useState({ cheese: 0, mood: 0, trust: 0 });
  const rewards: RewardItem[] = [
    { icon: '🧀', label: 'Cheese', value: 25, color: '#FFD700', emoji: '🧀' },
    { icon: '♥', label: 'Mood', value: 10, color: '#FF6B9D', emoji: '♥' },
    { icon: '🤝', label: 'Trust', value: 5, color: '#60A5FA', emoji: '🤝' },
  ];

  // Animate counters on mount
  useEffect(() => {
    const duration = 1500;
    const steps = 30;
    const interval = duration / steps;

    let step = 0;
    const timer = setInterval(() => {
      step++;
      const progress = step / steps;
      setCounters({
        cheese: Math.floor(25 * progress),
        mood: Math.floor(10 * progress),
        trust: Math.floor(5 * progress),
      });

      if (step >= steps) {
        clearInterval(timer);
        setCounters({ cheese: 25, mood: 10, trust: 5 });
      }
    }, interval);

    return () => clearInterval(timer);
  }, []);

  return (
    <div className="relative min-h-screen overflow-hidden bg-[#2D1B2E] flex items-center justify-center">
      {/* Golden light rays from center */}
      <div className="absolute inset-0 flex items-center justify-center">
        <motion.div
          className="absolute"
          animate={{
            rotate: 360,
          }}
          transition={{
            duration: 20,
            repeat: Infinity,
            ease: 'linear',
          }}
        >
          {Array.from({ length: 12 }).map((_, i) => (
            <div
              key={i}
              className="absolute top-1/2 left-1/2 origin-left"
              style={{
                transform: `rotate(${i * 30}deg)`,
                width: '600px',
                height: '120px',
                marginTop: '-60px',
              }}
            >
              <div
                className="h-full w-full opacity-10"
                style={{
                  background: `linear-gradient(to right, transparent, rgba(255, 215, 0, 0.3), transparent)`,
                }}
              />
            </div>
          ))}
        </motion.div>
      </div>

      {/* Floating particles */}
      <FloatingParticles />

      {/* Warm vignette */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          background: 'radial-gradient(circle at center, transparent 0%, rgba(45, 27, 46, 0.8) 100%)',
        }}
      />

      {/* Main content container - mobile optimized */}
      <div className="relative z-10 w-full max-w-md px-6 py-8">
        {/* Streak badge */}
        <motion.div
          className="absolute top-4 right-6 backdrop-blur-md bg-white/10 rounded-full px-4 py-2 border border-white/20"
          initial={{ scale: 0, rotate: -180 }}
          animate={{ scale: 1, rotate: 0 }}
          transition={{ delay: 0.5, type: 'spring', bounce: 0.5 }}
        >
          <div className="flex items-center gap-2">
            <Flame size={16} fill="#FF6B35" color="#FF6B35" />
            <span className="text-[#FFF5E1] font-semibold text-sm">5 days</span>
          </div>
        </motion.div>

        {/* Content */}
        <div className="flex flex-col items-center gap-6 mt-12">
          {/* Title */}
          <motion.div
            className="text-center"
            initial={{ opacity: 0, y: -30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
          >
            <h1
              className="text-3xl mb-2 text-[#FFF5E1] drop-shadow-[0_0_20px_rgba(255,215,0,0.5)]"
              style={{
                fontFamily: "'Press Start 2P', cursive",
                lineHeight: '1.4',
              }}
            >
              Focus Complete!
            </h1>
            <p className="text-[#C8B3CE] text-sm">50 minutes of deep focus</p>
          </motion.div>

          {/* Pixel rat */}
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.4, type: 'spring', bounce: 0.6 }}
          >
            <PixelRat />
          </motion.div>

          {/* Reward card */}
          <motion.div
            className="w-full backdrop-blur-lg bg-white/10 rounded-3xl p-6 border border-white/20 shadow-2xl"
            style={{
              boxShadow: '0 8px 32px rgba(139, 77, 139, 0.3)',
            }}
            initial={{ opacity: 0, y: 50 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6 }}
          >
            <div className="space-y-4">
              {rewards.map((reward, index) => (
                <motion.div
                  key={reward.label}
                  className="relative overflow-hidden rounded-xl bg-white/5 p-4 border border-white/10"
                  initial={{ opacity: 0, x: -50 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.8 + index * 0.1 }}
                >
                  {/* Shimmer effect */}
                  <motion.div
                    className="absolute inset-0 opacity-30"
                    animate={{
                      x: ['-100%', '200%'],
                    }}
                    transition={{
                      duration: 2,
                      delay: 1 + index * 0.2,
                      repeat: 1,
                    }}
                    style={{
                      background: 'linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent)',
                    }}
                  />

                  <div className="relative flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <span className="text-2xl">{reward.emoji}</span>
                      <span className="text-[#FFF5E1] font-medium">{reward.label}</span>
                    </div>
                    <motion.div
                      className="flex items-center gap-1 font-bold text-xl"
                      style={{ color: reward.color }}
                      animate={{ scale: [1, 1.2, 1] }}
                      transition={{
                        delay: 1.5 + index * 0.1,
                        duration: 0.5,
                      }}
                    >
                      <span>+</span>
                      <span>
                        {reward.label === 'Cheese'
                          ? counters.cheese
                          : reward.label === 'Mood'
                          ? counters.mood
                          : counters.trust}
                      </span>
                      {reward.label === 'Mood' && (
                        <ArrowUp size={16} className="ml-1" />
                      )}
                      {reward.label === 'Trust' && (
                        <Plus size={16} className="ml-1" />
                      )}
                    </motion.div>
                  </div>
                </motion.div>
              ))}
            </div>
          </motion.div>

          {/* Action buttons */}
          <motion.div
            className="w-full space-y-3 mt-4"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1.2 }}
          >
            {/* Primary button */}
            <motion.button
              className="w-full backdrop-blur-md bg-[#8B4D8B] text-[#FFF5E1] rounded-2xl py-4 font-semibold text-lg border border-[#A678A6] shadow-lg relative overflow-hidden"
              style={{
                boxShadow: '0 0 30px rgba(139, 77, 139, 0.4)',
              }}
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
            >
              <motion.div
                className="absolute inset-0 opacity-20"
                animate={{
                  background: [
                    'radial-gradient(circle at 0% 50%, rgba(255, 255, 255, 0.3), transparent)',
                    'radial-gradient(circle at 100% 50%, rgba(255, 255, 255, 0.3), transparent)',
                    'radial-gradient(circle at 0% 50%, rgba(255, 255, 255, 0.3), transparent)',
                  ],
                }}
                transition={{
                  duration: 2,
                  repeat: Infinity,
                }}
              />
              <span className="relative z-10">Collect & Return</span>
            </motion.button>

            {/* Secondary button */}
            <motion.button
              className="w-full backdrop-blur-md bg-transparent text-[#FFF5E1] rounded-2xl py-3 font-medium border border-[#FFF5E1]/30 flex items-center justify-center gap-2"
              whileHover={{ scale: 1.02, borderColor: 'rgba(255, 245, 225, 0.6)' }}
              whileTap={{ scale: 0.98 }}
            >
              <span>Share Screenshot</span>
              <Share2 size={18} />
            </motion.button>
          </motion.div>
        </div>
      </div>
    </div>
  );
}
