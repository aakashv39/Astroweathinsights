import React, { useState } from 'react';
import './Chatbot.css';
import { sendChatbotMessage } from '../services/api';


const Chatbot = () => {
  const [messages, setMessages] = useState([
    { sender: 'bot', text: 'Hi! How can I help you with astrology insights today?' }
  ]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [minimized, setMinimized] = useState(false);

  const handleSend = async () => {
    if (!input.trim()) return;
    setMessages([...messages, { sender: 'user', text: input }]);
    setLoading(true);
    try {
      const response = await sendChatbotMessage(input);
      console.log('Chatbot API response:', response);
      // If response is an array, show only the first element
      let botReply = response.reply;
      // Handle backend response with 'response' array
      if (response.response && Array.isArray(response.response)) {
        botReply = response.response[0] || '';
      } else if (Array.isArray(botReply)) {
        botReply = botReply[0] || '';
      }
      setMessages((prev) => [...prev, { sender: 'bot', text: botReply }]);
    } catch (err) {
      console.error('Chatbot API error:', err);
      setMessages((prev) => [...prev, { sender: 'bot', text: 'Sorry, something went wrong.' }]);
    }
    setInput('');
    setLoading(false);
  };

  if (minimized) {
    return (
      <div className="chatbot-container chatbot-minimized">
        <button className="chatbot-cross-btn" onClick={() => setMinimized(false)} title="Open chatbot">💬</button>
      </div>
    );
  }

  return (
    <div className="chatbot-container chatbot-large">
      <div className="chatbot-header text-gold-gradient">
        <span style={{ fontSize: '1.5rem', fontWeight: 'bold' }}>Astro Chatbot</span>
        <button className="chatbot-cross-btn" onClick={() => setMinimized(true)} title="Minimize chatbot">✕</button>
      </div>
      <div className="chatbot-messages">
        {messages.map((msg, idx) => (
          <div key={idx} className={`chatbot-message chatbot-${msg.sender}`}>{msg.text}</div>
        ))}
      </div>
      <div className="chatbot-input-row">
        <input
          className="chatbot-input"
          value={input}
          onChange={e => setInput(e.target.value)}
          placeholder="Ask your astrology question..."
          disabled={loading}
          onKeyDown={e => {
            if (e.key === 'Enter' && input.trim() && !loading) handleSend();
          }}
        />
        <button className="chatbot-send-btn" onClick={handleSend} disabled={loading || !input.trim()}>
          Send
        </button>
      </div>
    </div>
  );
};

export default Chatbot;
