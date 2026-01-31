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

    const inputClasses = "w-full bg-white/50 border border-slate-200 rounded-xl px-4 py-3 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all placeholder:text-slate-400";
    const labelClasses = "block text-sm font-bold text-slate-700 mb-2 uppercase tracking-tight";

    return (
        <div className="min-h-screen py-24 px-6 md:px-12 flex items-center justify-center">
            <motion.div
                className="w-full max-w-2xl bg-white/70 backdrop-blur-2xl p-8 md:p-12 rounded-[2rem] border border-white/50 shadow-2xl"
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6 }}
            >
                <div className="mb-10 text-center">
                    <h1 className="text-3xl md:text-4xl font-serif font-black text-slate-900 mb-2">Get Your Detailed Report</h1>
                    <p className="text-slate-600">Please provide your precise birth details for accurate analysis.</p>
                </div>

                {status.message && (
                    <div className={`mb-8 p-4 rounded-xl flex items-center gap-3 ${status.type === 'success' ? 'bg-green-100 text-green-700 border border-green-200' : 'bg-red-100 text-red-700 border border-red-200'
                        }`}>
                        <Icon icon={status.type === 'success' ? "ph:check-circle-fill" : "ph:warning-circle-fill"} className="text-2xl flex-shrink-0" />
                        <span className="font-medium">{status.message}</span>
                    </div>
                )}

                <form onSubmit={handleSubmit} className="space-y-8">
                    {/* Name Section */}
                    <div>
                        <label className={labelClasses}>Name of Person Report is about <span className="text-red-500">*</span></label>
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <input
                                    type="text"
                                    name="first_name"
                                    placeholder="First Name"
                                    required
                                    className={inputClasses}
                                    value={formData.first_name}
                                    onChange={handleChange}
                                />
                                <span className="text-xs text-slate-500 mt-1 block px-1">First Name</span>
                            </div>
                            <div>
                                <input
                                    type="text"
                                    name="last_name"
                                    placeholder="Last Name"
                                    required
                                    className={inputClasses}
                                    value={formData.last_name}
                                    onChange={handleChange}
                                />
                                <span className="text-xs text-slate-500 mt-1 block px-1">Last Name</span>
                            </div>
                        </div>
                    </div>

                    {/* Birth Date Section */}
                    <div>
                        <label className={labelClasses}>Birth Date <span className="text-red-500">*</span></label>
                        <div className="grid grid-cols-3 gap-4">
                            <select name="birth_month" required className={inputClasses} value={formData.birth_month} onChange={handleChange}>
                                <option value="">Month</option>
                                {['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'].map(m => (
                                    <option key={m} value={m}>{m}</option>
                                ))}
                            </select>
                            <select name="birth_day" required className={inputClasses} value={formData.birth_day} onChange={handleChange}>
                                <option value="">Day</option>
                                {[...Array(31)].map((_, i) => (
                                    <option key={i + 1} value={i + 1}>{i + 1}</option>
                                ))}
                            </select>
                            <input
                                type="text"
                                name="birth_year"
                                placeholder="Year"
                                required
                                className={inputClasses}
                                value={formData.birth_year}
                                onChange={handleChange}
                            />
                        </div>
                        <div className="grid grid-cols-3 gap-4 mt-1 px-1">
                            <span className="text-xs text-slate-500">Month</span>
                            <span className="text-xs text-slate-500">Day</span>
                            <span className="text-xs text-slate-500">Year</span>
                        </div>
                    </div>

                    {/* Time of Birth Section */}
                    <div>
                        <label className={labelClasses}>Time of Birth</label>
                        <div className="grid grid-cols-3 gap-4">
                            <select name="birth_hour" className={inputClasses} value={formData.birth_hour} onChange={handleChange}>
                                {[...Array(12)].map((_, i) => (
                                    <option key={i + 1} value={i + 1}>{i + 1}</option>
                                ))}
                            </select>
                            <select name="birth_minutes" className={inputClasses} value={formData.birth_minutes} onChange={handleChange}>
                                {[...Array(60)].map((_, i) => (
                                    <option key={i} value={i < 10 ? `0${i}` : i}>{i < 10 ? `0${i}` : i}</option>
                                ))}
                            </select>
                            <select name="birth_period" className={inputClasses} value={formData.birth_period} onChange={handleChange}>
                                <option value="AM">AM</option>
                                <option value="PM">PM</option>
                            </select>
                        </div>
                        <div className="grid grid-cols-3 gap-4 mt-1 px-1">
                            <span className="text-xs text-slate-500">Hour</span>
                            <span className="text-xs text-slate-500">Minutes</span>
                        </div>
                    </div>

                    {/* Gender Section */}
                    <div>
                        <label className={labelClasses}>Gender <span className="text-red-500">*</span></label>
                        <div className="flex gap-8">
                            <label className="flex items-center gap-3 cursor-pointer group">
                                <div
                                    className={`w-5 h-5 border-2 rounded flex items-center justify-center transition-all ${formData.gender === 'MALE' ? 'bg-amber-500 border-amber-500' : 'bg-white border-slate-300'
                                        }`}
                                    onClick={() => handleGenderSelect('MALE')}
                                >
                                    {formData.gender === 'MALE' && <Icon icon="ph:check-bold" className="text-white text-xs" />}
                                </div>
                                <span className="text-slate-700 font-semibold group-hover:text-amber-600 transition-colors uppercase text-sm">Male</span>
                            </label>
                            <label className="flex items-center gap-3 cursor-pointer group">
                                <div
                                    className={`w-5 h-5 border-2 rounded flex items-center justify-center transition-all ${formData.gender === 'FEMALE' ? 'bg-amber-500 border-amber-500' : 'bg-white border-slate-300'
                                        }`}
                                    onClick={() => handleGenderSelect('FEMALE')}
                                >
                                    {formData.gender === 'FEMALE' && <Icon icon="ph:check-bold" className="text-white text-xs" />}
                                </div>
                                <span className="text-slate-700 font-semibold group-hover:text-amber-600 transition-colors uppercase text-sm">Female</span>
                            </label>
                        </div>
                    </div>

                    {/* Residence Section */}
                    <div>
                        <label className={labelClasses}>Current Residence</label>
                        <textarea
                            name="current_residence"
                            placeholder="City, State or Province, Country"
                            className={`${inputClasses} h-24 resize-none`}
                            value={formData.current_residence}
                            onChange={handleChange}
                        ></textarea>
                    </div>

                    {/* Place of Birth Section */}
                    <div>
                        <label className={labelClasses}>Place of Birth</label>
                        <textarea
                            name="place_of_birth"
                            placeholder="City, State or Province, Country"
                            className={`${inputClasses} h-24 resize-none`}
                            value={formData.place_of_birth}
                            onChange={handleChange}
                        ></textarea>
                    </div>

                    {/* Submit Button */}
                    <motion.button
                        type="submit"
                        disabled={isLoading}
                        className="w-full bg-gradient-to-r from-amber-500 to-amber-700 text-white font-bold py-4 rounded-2xl shadow-xl shadow-amber-500/20 hover:opacity-90 disabled:opacity-50 transition-all flex items-center justify-center gap-2 text-lg"
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                    >
                        {isLoading ? (
                            <>
                                <Icon icon="ph:circle-notch" className="animate-spin text-2xl" />
                                <span>Submitting...</span>
                            </>
                        ) : (
                            <>
                                <Icon icon="ph:rocket-launch-fill" className="text-2xl" />
                                <span>Get My Report</span>
                            </>
                        )}
                    </motion.button>
                </form>
            </motion.div>
        </div>
    );
};

export default ConsultationForm;
