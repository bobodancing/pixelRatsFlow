import { motion } from 'motion/react';
import { Star } from 'lucide-react';

interface Particle {
  id: number;
  x: number;
  delay: number;
  duration: number;
  type: 'confetti' | 'star';
  color: string;
  size: number;
}

export function FloatingParticles() {
  // Generate random particles
  const particles: Particle[] = Array.from({ length: 30 }, (_, i) => ({
    id: i,
    x: Math.random() * 100,
    delay: Math.random() * 3,
    duration: 3 + Math.random() * 2,
    type: Math.random() > 0.5 ? 'confetti' : 'star',
    color: ['#FFD700', '#FFA500', '#FF6B9D', '#A78BFA'][Math.floor(Math.random() * 4)],
    size: 4 + Math.random() * 8,
  }));

  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none">
      {particles.map((particle) => (
        <motion.div
          key={particle.id}
          className="absolute"
          style={{
            left: `${particle.x}%`,
            top: '-5%',
          }}
          animate={{
            y: ['0vh', '110vh'],
            x: [0, (Math.random() - 0.5) * 100],
            rotate: [0, 360 * (Math.random() > 0.5 ? 1 : -1)],
            opacity: [0, 1, 1, 0],
          }}
          transition={{
            duration: particle.duration,
            delay: particle.delay,
            repeat: Infinity,
            ease: 'linear',
          }}
        >
          {particle.type === 'star' ? (
            <Star
              size={particle.size}
              fill={particle.color}
              color={particle.color}
            />
          ) : (
            <div
              style={{
                width: particle.size,
                height: particle.size * 1.5,
                backgroundColor: particle.color,
                borderRadius: '2px',
              }}
            />
          )}
        </motion.div>
      ))}
    </div>
  );
}
