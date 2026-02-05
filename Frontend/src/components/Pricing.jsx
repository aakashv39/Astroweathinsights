import React, { useEffect, useState } from 'react';
import { Icon } from '@iconify/react';
import { motion } from 'framer-motion';
import { createOrder, verifyPayment } from '../services/api';

const Pricing = () => {
    const [loadingPlan, setLoadingPlan] = useState(null);
    const [paymentStatus, setPaymentStatus] = useState({ show: false, success: false, message: '' });

    // Load Razorpay Script
    useEffect(() => {
        const script = document.createElement('script');
        script.src = 'https://checkout.razorpay.com/v1/checkout.js';
        script.async = true;
        document.body.appendChild(script);
        return () => {
            if (document.body.contains(script)) {
                document.body.removeChild(script);
            }
        }
    }, []);

    const showStatus = (success, message) => {
        setPaymentStatus({ show: true, success, message });
        setTimeout(() => setPaymentStatus({ show: false, success: false, message: '' }), 5000);
    };

    const handlePayment = async (amount, planName) => {
        const token = localStorage.getItem('token');
        if (!token) {
            showStatus(false, 'Please sign in to purchase a plan');
            return;
        }

        setLoadingPlan(planName);

        try {
            const order = await createOrder(amount);

            const options = {
                key: import.meta.env.VITE_RAZORPAY_KEY_ID,
                amount: order.amount,
                currency: order.currency,
                name: "AstroTech Wealth",
                description: `Purchase ${planName}`,
                order_id: order.id,
                handler: async function (response) {
                    try {
                        const verify = await verifyPayment({
                            razorpay_order_id: response.razorpay_order_id,
                            razorpay_payment_id: response.razorpay_payment_id,
                            razorpay_signature: response.razorpay_signature
                        });
                        showStatus(true, verify.message || 'Payment successful! Thank you for your purchase.');
                    } catch (err) {
                        showStatus(false, 'Payment verification failed. Please contact support.');
                    }
                    setLoadingPlan(null);
                },
                modal: {
                    ondismiss: function () {
                        setLoadingPlan(null);
                    }
                },
                prefill: {
                    name: "",
                    email: "",
                    contact: ""
                },
                theme: {
                    color: "#d97706"
                }
            };

            const rzp = new window.Razorpay(options);
            rzp.on('payment.failed', function (response) {
                showStatus(false, response.error.description || 'Payment failed. Please try again.');
                setLoadingPlan(null);
            });
            rzp.open();

        } catch (error) {
            console.error('Payment Error', error);
            showStatus(false, error.message || 'Something went wrong. Please try again.');
            setLoadingPlan(null);
        }
    };

    const container = {
        hidden: { opacity: 0 },
        visible: {
            opacity: 1,
            transition: { staggerChildren: 0.2 }
        }
    };

    const item = {
        hidden: { opacity: 0, y: 30 },
        visible: { opacity: 1, y: 0, transition: { duration: 0.6 } }
    };

    const plans = [
        {
            name: "Report Generation",
            icon: "ph:file-pdf-fill",
            price: 499,
            period: "/report",
            description: "Get your personalized Varshaphal annual prediction report.",
            features: ['Complete Birth Chart Analysis', 'Planetary Strength Report', 'Tajik Yoga Detection', 'Annual Predictions PDF', 'Sahama Timing Analysis'],
            popular: false,
            locked: false
        },
        {
            name: "Expert Consultancy",
            icon: "ph:video-camera-fill",
            price: 2999,
            period: "/session",
            description: "One-on-one session with our expert astrologers.",
            features: ['Everything in Report Generation', '45-Minute Video Consultation', 'Personalized Remedies', 'Career & Relationship Guidance', 'Follow-up Support'],
            popular: true,
            locked: false
        },
        {
            name: "Trading Insights",
            icon: "ph:chart-line-up-fill",
            price: 4999,
            period: "/month",
            description: "Astrological market timing for traders.",
            features: ['Market Volatility Predictions', 'Sector-Specific Analysis', 'Daily Trading Windows', 'Risk Assessment Reports', 'Premium Alerts'],
            popular: false,
            locked: true,
            comingSoon: true
        }
    ];


    return (
        <section className="relative py-24 px-6 md:px-20 overflow-hidden">
            {/* Background Atmosphere */}
            <div className="absolute inset-0 pointer-events-none z-[-1]">
                <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-amber-100/40 rounded-full blur-[120px]"></div>
                <div className="absolute bottom-0 right-0 w-[400px] h-[400px] bg-purple-50/50 rounded-full blur-[100px]"></div>
            </div>

            {/* Payment Status Toast */}
            {paymentStatus.show && (
                <div className={`fixed top-8 left-1/2 -translate-x-1/2 z-[200] px-6 py-4 rounded-xl shadow-2xl flex items-center gap-4 animate-slideDown backdrop-blur-md border ${paymentStatus.success ? 'bg-emerald-50/90 border-emerald-200 text-emerald-800' : 'bg-red-50/90 border-red-200 text-red-800'
                    }`}>
                    <Icon icon={paymentStatus.success ? "ph:check-circle-fill" : "ph:warning-circle-fill"} className="text-2xl" />
                    <div>
                        <h4 className="font-bold text-sm uppercase tracking-wide">{paymentStatus.success ? 'Success' : 'Error'}</h4>
                        <p className="text-sm font-medium">{paymentStatus.message}</p>
                    </div>
                    <button onClick={() => setPaymentStatus({ show: false, success: false, message: '' })} className="ml-2 hover:opacity-60 transition-opacity">
                        <Icon icon="ph:x-bold" className="text-lg" />
                    </button>
                </div>
            )}

            <motion.div
                initial="hidden"
                whileInView="visible"
                viewport={{ once: true, amount: 0.2 }}
                variants={container}
                className="max-w-7xl mx-auto"
            >
                {/* Header */}
                <div className="text-center mb-20">
                    <motion.div variants={item} className="inline-block mb-4">
                        <div className="flex items-center gap-2 px-3 py-1 rounded-full bg-amber-50 border border-amber-100 mb-4 mx-auto w-fit">
                            <span className="w-2 h-2 rounded-full bg-amber-500 animate-pulse"></span>
                            <span className="text-xs font-bold text-amber-700 uppercase tracking-widest">Invest in Yourself</span>
                        </div>
                    </motion.div>
                    <motion.h2 variants={item} className="text-5xl md:text-6xl font-serif font-black text-slate-900 mb-6 tracking-tight">
                        Simple, Transparent <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-500 to-amber-700">Pricing</span>
                    </motion.h2>
                    <motion.p variants={item} className="text-xl text-slate-600 font-light max-w-2xl mx-auto">
                        Choose the perfect plan to unlock the mysteries of your financial and personal destiny.
                    </motion.p>
                </div>

                <motion.div className="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start max-w-6xl mx-auto" variants={container}>
                    {plans.map((plan, idx) => (
                        <motion.div
                            key={plan.name}
                            className={`relative group rounded-[1.5rem] p-6 transition-all duration-500 ${plan.popular
                                ? 'bg-slate-900 text-white shadow-2xl shadow-amber-900/20 scale-105 z-10 ring-1 ring-white/10'
                                : 'bg-white/80 backdrop-blur-lg border border-slate-100 text-slate-900 hover:shadow-xl hover:shadow-slate-200/50 hover:border-amber-200/50 hover:-translate-y-2'
                                } ${plan.locked ? 'opacity-90' : ''}`}
                            variants={item}
                        >
                            {/* Popular Badge */}
                            {plan.popular && (
                                <div className="absolute top-0 left-1/2 -translate-x-1/2 -translate-y-1/2">
                                    <span className="bg-gradient-to-r from-amber-400 to-amber-600 text-white text-[10px] font-bold px-3 py-1 rounded-full uppercase tracking-wider shadow-lg shadow-amber-500/30 ring-4 ring-white dark:ring-slate-900">
                                        Most Popular
                                    </span>
                                </div>
                            )}

                            {/* Locked Badge */}
                            {plan.comingSoon && (
                                <div className="absolute inset-0 bg-slate-900/10 backdrop-blur-[2px] rounded-[1.5rem] z-20 flex items-center justify-center">
                                    <div className="bg-white/90 backdrop-blur-md px-5 py-2.5 rounded-xl shadow-xl flex items-center gap-3 border border-white">
                                        <Icon icon="ph:lock-key-fill" className="text-amber-500 text-xl" />
                                        <div>
                                            <div className="text-slate-900 font-bold text-xs uppercase tracking-wider">Coming Soon</div>
                                            <div className="text-slate-500 text-[10px]">Join the waitlist</div>
                                        </div>
                                    </div>
                                </div>
                            )}

                            {/* Card Header */}
                            <div className="mb-6 text-center relative">
                                <div className={`w-12 h-12 mx-auto rounded-xl flex items-center justify-center mb-4 text-2xl shadow-lg transition-transform group-hover:scale-110 duration-500 ${plan.popular ? 'bg-white/10 text-amber-400 ring-1 ring-white/20' : 'bg-amber-50 text-amber-600'}`}>
                                    <Icon icon={plan.icon} />
                                </div>
                                <h3 className={`text-xl font-serif font-bold mb-1 ${plan.popular ? 'text-white' : 'text-slate-900'}`}>{plan.name}</h3>
                                <div className="flex items-end justify-center gap-1 mb-3">
                                    <span className={`text-4xl font-bold tracking-tight ${plan.popular ? 'text-white' : 'text-slate-900'}`}>
                                        ₹{plan.price.toLocaleString()}
                                    </span>
                                    <span className={`text-sm font-medium mb-1 ${plan.popular ? 'text-slate-400' : 'text-slate-400'}`}>
                                        {plan.period}
                                    </span>
                                </div>
                                <p className={`text-xs ${plan.popular ? 'text-slate-300' : 'text-slate-500'} font-light px-2 leading-relaxed`}>
                                    {plan.description}
                                </p>
                            </div>

                            {/* Divider with gradient */}
                            <div className={`h-px w-full bg-gradient-to-r from-transparent via-current to-transparent opacity-20 mb-6 ${plan.popular ? 'text-white' : 'text-slate-300'}`}></div>

                            {/* Features */}
                            <ul className="space-y-3 mb-8">
                                {plan.features.map((feature, i) => (
                                    <li key={i} className={`flex items-start gap-2.5 text-xs font-medium ${plan.popular ? 'text-slate-200' : 'text-slate-600'}`}>
                                        <Icon icon="ph:check-circle-fill" className={`text-base flex-shrink-0 ${plan.popular ? 'text-amber-400' : 'text-amber-500'}`} />
                                        <span className="leading-snug">{feature}</span>
                                    </li>
                                ))}
                            </ul>

                            {/* Action Button */}
                            <button
                                onClick={() => !plan.locked && handlePayment(plan.price, plan.name)}
                                disabled={loadingPlan !== null || plan.locked}
                                className={`w-full py-3 rounded-lg font-bold text-xs uppercase tracking-widest transition-all duration-300 flex items-center justify-center gap-2 ${plan.locked
                                    ? 'bg-slate-100 text-slate-400 cursor-not-allowed'
                                    : plan.popular
                                        ? 'bg-gradient-to-r from-amber-400 to-amber-600 text-white shadow-lg shadow-amber-500/30 hover:shadow-amber-500/50 hover:brightness-110 active:scale-[0.98]'
                                        : 'bg-slate-900 text-white shadow-lg hover:bg-slate-800 hover:shadow-xl active:scale-[0.98]'
                                    }`}
                            >
                                {loadingPlan === plan.name ? (
                                    <>
                                        <Icon icon="ph:circle-notch-bold" className="text-lg animate-spin" />
                                        <span>Processing...</span>
                                    </>
                                ) : (
                                    <>
                                        <span>{plan.locked ? 'Coming Soon' : 'Get Started'}</span>
                                        {!plan.locked && <Icon icon="ph:arrow-right-bold" />}
                                    </>
                                )}
                            </button>
                        </motion.div>
                    ))}
                </motion.div>

                {/* Trust Badges */}
                <motion.div variants={item} className="mt-20 pt-10 border-t border-slate-200 flex flex-wrap justify-center gap-x-12 gap-y-6 opacity-60 hover:opacity-100 transition-opacity">
                    {['256-bit SSL Encryption', 'Secure Payment Gateways', 'Instant Access', 'Money-back Guarantee'].map((text, i) => (
                        <div key={i} className="flex items-center gap-2 text-slate-500 text-sm font-semibold uppercase tracking-wider">
                            <Icon icon="ph:shield-check-fill" className="text-amber-500 text-lg" />
                            {text}
                        </div>
                    ))}
                </motion.div>
            </motion.div>

            {/* CSS for custom animations */}
            <style>{`
                @keyframes slideDown {
                    from { opacity: 0; transform: translate(-50%, -20px); }
                    to { opacity: 1; transform: translate(-50%, 0); }
                }
                .animate-slideDown {
                    animation: slideDown 0.4s cubic-bezier(0.16, 1, 0.3, 1);
                }
            `}</style>
        </section>
    );
};

export default Pricing;
