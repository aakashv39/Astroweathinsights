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
      <nav className="fixed top-0 left-0 w-full z-[100] px-6 md:px-20 py-3 bg-white/80 backdrop-blur-md shadow-sm transition-all duration-300">
        <div className="max-w-7xl mx-auto flex justify-between items-center">
          <a href="/" className="font-serif font-bold text-xl md:text-2xl text-slate-900 no-underline">
            AstroTech<span className="text-amber-600">Wealth</span>
          </a>

          {/* Desktop Links */}
          <div className="hidden md:flex gap-8 items-center">
            <a href="/" className="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">Home</a>
            <a href="#services" className="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">Services</a>
            <Link to="/book-consultancy" className="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors flex items-center gap-1">
              <Icon icon="ph:video-camera" className="text-lg" />
              Consultancy
            </Link>

            {user ? (
              <div className="flex items-center gap-4">
                <div className="flex items-center gap-2 bg-amber-50 px-3 py-1.5 rounded-full">
                  <Icon icon="ph:user-circle-fill" className="text-amber-600 text-xl" />
                  <span className="text-sm font-bold text-slate-800">{user.full_name || 'User'}</span>
                </div>
                <button onClick={handleLogout} className="text-sm font-medium text-red-500 hover:text-red-700 transition-colors">Logout</button>
              </div>
            ) : (
              <button onClick={() => openAuthModal('login')} className="text-sm font-medium text-slate-600 hover:text-slate-900 transition-colors">
                Sign In
              </button>
            )}

            <Link to="/get-started" className="bg-gradient-to-r from-amber-500 to-amber-700 text-white px-5 py-2 rounded-full font-semibold text-sm hover:opacity-90 transition-opacity shadow-lg hover:shadow-xl no-underline">
              Get Started
            </Link>
          </div>

          {/* Mobile Menu Button */}
          <button className="md:hidden text-2xl text-slate-800" onClick={() => setIsOpen(!isOpen)}>
            <Icon icon={isOpen ? "ph:x-bold" : "ph:list-bold"} />
          </button>
        </div>

        {/* Mobile Menu Content */}
        {isOpen && (
          <div className="md:hidden absolute top-full left-0 w-full bg-white/95 backdrop-blur-md shadow-lg p-6 flex flex-col gap-2 items-center animate-fadeIn border-t border-slate-100">
            <a href="/" onClick={() => setIsOpen(false)} className="text-slate-800 font-medium w-full text-center py-3 hover:bg-slate-50 rounded-xl transition-colors">Home</a>
            <a href="#services" onClick={() => setIsOpen(false)} className="text-slate-800 font-medium w-full text-center py-3 hover:bg-slate-50 rounded-xl transition-colors">Services</a>
            <Link to="/book-consultancy" onClick={() => setIsOpen(false)} className="text-slate-800 font-medium w-full text-center py-3 hover:bg-slate-50 rounded-xl transition-colors flex items-center justify-center gap-2">
              <Icon icon="ph:video-camera" className="text-lg" />
              Consultancy
            </Link>
            {user ? (
              <button onClick={() => { handleLogout(); setIsOpen(false); }} className="text-red-500 font-medium w-full text-center py-3 hover:bg-red-50 rounded-xl transition-colors">Logout</button>
            ) : (
              <button onClick={() => { openAuthModal('login'); setIsOpen(false); }} className="text-slate-800 font-medium w-full text-center py-3 hover:bg-slate-50 rounded-xl transition-colors">Sign In</button>
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
