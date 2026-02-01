# Vercel Deployment Configuration

## Environment Variables on Vercel

Your frontend is deployed on Vercel at: **https://astrotalkinsight.vercel.app/**

### Required Environment Variables

To ensure your Vercel deployment connects to the backend, you need to set the following environment variables in your Vercel project settings:

1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Select your project: `astrotalkinsight`
3. Go to **Settings** → **Environment Variables**
4. Add the following variables:

| Variable Name | Value | Environment |
|--------------|-------|-------------|
| `VITE_API_URL` | `https://astrotalkinsight.onrender.com` | Production, Preview, Development |
| `VITE_RAZORPAY_KEY_ID` | `rzp_test_SAOJ9udbL5iqeF` | Production, Preview, Development |

### How to Add Environment Variables on Vercel

1. **Via Dashboard:**
   - Navigate to your project settings
   - Click on "Environment Variables"
   - Add each variable with its value
   - Select which environments (Production/Preview/Development) should use this variable
   - Click "Save"

2. **Via Vercel CLI:**
   ```bash
   vercel env add VITE_API_URL production
   # Then enter: https://astrotalkinsight.onrender.com
   
   vercel env add VITE_RAZORPAY_KEY_ID production
   # Then enter: rzp_test_SAOJ9udbL5iqeF
   ```

### Redeploy After Adding Variables

After adding environment variables, you need to trigger a new deployment:

1. **Option 1: Redeploy via Dashboard**
   - Go to Deployments tab
   - Click the ⋯ menu on the latest deployment
   - Select "Redeploy"

2. **Option 2: Push a new commit**
   ```bash
   git commit --allow-empty -m "Trigger Vercel redeploy"
   git push
   ```

3. **Option 3: Via Vercel CLI**
   ```bash
   vercel --prod
   ```

## Custom Domain Setup

Your custom domain: **astrotalkinsight.com**

### Steps to Configure Custom Domain on Vercel:

1. Go to your Vercel project → **Settings** → **Domains**
2. Add your domain: `astrotalkinsight.com`
3. Add www subdomain: `www.astrotalkinsight.com`
4. Vercel will provide DNS records to add to your domain registrar:

   **For apex domain (astrotalkinsight.com):**
   ```
   Type: A
   Name: @
   Value: 76.76.21.21
   ```

   **For www subdomain:**
   ```
   Type: CNAME
   Name: www
   Value: cname.vercel-dns.com
   ```

5. Add these records to your domain registrar (GoDaddy, Namecheap, etc.)
6. Wait for DNS propagation (can take 24-48 hours, but usually faster)

### Verify DNS Configuration

Once configured, you can verify using:
```bash
# Check A record
nslookup astrotalkinsight.com

# Check CNAME
nslookup www.astrotalkinsight.com
```

## CORS Configuration

The backend has been updated to allow requests from:
- ✅ `https://astrotalkinsight.vercel.app` (Vercel URL)
- ✅ `https://astrotalkinsight.com` (Custom domain)
- ✅ `https://www.astrotalkinsight.com` (WWW subdomain)
- ✅ `http://localhost:5173` (Local development)

## Testing Your Deployment

### Test the Vercel Deployment:
1. Visit: https://astrotalkinsight.vercel.app/
2. Try signing up / logging in
3. Submit the consultation form
4. Generate a report

### Check if Environment Variables are Loaded:
1. Open browser console (F12)
2. Type: `import.meta.env.VITE_API_URL`
3. Should show: `https://astrotalkinsight.onrender.com`

If it shows `undefined`, the environment variables aren't configured on Vercel.

## Troubleshooting

### "Unable to connect to server" Error
**Cause**: Environment variables not set on Vercel  
**Solution**: Add `VITE_API_URL` to Vercel environment variables and redeploy

### CORS Errors
**Cause**: Backend hasn't been redeployed with new CORS settings  
**Solution**: Wait for Render to finish deploying (check Render dashboard)

### Custom Domain Not Working
**Cause**: DNS not propagated yet  
**Solution**: Wait 24-48 hours or check DNS configuration

### API Calls Work Locally But Not on Vercel
**Cause**: Different environment variables  
**Solution**: Ensure Vercel has the same `.env` values as your local setup

## Build Settings (Already Configured)

For reference, your Vercel build settings should be:

```
Build Command: npm run build
Output Directory: dist
Install Command: npm install
Development Command: npm run dev
```

## Next Steps

1. ✅ Set environment variables on Vercel
2. ✅ Redeploy the frontend
3. ⏳ Wait for Render backend deployment (~2-5 min)
4. 🧪 Test the live application
5. 🌐 Configure custom domain (optional but recommended)
