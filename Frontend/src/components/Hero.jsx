import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Icon } from '@iconify/react';
import { Link } from 'react-router-dom';

const Hero = () => {
    const [showReport, setShowReport] = useState(false);

    const fadeInUp = {
        hidden: { opacity: 0, y: 30 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.8, ease: "easeOut" } }
    };

    const staggerContainer = {
        hidden: { opacity: 0 },
        visible: {
            opacity: 1,
            transition: {
                staggerChildren: 0.2,
                delayChildren: 0.1
            }
        }
    };

    return (
        <section className="relative min-h-screen flex flex-col items-center justify-center overflow-hidden px-6 md:px-20 pt-32 pb-20">

            {/* Background Wheel - Centralized & Large */}
            <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] md:w-[1000px] md:h-[1000px] -z-10 opacity-25 select-none pointer-events-none">
                <motion.div
                    className="w-full h-full"
                    animate={{ rotate: 360 }}
                    transition={{ duration: 120, repeat: Infinity, ease: "linear" }}
                >
                    <img src="/hero-wheel-gold.png" alt="" className="w-full h-full object-contain mix-blend-multiply" />
                </motion.div>
                {/* Glow Core */}
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[300px] h-[300px] bg-amber-500/20 blur-[100px] rounded-full"></div>
            </div>

            <motion.div
                className="w-full max-w-5xl mx-auto text-center z-10 flex flex-col items-center"
                initial="hidden"
                animate="visible"
                variants={staggerContainer}
            >
                <motion.div variants={fadeInUp} className="mb-8 inline-block">
                    <span className="px-5 py-2 rounded-full border border-amber-200/60 bg-white/60 backdrop-blur-md text-amber-800 text-xs font-bold tracking-[0.2em] uppercase shadow-sm">
                        AI-Powered Vedic Precision
                    </span>
                </motion.div>

                <motion.h1
                    variants={fadeInUp}
                    className="text-5xl sm:text-6xl md:text-7xl lg:text-8xl font-serif font-medium leading-[1.1] mb-8 text-slate-800 tracking-tight"
                >
                    Unlock Your Cosmic <br className="hidden md:block" />
                    <span className="italic font-light text-amber-600">Wealth Potential</span>
                </motion.h1>

                <motion.p
                    className="text-lg md:text-xl text-slate-600 mb-12 max-w-2xl mx-auto leading-relaxed font-light font-sans"
                    variants={fadeInUp}
                >
                    Align your financial destiny with the stars. Experience precise life-path guidance powered by ancient Vedic wisdom.
                </motion.p>

                <motion.div
                    className="flex flex-col sm:flex-row gap-5 justify-center w-full mb-20"
                    variants={fadeInUp}
                >
                    <Link
                        to="/get-started"
                        className="group relative overflow-hidden bg-gradient-to-r from-amber-500 via-amber-400 to-amber-600 text-white px-8 py-3.5 rounded-full font-bold text-base shadow-lg shadow-amber-500/40 hover:shadow-xl hover:shadow-amber-500/50 hover:-translate-y-0.5 transition-all duration-300 no-underline min-w-[180px]"
                    >
                        <span className="relative z-10">Get Started</span>
                        <div className="absolute inset-0 -translate-x-full group-hover:translate-x-full transition-transform duration-700 ease-in-out bg-gradient-to-r from-transparent via-white/30 to-transparent skew-x-12"></div>
                    </Link>
                    <motion.button
                        className="bg-transparent text-slate-700 px-8 py-3.5 rounded-full font-bold text-base border border-amber-200 hover:border-amber-500 hover:text-amber-800 transition-all flex items-center justify-center gap-2 group min-w-[180px]"
                        onClick={() => setShowReport(true)}
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                    >
                        <Icon icon="ph:play-circle" className="text-xl text-amber-400 group-hover:text-amber-600 transition-colors" />
                        See Example
                    </motion.button>
                </motion.div>

                <motion.div
                    className="flex flex-col items-center gap-4 justify-center"
                    variants={fadeInUp}
                >
                    <div className="flex -space-x-4 grayscale opacity-80 hover:grayscale-0 hover:opacity-100 transition-all duration-500">
                        {[1, 2, 3, 4, 5].map((i) => (
                            <img key={i} src={`https://i.pravatar.cc/100?img=${i + 10}`} alt="User" className="w-12 h-12 rounded-full border-4 border-white shadow-sm" />
                        ))}
                    </div>
                    <div className="text-sm font-medium text-amber-900/60 tracking-wide uppercase text-[10px]">
                        Trusted by 10,000+ professionals
                    </div>
                </motion.div>
            </motion.div>

            {/* Scroll Indicator */}
            <motion.div
                className="absolute bottom-10 left-1/2 -translate-x-1/2 text-slate-400 flex flex-col items-center gap-2"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1, y: [0, 10, 0] }}
                transition={{ delay: 2, duration: 2, repeat: Infinity }}
            >
                <span className="text-xs uppercase tracking-widest font-semibold">Scroll</span>
                <Icon icon="ph:arrow-down-simple" />
            </motion.div>

            <AnimatePresence>
                {showReport && (
                    <motion.div
                        className="fixed inset-0 bg-slate-900/80 backdrop-blur-md z-[200] flex justify-center items-center p-4 md:p-8"
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        onClick={() => setShowReport(false)}
                    >
                        <motion.div
                            className="bg-white w-full max-w-6xl h-full md:h-[90vh] rounded-3xl relative shadow-2xl flex flex-col overflow-hidden ring-1 ring-white/20"
                            initial={{ scale: 0.9, opacity: 0, y: 40 }}
                            animate={{ scale: 1, opacity: 1, y: 0 }}
                            exit={{ scale: 0.95, opacity: 0, y: 20 }}
                            transition={{ type: "spring", damping: 25, stiffness: 300 }}
                            onClick={(e) => e.stopPropagation()}
                        >
                            <button
                                className="absolute top-6 right-6 z-50 p-2 bg-slate-100 hover:bg-slate-200 rounded-full transition-colors group"
                                onClick={() => setShowReport(false)}
                            >
                                <Icon icon="ph:x-bold" className="text-2xl text-slate-500 group-hover:text-slate-800" />
                            </button>
                            <div className="w-full h-full bg-slate-100 p-1 md:p-2">
                                <iframe
                                    src="/sample-report.pdf"
                                    title="Sample Astrology Report"
                                    className="w-full h-full rounded-2xl bg-white shadow-inner"
                                ></iframe>
                            </div>
                        </motion.div>
                    </motion.div>
                )}
            </AnimatePresence>
        </section>
    );
};

export default Hero;
