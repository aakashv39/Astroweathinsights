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
        <section className="flex flex-col justify-center py-12 px-6 md:px-20 bg-white/40 backdrop-blur-md text-slate-900 text-center relative z-10">
            {/* Payment Status Toast */}
            {paymentStatus.show && (
                <div className={`fixed top-6 left-1/2 -translate-x-1/2 z-[200] px-6 py-4 rounded-xl shadow-2xl flex items-center gap-3 animate-slideDown ${paymentStatus.success ? 'bg-green-600 text-white' : 'bg-red-600 text-white'
                    }`}>
                    <Icon icon={paymentStatus.success ? "ph:check-circle-fill" : "ph:warning-circle-fill"} className="text-2xl" />
                    <span className="font-medium">{paymentStatus.message}</span>
                    <button onClick={() => setPaymentStatus({ show: false, success: false, message: '' })} className="ml-2 hover:opacity-80">
                        <Icon icon="ph:x" className="text-xl" />
                    </button>
                </div>
            )}

            <motion.div
                initial="hidden"
                whileInView="visible"
                viewport={{ once: true, amount: 0.2 }}
                variants={container}
                className="w-full max-w-7xl mx-auto"
            >
                <div className="mb-16">
                    <motion.h2 variants={item} className="text-4xl md:text-5xl font-extrabold mb-4 text-slate-900">Premium Astrology Services</motion.h2>
                    <motion.p variants={item} className="text-lg text-slate-500 max-w-2xl mx-auto leading-relaxed">
                        Invest in your destiny with our specialized reading packages.
                    </motion.p>
                </div>

                <motion.div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 items-stretch" variants={container}>
                    {plans.map((plan) => (
                        <motion.div
                            key={plan.name}
                            className={`relative bg-white rounded-3xl p-6 md:p-10 transition-all duration-300 flex flex-col text-left h-full group ${plan.locked
                                ? 'opacity-75 cursor-not-allowed'
                                : 'hover:-translate-y-2 hover:shadow-xl'
                                } ${plan.popular
                                    ? 'border-2 border-amber-600 shadow-2xl shadow-amber-500/10 scale-100 lg:scale-105 z-10'
                                    : 'border border-slate-200 hover:border-amber-400'
                                }`}
                            variants={item}
                        >
                            {/* Coming Soon Overlay */}
                            {plan.comingSoon && (
                                <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm rounded-3xl flex flex-col items-center justify-center z-20">
                                    <Icon icon="ph:lock-fill" className="text-6xl text-amber-400 mb-4" />
                                    <span className="text-2xl font-bold text-white mb-2">Coming Soon</span>
                                    <span className="text-sm text-slate-300">This feature will be available soon!</span>
                                </div>
                            )}

                            {plan.popular && (
                                <div className="absolute -top-3 left-1/2 -translate-x-1/2 bg-gradient-to-r from-amber-500 to-amber-700 text-white px-4 py-1 rounded-full text-sm font-bold uppercase tracking-wider shadow-md">
                                    Most Popular
                                </div>
                            )}
                            <div className={`text-center border-b border-slate-100 pb-8 mb-8 ${plan.popular ? 'mt-2' : ''}`}>
                                <Icon icon={plan.icon} className={`text-5xl mb-4 mx-auto transition-transform ${plan.popular ? 'text-amber-600' : 'text-amber-500 group-hover:scale-110'}`} />
                                <h3 className="text-xl font-bold text-slate-800 mb-4">{plan.name}</h3>
                                <div className="text-4xl font-black text-slate-900 font-display mb-2">
                                    ₹ {plan.price.toLocaleString()}<span className="text-sm font-medium text-slate-500 ml-1">{plan.period}</span>
                                </div>
                                <p className="text-slate-500 text-sm leading-relaxed">{plan.description}</p>
                            </div>
                            <ul className="space-y-4 mb-8 flex-1">
                                {plan.features.map((feature, i) => (
                                    <li key={i} className="flex items-start gap-3 text-slate-600 text-sm font-medium">
                                        <Icon icon={plan.locked ? "ph:clock-fill" : "ph:check-circle-fill"} className={`text-xl flex-shrink-0 ${plan.locked ? 'text-slate-400' : 'text-green-600'}`} />
                                        {feature}
                                    </li>
                                ))}
                            </ul>
                            <button
                                onClick={() => !plan.locked && handlePayment(plan.price, plan.name)}
                                disabled={loadingPlan !== null || plan.locked}
                                className={`w-full py-3 rounded-full font-semibold transition-all flex items-center justify-center gap-2 disabled:cursor-not-allowed ${plan.locked
                                    ? 'bg-slate-200 text-slate-400 cursor-not-allowed'
                                    : plan.popular
                                        ? 'bg-gradient-to-r from-amber-500 to-amber-700 text-white shadow-lg hover:shadow-xl hover:-translate-y-0.5'
                                        : 'border-2 border-slate-200 text-slate-600 hover:border-amber-500 hover:text-amber-500 bg-transparent'
                                    }`}
                            >
                                {plan.locked ? (
                                    <>
                                        <Icon icon="ph:lock-simple-fill" className="text-xl" />
                                        <span>Available Soon</span>
                                    </>
                                ) : loadingPlan === plan.name ? (
                                    <>
                                        <Icon icon="ph:circle-notch" className="text-xl animate-spin" />
                                        <span>Processing...</span>
                                    </>
                                ) : (
                                    <>
                                        <Icon icon="ph:credit-card" className="text-xl" />
                                        <span>Choose Plan</span>
                                    </>
                                )}
                            </button>
                        </motion.div>
                    ))}
                </motion.div>


                {/* Security Badge */}
                <motion.div variants={item} className="mt-12 flex items-center justify-center gap-6 text-slate-400 text-sm">
                    <div className="flex items-center gap-2">
                        <Icon icon="ph:shield-check-fill" className="text-green-500 text-xl" />
                        <span>Secure Payment</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <Icon icon="ph:lock-fill" className="text-green-500 text-xl" />
                        <span>SSL Encrypted</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <Icon icon="ph:credit-card-fill" className="text-green-500 text-xl" />
                        <span>Razorpay Protected</span>
                    </div>
                </motion.div>
            </motion.div>

            {/* CSS for animations */}
            <style>{`
                @keyframes slideDown {
                    from { opacity: 0; transform: translate(-50%, -20px); }
                    to { opacity: 1; transform: translate(-50%, 0); }
                }
                .animate-slideDown {
                    animation: slideDown 0.3s ease-out;
                }
            `}</style>
        </section>
    );
};

export default Pricing;
