import React, { useState, useEffect } from 'react';
import { Icon } from '@iconify/react';
import { Link } from 'react-router-dom';
import { login, signup, getMe } from '../services/api';

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [authMode, setAuthMode] = useState('login'); // 'login' or 'signup'
  const [user, setUser] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  // Form State
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      getMe().then(setUser).catch(() => {
        localStorage.removeItem('token');
        setUser(null);
      });
    }
  }, []);

  const resetForm = () => {
    setEmail('');
    setPassword('');
    setFullName('');
    setPhoneNumber('');
    setError('');
    setSuccess('');
  };

  const handleAuth = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    setIsLoading(true);

    try {
      if (authMode === 'login') {
        const data = await login(email, password);
        localStorage.setItem('token', data.access_token);
        const userData = await getMe();
        setUser(userData);
        setSuccess('Login successful! Welcome back.');
        setTimeout(() => {
          setShowAuthModal(false);
          resetForm();
        }, 1000);
      } else {
        await signup(email, password, fullName, phoneNumber);
        setSuccess('Account created! Logging you in...');
        // Auto login after signup
        const data = await login(email, password);
        localStorage.setItem('token', data.access_token);
        const userData = await getMe();
        setUser(userData);
        setTimeout(() => {
          setShowAuthModal(false);
          resetForm();
        }, 1500);
      }
    } catch (err) {
      console.error(err);
      setError(err.message || 'Authentication failed. Please check your credentials.');
    } finally {
      setIsLoading(false);
    }
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    setUser(null);
  };

  const openAuthModal = (mode) => {
    setAuthMode(mode);
    resetForm();
    setShowAuthModal(true);
  };

  return (
    <>
      <nav className="fixed top-0 left-0 w-full z-[999] px-6 md:px-12 py-4 bg-white/90 backdrop-blur-md border-b border-amber-100/50 shadow-sm transition-all duration-300">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <Link to="/" className="font-serif font-black text-2xl text-slate-900 tracking-tight flex items-center gap-2 no-underline group">
            <span>AstroTech<span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-500 to-amber-700">Wealth</span></span>
          </Link>

          {/* Desktop Links */}
          <div className="hidden md:flex gap-8 items-center bg-white/50 px-6 py-2 rounded-full border border-white/50 shadow-sm backdrop-blur-sm">
            <Link to="/" className="text-xs font-bold uppercase tracking-widest text-slate-500 hover:text-amber-600 transition-colors">Home</Link>
            <a href="#services" className="text-xs font-bold uppercase tracking-widest text-slate-500 hover:text-amber-600 transition-colors">Services</a>
            <Link to="/book-consultancy" className="text-xs font-bold uppercase tracking-widest text-slate-500 hover:text-amber-600 transition-colors flex items-center gap-1">
              Consultancy
            </Link>
          </div>

          <div className="hidden md:flex items-center gap-4">
            {user ? (
              <div className="flex items-center gap-4">
                <div className="flex items-center gap-2 pl-2 pr-4 py-1.5 rounded-full bg-slate-50 border border-slate-100">
                  <div className="w-8 h-8 rounded-full bg-gradient-to-br from-amber-400 to-amber-600 flex items-center justify-center text-white text-xs font-bold shadow-sm">
                    {user.full_name ? user.full_name.charAt(0).toUpperCase() : 'U'}
                  </div>
                  <span className="text-xs font-bold text-slate-700">{user.full_name?.split(' ')[0] || 'User'}</span>
                </div>
                <button onClick={handleLogout} className="w-8 h-8 rounded-full flex items-center justify-center text-slate-400 hover:text-red-500 hover:bg-red-50 transition-all" title="Logout">
                  <Icon icon="ph:sign-out-bold" />
                </button>
              </div>
            ) : (
              <button
                onClick={() => openAuthModal('login')}
                className="text-xs font-bold uppercase tracking-widest text-slate-500 hover:text-slate-900 transition-colors"
              >
                Sign In
              </button>
            )}

            <Link to="/get-started" className="bg-gradient-to-r from-amber-500 to-amber-700 text-white px-6 py-2.5 rounded-xl font-bold text-xs uppercase tracking-widest hover:opacity-90 transition-all shadow-lg shadow-amber-200 no-underline flex items-center gap-2 group">
              Get Started
              <Icon icon="ph:arrow-right-bold" className="group-hover:translate-x-1 transition-transform" />
            </Link>
          </div>

          {/* Mobile Menu Button */}
          <button className="md:hidden text-2xl text-slate-800 p-2" onClick={() => setIsOpen(!isOpen)}>
            <Icon icon={isOpen ? "ph:x-bold" : "ph:list-bold"} />
          </button>
        </div>

        {/* Mobile Menu Content */}
        {isOpen && (
          <div className="md:hidden absolute top-full left-0 w-full bg-white border-b border-slate-100 p-6 flex flex-col gap-4 shadow-xl animate-fadeIn h-screen z-[998]">
            <Link to="/" onClick={() => setIsOpen(false)} className="flex items-center p-3 rounded-xl bg-slate-50 hover:bg-amber-50 text-slate-600 hover:text-amber-700 font-bold transition-all">
              <Icon icon="ph:house-bold" className="mr-3 text-lg" />
              Home
            </Link>
            <a href="#services" onClick={() => setIsOpen(false)} className="flex items-center p-3 rounded-xl bg-slate-50 hover:bg-amber-50 text-slate-600 hover:text-amber-700 font-bold transition-all">
              <Icon icon="ph:star-four-bold" className="mr-3 text-lg" />
              Services
            </a>
            <Link to="/book-consultancy" onClick={() => setIsOpen(false)} className="flex items-center p-3 rounded-xl bg-slate-50 hover:bg-amber-50 text-slate-600 hover:text-amber-700 font-bold transition-all">
              <Icon icon="ph:video-camera-bold" className="mr-3 text-lg" />
              Consultancy
            </Link>

            <div className="h-px bg-slate-100 my-2"></div>

            {user ? (
              <button onClick={() => { handleLogout(); setIsOpen(false); }} className="flex items-center justify-center p-3 text-red-500 font-bold bg-red-50 rounded-xl">
                Logout
              </button>
            ) : (
              <div className="grid grid-cols-2 gap-3">
                <button onClick={() => { openAuthModal('login'); setIsOpen(false); }} className="p-3 text-slate-600 font-bold bg-slate-50 rounded-xl hover:bg-slate-100">
                  Sign In
                </button>
                <button onClick={() => { openAuthModal('signup'); setIsOpen(false); }} className="p-3 text-white font-bold bg-amber-600 rounded-xl hover:bg-amber-700 shadow-lg shadow-amber-200">
                  Sign Up
                </button>
              </div>
            )}
          </div>
        )}
      </nav>

      {/* Auth Modal */}
      {showAuthModal && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 animate-fadeIn">
          <div className="bg-white rounded-2xl w-full max-w-md p-8 relative shadow-2xl transform transition-all animate-slideUp">
            <button
              onClick={() => { setShowAuthModal(false); resetForm(); }}
              className="absolute top-4 right-4 text-slate-400 hover:text-slate-600 transition-colors"
              disabled={isLoading}
            >
              <Icon icon="ph:x-circle-fill" className="text-2xl" />
            </button>

            {/* Header with Icon */}
            <div className="text-center mb-6">
              <div className="w-16 h-16 bg-gradient-to-br from-amber-400 to-amber-600 rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg">
                <Icon icon={authMode === 'login' ? "ph:sign-in-bold" : "ph:user-plus-bold"} className="text-white text-2xl" />
              </div>
              <h2 className="text-2xl font-bold text-slate-800">
                {authMode === 'login' ? 'Welcome Back' : 'Create Account'}
              </h2>
              <p className="text-slate-500 text-sm mt-1">
                {authMode === 'login' ? 'Sign in to access your account' : 'Join us for cosmic insights'}
              </p>
            </div>

            {/* Success Message */}
            {success && (
              <div className="flex items-center gap-2 text-green-600 text-sm text-center mb-4 bg-green-50 p-3 rounded-lg border border-green-200">
                <Icon icon="ph:check-circle-fill" className="text-xl flex-shrink-0" />
                <span>{success}</span>
              </div>
            )}

            {/* Error Message */}
            {error && (
              <div className="flex items-center gap-2 text-red-600 text-sm text-center mb-4 bg-red-50 p-3 rounded-lg border border-red-200">
                <Icon icon="ph:warning-circle-fill" className="text-xl flex-shrink-0" />
                <span>{error}</span>
              </div>
            )}

            <form onSubmit={handleAuth} className="space-y-4">
              {authMode === 'signup' && (
                <>
                  <div>
                    <label className="block text-sm font-medium text-slate-600 mb-1">Full Name</label>
                    <div className="relative">
                      <Icon icon="ph:user" className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                      <input
                        type="text"
                        required
                        placeholder="Enter your full name"
                        className="w-full border border-slate-300 rounded-lg pl-10 pr-4 py-2.5 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all"
                        value={fullName}
                        onChange={(e) => setFullName(e.target.value)}
                        disabled={isLoading}
                      />
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-600 mb-1">Phone Number</label>
                    <div className="relative">
                      <Icon icon="ph:phone" className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                      <input
                        type="tel"
                        placeholder="Enter your phone number"
                        className="w-full border border-slate-300 rounded-lg pl-10 pr-4 py-2.5 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all"
                        value={phoneNumber}
                        onChange={(e) => setPhoneNumber(e.target.value)}
                        disabled={isLoading}
                      />
                    </div>
                  </div>
                </>
              )}
              <div>
                <label className="block text-sm font-medium text-slate-600 mb-1">Email Address</label>
                <div className="relative">
                  <Icon icon="ph:envelope" className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                  <input
                    type="email"
                    required
                    placeholder="you@example.com"
                    autoComplete="email"
                    className="w-full border border-slate-300 rounded-lg pl-10 pr-4 py-2.5 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    disabled={isLoading}
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-600 mb-1">Password</label>
                <div className="relative">
                  <Icon icon="ph:lock-key" className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                  <input
                    type="password"
                    required
                    placeholder="••••••••"
                    autoComplete={authMode === 'login' ? 'current-password' : 'new-password'}
                    className="w-full border border-slate-300 rounded-lg pl-10 pr-4 py-2.5 focus:ring-2 focus:ring-amber-500 focus:border-amber-500 outline-none transition-all"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    disabled={isLoading}
                  />
                </div>
              </div>

              <button
                type="submit"
                disabled={isLoading}
                className="w-full bg-gradient-to-r from-amber-500 to-amber-700 text-white font-bold py-3 rounded-lg shadow-lg hover:opacity-90 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                {isLoading ? (
                  <>
                    <Icon icon="ph:circle-notch" className="text-xl animate-spin" />
                    <span>{authMode === 'login' ? 'Signing In...' : 'Creating Account...'}</span>
                  </>
                ) : (
                  <>
                    <Icon icon={authMode === 'login' ? "ph:sign-in-bold" : "ph:user-plus-bold"} className="text-xl" />
                    <span>{authMode === 'login' ? 'Sign In' : 'Sign Up'}</span>
                  </>
                )}
              </button>
            </form>

            <div className="mt-6 text-center text-sm text-slate-500">
              {authMode === 'login' ? (
                <>Don't have an account? <button onClick={() => { setAuthMode('signup'); setError(''); setSuccess(''); }} className="text-amber-600 font-bold hover:underline" disabled={isLoading}>Sign Up</button></>
              ) : (
                <>Already have an account? <button onClick={() => { setAuthMode('login'); setError(''); setSuccess(''); }} className="text-amber-600 font-bold hover:underline" disabled={isLoading}>Log In</button></>
              )}
            </div>
          </div>
        </div>
      )}

      {/* CSS for animations */}
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slideUp {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        .animate-fadeIn {
          animation: fadeIn 0.2s ease-out;
        }
        .animate-slideUp {
          animation: slideUp 0.3s ease-out;
        }
      `}</style>
    </>
  );
};
export default Navbar;
