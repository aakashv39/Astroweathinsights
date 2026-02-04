import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Icon } from '@iconify/react';
import { Link } from 'react-router-dom';

const Hero = () => {
    const [showReport, setShowReport] = useState(false);

    const fadeInUp = {
        hidden: { opacity: 0, y: 20 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.6 } }
    };

    const staggerContainer = {
        hidden: { opacity: 0 },
        visible: {
            opacity: 1,
            transition: {
                staggerChildren: 0.2
            }
        }
    };

    return (
        <section className="relative min-h-[85vh] flex items-center overflow-hidden px-6 md:px-12 lg:px-20 pt-24 lg:pt-0 pb-12 lg:pb-8">
            <div className="w-full max-w-[1440px] mx-auto flex flex-col lg:flex-row items-center justify-between gap-10 lg:gap-16">
                <motion.div
                    className="flex-1 max-w-full lg:max-w-xl text-center lg:text-left z-10"
                    initial="hidden"
                    animate="visible"
                    variants={staggerContainer}
                >
                    <motion.h1 variants={fadeInUp} className="text-3xl sm:text-4xl md:text-5xl lg:text-5xl font-serif font-black leading-[1.2] mb-4 text-slate-900">
                        Personalized Astrology Guidance for <span className="bg-gradient-to-br from-amber-400 to-amber-600 bg-clip-text text-transparent">Wealth, Career & Life</span>
                    </motion.h1>
                    <motion.p className="text-base md:text-lg text-slate-600 mb-8 max-w-lg mx-auto lg:mx-0 leading-relaxed" variants={fadeInUp}>
                        Leveraging advanced algorithms and Vedic wisdom to provide precise financial and life path predictions. Experience the future of spiritual guidance.
                    </motion.p>

                    <motion.div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start mb-10" variants={fadeInUp}>
                        <Link
                            to="/get-started"
                            className="bg-gradient-to-r from-amber-500 to-amber-700 text-white px-7 py-2.5 rounded-full font-semibold text-base shadow-lg shadow-amber-500/30 hover:shadow-xl hover:-translate-y-0.5 transition-all no-underline"
                        >
                            Get Started
                        </Link>
                        <motion.button
                            className="bg-white text-slate-900 px-7 py-2.5 rounded-full font-semibold text-base border border-slate-200 hover:bg-slate-50 hover:border-slate-300 transition-all shadow-sm"
                            whileHover={{ scale: 1.05 }}
                            whileTap={{ scale: 0.95 }}
                            onClick={() => setShowReport(true)}
                        >
                            View Sample Report
                        </motion.button>
                    </motion.div>

                    <motion.div className="flex flex-col sm:flex-row items-center gap-4 justify-center lg:justify-start" variants={fadeInUp}>
                        <div className="flex -space-x-3">
                            {[1, 2, 3, 4].map((i) => (
                                <img key={i} src={`https://i.pravatar.cc/100?img=${i}`} alt="User" className="w-8 h-8 rounded-full border-2 border-white" />
                            ))}
                        </div>
                        <span className="text-xs font-medium text-slate-500">Trusted by 10,000+ professionals</span>
                    </motion.div>
                </motion.div>

                <div className="flex-1 flex justify-center items-center relative w-full max-w-[500px]">
                    <motion.div
                        className="relative w-full aspect-square flex justify-center items-center"
                        initial={{ opacity: 0, scale: 0.8, rotate: -10 }}
                        animate={{ opacity: 1, scale: 1, rotate: 0 }}
                        transition={{ duration: 0.8, delay: 0.2 }}
                    >
                        <motion.img
                            src="/hero-wheel-gold.png"
                            alt="Astrology Wheel"
                            className="w-full h-auto mix-blend-multiply rounded-full"
                            animate={{ rotate: 360 }}
                            transition={{ duration: 60, repeat: Infinity, ease: "linear" }}
                        />
                        {/* Glow Effect */}
                        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-amber-500/10 rounded-full blur-3xl -z-10 pointer-events-none"></div>
                    </motion.div>
                </div>
            </div>

            <AnimatePresence>
                {showReport && (
                    <motion.div
                        className="fixed inset-0 bg-black/80 backdrop-blur-sm z-[100] flex justify-center items-center p-4 pl-[80px] md:pl-4"
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={() => setShowReport(false)}
                    >
                        <motion.div
                            className="bg-white w-full max-w-5xl h-[85vh] rounded-2xl relative shadow-2xl flex flex-col overflow-hidden"
                            initial={{ scale: 0.95, opacity: 0 }}
                            animate={{ scale: 1, opacity: 1 }}
                            exit={{ scale: 0.95, opacity: 0 }}
                            onClick={(e) => e.stopPropagation()}
                        >
                            <button className="absolute top-4 right-4 md:right-[-3rem] md:top-[-1rem] text-slate-400 hover:text-amber-500 transition-colors z-50 p-2 bg-white/10 rounded-full" onClick={() => setShowReport(false)}>
                                <Icon icon="ph:x-circle-fill" className="text-3xl md:text-white" />
                            </button>
                            <iframe
                                src="/sample-report.pdf"
                                title="Sample Astrology Report"
                                className="w-full h-full border-none"
                            ></iframe>
                        </motion.div>
                    </motion.div>
                )}
            </AnimatePresence>
        </section>
    );
};

export default Hero;
