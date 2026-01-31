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

    return (
        <div className="min-h-screen pt-32 pb-16 px-4 md:px-8 bg-white/40 backdrop-blur-md">
            {/* Payment Status Toast */}
            {paymentStatus.show && (
                <div className={`fixed top-6 left-1/2 -translate-x-1/2 z-[200] px-6 py-4 rounded-xl shadow-2xl flex items-center gap-3 animate-slideDown ${paymentStatus.success ? 'bg-green-600 text-white' : 'bg-red-600 text-white'}`}>
                    <Icon icon={paymentStatus.success ? "ph:check-circle-fill" : "ph:warning-circle-fill"} className="text-2xl" />
                    <span className="font-medium">{paymentStatus.message}</span>
                    <button onClick={() => setPaymentStatus({ show: false, success: false, message: '' })} className="ml-2 hover:opacity-80">
                        <Icon icon="ph:x" className="text-xl" />
                    </button>
                </div>
            )}

            <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className="max-w-5xl mx-auto"
            >
                {/* Header */}
                <div className="text-center mb-10">
                    <motion.div
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        className="w-20 h-20 bg-gradient-to-br from-amber-400 to-amber-600 rounded-full flex items-center justify-center mx-auto mb-6 shadow-xl"
                    >
                        <Icon icon="ph:video-camera-fill" className="text-white text-4xl" />
                    </motion.div>
                    <h1 className="text-3xl md:text-5xl font-serif font-bold text-slate-900 mb-3">
                        Book Expert Consultation
                    </h1>
                    <p className="text-slate-600 max-w-lg mx-auto text-lg leading-relaxed">
                        Get personalized astrological guidance via Google Meet with our experts.
                    </p>
                </div>

                {/* Progress Steps */}
                <div className="flex items-center justify-center gap-2 mb-12 overflow-x-auto pb-2">
                    {stepTitles.slice(0, 4).map((title, idx) => (
                        <div key={idx} className="flex items-center">
                            <div className="flex flex-col items-center">
                                <div className={`w-10 h-10 rounded-full flex items-center justify-center font-bold transition-all shadow-md ${step > idx + 1
                                    ? 'bg-green-500 text-white'
                                    : step === idx + 1
                                        ? 'bg-amber-600 text-white'
                                        : 'bg-white text-slate-400 border border-slate-200'
                                    }`}>
                                    {step > idx + 1 ? <Icon icon="ph:check-bold" /> : idx + 1}
                                </div>
                                <span className={`text-xs mt-2 hidden md:block font-medium ${step === idx + 1 ? 'text-amber-700' : 'text-slate-400'}`}>
                                    {title}
                                </span>
                            </div>
                            {idx < 3 && (
                                <div className={`w-8 md:w-16 h-1 mx-1 rounded-full ${step > idx + 1 ? 'bg-green-500' : 'bg-slate-200'}`} />
                            )}
                        </div>
                    ))}
                </div>

                {/* Step Content with Glass Effect */}
                <div className="bg-white/80 backdrop-blur-lg border border-white/20 rounded-3xl shadow-2xl p-8 md:p-12">
                    {/* Step 1: Choose Consultation Type */}
                    {step === 1 && (
                        <motion.div
                            initial={{ opacity: 0, x: -20 }}
                            animate={{ opacity: 1, x: 0 }}
                        >
                            <h2 className="text-2xl font-serif font-bold text-slate-800 mb-8 flex items-center gap-3">
                                <span className="w-8 h-8 bg-amber-100 text-amber-600 rounded-lg flex items-center justify-center text-base">
                                    <Icon icon="ph:list-bullets-bold" />
                                </span>
                                What would you like to discuss?
                            </h2>
                            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                                {consultationTypes.map((type) => (
                                    <button
                                        key={type.id}
                                        onClick={() => handleTypeSelect(type)}
                                        className="p-6 rounded-2xl border border-slate-100 bg-white hover:border-amber-400 hover:shadow-xl hover:-translate-y-1 transition-all text-left group shadow-sm"
                                    >
                                        <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${type.color} flex items-center justify-center mb-4 group-hover:scale-110 shadow-lg transition-transform`}>
                                            <Icon icon={type.icon} className="text-white text-2xl" />
                                        </div>
                                        <h3 className="text-lg font-bold text-slate-800 mb-2 font-serif">{type.name}</h3>
                                        <p className="text-sm text-slate-500 mb-3 leading-relaxed">{type.description}</p>
                                        <div className="flex items-center gap-2 text-xs font-bold text-amber-600 uppercase tracking-wider">
                                            <Icon icon="ph:timer-bold" />
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
                                className="flex items-center gap-2 text-amber-600 hover:text-amber-700 mb-6 font-semibold group"
                            >
                                <Icon icon="ph:arrow-left-bold" className="group-hover:-translate-x-1 transition-transform" /> Back
                            </button>

                            <div className="bg-amber-50 rounded-2xl p-6 mb-8 flex items-center gap-4 border border-amber-100">
                                <div className={`w-14 h-14 rounded-xl bg-gradient-to-br ${selectedType?.color} flex items-center justify-center shadow-lg`}>
                                    <Icon icon={selectedType?.icon} className="text-white text-2xl" />
                                </div>
                                <div>
                                    <div className="text-sm font-semibold text-amber-600 uppercase tracking-wider">Selected Consultation</div>
                                    <div className="text-xl font-serif font-bold text-slate-800">{selectedType?.name}</div>
                                </div>
                            </div>

                            <h2 className="text-2xl font-serif font-bold text-slate-800 mb-8 flex items-center gap-3">
                                <span className="w-8 h-8 bg-amber-100 text-amber-600 rounded-lg flex items-center justify-center text-base">
                                    <Icon icon="ph:calendar-bold" />
                                </span>
                                Choose a Date
                            </h2>
                            <div className="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-7 gap-4">
                                {generateDates().map((date, idx) => (
                                    <button
                                        key={idx}
                                        onClick={() => handleDateSelect(date)}
                                        className="p-4 rounded-2xl border border-slate-200 hover:border-amber-500 hover:bg-amber-50 transition-all text-center group bg-white shadow-sm"
                                    >
                                        <div className="text-xs font-bold text-slate-400 group-hover:text-amber-600 uppercase tracking-tighter">
                                            {date.toLocaleDateString('en-US', { weekday: 'short' })}
                                        </div>
                                        <div className="text-2xl font-bold text-slate-800 group-hover:text-amber-600 my-1">
                                            {date.getDate()}
                                        </div>
                                        <div className="text-xs font-medium text-slate-500">
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
                                className="flex items-center gap-2 text-amber-600 hover:text-amber-700 mb-6 font-semibold group"
                            >
                                <Icon icon="ph:arrow-left-bold" className="group-hover:-translate-x-1 transition-transform" /> Back
                            </button>

                            <div className="bg-amber-50 rounded-2xl p-6 mb-8 border border-amber-100">
                                <div className="flex flex-wrap gap-8">
                                    <div className="flex items-center gap-3">
                                        <div className={`w-10 h-10 rounded-lg bg-gradient-to-br ${selectedType?.color} flex items-center justify-center shadow-md`}>
                                            <Icon icon={selectedType?.icon} className="text-white text-xl" />
                                        </div>
                                        <span className="font-serif font-bold text-slate-800">{selectedType?.name}</span>
                                    </div>
                                    <div className="flex items-center gap-3">
                                        <div className="w-10 h-10 rounded-lg bg-white flex items-center justify-center shadow-md">
                                            <Icon icon="ph:calendar-fill" className="text-amber-600 text-xl" />
                                        </div>
                                        <span className="font-semibold text-slate-700">{formatFullDate(selectedDate)}</span>
                                    </div>
                                </div>
                            </div>

                            <h2 className="text-2xl font-serif font-bold text-slate-800 mb-8 flex items-center gap-3">
                                <span className="w-8 h-8 bg-amber-100 text-amber-600 rounded-lg flex items-center justify-center text-base">
                                    <Icon icon="ph:clock-bold" />
                                </span>
                                Choose a Time Slot
                            </h2>
                            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
                                {timeSlots.map((slot, idx) => (
                                    <button
                                        key={idx}
                                        onClick={() => slot.available && handleTimeSelect(slot.time)}
                                        disabled={!slot.available}
                                        className={`p-5 rounded-2xl border-2 transition-all text-center font-bold glass-panel ${slot.available
                                            ? 'border-slate-200 hover:border-amber-500 hover:bg-amber-50 text-slate-700 hover:text-amber-600'
                                            : 'border-slate-100 bg-slate-50 text-slate-300 cursor-not-allowed'
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
                                className="flex items-center gap-2 text-amber-600 hover:text-amber-700 mb-6 font-semibold group"
                            >
                                <Icon icon="ph:arrow-left-bold" className="group-hover:-translate-x-1 transition-transform" /> Back
                            </button>

                            {/* Booking Summary */}
                            <div className="bg-gradient-to-r from-amber-500 to-amber-700 rounded-3xl p-8 mb-10 text-white shadow-xl relative overflow-hidden">
                                <Icon icon="ph:confetti-fill" className="absolute -right-8 -bottom-8 text-white/10 text-[10rem] rotate-12" />
                                <h3 className="text-xl font-serif font-bold mb-6 flex items-center gap-2">
                                    <Icon icon="ph:receipt-bold" />
                                    Booking Summary
                                </h3>
                                <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6 relative z-10">
                                    <div className="bg-white/10 backdrop-blur-md rounded-2xl p-4 border border-white/20">
                                        <div className="text-white/70 text-xs font-bold uppercase tracking-wider mb-1">Consultation</div>
                                        <div className="font-bold truncate">{selectedType?.name}</div>
                                    </div>
                                    <div className="bg-white/10 backdrop-blur-md rounded-2xl p-4 border border-white/20">
                                        <div className="text-white/70 text-xs font-bold uppercase tracking-wider mb-1">Date</div>
                                        <div className="font-bold truncate">{formatFullDate(selectedDate)}</div>
                                    </div>
                                    <div className="bg-white/10 backdrop-blur-md rounded-2xl p-4 border border-white/20">
                                        <div className="text-white/70 text-xs font-bold uppercase tracking-wider mb-1">Time</div>
                                        <div className="font-bold truncate">{selectedTime}</div>
                                    </div>
                                    <div className="bg-white/10 backdrop-blur-md rounded-2xl p-4 border border-white/20">
                                        <div className="text-white/70 text-xs font-bold uppercase tracking-wider mb-1">Platform</div>
                                        <div className="font-bold truncate flex items-center gap-1">
                                            <Icon icon="ph:video-camera-fill" /> Meet
                                        </div>
                                    </div>
                                </div>
                                <div className="mt-8 pt-6 border-t border-white/20 flex justify-between items-center">
                                    <span className="font-bold">Total Investment</span>
                                    <span className="text-3xl font-black font-display">₹ {CONSULTATION_PRICE.toLocaleString()}</span>
                                </div>
                            </div>

                            {/* Contact Form */}
                            <h2 className="text-2xl font-serif font-bold text-slate-800 mb-8 flex items-center gap-3">
                                <span className="w-8 h-8 bg-amber-100 text-amber-600 rounded-lg flex items-center justify-center text-base">
                                    <Icon icon="ph:user-bold" />
                                </span>
                                Your Information
                            </h2>
                            <div className="grid md:grid-cols-2 gap-6 mb-6">
                                <div className="space-y-2">
                                    <label className="text-sm font-bold text-slate-600 ml-1">Full Name *</label>
                                    <div className="relative">
                                        <Icon icon="ph:user" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                                        <input
                                            type="text"
                                            name="name"
                                            value={formData.name}
                                            onChange={handleInputChange}
                                            placeholder="Enter your name"
                                            className="w-full border border-slate-200 rounded-2xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all shadow-sm"
                                            required
                                        />
                                    </div>
                                </div>
                                <div className="space-y-2">
                                    <label className="text-sm font-bold text-slate-600 ml-1">Email *</label>
                                    <div className="relative">
                                        <Icon icon="ph:envelope" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                                        <input
                                            type="email"
                                            name="email"
                                            value={formData.email}
                                            onChange={handleInputChange}
                                            placeholder="you@example.com"
                                            className="w-full border border-slate-200 rounded-2xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all shadow-sm"
                                            required
                                        />
                                    </div>
                                </div>
                                <div className="space-y-2">
                                    <label className="text-sm font-bold text-slate-600 ml-1">Phone Number *</label>
                                    <div className="relative">
                                        <Icon icon="ph:phone" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                                        <input
                                            type="tel"
                                            name="phone"
                                            value={formData.phone}
                                            onChange={handleInputChange}
                                            placeholder="+91 XXXXX XXXXX"
                                            className="w-full border border-slate-200 rounded-2xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all shadow-sm"
                                            required
                                        />
                                    </div>
                                </div>
                                <div className="space-y-2">
                                    <label className="text-sm font-bold text-slate-600 ml-1">Preferred Language</label>
                                    <div className="relative">
                                        <Icon icon="ph:translate" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
                                        <select
                                            name="topic"
                                            value={formData.topic}
                                            onChange={handleInputChange}
                                            className="w-full border border-slate-200 rounded-2xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none bg-white shadow-sm appearance-none"
                                        >
                                            <option value="Hindi">Hindi</option>
                                            <option value="English">English</option>
                                            <option value="Hindi + English">Hindi + English</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div className="mb-10 space-y-2">
                                <label className="text-sm font-bold text-slate-600 ml-1">Specific Questions or Background</label>
                                <textarea
                                    name="questions"
                                    value={formData.questions}
                                    onChange={handleInputChange}
                                    rows={4}
                                    placeholder="Briefly describe what you'd like to gain from this session..."
                                    className="w-full border border-slate-200 rounded-2xl px-6 py-4 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none resize-none transition-all shadow-sm"
                                />
                            </div>

                            {/* Pay Button */}
                            <button
                                onClick={handlePayment}
                                disabled={isLoading}
                                className="w-full btn-gold py-5 shadow-2xl flex items-center justify-center gap-4 text-xl group"
                            >
                                {isLoading ? (
                                    <>
                                        <Icon icon="ph:circle-notch" className="text-2xl animate-spin" />
                                        Securing Transaction...
                                    </>
                                ) : (
                                    <>
                                        <Icon icon="ph:credit-card-fill" className="text-2xl group-hover:rotate-12 transition-transform" />
                                        Schedule & Pay ₹ {CONSULTATION_PRICE.toLocaleString()}
                                    </>
                                )}
                            </button>

                            <div className="mt-8 flex items-center justify-center gap-8 text-xs font-bold text-slate-400 uppercase tracking-widest">
                                <div className="flex items-center gap-2">
                                    <Icon icon="ph:shield-check-fill" className="text-green-500 text-base" />
                                    SSL Encrypted
                                </div>
                                <div className="flex items-center gap-2">
                                    <Icon icon="ph:certificate-fill" className="text-amber-500 text-base" />
                                    Verified Experts
                                </div>
                            </div>
                        </motion.div>
                    )}

                    {/* Step 5: Success */}
                    {step === 5 && (
                        <motion.div
                            initial={{ opacity: 0, scale: 0.95 }}
                            animate={{ opacity: 1, scale: 1 }}
                            className="text-center"
                        >
                            <div className="w-28 h-28 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-8 shadow-inner">
                                <Icon icon="ph:check-circle-fill" className="text-green-500 text-7xl" />
                            </div>
                            <h2 className="text-3xl font-serif font-bold text-slate-800 mb-4">Cosmic Connection Confirmed!</h2>
                            <p className="text-slate-500 mb-10 max-w-md mx-auto text-lg">
                                Your payment was successful. We've sent a calendar invite. Please confirm it to finalize your session.
                            </p>
                            <div className="glass-panel border border-slate-100 rounded-3xl p-8 mb-10 text-left max-w-md mx-auto shadow-xl">
                                <div className="space-y-5">
                                    <div className="flex items-center gap-4">
                                        <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${selectedType?.color} flex items-center justify-center shadow-lg`}>
                                            <Icon icon={selectedType?.icon} className="text-white text-2xl" />
                                        </div>
                                        <span className="text-xl font-serif font-bold text-slate-800">{selectedType?.name}</span>
                                    </div>
                                    <div className="flex items-center gap-4 border-t border-slate-100 pt-5">
                                        <div className="w-10 h-10 rounded-lg bg-amber-50 flex items-center justify-center">
                                            <Icon icon="ph:calendar-bold" className="text-amber-600 text-xl" />
                                        </div>
                                        <span className="font-bold text-slate-700">{selectedDate && formatFullDate(selectedDate)}</span>
                                    </div>
                                    <div className="flex items-center gap-4">
                                        <div className="w-10 h-10 rounded-lg bg-amber-50 flex items-center justify-center">
                                            <Icon icon="ph:clock-bold" className="text-amber-600 text-xl" />
                                        </div>
                                        <span className="font-bold text-slate-700">{selectedTime}</span>
                                    </div>
                                </div>
                            </div>
                            <div className="flex flex-col sm:flex-row gap-4 justify-center">
                                <a
                                    href={createGoogleCalendarLink()}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="btn-gold px-10 py-4 flex items-center gap-3"
                                >
                                    <Icon icon="ph:calendar-plus-fill" className="text-xl" />
                                    Add to Calendar
                                </a>
                                <button
                                    onClick={() => navigate('/')}
                                    className="px-10 py-4 rounded-full font-bold border-2 border-slate-200 text-slate-600 hover:border-amber-500 hover:text-amber-600 transition-all bg-white"
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
