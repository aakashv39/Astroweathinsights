import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Features from './components/Features';
import Services from './components/Services';
import Pricing from './components/Pricing';
import Footer from './components/Footer';
import LiveStatsStrip from './components/LiveStatsStrip';
import AstroHub from './components/AstroHub';
import HowItWorks from './components/HowItWorks';

import ConsultationForm from './components/ConsultationForm';
import BookConsultancy from './components/BookConsultancy';
import Chatbot from './components/Chatbot';
import PanchangPage from './components/PanchangPage';

function App() {
  return (
    <Router>
      <div className="overflow-x-hidden min-h-screen">
        <Navbar />
        <Routes>
          <Route path="/" element={
            <>
              <Hero />
              <LiveStatsStrip />
              <AstroHub />
              <Services />
              <Features />
              <HowItWorks />
              <Pricing />
            </>
          } />
          <Route path="/get-started" element={<ConsultationForm />} />
          <Route path="/book-consultancy" element={<BookConsultancy />} />
          <Route path="/panchang" element={<PanchangPage />} />
        </Routes>
        <Footer />
        <Chatbot />
      </div>
    </Router>
  );
}

export default App;
