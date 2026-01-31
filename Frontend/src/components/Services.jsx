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
        <section id="services" className="py-12 px-6 md:px-12 bg-white">
            <motion.div
                initial="hidden"
                whileInView="visible"
                viewport={{ once: true, amount: 0.2 }}
                variants={container}
                className="max-w-7xl mx-auto"
            >
                {/* Header */}
                <div className="text-center mb-12">
                    <motion.div variants={item} className="inline-flex items-center gap-2 bg-amber-100 text-amber-700 px-4 py-2 rounded-full text-sm font-semibold mb-4">
                        <Icon icon="ph:sparkle-fill" />
                        Our Services
                    </motion.div>
                    <motion.h2 variants={item} className="text-3xl md:text-4xl font-bold text-slate-900 mb-4">
                        What We Offer
                    </motion.h2>
                    <motion.p variants={item} className="text-slate-500 max-w-xl mx-auto">
                        Explore our range of astrological services designed to guide you.
                    </motion.p>
                </div>

                {/* Services Grid */}
                <motion.div variants={container} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    {services.map((service, idx) => (
                        <motion.div
                            key={idx}
                            variants={item}
                            className="relative bg-white rounded-2xl p-6 border border-slate-100 shadow-sm hover:shadow-lg transition-all duration-300 group hover:-translate-y-1"
                        >
                            {/* Icon */}
                            <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${service.color} flex items-center justify-center mb-4 shadow-md group-hover:scale-110 transition-transform`}>
                                <Icon icon={service.icon} className="text-white text-xl" />
                            </div>

                            {/* Content */}
                            <h3 className="text-lg font-bold text-slate-800 mb-2">{service.title}</h3>
                            <p className="text-slate-500 text-sm mb-4 leading-relaxed">{service.description}</p>

                            {/* Features */}
                            <ul className="space-y-1.5 mb-4">
                                {service.features.map((feature, i) => (
                                    <li key={i} className="flex items-center gap-2 text-xs text-slate-600">
                                        <Icon icon="ph:check-circle-fill" className="text-green-500 flex-shrink-0 text-sm" />
                                        {feature}
                                    </li>
                                ))}
                            </ul>

                            {/* CTA Button */}
                            <Link
                                to={service.link}
                                className={`inline-flex items-center gap-1 text-sm font-semibold bg-gradient-to-r ${service.color} bg-clip-text text-transparent hover:gap-2 transition-all`}
                            >
                                Learn More
                                <Icon icon="ph:arrow-right" className="text-amber-500" />
                            </Link>
                        </motion.div>
                    ))}
                </motion.div>
            </motion.div>
        </section>
    );
};

export default Services;
