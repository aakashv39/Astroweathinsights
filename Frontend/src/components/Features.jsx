import React, { useState } from 'react';
import { Icon } from '@iconify/react';
import { motion, AnimatePresence } from 'framer-motion';

const zodiacData = [
    { name: 'Aries', date: 'Mar 21 - Apr 19', element: 'Fire', img: '/zodiac/aries.png', mood: 'Ambitious', num: 7, color: 'Red' },
    { name: 'Taurus', date: 'Apr 20 - May 20', element: 'Earth', img: '/zodiac/taurus.png', mood: 'Grounded', num: 4, color: 'Green' },
    { name: 'Gemini', date: 'May 21 - Jun 20', element: 'Air', img: '/zodiac/gemini.png', mood: 'Curious', num: 5, color: 'Yellow' },
    { name: 'Cancer', date: 'Jun 21 - Jul 22', element: 'Water', img: '/zodiac/cancer.png', mood: 'Intuitive', num: 2, color: 'Silver' },
    { name: 'Leo', date: 'Jul 23 - Aug 22', element: 'Fire', img: '/zodiac/leo.png', mood: 'Confident', num: 1, color: 'Gold' },
    { name: 'Virgo', date: 'Aug 23 - Sep 22', element: 'Earth', img: '/zodiac/virgo.png', mood: 'Analytical', num: 3, color: 'Brown' },
    { name: 'Libra', date: 'Sep 23 - Oct 22', element: 'Air', img: '/zodiac/libra.png', mood: 'Harmonious', num: 6, color: 'Pink' },
    { name: 'Scorpio', date: 'Oct 23 - Nov 21', element: 'Water', img: '/zodiac/scorpio.png', mood: 'Intense', num: 8, color: 'Black' },
    { name: 'Sagittarius', date: 'Nov 22 - Dec 21', element: 'Fire', img: '/zodiac/sagittarius.png', mood: 'Adventurous', num: 9, color: 'Purple' },
    { name: 'Capricorn', date: 'Dec 22 - Jan 19', element: 'Earth', img: '/zodiac/capricorn.png', mood: 'Disciplined', num: 10, color: 'Grey' },
    { name: 'Aquarius', date: 'Jan 20 - Feb 18', element: 'Air', img: '/zodiac/aquarius.png', mood: 'Innovative', num: 11, color: 'Blue' },
    { name: 'Pisces', date: 'Feb 19 - Mar 20', element: 'Water', img: '/zodiac/pisces.png', mood: 'Dreamy', num: 12, color: 'Sea Green' }
];

