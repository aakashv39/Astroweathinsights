import React from 'react';
import { Icon } from '@iconify/react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';

const Footer = () => {
    return (
        <footer className="relative bg-slate-900 border-t border-slate-800 text-slate-300 overflow-hidden">
            {/* Background Decor */}
            <div className="absolute top-0 left-0 w-full h-full pointer-events-none opacity-20">
                <div className="absolute top-[-20%] left-[-10%] w-[500px] h-[500px] bg-amber-500/30 rounded-full blur-[120px]"></div>
                <div className="absolute bottom-[-20%] right-[-10%] w-[500px] h-[500px] bg-indigo-500/20 rounded-full blur-[120px]"></div>
            </div>

            <div className="relative max-w-7xl mx-auto px-6 md:px-12 pt-20 pb-10">
                {/* CTA Section */}
                <div className="flex flex-col md:flex-row items-center justify-between gap-10 border-b border-slate-800 pb-16 mb-16">
                    <div className="max-w-2xl text-center md:text-left">
                        <h2 className="text-3xl md:text-4xl font-serif font-bold text-white mb-4">
                            Ready to Align with Your <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-400 to-amber-600">Cosmic Destiny?</span>
                        </h2>
                        <p className="text-slate-400 text-lg">
                            Get personalized financial and career insights delivered daily.
                        </p>
                    </div>
                    <Link
                        to="/get-started"
                        className="bg-gradient-to-r from-amber-500 to-amber-700 text-white px-8 py-4 rounded-xl font-bold text-sm uppercase tracking-widest hover:scale-105 hover:shadow-xl hover:shadow-amber-900/20 transition-all duration-300 shadow-lg whitespace-nowrap"
                    >
                        Get Started Now
                    </Link>
                </div>

                {/* Main Footer Content */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12 mb-16">
                    {/* Brand Column */}
                    <div>
                        <Link to="/" className="font-serif font-black text-2xl text-white tracking-tight flex items-center gap-2 no-underline mb-6">
                            <span>AstroTech<span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-400 to-amber-600">Wealth</span></span>
                        </Link>
                        <p className="text-slate-500 leading-relaxed mb-6">
                            Merging ancient Vedic wisdom with modern technological precision to guide your financial journey.
                        </p>
                        <div className="flex gap-4">
                            <a href="#" className="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center hover:bg-amber-600 hover:text-white transition-all text-slate-400"><Icon icon="ph:instagram-logo-fill" className="text-xl" /></a>
                            <a href="#" className="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center hover:bg-amber-600 hover:text-white transition-all text-slate-400"><Icon icon="ph:twitter-logo-fill" className="text-xl" /></a>
                            <a href="#" className="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center hover:bg-amber-600 hover:text-white transition-all text-slate-400"><Icon icon="ph:linkedin-logo-fill" className="text-xl" /></a>
                        </div>
                    </div>

                    {/* Links Column 1 */}
                    <div>
                        <h4 className="text-white font-bold text-lg mb-6 font-serif">Services</h4>
                        <ul className="space-y-4">
                            <li><a href="#services" className="text-slate-400 hover:text-amber-400 transition-colors">Wealth Forecast</a></li>
                            <li><a href="#services" className="text-slate-400 hover:text-amber-400 transition-colors">Career Guidance</a></li>
                            <li><a href="#services" className="text-slate-400 hover:text-amber-400 transition-colors">Business Timing</a></li>
                            <li><a href="#services" className="text-slate-400 hover:text-amber-400 transition-colors">Investment Insights</a></li>
                        </ul>
                    </div>

                    {/* Links Column 2 */}
                    <div>
                        <h4 className="text-white font-bold text-lg mb-6 font-serif">Company</h4>
                        <ul className="space-y-4">
                            <li><Link to="/" className="text-slate-400 hover:text-amber-400 transition-colors">About Us</Link></li>
                            <li><Link to="/contact" className="text-slate-400 hover:text-amber-400 transition-colors">Contact</Link></li>
                            <li><a href="#" className="text-slate-400 hover:text-amber-400 transition-colors">Privacy Policy</a></li>
                            <li><a href="#" className="text-slate-400 hover:text-amber-400 transition-colors">Terms of Service</a></li>
                        </ul>
                    </div>

                    {/* Contact Column */}
                    <div>
                        <h4 className="text-white font-bold text-lg mb-6 font-serif">Contact Us</h4>
                        <ul className="space-y-4">
                            <li className="flex items-start gap-3 text-slate-400">
                                <Icon icon="ph:map-pin-fill" className="text-amber-500 text-xl shrink-0 mt-1" />
                                <span>123 Cosmic Way, Galaxy Business Park, New Delhi, India</span>
                            </li>
                            <li className="flex items-center gap-3 text-slate-400">
                                <Icon icon="ph:phone-fill" className="text-amber-500 text-xl shrink-0" />
                                <span>+91 85277 70474</span>
                            </li>
                            <li className="flex items-center gap-3 text-slate-400">
                                <Icon icon="ph:envelope-fill" className="text-amber-500 text-xl shrink-0" />
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
