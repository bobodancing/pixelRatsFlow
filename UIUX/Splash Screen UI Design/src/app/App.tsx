import { useEffect, useState, useMemo } from 'react';
import { motion, AnimatePresence } from 'motion/react';

// Seeded random to keep values stable across renders
function seededRandom(seed: number) {
  const x = Math.sin(seed * 9301 + 49297) * 49297;
  return x - Math.floor(x);
}

export default function App() {
  const [progress, setProgress] = useState(0);
  const [loadingDone, setLoadingDone] = useState(false);

  useEffect(() => {
    const timer = setInterval(() => {
      setProgress((prev) => {
        if (prev >= 100) {
          clearInterval(timer);
          setLoadingDone(true);
          return 100;
        }
        return prev + 1;
      });
    }, 30);

    return () => clearInterval(timer);
  }, []);

  // Generate random stars (stable across re-renders)
  const stars = useMemo(() => Array.from({ length: 50 }, (_, i) => ({
    id: i,
    x: seededRandom(i * 3 + 1) * 100,
    y: seededRandom(i * 3 + 2) * 100,
    size: seededRandom(i * 3 + 3) * 2 + 1,
    opacity: seededRandom(i * 3 + 4) * 0.5 + 0.3,
    delay: seededRandom(i * 3 + 5) * 3,
  })), []);

  // Generate sparkles (stable across re-renders)
  const sparkles = useMemo(() => Array.from({ length: 20 }, (_, i) => ({
    id: i,
    x: seededRandom(i * 4 + 100) * 100,
    y: seededRandom(i * 4 + 101) * 100,
    fontSize: seededRandom(i * 4 + 102) * 8 + 4,
    duration: seededRandom(i * 4 + 103) * 2 + 2,
    delay: seededRandom(i * 4 + 104) * 3,
  })), []);

  // Generate floating particles (stable across re-renders)
  const particles = useMemo(() => Array.from({ length: 12 }, (_, i) => ({
    id: i,
    x: seededRandom(i * 2 + 200) * 60 - 30,
    delay: seededRandom(i * 2 + 201) * 2,
    duration: seededRandom(i * 2 + 202) * 3 + 3,
  })), []);

  return (
    <div className="relative w-full h-screen overflow-hidden bg-gradient-to-b from-[#2D1B2E] to-[#1A0F1E] flex items-center justify-center">
      {/* Aspect ratio container for mobile (9:19.5) */}
      <div className="relative w-full max-w-[430px] h-full flex flex-col items-center justify-between py-16 px-8">
        
        {/* Stars background */}
        {stars.map((star) => (
          <motion.div
            key={star.id}
            className="absolute rounded-full bg-white"
            style={{
              left: `${star.x}%`,
              top: `${star.y}%`,
              width: `${star.size}px`,
              height: `${star.size}px`,
            }}
            animate={{
              opacity: [star.opacity, star.opacity * 0.3, star.opacity],
              scale: [1, 0.8, 1],
            }}
            transition={{
              duration: 2 + star.delay,
              repeat: Infinity,
              delay: star.delay,
            }}
          />
        ))}

        {/* Sparkles */}
        {sparkles.map((s) => (
          <motion.div
            key={`sparkle-${s.id}`}
            className="absolute text-[#FFD700]"
            style={{
              left: `${s.x}%`,
              top: `${s.y}%`,
              fontSize: `${s.fontSize}px`,
            }}
            animate={{
              opacity: [0, 1, 0],
              scale: [0, 1, 0],
            }}
            transition={{
              duration: s.duration,
              repeat: Infinity,
              delay: s.delay,
            }}
          >
            ✦
          </motion.div>
        ))}

        <div className="flex-1" />

        {/* Main content - centered */}
        <div className="relative flex flex-col items-center">
          {/* Floating particles (ambient glow) */}
          <div className="relative z-10 h-16">
            {particles.map((particle) => (
              <motion.div
                key={particle.id}
                className="absolute w-1.5 h-1.5 rounded-full bg-gradient-to-t from-[#FFD700] to-[#FFA500]"
                style={{
                  left: '50%',
                  bottom: '-10px',
                }}
                animate={{
                  y: [-10, -120],
                  x: [0, particle.x],
                  opacity: [1, 0.8, 0],
                  scale: [1, 0.8, 0.3],
                }}
                transition={{
                  duration: particle.duration,
                  repeat: Infinity,
                  delay: particle.delay,
                  ease: "easeOut",
                }}
              />
            ))}
          </div>

          {/* App Name */}
          <motion.h1
            className="mt-12 text-4xl text-[#FFE4A0] relative"
            style={{
              fontFamily: "'Press Start 2P', cursive",
              textShadow: '0 0 20px rgba(255, 215, 0, 0.5)',
            }}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5, duration: 0.8 }}
          >
            PixelRats
          </motion.h1>

          {/* Tagline */}
          <motion.p
            className="mt-4 text-sm text-[#B8A0BA]"
            style={{
              fontFamily: 'system-ui, -apple-system, sans-serif',
              fontWeight: 300,
              letterSpacing: '0.05em',
            }}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.8, duration: 0.8 }}
          >
            Focus together.
          </motion.p>
        </div>

        <div className="flex-1" />

        {/* Loading bar + Start button */}
        <div className="w-full max-w-[280px] flex flex-col items-center gap-6">
          <AnimatePresence mode="wait">
            {!loadingDone ? (
              <motion.div
                key="loading"
                className="w-full h-2 rounded-full overflow-hidden relative"
                style={{
                  background: 'rgba(139, 92, 139, 0.2)',
                  backdropFilter: 'blur(10px)',
                  border: '1px solid rgba(184, 160, 186, 0.2)',
                }}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ delay: 1, duration: 0.8 }}
              >
                <motion.div
                  className="h-full rounded-full bg-gradient-to-r from-[#FFB6C1] via-[#FFD700] to-[#FFA500]"
                  style={{
                    boxShadow: '0 0 10px rgba(255, 215, 0, 0.5)',
                  }}
                  initial={{ width: '0%' }}
                  animate={{ width: `${progress}%` }}
                  transition={{ duration: 0.3 }}
                />
              </motion.div>
            ) : (
              <motion.button
                key="start-btn"
                className="w-full max-w-[220px] py-3.5 rounded-full font-semibold text-lg cursor-pointer"
                style={{
                  background: 'linear-gradient(135deg, #8B4D8B, #6A3A6A)',
                  color: '#FFE4A0',
                  border: '1.5px solid rgba(180, 120, 180, 0.5)',
                  boxShadow: '0 0 24px rgba(139, 77, 139, 0.5), 0 4px 12px rgba(0,0,0,0.3)',
                  fontFamily: 'system-ui, -apple-system, sans-serif',
                  letterSpacing: '0.08em',
                }}
                initial={{ opacity: 0, scale: 0.8, y: 20 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                whileHover={{ scale: 1.05, boxShadow: '0 0 32px rgba(139, 77, 139, 0.7)' }}
                whileTap={{ scale: 0.95 }}
                transition={{ type: 'spring', bounce: 0.4 }}
              >
                Start
              </motion.button>
            )}
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}
