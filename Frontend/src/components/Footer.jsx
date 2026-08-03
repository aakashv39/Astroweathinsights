import React from 'react';
import { Icon } from '@iconify/react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';

const Footer = () => {
    return (
        <footer id="footer" className="relative bg-slate-900 border-t border-slate-800 text-slate-300 overflow-hidden">
            {/* Background Decor */}
            <div className="absolute top-0 left-0 w-full h-full pointer-events-none opacity-20">
                <div className="absolute top-[-20%] left-[-10%] w-[500px] h-[500px] bg-amber-500/30 rounded-full blur-[120px]"></div>
                <div className="absolute bottom-[-20%] right-[-10%] w-[500px] h-[500px] bg-indigo-500/20 rounded-full blur-[120px]"></div>
            </div>

            <div className="relative max-w-7xl mx-auto px-6 md:px-12 pt-12 pb-6">
                {/* CTA Section */}
                <div className="flex flex-col md:flex-row items-center justify-between gap-6 border-b border-slate-800 pb-10 mb-10">
                    <div className="max-w-2xl text-center md:text-left">
                        <h2 className="text-2xl md:text-3xl font-serif font-bold text-white mb-2">
                            Ready to Align with Your <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-400 to-amber-600">Cosmic Destiny?</span>
                        </h2>
                        <p className="text-slate-400 text-base">
                            Get personalized financial and career insights delivered daily.
                        </p>
                    </div>
                    <Link
                        to="/get-started"
                        className="bg-gradient-to-r from-amber-500 to-amber-700 text-white px-6 py-3 rounded-lg font-bold text-xs uppercase tracking-widest hover:scale-105 hover:shadow-xl hover:shadow-amber-900/20 transition-all duration-300 shadow-lg whitespace-nowrap"
                    >
                        Get Started Now
                    </Link>
                </div>

                {/* Main Footer Content */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-8">
                    {/* Brand Column */}
                    <div>
                        <Link to="/" className="font-serif font-black text-xl text-white tracking-tight flex items-center gap-2 no-underline mb-4">
                            <span>AstroTech<span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-400 to-amber-600">Wealth</span></span>
                        </Link>
                        <p className="text-slate-500 text-sm leading-relaxed mb-4 max-w-sm">
                            Merging ancient Vedic wisdom with modern technological precision to guide your financial journey.
                        </p>
                    </div>

                    {/* Contact Column */}
                    <div className="md:text-right">
                        <h4 className="text-white font-bold text-base mb-4 font-serif">Contact Us</h4>
                        <ul className="space-y-2 inline-block text-left text-sm">
                            <li className="flex items-center gap-3 text-slate-400">
                                <Icon icon="ph:phone-fill" className="text-amber-500 text-lg shrink-0" />
                                <span>+91 85277 70474</span>
                            </li>
                            <li className="flex items-center gap-3 text-slate-400">
                                <Icon icon="ph:envelope-fill" className="text-amber-500 text-lg shrink-0" />
                                <span>support@astrotechwealth.com</span>
                            </li>
                        </ul>
                    </div>
                </div>

                <div className="pt-8 border-t border-slate-800 text-center md:text-left flex flex-col md:flex-row justify-between items-center text-sm text-slate-600 gap-4">
                    <p>© 2026 AstroTechWealth. All rights reserved.</p>
                    <p className="flex items-center gap-1">
                        Made with <Icon icon="ph:heart-fill" className="text-red-500" /> for the Stars
                    </p>
                </div>
            </div>
        </footer>
    );
};

export default Footer;
