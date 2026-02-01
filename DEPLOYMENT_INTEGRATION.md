# Frontend-Backend Integration - Deployment Setup

## Changes Made

### 1. Frontend Configuration (`.env`)
Added the deployed backend URL to the frontend environment configuration:

```bash
VITE_API_URL=https://astrotalkinsight.onrender.com
VITE_RAZORPAY_KEY_ID=rzp_test_SAOJ9udbL5iqeF
```

### 2. Backend CORS Configuration (`Backend/main.py`)
Updated the CORS middleware to allow requests from any origin:

```python
# CORS Origins - Allow all origins for deployment
origins = ["*"]

# Enable CORS for frontend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=False,  # Must be False when using allow_origins=["*"]
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Note**: When using `allow_origins=["*"]`, `allow_credentials` must be set to `False`. This is acceptable because:
- JWT tokens are sent via the `Authorization` header (not cookies)
- The backend validates tokens on each request
- This doesn't compromise security for token-based authentication

## Testing the Integration

### Local Testing
1. Start the frontend development server:
   ```bash
   cd Frontend
   npm run dev
   ```

2. The frontend will now connect to the deployed backend at `https://astrotalkinsight.onrender.com`

3. Test the following flows:
   - **Sign Up**: Create a new account
   - **Login**: Sign in with credentials
   - **Consultation Form**: Submit consultation details
   - **Report Generation**: Generate and download the astrology report PDF

### What Happens Now
- The frontend (running on `http://localhost:5173`) makes API calls to `https://astrotalkinsight.onrender.com`
- The backend accepts these requests because CORS is configured to allow all origins
- Authentication works via JWT tokens stored in `localStorage` and sent via the `Authorization` header

## Deployment Checklist

### Backend (Already Deployed on Render)
- ✅ Updated CORS configuration
- ✅ Committed and pushed changes to GitHub
- ⏳ Render will automatically redeploy with the new CORS settings

### Frontend (To Deploy)
When deploying the frontend (e.g., on Vercel, Netlify, or Render):
1. Make sure the `.env` file is configured with:
   ```bash
   VITE_API_URL=https://astrotalkinsight.onrender.com
   ```
2. The build process will automatically use this environment variable
3. No additional CORS configuration needed on the frontend

## API Endpoints Available
- `POST /signup` - User registration
- `POST /token` - User login (returns JWT)
- `GET /users/me` - Get current user info
- `POST /consultation` - Submit consultation form
- `POST /generate-report` - Generate astrology report PDF
- `POST /create-order` - Create Razorpay payment order
- `POST /verify-payment` - Verify payment signature

## Environment Variables Summary

### Frontend `.env`
```bash
VITE_API_URL=https://astrotalkinsight.onrender.com
VITE_RAZORPAY_KEY_ID=rzp_test_SAOJ9udbL5iqeF
```

### Backend `.env` (on Render)
```bash
MONGODB_URL=your_mongodb_connection_string
SECRET_KEY=your_secret_key
RAZORPAY_KEY_ID=your_razorpay_key_id
RAZORPAY_KEY_SECRET=your_razorpay_secret
PORT=8000
```

## Troubleshooting

### CORS Errors
If you see CORS errors in the browser console:
1. Ensure the backend has been redeployed with the updated CORS configuration
2. Check that Render has finished deploying the latest commit
3. Clear browser cache and try again

### API Connection Errors
If API calls fail:
1. Verify the backend is running: Visit `https://astrotalkinsight.onrender.com/health`
2. Check the browser Network tab for the actual error response
3. Ensure the `.env` file is being loaded (check `console.log(import.meta.env.VITE_API_URL)` in your code)

### Authentication Issues
If login/signup doesn't work:
1. Check the browser console for any errors
2. Verify the JWT token is being stored in `localStorage`
3. Check that the `Authorization` header is being sent with requests (visible in Network tab)

## Next Steps
1. Wait for Render to finish deploying the updated backend (~2-5 minutes)
2. Test the local frontend with the deployed backend
3. Deploy the frontend to your preferred hosting platform
4. Update the Razorpay payment integration with production keys when ready
