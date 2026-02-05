import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { Icon } from '@iconify/react';
import { useNavigate } from 'react-router-dom';
import { submitConsultation, generateReport } from '../services/api';

const ConsultationForm = () => {
    const navigate = useNavigate();
    const [isLoading, setIsLoading] = useState(false);
    const [status, setStatus] = useState({ type: '', message: '' });

    const [formData, setFormData] = useState({
        first_name: '',
        last_name: '',
        birth_month: '',
        birth_day: '',
        birth_year: '',
        birth_hour: '12',
        birth_minutes: '00',
        birth_period: 'AM',
        gender: '',
        current_residence: '',
        place_of_birth: ''
    });

    useEffect(() => {
        window.scrollTo(0, 0);
    }, []);

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({ ...prev, [name]: value }));
    };

    const handleGenderSelect = (gender) => {
        setFormData(prev => ({ ...prev, gender }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        const token = localStorage.getItem('token');
        if (!token) {
            setStatus({ type: 'error', message: 'Please sign in first to submit your details.' });
            return;
        }

        if (!formData.gender) {
            setStatus({ type: 'error', message: 'Please select a gender.' });
            return;
        }

        setIsLoading(true);
        setStatus({ type: '', message: '' });

        try {
            // 1. Submit to database (existing logic)
            await submitConsultation(formData);

            // 2. Prepare data for PDF generation
            const monthMap = {
                'January': '01', 'February': '02', 'March': '03', 'April': '04',
                'May': '05', 'June': '06', 'July': '07', 'August': '08',
                'September': '09', 'October': '10', 'November': '11', 'December': '12'
            };

            const day = formData.birth_day.padStart(2, '0');
            const month = monthMap[formData.birth_month];
            const year = formData.birth_year;

            // Format time: HH:MM
            let hour = parseInt(formData.birth_hour);
            if (formData.birth_period === 'PM' && hour !== 12) hour += 12;
            if (formData.birth_period === 'AM' && hour === 12) hour = 0;
            const timeStr = `${hour.toString().padStart(2, '0')}:${formData.birth_minutes}`;

            const reportData = {
                birth_date: `${year}-${month}-${day}`,
                birth_time: timeStr,
                lat: 28.6139, // Default for now, could be enhanced with geocoding
                lon: 77.2090, // Default for now
                timezone: "+05:30", // Default for now
                target_year: 2025,
                client_name: `${formData.first_name} ${formData.last_name}`
            };

            // 3. Generate and Download PDF
            const blob = await generateReport(reportData);
            const url = window.URL.createObjectURL(new Blob([blob]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', `Varshphal_Report_${formData.first_name}.pdf`);
            document.body.appendChild(link);
            link.click();
            link.remove();

            setStatus({ type: 'success', message: 'Report generated and downloaded successfully!' });
            setTimeout(() => {
                navigate('/');
            }, 5000);
        } catch (err) {
            console.error('Submit error:', err);
            setStatus({ type: 'error', message: err.message || 'Failed to generate report. Please try again.' });
        } finally {
            setIsLoading(false);
        }
    };

    const inputClasses = "w-full bg-white/50 border border-slate-200 rounded-xl pl-12 pr-4 py-4 focus:ring-2 focus:ring-amber-500/50 focus:border-amber-500 outline-none transition-all placeholder:text-slate-400 font-medium text-slate-700 hover:bg-white/80";
    const labelClasses = "block text-xs font-bold text-slate-500 mb-2 uppercase tracking-widest pl-1";

    return (
        <div className="min-h-screen py-32 px-4 md:px-6 flex items-center justify-center relative overflow-hidden bg-slate-50">
            {/* Background Atmosphere */}
            <div className="absolute top-0 left-0 w-full h-full pointer-events-none">
                <div className="absolute top-[-10%] right-[-5%] w-[600px] h-[600px] bg-amber-200/20 rounded-full blur-[120px]"></div>
                <div className="absolute bottom-[-10%] left-[-10%] w-[500px] h-[500px] bg-indigo-200/20 rounded-full blur-[120px]"></div>
            </div>

            <motion.div
                className="w-full max-w-3xl bg-white/80 backdrop-blur-2xl p-8 md:p-12 rounded-[2.5rem] border border-white shadow-2xl relative z-10"
                initial={{ opacity: 0, y: 40 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.8, ease: "easeOut" }}
            >
                <div className="mb-12 text-center">
                    <motion.div
                        initial={{ scale: 0.9, opacity: 0 }}
                        animate={{ scale: 1, opacity: 1 }}
                        transition={{ delay: 0.2 }}
                        className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gradient-to-br from-amber-100 to-amber-200 text-amber-600 mb-6 shadow-inner"
                    >
                        <Icon icon="ph:scroll-fill" className="text-3xl" />
                    </motion.div>
                    <h1 className="text-4xl md:text-5xl font-serif font-black text-slate-900 mb-4 tracking-tight">
                        Your <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-500 to-amber-700">Cosmic Blueprint</span>
                    </h1>
                    <p className="text-slate-500 text-lg max-w-xl mx-auto leading-relaxed">
                        To generate your precise Varshphal report, we need the exact alignment of stars at your birth.
                    </p>
                </div>

                {status.message && (
                    <motion.div
                        initial={{ opacity: 0, height: 0 }}
                        animate={{ opacity: 1, height: 'auto' }}
                        className={`mb-10 p-5 rounded-2xl flex items-start gap-4 ${status.type === 'success' ? 'bg-green-50 text-green-800 border-green-100 ring-1 ring-green-200' : 'bg-red-50 text-red-800 border-red-100 ring-1 ring-red-200'
                            }`}
                    >
                        <Icon icon={status.type === 'success' ? "ph:check-circle-fill" : "ph:warning-circle-fill"} className="text-2xl mt-0.5 flex-shrink-0" />
                        <div>
                            <p className="font-bold text-sm uppercase tracking-wide mb-1">{status.type === 'success' ? 'Success' : 'Attention Needed'}</p>
                            <span className="font-medium text-base opacity-90">{status.message}</span>
                        </div>
                    </motion.div>
                )}

                <form onSubmit={handleSubmit} className="space-y-10">
                    {/* Person Details */}
                    <div>
                        <div className="flex items-center gap-3 mb-6">
                            <span className="w-8 h-1 bg-amber-500 rounded-full"></span>
                            <h3 className="text-xl font-serif font-bold text-slate-800">Personal Details</h3>
                        </div>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div className="group">
                                <label className={labelClasses}>First Name</label>
                                <div className="relative">
                                    <Icon icon="ph:user" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xl group-focus-within:text-amber-500 transition-colors" />
                                    <input
                                        type="text"
                                        name="first_name"
                                        placeholder="Arjun"
                                        required
                                        className={inputClasses}
                                        value={formData.first_name}
                                        onChange={handleChange}
                                    />
                                </div>
                            </div>
                            <div className="group">
                                <label className={labelClasses}>Last Name</label>
                                <div className="relative">
                                    <Icon icon="ph:user-bold" className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 text-xl group-focus-within:text-amber-500 transition-colors" />
                                    <input
                                        type="text"
                                        name="last_name"
                                        placeholder="Sharma"
                                        required
                                        className={inputClasses}
                                        value={formData.last_name}
                                        onChange={handleChange}
                                    />
                                </div>
                            </div>
                        </div>

                        <div className="mt-8">
                            <label className={labelClasses}>Gender</label>
                            <div className="grid grid-cols-2 gap-4">
                                <div
                                    onClick={() => handleGenderSelect('MALE')}
                                    className={`cursor-pointer relative p-4 rounded-xl border-2 transition-all duration-300 flex items-center justify-center gap-3 ${formData.gender === 'MALE' ? 'border-amber-500 bg-amber-50 text-amber-700' : 'border-slate-100 bg-white hover:border-slate-200'}`}
                                >
                                    <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${formData.gender === 'MALE' ? 'border-amber-500' : 'border-slate-300'}`}>
                                        {formData.gender === 'MALE' && <div className="w-2.5 h-2.5 bg-amber-500 rounded-full" />}
                                    </div>
                                    <span className="font-bold">Male</span>
                                </div>
                                <div
                                    onClick={() => handleGenderSelect('FEMALE')}
                                    className={`cursor-pointer relative p-4 rounded-xl border-2 transition-all duration-300 flex items-center justify-center gap-3 ${formData.gender === 'FEMALE' ? 'border-amber-500 bg-amber-50 text-amber-700' : 'border-slate-100 bg-white hover:border-slate-200'}`}
                                >
                                    <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${formData.gender === 'FEMALE' ? 'border-amber-500' : 'border-slate-300'}`}>
                                        {formData.gender === 'FEMALE' && <div className="w-2.5 h-2.5 bg-amber-500 rounded-full" />}
                                    </div>
                                    <span className="font-bold">Female</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Birth Details */}
                    <div>
                        <div className="flex items-center gap-3 mb-6">
                            <span className="w-8 h-1 bg-amber-500 rounded-full"></span>
                            <h3 className="text-xl font-serif font-bold text-slate-800">Birth Information</h3>
                        </div>

                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                            <div className="relative group">
                                <label className={labelClasses}>Month</label>
                                <Icon icon="ph:calendar-blank" className="absolute left-4 top-[3.2rem] text-slate-400 text-xl z-10" />
                                <select name="birth_month" required className={`${inputClasses} appearance-none cursor-pointer`} value={formData.birth_month} onChange={handleChange}>
                                    <option value="">Select Month</option>
                                    {['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'].map(m => (
                                        <option key={m} value={m}>{m}</option>
                                    ))}
                                </select>
                            </div>
                            <div className="relative group">
                                <label className={labelClasses}>Day</label>
                                <Icon icon="ph:calendar-plus" className="absolute left-4 top-[3.2rem] text-slate-400 text-xl z-10" />
                                <select name="birth_day" required className={`${inputClasses} appearance-none cursor-pointer`} value={formData.birth_day} onChange={handleChange}>
                                    <option value="">Select Day</option>
                                    {[...Array(31)].map((_, i) => (
                                        <option key={i + 1} value={i + 1}>{i + 1}</option>
                                    ))}
                                </select>
                            </div>
                            <div className="relative group">
                                <label className={labelClasses}>Year</label>
                                <Icon icon="ph:calendar" className="absolute left-4 top-[3.2rem] text-slate-400 text-xl z-10" />
                                <input
                                    type="text"
                                    name="birth_year"
                                    placeholder="YYYY"
                                    required
                                    className={inputClasses}
                                    value={formData.birth_year}
                                    onChange={handleChange}
                                    maxLength={4}
                                />
                            </div>
                        </div>

                        <div className="grid grid-cols-3 gap-4">
                            <div className="relative group">
                                <label className={labelClasses}>Hour</label>
                                <Icon icon="ph:clock" className="absolute left-4 top-[3.2rem] text-slate-400 text-xl z-10" />
                                <select name="birth_hour" className={`${inputClasses} appearance-none cursor-pointer`} value={formData.birth_hour} onChange={handleChange}>
                                    {[...Array(12)].map((_, i) => (
                                        <option key={i + 1} value={i + 1}>{i + 1}</option>
                                    ))}
                                </select>
                            </div>
                            <div className="relative group">
                                <label className={labelClasses}>Minute</label>
                                <Icon icon="ph:timer" className="absolute left-4 top-[3.2rem] text-slate-400 text-xl z-10" />
                                <select name="birth_minutes" className={`${inputClasses} appearance-none cursor-pointer`} value={formData.birth_minutes} onChange={handleChange}>
                                    {[...Array(60)].map((_, i) => (
                                        <option key={i} value={i < 10 ? `0${i}` : i}>{i < 10 ? `0${i}` : i}</option>
                                    ))}
                                </select>
                            </div>
                            <div className="relative group">
                                <label className={labelClasses}>AM/PM</label>
                                <Icon icon="ph:sun-horizon" className="absolute left-4 top-[3.2rem] text-slate-400 text-xl z-10" />
                                <select name="birth_period" className={`${inputClasses} appearance-none cursor-pointer`} value={formData.birth_period} onChange={handleChange}>
                                    <option value="AM">AM</option>
                                    <option value="PM">PM</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    {/* Location Details */}
                    <div>
                        <div className="flex items-center gap-3 mb-6">
                            <span className="w-8 h-1 bg-amber-500 rounded-full"></span>
                            <h3 className="text-xl font-serif font-bold text-slate-800">Location Details</h3>
                        </div>
                        <div className="space-y-6">
                            <div className="group">
                                <label className={labelClasses}>Place of Birth</label>
                                <div className="relative">
                                    <Icon icon="ph:map-pin-line" className="absolute left-4 top-5 text-slate-400 text-xl z-10" />
                                    <textarea
                                        name="place_of_birth"
                                        placeholder="e.g. Mumbai, Maharashtra, India"
                                        className={`${inputClasses} h-24 resize-none pt-4`}
                                        value={formData.place_of_birth}
                                        onChange={handleChange}
                                    ></textarea>
                                </div>
                            </div>
                            <div className="group">
                                <label className={labelClasses}>Current Residence</label>
                                <div className="relative">
                                    <Icon icon="ph:house-line" className="absolute left-4 top-5 text-slate-400 text-xl z-10" />
                                    <textarea
                                        name="current_residence"
                                        placeholder="e.g. New Delhi, India"
                                        className={`${inputClasses} h-24 resize-none pt-4`}
                                        value={formData.current_residence}
                                        onChange={handleChange}
                                    ></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Submit Button */}
                    <motion.button
                        type="submit"
                        disabled={isLoading}
                        className="w-full bg-slate-900 text-white font-bold py-5 rounded-2xl shadow-xl hover:shadow-2xl hover:bg-slate-800 disabled:opacity-70 transition-all flex items-center justify-center gap-3 text-lg tracking-wide group relative overflow-hidden"
                        whileHover={{ scale: 1.01 }}
                        whileTap={{ scale: 0.99 }}
                    >
                        <div className="absolute inset-0 bg-gradient-to-r from-amber-500 to-amber-700 opacity-0 group-hover:opacity-10 transition-opacity duration-300"></div>
                        {isLoading ? (
                            <>
                                <Icon icon="ph:spinner-gap-bold" className="animate-spin text-2xl" />
                                <span>Generating Analysis...</span>
                            </>
                        ) : (
                            <>
                                <span>Generate Premium Report</span>
                                <Icon icon="ph:arrow-right-bold" className="text-xl group-hover:translate-x-1 transition-transform text-amber-500" />
                            </>
                        )}
                    </motion.button>

                    <p className="text-center text-xs text-slate-400 font-medium">
                        <Icon icon="ph:lock-key-fill" className="inline mb-0.5 mr-1" />
                        Your data is encrypted and used only for report generation.
                    </p>
                </form>
            </motion.div>
        </div>
    );
};

export default ConsultationForm;
