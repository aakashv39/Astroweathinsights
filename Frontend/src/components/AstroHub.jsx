import React from 'react';
import { Icon } from '@iconify/react';

const modules = [
  {
    icon: 'ph:scroll-fill',
    title: 'Kundali',
    desc: 'Generate detailed birth chart insights instantly.',
  },
  {
    icon: 'ph:sun-dim-fill',
    title: 'Panchang',
    desc: 'Daily planetary timings, muhurat, and tithi guidance.',
  },
  {
    icon: 'ph:flower-lotus-fill',
    title: 'Puja',
    desc: 'Book personalized rituals and remedy sessions.',
  },
  {
    icon: 'ph:file-text-fill',
    title: 'Reports',
    desc: 'Comprehensive annual and focused life reports.',
  },
  {
    icon: 'ph:moon-stars-fill',
    title: 'Horoscope',
    desc: 'Daily zodiac forecast with money and career insights.',
  },
  {
    icon: 'ph:shopping-bag-fill',
    title: 'Shop & Blog',
    desc: 'Explore spiritual products and practical guidance articles.',
  },
];

const AstroHub = () => {
  return (
    <section id="astro-hub" className="relative py-16 px-6 md:px-12 lg:px-20 overflow-hidden">
      <div className="absolute inset-0 pointer-events-none -z-10">
        <div className="absolute top-0 right-0 w-[380px] h-[380px] bg-amber-100/30 rounded-full blur-[120px]" />
        <div className="absolute bottom-0 left-0 w-[380px] h-[380px] bg-slate-200/30 rounded-full blur-[120px]" />
      </div>

      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-10">
          <p className="text-amber-700 font-bold uppercase tracking-[0.18em] text-xs mb-2">
            Astroway-Style Modules
          </p>
          <h2 className="text-3xl md:text-5xl font-serif font-black text-slate-900 mb-3">
            Everything You Need In One Place
          </h2>
          <p className="text-slate-600 max-w-2xl mx-auto">
            A complete consultation ecosystem from instant chat to in-depth reports.
          </p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {modules.map((item) => (
            <article
              key={item.title}
              className="rounded-2xl border border-amber-100 bg-white/85 backdrop-blur-sm p-5 shadow-md hover:shadow-xl hover:-translate-y-1 transition-all"
            >
              <div className="w-11 h-11 rounded-xl bg-gradient-to-br from-amber-500 to-amber-700 grid place-items-center mb-3 shadow-md shadow-amber-500/30">
                <Icon icon={item.icon} className="text-white text-xl" />
              </div>
              <h3 className="text-xl font-serif font-bold text-slate-900 mb-2">{item.title}</h3>
              <p className="text-sm text-slate-600 leading-relaxed m-0">{item.desc}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
};

export default AstroHub;