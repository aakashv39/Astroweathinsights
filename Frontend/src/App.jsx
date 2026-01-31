import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Features from './components/Features';
import Services from './components/Services';
import Pricing from './components/Pricing';
import Footer from './components/Footer';
import ConsultationForm from './components/ConsultationForm';
import BookConsultancy from './components/BookConsultancy';

function App() {
  return (
    <Router>
      <div className="overflow-x-hidden min-h-screen">
        <Navbar />
        <Routes>
          <Route path="/" element={
            <>
              <Hero />
              <Services />
              <Features />
              <Pricing />
            </>
          } />
          <Route path="/get-started" element={<ConsultationForm />} />
          <Route path="/book-consultancy" element={<BookConsultancy />} />
        </Routes>
        <Footer />
      </div>
    </Router>
  );
}

export default App;
