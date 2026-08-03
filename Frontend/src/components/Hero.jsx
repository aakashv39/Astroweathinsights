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
        <section className="relative min-h-[90vh] flex items-center overflow-hidden px-6 md:px-12 lg:px-20 pt-28 lg:pt-24 pb-12 mt-8">
            <div className="absolute top-0 left-0 right-0 px-6 md:px-12 lg:px-20 z-20">
                <div className="max-w-7xl mx-auto bg-gradient-to-r from-amber-500 to-amber-700 text-white rounded-2xl px-4 md:px-6 py-3 shadow-xl shadow-amber-600/30">
                    <div className="flex flex-wrap items-center justify-center gap-2 text-xs md:text-sm font-semibold tracking-wide">
                        <Icon icon="ph:sparkle-fill" className="text-base" />
                        <span>First Session with Astrologer is FREE</span>
                    </div>
                </div>
            </div>

            <div className="w-full max-w-7xl mx-auto flex flex-col lg:flex-row items-center justify-center gap-12 lg:gap-20">
                <motion.div
                    className="flex-1 max-w-full lg:max-w-2xl text-center lg:text-left z-10"
                    initial="hidden"
                    animate="visible"
                    variants={staggerContainer}
                >
                    <motion.h1 variants={fadeInUp} className="text-4xl sm:text-5xl md:text-6xl lg:text-6xl font-serif font-black leading-[1.08] mb-5 text-slate-900">
                        Talk To <span className="bg-gradient-to-br from-amber-400 to-amber-700 bg-clip-text text-transparent">Astrologers</span> Right Now
                    </motion.h1>
                    <motion.p className="text-base md:text-lg text-slate-600 mb-8 max-w-xl mx-auto lg:mx-0 leading-relaxed" variants={fadeInUp}>
                        Connect with verified experts online for instant guidance on career, marriage, love, and finance.
                    </motion.p>

                    <motion.div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-8" variants={fadeInUp}>
                        <Link
                            to="/get-started"
                            className="bg-white/90 border border-amber-100 text-slate-900 rounded-2xl px-5 py-4 no-underline hover:-translate-y-1 hover:shadow-xl transition-all shadow-md"
                        >
                            <div className="flex items-center gap-3 mb-1">
                                <div className="w-9 h-9 rounded-full bg-amber-500 text-white grid place-items-center">
                                    <Icon icon="ph:chat-circle-dots-fill" className="text-lg" />
                                </div>
                                <span className="font-bold text-sm">Chat with Astrologer</span>
                            </div>
                            <p className="text-xs text-slate-500 m-0">First session free</p>
                        </Link>

                        <Link
                            to="/book-consultancy"
                            className="bg-white/90 border border-amber-100 text-slate-900 rounded-2xl px-5 py-4 no-underline hover:-translate-y-1 hover:shadow-xl transition-all shadow-md"
                        >
                            <div className="flex items-center gap-3 mb-1">
                                <div className="w-9 h-9 rounded-full bg-amber-700 text-white grid place-items-center">
                                    <Icon icon="ph:phone-call-fill" className="text-lg" />
                                </div>
                                <span className="font-bold text-sm">Call with Astrologer</span>
                            </div>
                            <p className="text-xs text-slate-500 m-0">Talk to experts instantly</p>
                        </Link>
                    </motion.div>

                    <motion.div className="flex flex-wrap items-center gap-3 justify-center lg:justify-start" variants={fadeInUp}>
                        {[
                            '100% Private',
                            'Verified Experts',
                            'Safe Payments',
                        ].map((item) => (
                            <span key={item} className="text-xs font-bold uppercase tracking-wider text-slate-600 bg-white/80 border border-slate-200 rounded-full px-3 py-1.5">
                                {item}
                            </span>
                        ))}
                    </motion.div>

                    <motion.div className="grid grid-cols-3 gap-3 mt-8" variants={fadeInUp}>
                        <div className="bg-white/70 border border-amber-100 rounded-xl px-3 py-3 text-center">
                            <p className="m-0 text-lg md:text-xl font-black text-slate-900">24x7</p>
                            <p className="m-0 text-[11px] text-slate-500 font-semibold">Available</p>
                        </div>
                        <div className="bg-white/70 border border-amber-100 rounded-xl px-3 py-3 text-center">
                            <p className="m-0 text-lg md:text-xl font-black text-slate-900">48,726+</p>
                            <p className="m-0 text-[11px] text-slate-500 font-semibold">Astrologers</p>
                        </div>
                        <div className="bg-white/70 border border-amber-100 rounded-xl px-3 py-3 text-center">
                            <p className="m-0 text-lg md:text-xl font-black text-slate-900">120M+</p>
                            <p className="m-0 text-[11px] text-slate-500 font-semibold">Customers</p>
                        </div>
                    </motion.div>
                </motion.div>

                <div className="flex-1 flex justify-center items-center relative w-full max-w-[560px]">
                    <motion.div
                        className="relative w-full aspect-square flex justify-center items-center"
                        initial={{ opacity: 0, scale: 0.85, rotate: -8 }}
                        animate={{ opacity: 1, scale: 1, rotate: 0 }}
                        transition={{ duration: 0.8, delay: 0.2 }}
                    >
                        <motion.div
                            className="absolute inset-0 rounded-full border border-amber-200/50"
                            animate={{ rotate: -360 }}
                            transition={{ duration: 90, repeat: Infinity, ease: 'linear' }}
                        />
                        <motion.img
                            src="/hero-wheel-gold.png"
                            alt="Astrology Wheel"
                            className="w-full h-auto mix-blend-multiply rounded-full"
                            animate={{ rotate: 360 }}
                            transition={{ duration: 65, repeat: Infinity, ease: "linear" }}
                        />
                        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[130%] h-[130%] bg-amber-500/10 rounded-full blur-3xl -z-10 pointer-events-none"></div>

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
