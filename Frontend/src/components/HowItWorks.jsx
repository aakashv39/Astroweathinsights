import React from 'react';
import { Icon } from '@iconify/react';

const steps = [
  {
    id: '01',
    title: 'Choose Consultation Mode',
    text: 'Pick chat, call, or in-depth report based on your current need.',
    icon: 'ph:app-window-fill',
  },
  {
    id: '02',
    title: 'Connect With Expert',
    text: 'Get matched with a verified astrologer specialized in your topic.',
    icon: 'ph:user-focus-fill',
  },
  {
    id: '03',
    title: 'Get Actionable Guidance',
    text: 'Receive practical remedies and timing insights you can apply now.',
    icon: 'ph:target-fill',
  },
];

const HowItWorks = () => {
  return (
    <section className="py-20 px-6 md:px-12 lg:px-20">
      <div className="max-w-7xl mx-auto rounded-3xl bg-slate-900 text-white p-8 md:p-12 border border-slate-800 shadow-2xl shadow-slate-900/30">
        <div className="mb-10 text-center md:text-left">
          <p className="text-amber-400 uppercase tracking-[0.2em] text-xs font-bold mb-2">
            How It Works
          </p>
          <h2 className="text-3xl md:text-5xl font-serif font-black mb-3">
            Fast, Private, Reliable Guidance
          </h2>
          <p className="text-slate-300 max-w-2xl">
            A structured consultation flow inspired by modern astrology app experiences.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {steps.map((step) => (
            <article
              key={step.id}
              className="rounded-2xl border border-slate-700 bg-slate-800/80 p-5"
            >
              <div className="flex items-center justify-between mb-4">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-400 to-amber-600 grid place-items-center">
                  <Icon icon={step.icon} className="text-slate-900 text-lg" />
                </div>
                <span className="text-slate-500 font-black text-lg">{step.id}</span>
              </div>
              <h3 className="text-lg font-bold mb-2">{step.title}</h3>
              <p className="text-sm text-slate-300 m-0 leading-relaxed">{step.text}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
};

export default HowItWorks;