const Features = () => {
    const [selectedSign, setSelectedSign] = useState(null);

    return (
        <section className="relative py-20 px-6 md:px-20 bg-gradient-to-b from-white/20 to-amber-50/30 backdrop-blur-sm border-t border-white/40">
            <motion.div
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                className="mb-16 text-center max-w-3xl mx-auto"
            >
                <div className="flex items-center justify-center gap-2 mb-4">
                    <div className="h-[1px] w-12 bg-amber-300"></div>
                    <span className="text-amber-600 font-serif italic text-lg tracking-wide">Daily Insights</span>
                    <div className="h-[1px] w-12 bg-amber-300"></div>
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
                className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-6 max-w-[1300px] mx-auto"
                initial={{ opacity: 0 }}
                whileInView={{ opacity: 1 }}
                viewport={{ once: true }}
            >
                {zodiacData.map((sign) => (
                    <motion.div
                        key={sign.name}
                        className="group relative bg-white/60 backdrop-blur-md rounded-2xl p-6 cursor-pointer border border-white/50 shadow-sm hover:shadow-xl hover:shadow-amber-500/10 hover:bg-white transition-all duration-300 flex flex-col items-center gap-4 overflow-hidden"
                        whileHover={{ y: -5 }}
                        onClick={() => setSelectedSign(sign)}
                    >
                        {/* Hover Gradient Background */}
                        <div className="absolute inset-0 bg-gradient-to-br from-amber-500/0 to-amber-500/0 group-hover:from-amber-500/5 group-hover:to-amber-500/10 transition-colors duration-300"></div>

                        <div className="relative w-20 h-20 md:w-24 md:h-24 flex items-center justify-center transition-transform duration-500 group-hover:scale-110">
                            <img src={sign.img} alt={sign.name} className="w-full h-full object-contain drop-shadow-sm" />
                        </div>
                        <div className="relative text-center">
                            <h3 className="font-serif font-bold text-lg text-slate-800 group-hover:text-amber-700 transition-colors">{sign.name}</h3>
                            <p className="text-xs font-medium text-slate-500 uppercase tracking-wider mt-1 opacity-0 group-hover:opacity-100 transition-opacity transform translate-y-2 group-hover:translate-y-0">{sign.date}</p>
                        </div>
                    </motion.div>
                ))}
            </motion.div>

            {/* Modal Overlay */}
            <AnimatePresence>
                {selectedSign && (
                    <motion.div
                        className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[200] flex items-center justify-center p-4"
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0, transition: { duration: 0.2 } }}
                        onClick={() => setSelectedSign(null)}
                    >
                        <motion.div
                            className="w-full max-w-[600px] bg-white rounded-3xl overflow-hidden shadow-2xl relative flex flex-col max-h-[90vh]"
                            initial={{ scale: 0.9, opacity: 0, y: 20 }}
                            animate={{ scale: 1, opacity: 1, y: 0 }}
                            exit={{ scale: 0.95, opacity: 0, y: 10 }}
                            transition={{ type: "spring", damping: 25, stiffness: 300 }}
                            onClick={(e) => e.stopPropagation()}
                        >
                            <div className="flex flex-col h-full overflow-y-auto">
                                {/* Modal Header */}
                                <div className="relative h-32 bg-gradient-to-r from-amber-500 to-amber-700 overflow-hidden shrink-0">
                                    <div className="absolute inset-0 bg-[url('/noise.png')] opacity-20 mix-blend-overlay"></div>
                                    <Icon icon="ph:sparkle-fill" className="absolute top-4 right-16 text-white/20 text-6xl rotate-12" />
                                    <button
                                        className="absolute top-4 right-4 text-white/80 hover:text-white transition-colors p-2 rounded-full hover:bg-white/20 z-10"
                                        onClick={() => setSelectedSign(null)}
                                    >
                                        <Icon icon="ph:x-bold" className="text-2xl" />
                                    </button>
                                </div>

                                {/* Modal Body */}
                                <div className="pt-12 pb-8 px-8 flex-1 flex flex-col items-center text-center">
                                    <div className="flex flex-col items-center gap-4 mb-8 w-full">
                                        <div>
                                            <h3 className="text-4xl font-serif font-bold text-slate-900 mb-1">{selectedSign.name}</h3>
                                            <p className="text-base font-medium text-slate-500">{selectedSign.date}</p>
                                        </div>
                                        <div className="px-4 py-1.5 bg-amber-100 text-amber-800 text-xs font-bold uppercase tracking-wider rounded-full">
                                            {selectedSign.element}
                                        </div>
                                    </div>

                                    <div className="bg-slate-50 rounded-xl p-5 border border-slate-100 mb-6">
                                        <h4 className="flex items-center gap-2 font-serif font-bold text-slate-800 mb-3">
                                            <Icon icon="ph:shooting-star-fill" className="text-amber-500" />
                                            Today's Forecast
                                        </h4>
                                        <p className="text-slate-600 leading-relaxed text-sm md:text-base">
                                            The stars align to bring {selectedSign.mood.toLowerCase()} energy to your financial endeavors.
                                            {selectedSign.element === 'Fire' ? ' Use your natural drive to initiate new projects.' :
                                                selectedSign.element === 'Earth' ? ' Consolidate your gains and plan for the long term.' :
                                                    selectedSign.element === 'Air' ? ' Networking will reveal profitable opportunities.' :
                                                        ' Trust your gut feeling on investment decisions.'}
                                        </p>
                                    </div>

                                    <div className="grid grid-cols-3 gap-4">
                                        <div className="text-center p-3 rounded-xl bg-white border border-slate-100 shadow-sm">
                                            <div className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">Mood</div>
                                            <div className="text-amber-600 font-serif font-bold">{selectedSign.mood}</div>
                                        </div>
                                        <div className="text-center p-3 rounded-xl bg-white border border-slate-100 shadow-sm">
                                            <div className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">Lucky No.</div>
                                            <div className="text-amber-600 font-serif font-bold">{selectedSign.num}</div>
                                        </div>
                                        <div className="text-center p-3 rounded-xl bg-white border border-slate-100 shadow-sm">
                                            <div className="text-xs text-slate-400 uppercase font-bold tracking-wider mb-1">Color</div>
                                            <div className="text-amber-600 font-serif font-bold">{selectedSign.color}</div>
                                        </div>
                                    </div>
                                </div>

                                <div className="p-4 bg-slate-50 border-t border-slate-200 text-center shrink-0">
                                    <p className="text-[10px] text-slate-400 font-medium uppercase tracking-widest">AstroTech Wealth Analytics</p>
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
