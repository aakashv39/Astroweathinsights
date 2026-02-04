import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'https://astrotalkinsight.onrender.com';

const api = axios.create({
    baseURL: API_URL,
    timeout: 10000, // 10 second timeout
    headers: {
        'Content-Type': 'application/json',
    },
});

// Request interceptor to add auth token
api.interceptors.request.use(
    (config) => {
        const token = localStorage.getItem('token');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Response interceptor for error handling
api.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response) {
            // Server responded with error status
            const message = error.response.data?.detail || 'An error occurred';
            error.message = message;
        } else if (error.request) {
            // Request was made but no response received
            error.message = 'Unable to connect to server. Please check your connection.';
        }
        return Promise.reject(error);
    }
);

export const login = async (email, password) => {
    // FastAPI expects form-data for OAuth2PasswordRequestForm
    const formData = new URLSearchParams();
    formData.append('username', email);
    formData.append('password', password);

    const response = await api.post('/token', formData, {
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
    });
    return response.data;
};

export const signup = async (email, password, fullName, phoneNumber) => {
    const response = await api.post('/signup', {
        email,
        password,
        full_name: fullName,
        phone_number: phoneNumber || null,
    });
    return response.data;
};

export const getMe = async () => {
    const response = await api.get('/users/me');
    return response.data;
};

export const createOrder = async (amount) => {
    const response = await api.post('/create-order', {
        amount,
        currency: "INR"
    });
    return response.data;
};

export const verifyPayment = async (data) => {
    const response = await api.post('/verify-payment', data);
    return response.data;
};

export const submitConsultation = async (data) => {
    const response = await api.post('/consultation', data);
    return response.data;
};

export const generateReport = async (data) => {
    const response = await api.post('/generate-report', data, {
        responseType: 'blob' // Important for PDF
    });
    return response.data;
};

export default api;
