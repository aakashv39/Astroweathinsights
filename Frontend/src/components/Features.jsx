import React, { useState } from 'react';
import { Icon } from '@iconify/react';
import { motion, AnimatePresence } from 'framer-motion';

const zodiacData = [
    { name: 'Aries', date: 'Mar 21 - Apr 19', element: 'Fire', icon: 'mdi:zodiac-aries', mood: 'Ambitious', num: 7, color: 'Red' },
    { name: 'Taurus', date: 'Apr 20 - May 20', element: 'Earth', icon: 'mdi:zodiac-taurus', mood: 'Grounded', num: 4, color: 'Green' },
    { name: 'Gemini', date: 'May 21 - Jun 20', element: 'Air', icon: 'mdi:zodiac-gemini', mood: 'Curious', num: 5, color: 'Yellow' },
    { name: 'Cancer', date: 'Jun 21 - Jul 22', element: 'Water', icon: 'mdi:zodiac-cancer', mood: 'Intuitive', num: 2, color: 'Silver' },
    { name: 'Leo', date: 'Jul 23 - Aug 22', element: 'Fire', icon: 'mdi:zodiac-leo', mood: 'Confident', num: 1, color: 'Gold' },
    { name: 'Virgo', date: 'Aug 23 - Sep 22', element: 'Earth', icon: 'mdi:zodiac-virgo', mood: 'Analytical', num: 3, color: 'Brown' },
    { name: 'Libra', date: 'Sep 23 - Oct 22', element: 'Air', icon: 'mdi:zodiac-libra', mood: 'Harmonious', num: 6, color: 'Pink' },
    { name: 'Scorpio', date: 'Oct 23 - Nov 21', element: 'Water', icon: 'mdi:zodiac-scorpio', mood: 'Intense', num: 8, color: 'Black' },
    { name: 'Sagittarius', date: 'Nov 22 - Dec 21', element: 'Fire', icon: 'mdi:zodiac-sagittarius', mood: 'Adventurous', num: 9, color: 'Purple' },
    { name: 'Capricorn', date: 'Dec 22 - Jan 19', element: 'Earth', icon: 'mdi:zodiac-capricorn', mood: 'Disciplined', num: 10, color: 'Grey' },
    { name: 'Aquarius', date: 'Jan 20 - Feb 18', element: 'Air', icon: 'mdi:zodiac-aquarius', mood: 'Innovative', num: 11, color: 'Blue' },
    { name: 'Pisces', date: 'Feb 19 - Mar 20', element: 'Water', icon: 'mdi:zodiac-pisces', mood: 'Dreamy', num: 12, color: 'Sea Green' }
];

