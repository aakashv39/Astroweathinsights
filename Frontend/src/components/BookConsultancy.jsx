import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Icon } from '@iconify/react';
import { useNavigate } from 'react-router-dom';
import { createOrder, verifyPayment } from '../services/api';

const ASTROLOGER_EMAIL = 'srajangupta220@gmail.com';
const CONSULTATION_PRICE = 2999;

const BookConsultancy = () => {
    const navigate = useNavigate();
    const [selectedDate, setSelectedDate] = useState(null);
    const [selectedTime, setSelectedTime] = useState(null);
    const [selectedType, setSelectedType] = useState(null);
    const [step, setStep] = useState(1);
    const [isLoading, setIsLoading] = useState(false);
    const [paymentStatus, setPaymentStatus] = useState({ show: false, success: false, message: '' });
    const [formData, setFormData] = useState({
        name: '',
        email: '',
        phone: '',
        topic: '',
        questions: ''
    });

    // Consultation types aligned with gold/amber theme
    const consultationTypes = [
        {
            id: 'career',
            name: 'Career & Business',
            icon: 'ph:briefcase-fill',
            description: 'Job changes, promotions, business decisions',
            duration: '45 min',
            color: 'from-amber-400 to-amber-600'
        },
        {
            id: 'relationship',
            name: 'Relationships & Marriage',
            icon: 'ph:heart-fill',
            description: 'Love life, marriage timing, compatibility',
            duration: '45 min',
            color: 'from-orange-400 to-orange-600'
        },
        {
            id: 'finance',
            name: 'Finance & Investments',
            icon: 'ph:currency-inr-fill',
            description: 'Wealth, investments, financial planning',
            duration: '45 min',
            color: 'from-amber-500 to-gold'
        },
        {
            id: 'health',
            name: 'Health & Wellness',
            icon: 'ph:heartbeat-fill',
            description: 'Health concerns, recovery, wellness guidance',
            duration: '45 min',
            color: 'from-amber-600 to-gold-dark'
        },
        {
            id: 'general',
            name: 'General Life Guidance',
            icon: 'ph:compass-fill',
            description: 'Overall life direction, yearly predictions',
            duration: '60 min',
            color: 'from-amber-400 to-gold'
        },
        {
            id: 'remedies',
            name: 'Remedies & Solutions',
            icon: 'ph:sparkle-fill',
            description: 'Gemstones, mantras, rituals for specific issues',
            duration: '30 min',
            color: 'from-amber-300 to-amber-500'
        }
    ];

    // Generate next 14 days (excluding Sundays)
    const generateDates = () => {
        const dates = [];
        const today = new Date();
        for (let i = 1; i <= 21 && dates.length < 14; i++) {
            const date = new Date(today);
            date.setDate(today.getDate() + i);
            if (date.getDay() !== 0) {
                dates.push(date);
            }
        }
        return dates;
    };

    // Time slots
    const timeSlots = [
        { time: '10:00 AM', available: true },
        { time: '11:00 AM', available: true },
        { time: '12:00 PM', available: true },
        { time: '02:00 PM', available: true },
        { time: '03:00 PM', available: true },
        { time: '04:00 PM', available: true },
        { time: '05:00 PM', available: true },
        { time: '06:00 PM', available: true },
        { time: '07:00 PM', available: true },
        { time: '08:00 PM', available: true }
    ];

    const formatFullDate = (date) => {
        return date.toLocaleDateString('en-US', {
            weekday: 'long',
            month: 'long',
            day: 'numeric',
            year: 'numeric'
        });
    };

    const handleTypeSelect = (type) => {
        setSelectedType(type);
        setStep(2);
    };

    const handleDateSelect = (date) => {
        setSelectedDate(date);
        setStep(3);
    };

    const handleTimeSelect = (time) => {
        setSelectedTime(time);
        setStep(4);
    };

    const handleInputChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value
        });
    };

    const showStatus = (success, message) => {
        setPaymentStatus({ show: true, success, message });
        setTimeout(() => setPaymentStatus({ show: false, success: false, message: '' }), 5000);
    };

    const createGoogleCalendarLink = () => {
        if (!selectedDate || !selectedTime || !selectedType) return '#';

        const [hourMin, period] = selectedTime.split(' ');
        let [hours, minutes] = hourMin.split(':').map(Number);
        if (period === 'PM' && hours !== 12) hours += 12;
        if (period === 'AM' && hours === 12) hours = 0;

        const startDate = new Date(selectedDate);
        startDate.setHours(hours, minutes, 0);

        const duration = selectedType.id === 'general' ? 60 : selectedType.id === 'remedies' ? 30 : 45;
        const endDate = new Date(startDate);
        endDate.setMinutes(endDate.getMinutes() + duration);

        const formatForCalendar = (date) => {
            return date.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z';
        };

        const eventTitle = encodeURIComponent(`AstroTech Consultation: ${selectedType.name}`);
        const eventDetails = encodeURIComponent(
            `📌 Consultation Type: ${selectedType.name}\n` +
            `👤 Client: ${formData.name}\n` +
            `📧 Email: ${formData.email}\n` +
            `📱 Phone: ${formData.phone}\n\n` +
            `❓ Questions/Topics:\n${formData.questions || 'General consultation'}\n\n` +
            `⏰ Duration: ${duration} minutes\n` +
            `💰 Payment: Completed via Razorpay`
        );

        const startStr = formatForCalendar(startDate);
        const endStr = formatForCalendar(endDate);

        const attendees = encodeURIComponent(`${formData.email},${ASTROLOGER_EMAIL}`);

        return `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${eventTitle}&dates=${startStr}/${endStr}&details=${eventDetails}&add=${attendees}&sf=true`;
    };

    const handlePayment = async () => {
        const token = localStorage.getItem('token');
        if (!token) {
            showStatus(false, 'Please sign in to book a consultation');
            return;
        }

        if (!formData.name || !formData.email || !formData.phone) {
            showStatus(false, 'Please fill in all required fields');
            return;
        }

        setIsLoading(true);

        try {
            const order = await createOrder(CONSULTATION_PRICE);

            const options = {
                key: import.meta.env.VITE_RAZORPAY_KEY_ID,
                amount: order.amount,
                currency: order.currency,
                name: "AstroTech Wealth",
                description: `${selectedType.name} Consultation`,
                order_id: order.id,
                handler: async function (response) {
                    try {
                        await verifyPayment({
                            razorpay_order_id: response.razorpay_order_id,
                            razorpay_payment_id: response.razorpay_payment_id,
                            razorpay_signature: response.razorpay_signature
                        });

                        showStatus(true, 'Payment successful! Redirecting to schedule your meeting...');

                        setTimeout(() => {
                            window.open(createGoogleCalendarLink(), '_blank');
                            setStep(5);
                        }, 1500);

                    } catch (err) {
                        showStatus(false, 'Payment verification failed. Please contact support.');
                    }
                    setIsLoading(false);
                },
                modal: {
                    ondismiss: function () {
                        setIsLoading(false);
                    }
                },
                prefill: {
                    name: formData.name,
                    email: formData.email,
                    contact: formData.phone
                },
                theme: {
                    color: "#d97706"
                }
            };

            const rzp = new window.Razorpay(options);
            rzp.on('payment.failed', function (response) {
                showStatus(false, response.error.description || 'Payment failed. Please try again.');
                setIsLoading(false);
            });
            rzp.open();

        } catch (error) {
            console.error('Payment Error', error);
            showStatus(false, error.message || 'Something went wrong. Please try again.');
            setIsLoading(false);
        }
    };

    const stepTitles = ['Choose Type', 'Select Date', 'Select Time', 'Your Details', 'Confirmed'];

    // Premium Input Styles
    const inputClasses = "w-full bg-white/50 border border-slate-200 rounded-xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500 outline-none transition-all placeholder:text-slate-400 font-medium text-slate-700 hover:bg-white/80";
    const labelClasses = "block text-xs font-bold text-slate-500 mb-2 uppercase tracking-widest pl-1";

    // Active State Classes
    const activeCardClass = "border-amber-500 bg-amber-50 shadow-amber-100 ring-1 ring-amber-500/20";
    const inactiveCardClass = "border-slate-100 bg-white hover:border-amber-300 hover:shadow-lg";

    return (
        <div className="min-h-screen pt-32 pb-16 px-4 md:px-8 relative overflow-hidden bg-slate-50">
            {/* Background Atmosphere */}
            <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
                <div className="absolute top-[10%] left-[-10%] w-[600px] h-[600px] bg-amber-200/20 rounded-full blur-[120px]"></div>
                <div className="absolute bottom-[10%] right-[-10%] w-[500px] h-[500px] bg-indigo-200/20 rounded-full blur-[120px]"></div>
            </div>

            {/* Payment Status Toast */}
            {paymentStatus.show && (
                <div className={`fixed top-24 left-1/2 -translate-x-1/2 z-[200] px-6 py-4 rounded-xl shadow-2xl flex items-center gap-3 animate-slideDown border ${paymentStatus.success ? 'bg-white border-green-100 text-green-700' : 'bg-white border-red-100 text-red-700'}`}>
                    <Icon icon={paymentStatus.success ? "ph:check-circle-fill" : "ph:warning-circle-fill"} className="text-2xl" />
                    <span className="font-bold">{paymentStatus.message}</span>
                    <button onClick={() => setPaymentStatus({ show: false, success: false, message: '' })} className="ml-2 opacity-50 hover:opacity-100">
                        <Icon icon="ph:x-bold" />
                    </button>
                </div>
            )}

            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className="max-w-5xl mx-auto relative z-10"
            >
                {/* Header */}
                <div className="text-center mb-12">
                    <motion.div
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        className="w-20 h-20 bg-gradient-to-br from-amber-400 to-amber-600 rounded-3xl rotate-3 flex items-center justify-center mx-auto mb-6 shadow-xl shadow-amber-500/20"
                    >
                        <Icon icon="ph:video-camera-fill" className="text-white text-4xl -rotate-3" />
                    </motion.div>
                    <h1 className="text-4xl md:text-5xl font-serif font-black text-slate-900 mb-4 tracking-tight">
                        Book Expert Consultation
                    </h1>
                    <p className="text-slate-500 max-w-lg mx-auto text-lg leading-relaxed">
                        Get personalized astrological guidance via Google Meet with our renowned experts.
                    </p>
                </div>

                {/* Progress Steps */}
                <div className="mb-12 relative px-4">
                    <div className="absolute top-1/2 left-0 w-full h-1 bg-slate-200 -z-10 -translate-y-1/2 rounded-full hidden md:block"></div>
                    <div className="flex justify-between max-w-3xl mx-auto">
                        {stepTitles.map((title, idx) => (
                            <div key={idx} className="flex flex-col items-center gap-3 bg-slate-50 px-2 group">
                                <div className={`w-10 h-10 rounded-xl flex items-center justify-center font-bold text-sm transition-all duration-300 shadow-sm border-2 ${step > idx + 1
                                    ? 'bg-green-500 border-green-500 text-white'
                                    : step === idx + 1
                                        ? 'bg-amber-500 border-amber-500 text-white scale-110 shadow-amber-500/30'
                                        : 'bg-white border-slate-200 text-slate-400'
                                    }`}>
                                    {step > idx + 1 ? <Icon icon="ph:check-bold" /> : idx + 1}
                                </div>
                                <span className={`text-xs font-bold uppercase tracking-wider transition-colors ${step === idx + 1 ? 'text-amber-600' : 'text-slate-400'}`}>
                                    {title}
                                </span>
                            </div>
                        ))}
                    </div>
                </div>

                {/* Step Content */}
                <div className="bg-white/80 backdrop-blur-2xl border border-white/60 rounded-[2.5rem] shadow-2xl p-6 md:p-12 overflow-hidden relative">

                    {/* Decorative Elements */}
                    <div className="absolute top-0 right-0 w-64 h-64 bg-amber-500/5 rounded-full blur-3xl -z-10"></div>

                    {/* Step 1: Choose Consultation Type */}
                    {step === 1 && (
                        <motion.div
                            initial={{ opacity: 0, x: -20 }}
                            animate={{ opacity: 1, x: 0 }}
                        >
                            <h2 className="text-2xl font-serif font-bold text-slate-900 mb-8 flex items-center gap-3">
                                <Icon icon="ph:sparkle-fill" className="text-amber-500" />
                                What would you like to discuss?
                            </h2>
                            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                                {consultationTypes.map((type) => (
                                    <button
                                        key={type.id}
                                        onClick={() => handleTypeSelect(type)}
                                        className={`p-6 rounded-2xl text-left group transition-all duration-300 relative overflow-hidden border ${inactiveCardClass}`}
                                    >
                                        <div className="absolute top-0 right-0 w-24 h-24 bg-gradient-to-br from-slate-50 to-slate-100 rounded-bl-[4rem] -mr-4 -mt-4 transition-colors group-hover:from-amber-50 group-hover:to-amber-100"></div>

                                        <div className={`w-14 h-14 rounded-2xl bg-gradient-to-br ${type.color} flex items-center justify-center mb-5 shadow-lg relative z-10 group-hover:scale-110 transition-transform duration-300`}>
                                            <Icon icon={type.icon} className="text-white text-2xl" />
                                        </div>

                                        <h3 className="text-lg font-bold text-slate-800 mb-2 font-serif relative z-10">{type.name}</h3>
                                        <p className="text-sm text-slate-500 mb-4 leading-relaxed relative z-10">{type.description}</p>

                                        <div className="flex items-center gap-2 text-xs font-bold text-amber-600 uppercase tracking-widest relative z-10">
                                            <Icon icon="ph:clock-bold" />
                                            {type.duration}
                                        </div>
                                    </button>
                                ))}
                            </div>
                        </motion.div>
                    )}

                    {/* Step 2: Select Date */}
                    {step === 2 && (
                        <motion.div
                            initial={{ opacity: 0, x: 20 }}
                            animate={{ opacity: 1, x: 0 }}
                        >
                            <button
                                onClick={() => setStep(1)}
                                className="flex items-center gap-2 text-slate-400 hover:text-slate-600 mb-8 font-bold text-sm uppercase tracking-wider group transition-colors"
                            >
                                <Icon icon="ph:arrow-left-bold" className="group-hover:-translate-x-1 transition-transform" /> Back
                            </button>

                            <div className="bg-slate-50 rounded-2xl p-1 mb-10 inline-block border border-slate-100">
                                <div className="flex items-center gap-4 bg-white rounded-xl p-4 border border-slate-100 shadow-sm">
                                    <div className={`w-10 h-10 rounded-lg bg-gradient-to-br ${selectedType?.color} flex items-center justify-center shadow-md`}>
                                        <Icon icon={selectedType?.icon} className="text-white text-lg" />
                                    </div>
                                    <div>
                                        <div className="text-xs font-bold text-slate-400 uppercase tracking-wider">Session Type</div>
                                        <div className="text-base font-serif font-bold text-slate-800">{selectedType?.name}</div>
                                    </div>
                                </div>
                            </div>

                            <h2 className="text-2xl font-serif font-bold text-slate-900 mb-8">Choose a Date</h2>

                            <div className="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-7 gap-3">
                                {generateDates().map((date, idx) => (
                                    <button
                                        key={idx}
                                        onClick={() => handleDateSelect(date)}
                                        className="p-4 rounded-2xl border transition-all text-center group bg-white hover:border-amber-400 hover:shadow-lg hover:-translate-y-1 duration-300 border-slate-100"
                                    >
                                        <div className="text-xs font-bold text-slate-400 group-hover:text-amber-600 uppercase tracking-tight mb-2">
                                            {date.toLocaleDateString('en-US', { weekday: 'short' })}
                                        </div>
                                        <div className="text-3xl font-black text-slate-800 group-hover:text-amber-600 mb-1 font-serif">
                                            {date.getDate()}
                                        </div>
                                        <div className="text-xs font-medium text-slate-400 border-t border-slate-100 pt-2 mt-2 w-full">
                                            {date.toLocaleDateString('en-US', { month: 'short' })}
                                        </div>
                                    </button>
                                ))}
                            </div>
                        </motion.div>
                    )}

                    {/* Step 3: Select Time */}
                    {step === 3 && (
                        <motion.div
                            initial={{ opacity: 0, x: 20 }}
                            animate={{ opacity: 1, x: 0 }}
                        >
                            <button
                                onClick={() => setStep(2)}
                                className="flex items-center gap-2 text-slate-400 hover:text-slate-600 mb-8 font-bold text-sm uppercase tracking-wider group transition-colors"
                            >
                                <Icon icon="ph:arrow-left-bold" className="group-hover:-translate-x-1 transition-transform" /> Back
                            </button>

                            <div className="flex flex-wrap gap-4 mb-10">
                                <div className="bg-white rounded-xl px-5 py-3 border border-slate-100 shadow-sm flex items-center gap-3">
                                    <Icon icon="ph:briefcase-fill" className="text-amber-500 text-lg" />
                                    <span className="font-bold text-slate-700">{selectedType?.name}</span>
                                </div>
                                <div className="bg-white rounded-xl px-5 py-3 border border-slate-100 shadow-sm flex items-center gap-3">
                                    <Icon icon="ph:calendar-fill" className="text-amber-500 text-lg" />
                                    <span className="font-bold text-slate-700">{selectedDate ? formatFullDate(selectedDate) : ''}</span>
                                </div>
                            </div>

                            <h2 className="text-2xl font-serif font-bold text-slate-900 mb-8">Available Time Slots</h2>
                            <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-4">
                                {timeSlots.map((slot, idx) => (
                                    <button
                                        key={idx}
                                        onClick={() => slot.available && handleTimeSelect(slot.time)}
                                        disabled={!slot.available}
                                        className={`py-4 px-2 rounded-xl border-2 transition-all text-center font-bold text-sm ${slot.available
                                            ? 'border-slate-100 bg-white text-slate-600 hover:border-amber-500 hover:text-amber-600 hover:shadow-md'
                                            : 'border-transparent bg-slate-50 text-slate-300 cursor-not-allowed'
                                            }`}
                                    >
                                        {slot.time}
                                    </button>
                                ))}
                            </div>
                        </motion.div>
                    )}

                    {/* Step 4: Your Details & Payment */}
                    {step === 4 && (
                        <motion.div
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                        >
                            <button
                                onClick={() => setStep(3)}
                                className="flex items-center gap-2 text-slate-400 hover:text-slate-600 mb-8 font-bold text-sm uppercase tracking-wider group transition-colors"
                            >
                                <Icon icon="ph:arrow-left-bold" className="group-hover:-translate-x-1 transition-transform" /> Back
                            </button>

                            <div className="grid lg:grid-cols-2 gap-12">
                                {/* Form Column */}
                                <div>
                                    <h2 className="text-2xl font-serif font-bold text-slate-900 mb-6">Your Details</h2>
                                    <div className="space-y-6">
                                        <div className="group">
                                            <label className={labelClasses}>Full Name</label>
                                            <div className="relative">
                                                <Icon icon="ph:user" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xl group-focus-within:text-amber-500 transition-colors" />
                                                <input
                                                    type="text"
                                                    name="name"
                                                    value={formData.name}
                                                    onChange={handleInputChange}
                                                    className={inputClasses}
                                                    placeholder="Enter your name"
                                                    required
                                                />
                                            </div>
                                        </div>
                                        <div className="group">
                                            <label className={labelClasses}>Email Address</label>
                                            <div className="relative">
                                                <Icon icon="ph:envelope" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xl group-focus-within:text-amber-500 transition-colors" />
                                                <input
                                                    type="email"
                                                    name="email"
                                                    value={formData.email}
                                                    onChange={handleInputChange}
                                                    className={inputClasses}
                                                    placeholder="you@email.com"
                                                    required
                                                />
                                            </div>
                                        </div>
                                        <div className="group">
                                            <label className={labelClasses}>Phone Number</label>
                                            <div className="relative">
                                                <Icon icon="ph:phone" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xl group-focus-within:text-amber-500 transition-colors" />
                                                <input
                                                    type="tel"
                                                    name="phone"
                                                    value={formData.phone}
                                                    onChange={handleInputChange}
                                                    className={inputClasses}
                                                    placeholder="+91..."
                                                    required
                                                />
                                            </div>
                                        </div>
                                        <div className="group">
                                            <label className={labelClasses}>Topics to Discuss</label>
                                            <textarea
                                                name="questions"
                                                value={formData.questions}
                                                onChange={handleInputChange}
                                                rows={3}
                                                className={`${inputClasses} h-auto pt-4 resize-none`}
                                                placeholder="Briefly describe what you'd like to ask..."
                                            />
                                        </div>
                                    </div>
                                </div>

                                {/* Summary Column */}
                                <div>
                                    <h2 className="text-2xl font-serif font-bold text-slate-900 mb-6">Order Summary</h2>
                                    <div className="bg-slate-900 rounded-[2rem] p-8 text-white relative overflow-hidden shadow-2xl">
                                        <div className="absolute top-0 right-0 w-64 h-64 bg-amber-500/10 rounded-full blur-3xl"></div>

                                        <div className="relative z-10">
                                            <div className="flex justify-between items-start mb-8 border-b border-white/10 pb-8">
                                                <div>
                                                    <div className="text-amber-500 font-bold uppercase tracking-wider text-xs mb-1">Service</div>
                                                    <div className="font-serif text-xl font-bold">{selectedType?.name}</div>
                                                </div>
                                                <div className="bg-white/10 px-3 py-1 rounded-lg text-sm font-bold backdrop-blur-md">
                                                    {selectedType?.duration}
                                                </div>
                                            </div>

                                            <div className="space-y-4 mb-8">
                                                <div className="flex justify-between items-center text-sm">
                                                    <span className="text-slate-400">Date</span>
                                                    <span className="font-bold">{selectedDate ? formatFullDate(selectedDate) : '-'}</span>
                                                </div>
                                                <div className="flex justify-between items-center text-sm">
                                                    <span className="text-slate-400">Time</span>
                                                    <span className="font-bold">{selectedTime}</span>
                                                </div>
                                                <div className="flex justify-between items-center text-sm">
                                                    <span className="text-slate-400">Platform</span>
                                                    <span className="font-bold flex items-center gap-1"><Icon icon="ph:video-camera-fill" /> Google Meet</span>
                                                </div>
                                            </div>

                                            <div className="flex justify-between items-center pt-6 border-t border-white/10">
                                                <span className="text-slate-400 font-medium">Total Amount</span>
                                                <span className="text-3xl font-serif font-bold text-amber-400">₹ {CONSULTATION_PRICE.toLocaleString()}</span>
                                            </div>

                                            <button
                                                onClick={handlePayment}
                                                disabled={isLoading}
                                                className="w-full mt-8 bg-gradient-to-r from-amber-500 to-amber-600 text-white font-bold py-4 rounded-xl shadow-lg shadow-amber-900/40 hover:scale-[1.02] active:scale-[0.98] transition-all flex items-center justify-center gap-3 disabled:opacity-70 disabled:pointer-events-none"
                                            >
                                                {isLoading ? (
                                                    <Icon icon="ph:spinner-gap-bold" className="animate-spin text-2xl" />
                                                ) : (
                                                    <>
                                                        <Icon icon="ph:credit-card-fill" className="text-xl" />
                                                        Complete Payment
                                                    </>
                                                )}
                                            </button>

                                            <div className="mt-4 flex items-center justify-center gap-2 text-xs text-slate-500 font-medium">
                                                <Icon icon="ph:lock-key-fill" />
                                                SECURE CHECKOUT
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </motion.div>
                    )}

                    {/* Step 5: Success */}
                    {step === 5 && (
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95 }}
                            animate={{ opacity: 1, scale: 1 }}
                            className="text-center py-10"
                        >
                            <div className="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-8 shadow-inner ring-8 ring-green-50">
                                <Icon icon="ph:check-circle-fill" className="text-green-600 text-5xl" />
                            </div>
                            <h2 className="text-3xl md:text-4xl font-serif font-black text-slate-900 mb-4">Booking Confirmed!</h2>
                            <p className="text-slate-500 mb-10 max-w-md mx-auto text-lg leading-relaxed">
                                We've sent the meeting link and details to your email. Get ready for your cosmic clarity session.
                            </p>

                            <div className="flex flex-col sm:flex-row gap-4 justify-center">
                                <a
                                    href={createGoogleCalendarLink()}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="bg-slate-900 text-white px-8 py-4 rounded-xl font-bold hover:bg-slate-800 transition-all flex items-center justify-center gap-2 shadow-xl shadow-slate-200"
                                >
                                    <Icon icon="ph:calendar-plus-fill" className="text-xl" />
                                    Add to Calendar
                                </a>
                                <button
                                    onClick={() => navigate('/')}
                                    className="bg-white border-2 border-slate-100 text-slate-600 px-8 py-4 rounded-xl font-bold hover:border-slate-300 transition-all"
                                >
                                    Back to Home
                                </button>
                            </div>
                        </motion.div>
                    )}
                </div>
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
        </div>
    );
};

export default BookConsultancy;
