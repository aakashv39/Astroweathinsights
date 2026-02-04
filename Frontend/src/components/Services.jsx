import React from 'react';
import { motion } from 'framer-motion';
import { Icon } from '@iconify/react';
import { Link } from 'react-router-dom';

const Services = () => {
    const container = {
        hidden: { opacity: 0 },
        visible: {
            opacity: 1,
            transition: { staggerChildren: 0.15 }
        }
    };

    const item = {
        hidden: { opacity: 0, y: 30 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.5 } }
    };

    const services = [
        {
            icon: "ph:file-pdf-fill",
            title: "Varshaphal Report",
            description: "Get your personalized annual prediction report with detailed planetary analysis, Tajik yogas, and timing insights.",
            features: ["Birth Chart Analysis", "Planetary Strength", "Annual Predictions"],
            link: "/get-started",
            color: "from-amber-400 to-orange-500"
        },
        {
            icon: "ph:video-camera-fill",
            title: "Expert Consultancy",
            description: "One-on-one video consultation with our expert astrologers for personalized guidance and remedies.",
            features: ["45-Min Session", "Personalized Remedies", "Follow-up Support"],
            link: "/book-consultancy",
            color: "from-purple-400 to-indigo-500"
        },
        {
            icon: "ph:chart-line-up-fill",
            title: "Trading Insights",
            description: "Astrological market timing for traders with volatility predictions and sector analysis.",
            features: ["Market Timing", "Risk Assessment", "Daily Alerts"],
            link: "#",
            color: "from-emerald-400 to-teal-500"
        },
        {
            icon: "ph:star-four-fill",
            title: "Kundli Matching",
            description: "Comprehensive horoscope matching for marriage compatibility analysis.",
            features: ["Guna Milan", "Manglik Check", "Compatibility Score"],
            link: "#",
            color: "from-pink-400 to-rose-500"
        }
    ];

    return (
        <section id="services" className="py-20 px-6 md:px-20 bg-transparent">
            <motion.div
                initial="hidden"
                whileInView="visible"
                viewport={{ once: true, amount: 0.2 }}
                variants={container}
                className="max-w-7xl mx-auto"
            >
                {/* Header */}
                <div className="text-center mb-16">
                    <motion.div variants={item} className="flex items-center justify-center gap-2 mb-4">
                        <div className="h-[1px] w-12 bg-amber-300"></div>
                        <span className="text-amber-600 font-serif italic text-lg tracking-wide">Our Expertise</span>
                        <div className="h-[1px] w-12 bg-amber-300"></div>
                    </motion.div>
                    <motion.h2 variants={item} className="text-4xl md:text-5xl font-serif font-black text-slate-900 mb-6 leading-tight">
                        What We Offer
                    </motion.h2>
                    <motion.p variants={item} className="text-lg text-slate-600 font-light max-w-xl mx-auto leading-relaxed">
                        Explore our range of premium astrological services designed to guide your path to wealth and success.
                    </motion.p>
                </div>

                {/* Services Grid */}
                <motion.div variants={container} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    {services.map((service, idx) => (
                        <motion.div
                            key={idx}
                            variants={item}
                            className="relative bg-white/60 backdrop-blur-md rounded-2xl p-8 border border-white/50 shadow-sm hover:shadow-xl hover:shadow-amber-500/10 hover:bg-white transition-all duration-300 group hover:-translate-y-2"
                        >
                            {/* Icon */}
                            <div className="w-14 h-14 rounded-xl bg-gradient-to-br from-amber-400 to-amber-600 flex items-center justify-center mb-6 shadow-lg shadow-amber-500/20 group-hover:scale-110 transition-transform duration-300">
                                <Icon icon={service.icon} className="text-white text-2xl" />
                            </div>

                            {/* Content */}
                            <h3 className="text-xl font-serif font-bold text-slate-900 mb-3 group-hover:text-amber-700 transition-colors">{service.title}</h3>
                            <p className="text-slate-600 text-sm mb-6 leading-relaxed min-h-[60px]">{service.description}</p>

                            {/* Features */}
                            <ul className="space-y-2.5 mb-6 border-t border-slate-100 pt-6">
                                {service.features.map((feature, i) => (
                                    <li key={i} className="flex items-center gap-2.5 text-xs font-medium text-slate-500">
                                        <Icon icon="ph:star-fill" className="text-amber-400 flex-shrink-0 text-xs" />
                                        {feature}
                                    </li>
                                ))}
                            </ul>

                            {/* CTA Button */}
                            <Link
                                to={service.link}
                                className="inline-flex items-center gap-2 text-sm font-bold text-amber-600 hover:text-amber-800 transition-all uppercase tracking-wider group-hover:gap-3"
                            >
                                Learn More
                                <Icon icon="ph:arrow-right-bold" />
                            </Link>
                        </motion.div>
                    ))}
                </motion.div>
            </motion.div>
        </section>
    );
};

export default Services;