const Features = () => {
    const [selectedSign, setSelectedSign] = useState(null);

    return (
        <section className="relative py-24 px-6 md:px-20 overflow-hidden">
            {/* Background elements */}
            <div className="absolute top-0 left-0 w-full h-full pointer-events-none z-[-1] opacity-30">
                <div className="absolute top-20 left-[10%] w-[300px] h-[300px] bg-amber-200/20 rounded-full blur-[80px]"></div>
                <div className="absolute bottom-20 right-[10%] w-[400px] h-[400px] bg-slate-200/20 rounded-full blur-[80px]"></div>
            </div>

            <motion.div
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                className="mb-16 text-center max-w-3xl mx-auto"
            >
                <div className="flex items-center justify-center gap-2 mb-4">
                    <div className="h-[2px] w-12 bg-gradient-to-r from-transparent to-amber-400"></div>
                    <span className="text-amber-600 font-serif font-bold text-sm tracking-widest uppercase">Daily Insights</span>
                    <div className="h-[2px] w-12 bg-gradient-to-l from-transparent to-amber-400"></div>
                </div>
                <h2 className="text-4xl md:text-5xl font-serif font-black text-slate-900 mb-6 leading-tight">
                    Your Planetary <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-600 to-amber-800">Forecast</span>
                </h2>
                <p className="text-lg text-slate-600 font-light leading-relaxed">
                    Select your zodiac sign to unlock personalized financial and career guidance for today.
                    Align your actions with the cosmic rhythm.
                </p>
            </motion.div>

            {/* Responsive Grid */}
            <motion.div
                className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-6 max-w-7xl mx-auto"
                initial={{ opacity: 0 }}
                whileInView={{ opacity: 1 }}
                viewport={{ once: true }}
            >
                {zodiacData.map((sign) => (
                    <motion.div
                        key={sign.name}
                        className="group relative bg-white/70 backdrop-blur-md rounded-2xl p-6 cursor-pointer border border-white/60 shadow-lg shadow-slate-200/40 hover:shadow-2xl hover:shadow-amber-500/10 hover:-translate-y-2 transition-all duration-300 flex flex-col items-center gap-4 overflow-hidden"
                        whileHover={{ scale: 1.02 }}
                        onClick={() => setSelectedSign(sign)}
                    >
                        {/* Hover Gradient Background */}
                        <div className="absolute inset-0 bg-gradient-to-br from-amber-500/0 via-amber-500/0 to-amber-500/0 group-hover:from-amber-50/50 group-hover:to-amber-100/50 transition-colors duration-500"></div>

                        <div className="relative w-16 h-16 rounded-full bg-gradient-to-br from-slate-100 to-white border border-white shadow-inner flex items-center justify-center group-hover:from-amber-100 group-hover:to-amber-50 group-hover:border-amber-200 transition-all duration-500">
                            <Icon icon={sign.icon} className="text-3xl text-slate-400 group-hover:text-amber-600 transition-colors duration-500" />
                        </div>

                        <div className="relative text-center z-10">
                            <h3 className="font-serif font-bold text-lg text-slate-800 group-hover:text-amber-800 transition-colors">{sign.name}</h3>
                            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest mt-1 opacity-60 group-hover:opacity-100 group-hover:text-amber-600 transition-all">{sign.date}</p>
                        </div>
                    </motion.div>
                ))}
            </motion.div>

            {/* Modal Overlay */}
            <AnimatePresence>
                {selectedSign && (
                    <motion.div
                        className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[200] flex items-center justify-center p-4 pl-[80px] md:pl-4"
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={() => setSelectedSign(null)}
                    >
                        <motion.div
                            className="w-full max-w-[500px] bg-white rounded-3xl overflow-hidden shadow-2xl relative flex flex-col max-h-[85vh]"
                            initial={{ scale: 0.9, opacity: 0, y: 20 }}
                            animate={{ scale: 1, opacity: 1, y: 0 }}
                            exit={{ scale: 0.95, opacity: 0, y: 10 }}
                            transition={{ type: "spring", damping: 25, stiffness: 300 }}
                            onClick={(e) => e.stopPropagation()}
                        >
                            {/* Modal Header */}
                            <div className="relative h-32 bg-gradient-to-br from-amber-500 to-amber-700 overflow-hidden shrink-0 flex items-center justify-between px-8">
                                <div className="absolute inset-0 opacity-20 bg-[url('https://www.transparenttextures.com/patterns/stardust.png')]"></div>

                                <div className="z-10 text-white">
                                    <h3 className="text-3xl font-serif font-bold tracking-tight mb-1">{selectedSign.name}</h3>
                                    <p className="text-amber-100 text-xs font-semibold uppercase tracking-widest opacity-90">{selectedSign.date}</p>
                                </div>

                                <div className="z-10 w-16 h-16 rounded-full bg-white/20 backdrop-blur-md flex items-center justify-center border border-white/30">
                                    <Icon icon={selectedSign.icon} className="text-white text-3xl" />
                                </div>

                                <button
                                    className="absolute top-4 right-4 text-white/60 hover:text-white transition-colors z-20"
                                    onClick={() => setSelectedSign(null)}
                                >
                                    <Icon icon="ph:x-circle-fill" className="text-3xl" />
                                </button>
                            </div>

                            {/* Modal Body */}
                            <div className="p-8 flex-1 overflow-y-auto">
                                <div className="flex flex-wrap gap-2 mb-6">
                                    <span className="px-3 py-1 bg-amber-50 text-amber-700 text-[10px] font-bold uppercase tracking-wider rounded-full border border-amber-100">
                                        Element: {selectedSign.element}
                                    </span>
                                    <span className="px-3 py-1 bg-slate-50 text-slate-600 text-[10px] font-bold uppercase tracking-wider rounded-full border border-slate-100">
                                        Mood: {selectedSign.mood}
                                    </span>
                                </div>

                                <div className="bg-gradient-to-br from-slate-50 to-white rounded-xl p-5 border border-slate-100 mb-8 relative overflow-hidden group">
                                    <div className="absolute top-0 right-0 w-20 h-20 bg-amber-100/50 rounded-full blur-2xl -translate-y-1/2 translate-x-1/2 group-hover:bg-amber-200/50 transition-colors"></div>
                                    <h4 className="flex items-center gap-2 font-serif font-bold text-slate-900 mb-3 relative z-10">
                                        <Icon icon="ph:sparkle-fill" className="text-amber-500" />
                                        Today's Forecast
                                    </h4>
                                    <p className="text-slate-600 leading-relaxed text-sm relative z-10">
                                        The cosmic alignment suggests a specific focus on financial growth today.
                                        <br /><br />
                                        {selectedSign.element === 'Fire' ? 'Your energy is high. Take calculated risks and lead with confidence.' :
                                            selectedSign.element === 'Earth' ? 'Focus on stability. Review your budgets and long-term investments.' :
                                                selectedSign.element === 'Air' ? 'Communication is key. Share your ideas to attract wealth.' :
                                                    'Listen to your intuition. Hidden opportunities are surfacing for you.'}
                                    </p>
                                </div>

                                <div className="grid grid-cols-2 gap-4">
                                    <div className="p-4 rounded-2xl bg-slate-50 border border-slate-100 flex flex-col items-center justify-center gap-2">
                                        <Icon icon="ph:dice-five-fill" className="text-amber-400 text-2xl" />
                                        <div className="text-center">
                                            <div className="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Lucky Number</div>
                                            <div className="text-2xl font-black text-slate-800 font-serif">{selectedSign.num}</div>
                                        </div>
                                    </div>
                                    <div className="p-4 rounded-2xl bg-slate-50 border border-slate-100 flex flex-col items-center justify-center gap-2">
                                        <Icon icon="ph:palette-fill" className="text-amber-400 text-2xl" />
                                        <div className="text-center">
                                            <div className="text-[10px] text-slate-400 font-bold uppercase tracking-wider">Lucky Color</div>
                                            <div className="text-lg font-bold text-slate-800 font-serif">{selectedSign.color}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                        </motion.div>
                    </motion.div>
                )}
            </AnimatePresence>
        </section>
    );
};
export default Features;
