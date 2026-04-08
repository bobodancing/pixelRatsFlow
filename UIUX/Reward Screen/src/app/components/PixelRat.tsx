import { motion } from 'motion/react';
import { Sparkles } from 'lucide-react';

export function PixelRat() {
  return (
    <div className="relative">
      {/* Sparkle effects */}
      <motion.div
        className="absolute -top-2 -left-2 text-yellow-300"
        animate={{
          scale: [0, 1, 0],
          rotate: [0, 180, 360],
          opacity: [0, 1, 0],
        }}
        transition={{
          duration: 2,
          repeat: Infinity,
          repeatDelay: 0.5,
        }}
      >
        <Sparkles size={16} fill="currentColor" />
      </motion.div>

      <motion.div
        className="absolute -top-3 -right-3 text-yellow-300"
        animate={{
          scale: [0, 1, 0],
          rotate: [360, 180, 0],
          opacity: [0, 1, 0],
        }}
        transition={{
          duration: 2,
          repeat: Infinity,
          repeatDelay: 0.8,
          delay: 0.5,
        }}
      >
        <Sparkles size={12} fill="currentColor" />
      </motion.div>

      <motion.div
        className="absolute -bottom-1 left-8 text-yellow-300"
        animate={{
          scale: [0, 1, 0],
          rotate: [0, 180, 360],
          opacity: [0, 1, 0],
        }}
        transition={{
          duration: 2,
          repeat: Infinity,
          repeatDelay: 0.3,
          delay: 0.8,
        }}
      >
        <Sparkles size={10} fill="currentColor" />
      </motion.div>

      {/* Bouncing pixel rat - real sprite */}
      <motion.div
        className="relative"
        animate={{
          y: [0, -12, 0],
        }}
        transition={{
          duration: 1,
          repeat: Infinity,
          ease: "easeInOut",
        }}
      >
        <img
          src="/pixelrats.png"
          alt="Pixel rat"
          width={120}
          height={120}
          style={{ imageRendering: 'pixelated' }}
          draggable={false}
        />
      </motion.div>
    </div>
  );
}
