import { LucideIcon } from 'lucide-react';

interface StatCardProps {
  icon: LucideIcon;
  label: string;
  value: string;
}

export function StatCard({ icon: Icon, label, value }: StatCardProps) {
  return (
    <div className="
      flex items-center gap-2 px-3 py-2 rounded-lg
      bg-purple-950/40 backdrop-blur-md
      border border-purple-400/20
    ">
      <Icon className="w-4 h-4 text-purple-300" />
      <div className="flex flex-col">
        <span className="text-[10px] text-purple-200/60">{label}</span>
        <span className="text-sm font-semibold text-purple-100">{value}</span>
      </div>
    </div>
  );
}
