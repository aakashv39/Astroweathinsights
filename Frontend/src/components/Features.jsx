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
        <section className="min-h-screen flex flex-col justify-center py-24 px-6 md:px-12 bg-white/40 backdrop-blur-md text-slate-900 text-center relative z-10 border-t border-white/50 shadow-[0_-20px_40px_rgba(0,0,0,0.02)]">
            <motion.div
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                className="mb-12 text-center"
            >
                <div className="inline-block px-4 py-2 bg-amber-100/80 text-amber-700 rounded-full font-display text-sm font-semibold uppercase tracking-wider mb-4 border border-amber-200">
                    Daily Forecast
                </div>
                <h2 className="text-4xl md:text-5xl font-extrabold mb-4 text-slate-900">
                    Daily Planetary Forecast
                </h2>
                <p className="text-lg text-slate-500 max-w-2xl mx-auto leading-relaxed">
                    Select your zodiac sign to reveal your personalized wealth and career reading for today.
                </p>
            </motion.div>

            {/* Grid Always Visible */}
            <motion.div
                className="flex flex-wrap justify-center gap-8 max-w-[1300px] mx-auto"
                initial={{ opacity: 0 }}
                whileInView={{ opacity: 1 }}
                viewport={{ once: true }}
            >
                {zodiacData.map((sign) => (
                    <motion.div
                        key={sign.name}
                        className="group flex-none w-[200px] bg-white p-8 rounded-2xl cursor-pointer border border-slate-200 transition-all shadow-sm hover:shadow-xl hover:shadow-amber-500/10 hover:border-amber-400 flex flex-col items-center gap-2"
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        onClick={() => setSelectedSign(sign)}
                        layoutId={`card-${sign.name}`}
                    >
                        <div className="w-[120px] h-[120px] flex items-center justify-center">
                            <img src={sign.img} alt={sign.name} className="w-full h-full object-contain transition-transform duration-300 group-hover:scale-110" />
                        </div>
                        <span className="hidden font-display font-semibold text-slate-900">{sign.name}</span>
                    </motion.div>
                ))}
            </motion.div>

            {/* Modal Overlay */}
            <AnimatePresence>
                {selectedSign && (
                    <motion.div
                        className="fixed inset-0 bg-transparent backdrop-blur-md z-[100] flex items-center justify-center p-4"
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        transition={{ duration: 0.2 }} // Fast fade
                        onClick={() => setSelectedSign(null)}
                    >
                        <motion.div
                            className="w-full max-w-[700px] bg-white rounded-3xl overflow-hidden shadow-2xl relative"
                            layoutId={`card-${selectedSign.name}`}
                            transition={{ type: "spring", stiffness: 400, damping: 30 }} // Fast smooth pop
                            onClick={(e) => e.stopPropagation()}
                        >
                            <button className="absolute top-4 right-4 bg-transparent border-none text-3xl text-slate-400 hover:text-amber-600 cursor-pointer z-10 transition-colors" onClick={() => setSelectedSign(null)}>
                                <Icon icon="ph:x-circle-fill" />
                            </button>

                            <div className="p-12 border-none shadow-none">
                                <div className="flex items-center gap-4 mb-6">
                                    <div className="w-20 h-20 rounded-full flex items-center justify-center bg-amber-500/10 p-3">
                                        <img src={selectedSign.img} alt={selectedSign.name} className="w-full h-full object-contain" />
                                    </div>
                                    <div>
                                        <h3 className="text-2xl font-bold text-slate-900 mb-1">{selectedSign.name}</h3>
                                        <div className="text-sm text-slate-500">{selectedSign.date} • {selectedSign.element}</div>
                                    </div>
                                </div>
                                <p className="text-slate-600 leading-relaxed mb-8 text-lg">
                                    <strong className="block mb-2 text-slate-800">Your Reading for Today:</strong>
                                    The stars are aligning in your favor. {selectedSign.element === 'Fire' ? 'Take bold action' : selectedSign.element === 'Earth' ? 'Focus on stability' : selectedSign.element === 'Air' ? 'Communicate your ideas' : 'Trust your intuition'} regarding your financial portfolio.
                                    A new opportunity may present itself unexpectedly—stay alert.
                                </p>
                                <div className="grid grid-cols-3 gap-4 pt-6 border-t border-slate-100">
                                    <div className="flex flex-col gap-1">
                                        <span className="text-xs uppercase text-slate-400 font-semibold tracking-wider">Mood</span>
                                        <span className="text-base font-semibold text-amber-600">{selectedSign.mood}</span>
                                    </div>
                                    <div className="flex flex-col gap-1">
                                        <span className="text-xs uppercase text-slate-400 font-semibold tracking-wider">Number</span>
                                        <span className="text-base font-semibold text-amber-600">{selectedSign.num}</span>
                                    </div>
                                    <div className="flex flex-col gap-1">
                                        <span className="text-xs uppercase text-slate-400 font-semibold tracking-wider">Color</span>
                                        <span className="text-base font-semibold text-amber-600">{selectedSign.color}</span>
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
