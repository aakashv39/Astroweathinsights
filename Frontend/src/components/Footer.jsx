import React from 'react';
import { Icon } from '@iconify/react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';

const Footer = () => {
    return (
        <motion.footer
            className="bg-white/80 backdrop-blur-xl border-t border-white/50 pt-24 pb-8 px-6 md:px-12"
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.8 }}
        >
            <div className="max-w-4xl mx-auto text-center mb-16">
                <div className="mb-10">
                    <h2 className="text-4xl md:text-5xl font-serif font-black text-slate-900 leading-tight mb-4">
                        Ready to Unlock Your<br />
                        <span className="bg-gradient-to-r from-amber-500 to-amber-700 bg-clip-text text-transparent">Cosmic Blueprint?</span>
                    </h2>
                    <Link
                        to="/get-started"
                        className="bg-gradient-to-r from-amber-500 to-amber-700 text-white px-10 py-4 rounded-full font-semibold text-lg shadow-lg hover:shadow-amber-500/20 shadow-amber-500/10 transition-all hover:-translate-y-0.5 inline-block no-underline"
                    >
                        Get Started
                    </Link>
                </div>

                <div className="flex flex-col md:flex-row justify-center items-center gap-4 md:gap-8 text-slate-600 font-medium">
                    <div className="flex items-center gap-2">
                        <Icon icon="ph:phone-fill" className="text-xl text-amber-600" />
                        +91 98765 43210
                    </div>
                    <span className="hidden md:block text-slate-300">|</span>
                    <div className="flex items-center gap-2">
                        <Icon icon="ph:envelope-fill" className="text-xl text-amber-600" />
                        hello@astrotech.com
                    </div>
                </div>
            </div>

            <div className="max-w-7xl mx-auto pt-8 border-t border-slate-200 flex flex-col md:flex-row justify-between items-center gap-4 text-sm text-slate-500">
                <div className="copyright">
                    © 2024 AstroTech Wealth. All rights reserved.
                </div>
                <div className="flex gap-6">
                    <a href="#privacy" className="hover:text-amber-600 transition-colors">Privacy Policy</a>
                    <a href="#terms" className="hover:text-amber-600 transition-colors">Terms of Service</a>
                </div>
            </div>
        </motion.footer>
    );
};

export default Footer;
