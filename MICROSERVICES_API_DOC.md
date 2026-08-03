# Microservices API & URL Documentation

## Deployed Service URLs (example, replace with actual Railway URLs after deployment)

- Backend: https://your-backend-service.up.railway.app
- AIBotRAG: https://your-aibotrag-service.up.railway.app
- Astrotechengine: https://your-astrotechengine-service.up.railway.app
- tajik_varshphal: https://your-tajikvarshphal-service.up.railway.app
- Frontend: https://your-frontend-service.vercel.app

## Standard Endpoints

### Backend
- POST /chat
- POST /signup
- POST /token
- POST /create-order
- POST /verify-payment
- GET /users/me
- POST /consultation
- POST /generate-report
- GET /health

### AIBotRAG
- (Example) POST /rag-query
- GET /health

### Astrotechengine
- (Example) GET /astro, /nakshatra, /tithi, etc.
- GET /health

### tajik_varshphal
- (Example) POST /varshphal
- GET /health

## Inter-Service Communication
- All services communicate via REST endpoints using the above URLs.
- Service URLs should be stored in environment variables for flexibility.

## Gradio UI
- Gradio app remains available for internal testing at its own endpoint (e.g., /gradio or a separate port).
- React frontend will consume APIs from all FastAPI services.

## Notes
- Update this file with actual deployed URLs after Railway deployment.
- Add new endpoints as services evolve.
