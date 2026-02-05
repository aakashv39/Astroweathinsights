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
            icon: "ph:scroll-bold",
            title: "Varshaphal Report",
            description: "Get your personalized annual prediction report with detailed planetary analysis, Tajik yogas, and timing insights.",
            features: ["Birth Chart Analysis", "Planetary Strength", "Annual Predictions"],
            link: "/get-started",
            color: "from-amber-400 to-amber-600"
        },
        {
            icon: "ph:chats-teardrop-bold",
            title: "Expert Consultancy",
            description: "One-on-one video consultation with our expert astrologers for personalized guidance and remedies.",
            features: ["45-Min Session", "Personalized Remedies", "Follow-up Support"],
            link: "/book-consultancy",
            color: "from-amber-500 to-yellow-600"
        },
        {
            icon: "ph:graph-bold",
            title: "Trading Insights",
            description: "Astrological market timing for traders with volatility predictions and sector analysis.",
            features: ["Market Timing", "Risk Assessment", "Daily Alerts"],
            link: "#",
            color: "from-yellow-500 to-amber-700"
        },
        {
            icon: "ph:yin-yang-bold",
            title: "Kundli Matching",
            description: "Comprehensive horoscope matching for marriage compatibility analysis.",
            features: ["Guna Milan", "Manglik Check", "Compatibility Score"],
            link: "#",
            color: "from-amber-300 to-orange-400"
        }
    ];

    return (
        <section id="services" className="py-24 relative overflow-hidden bg-transparent">
            {/* Background Decor */}
            <div className="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none z-[-1]">
                <div className="absolute top-[-10%] right-[-5%] w-[500px] h-[500px] bg-amber-200/20 rounded-full blur-[100px]"></div>
                <div className="absolute bottom-[-10%] left-[-10%] w-[600px] h-[600px] bg-purple-200/20 rounded-full blur-[100px]"></div>
            </div>

            <div className="max-w-[1440px] mx-auto">
                {/* Header */}
                <div className="text-center mb-16 px-6">
                    <motion.div variants={item} className="flex items-center justify-center gap-3 mb-4">
                        <div className="h-[2px] w-8 bg-gradient-to-r from-transparent to-amber-400"></div>
                        <span className="text-amber-600 font-serif font-medium tracking-widest text-sm uppercase">Our Expertise</span>
                        <div className="h-[2px] w-8 bg-gradient-to-l from-transparent to-amber-400"></div>
                    </motion.div>
                    <motion.h2 variants={item} className="text-4xl md:text-6xl font-serif font-black text-slate-900 mb-6 tracking-tight">
                        Premium Services
                    </motion.h2>
                    <motion.p variants={item} className="text-lg text-slate-600 font-light max-w-2xl mx-auto leading-relaxed">
                        Discover our suite of elite astrological tools designed to empower your journey towards wealth, health, and enlightenment.
                    </motion.p>
                </div>

                {/* Services Carousel */}
                <motion.div
                    variants={container}
                    className="flex overflow-x-auto gap-6 pb-8 px-6 md:px-20 snap-x snap-mandatory scrollbar-hide relative z-10"
                    style={{
                        scrollbarWidth: 'none',
                        msOverflowStyle: 'none',
                        WebkitOverflowScrolling: 'touch'
                    }}
                >
                    {services.map((service, idx) => (
                        <motion.div
                            key={idx}
                            variants={item}
                            className="min-w-[280px] md:min-w-[320px] snap-center relative bg-white/80 backdrop-blur-sm rounded-2xl p-6 border border-slate-100 shadow-lg shadow-slate-200/50 hover:shadow-xl hover:shadow-amber-500/10 hover:-translate-y-1 transition-all duration-300 group"
                        >
                            {/* Icon */}
                            <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${service.color} flex items-center justify-center mb-4 shadow-md group-hover:scale-105 transition-transform duration-300`}>
                                <Icon icon={service.icon} className="text-white text-xl" />
                            </div>

                            {/* Content */}
                            <h3 className="text-xl font-serif font-bold text-slate-900 mb-2 group-hover:text-amber-700 transition-colors">{service.title}</h3>
                            <p className="text-slate-600 text-sm leading-relaxed mb-6 font-light">{service.description}</p>

                            {/* Features */}
                            <div className="space-y-3 pt-4 border-t border-slate-100">
                                {service.features.map((feature, i) => (
                                    <div key={i} className="flex items-center gap-2 text-xs font-semibold text-slate-500 group-hover:text-amber-700 transition-colors">
                                        <Icon icon="ph:check-circle-fill" className="text-amber-400 text-sm" />
                                        {feature}
                                    </div>
                                ))}
                            </div>
                        </motion.div>
                    ))}

                    {/* Spacer */}
                    <div className="min-w-[20px]"></div>
                </motion.div>
            </div>
        </section>
    );
};

export default Services;
