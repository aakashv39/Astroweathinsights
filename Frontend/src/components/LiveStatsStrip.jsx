import React from 'react';
import { Icon } from '@iconify/react';

const stats = [
  {
    value: '24x7',
    label: 'Astrologers Available',
    icon: 'ph:clock-countdown-fill',
  },
  {
    value: '48,726+',
    label: 'Verified Experts',
    icon: 'ph:seal-check-fill',
  },
  {
    value: '120M+',
    label: 'Guided Customers',
    icon: 'ph:users-three-fill',
  },
  {
    value: '4.9/5',
    label: 'User Satisfaction',
    icon: 'ph:star-fill',
  },
];

const LiveStatsStrip = () => {
  return (
    <section className="px-6 md:px-12 lg:px-20 mt-4 mb-4">
      <div className="max-w-7xl mx-auto bg-white/85 backdrop-blur-md border border-amber-100 rounded-2xl shadow-lg shadow-amber-100/40 p-3 md:p-4">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4">
          {stats.map((item) => (
            <div
              key={item.label}
              className="rounded-xl border border-slate-100 bg-gradient-to-br from-white to-amber-50/50 px-3 py-3 md:px-4 md:py-4"
            >
              <div className="flex items-center gap-2 mb-1.5">
                <Icon icon={item.icon} className="text-amber-600 text-lg" />
                <p className="m-0 text-base md:text-lg font-black text-slate-900">
                  {item.value}
                </p>
              </div>
              <p className="m-0 text-[11px] md:text-xs text-slate-500 font-semibold uppercase tracking-wide">
                {item.label}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default LiveStatsStrip;