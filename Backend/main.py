from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.responses import JSONResponse
from datetime import timedelta
from fastapi.middleware.cors import CORSMiddleware
import traceback
import os

import schemas, auth, payment, database

app = FastAPI()

# CORS Origins - Allow specific origins for security
origins = [
    "https://astrotalkinsight.vercel.app",
    "https://astrotalkinsight.com",
    "http://astrotalkinsight.com",
    "https://www.astrotalkinsight.com",
    "http://www.astrotalkinsight.com",
    # Local development
    "http://localhost:5173",
    "http://localhost:5174",
    "http://localhost:5175",
    "http://127.0.0.1:5173",
    "http://127.0.0.1:5174",
    "http://127.0.0.1:5175",
]

# Enable CORS for frontend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,  # Allow credentials for JWT tokens
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global exception handler to ensure CORS headers are always sent
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    print(f"Error: {exc}")
    print(traceback.format_exc())
    return JSONResponse(
        status_code=500,
        content={"detail": str(exc)},
    )

# Health check endpoint
@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Auth Routes
@app.post("/signup", response_model=schemas.User)
async def signup(user: schemas.UserCreate):
    try:
        # Check if user already exists
        db_user = await database.user_collection.find_one({"email": user.email})
        if db_user:
            raise HTTPException(status_code=400, detail="Email already registered")
        
        # Validate password length (bcrypt has 72-byte limit)
        if len(user.password) > 72:
            raise HTTPException(status_code=400, detail="Password too long. Maximum 72 characters allowed.")
        
        if len(user.password) < 6:
            raise HTTPException(status_code=400, detail="Password too short. Minimum 6 characters required.")
        
        hashed_password = auth.get_password_hash(user.password)
        user_dict = user.model_dump()  # Pydantic v2
        user_dict["hashed_password"] = hashed_password
        del user_dict["password"]
        user_dict["is_active"] = True

        new_user = await database.user_collection.insert_one(user_dict)
        created_user = await database.user_collection.find_one({"_id": new_user.inserted_id})
        return created_user
    except HTTPException:
        raise
    except Exception as e:
        print(f"Signup error: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@app.post("/token", response_model=schemas.Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    try:
        user = await database.user_collection.find_one({"email": form_data.username})
        if not user or not auth.verify_password(form_data.password, user["hashed_password"]):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect username or password",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        access_token_expires = timedelta(minutes=auth.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = auth.create_access_token(
            data={"sub": user["email"]}, expires_delta=access_token_expires
        )
        return {"access_token": access_token, "token_type": "bearer"}
    except HTTPException:
        raise
    except Exception as e:
        print(f"Login error: {e}")
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

# Payment Routes
@app.post("/create-order")
async def create_payment_order(order: schemas.OrderCreate, current_user: schemas.User = Depends(auth.get_current_user)):
    try:
        razorpay_order = payment.create_order(order.amount, order.currency)
        
        # Save transaction to DB
        new_txn = {
            "order_id": razorpay_order['id'],
            "amount": order.amount,
            "currency": order.currency,
            "status": "created",
            "user_id": current_user.id,
            "user_email": current_user.email
        }
        await database.transaction_collection.insert_one(new_txn)
        
        return razorpay_order
    except HTTPException:
        raise
    except Exception as e:
        print(f"Create order error: {e}")
        raise HTTPException(status_code=500, detail=f"Payment error: {str(e)}")

@app.post("/verify-payment")
async def verify_payment(data: schemas.PaymentVerify):
    try:
        is_valid = payment.verify_payment_signature(data.razorpay_order_id, data.razorpay_payment_id, data.razorpay_signature)
        
        if not is_valid:
            raise HTTPException(status_code=400, detail="Invalid payment signature")
        
        # Update transaction status
        await database.transaction_collection.update_one(
            {"order_id": data.razorpay_order_id},
            {"$set": {"payment_id": data.razorpay_payment_id, "status": "paid"}}
        )
        
        return {"status": "success", "message": "Payment verified successfully"}
    except HTTPException:
        raise
    except Exception as e:
        print(f"Verify payment error: {e}")
        raise HTTPException(status_code=500, detail=f"Verification error: {str(e)}")

@app.get("/users/me", response_model=schemas.User)
async def read_users_me(current_user: schemas.User = Depends(auth.get_current_user)):
    return current_user

@app.post("/consultation")
async def request_consultation(data: schemas.ConsultationCreate, current_user: schemas.User = Depends(auth.get_current_user)):
    try:
        from datetime import datetime
        consultation_dict = data.model_dump()
        consultation_dict["user_id"] = str(current_user.id)
        consultation_dict["created_at"] = datetime.utcnow().isoformat()
        
        result = await database.consultation_collection.insert_one(consultation_dict)
        return {"status": "success", "id": str(result.inserted_id)}
    except Exception as e:
        print(f"Consultation request error: {e}")
        raise HTTPException(status_code=500, detail="Failed to save consultation request")

from fastapi.responses import FileResponse
from core.report.report_service import run_report_pipeline

@app.post("/generate-report")
async def generate_report(data: schemas.ReportRequest, current_user: schemas.User = Depends(auth.get_current_user)):
    try:
        # Generate the report
        pdf_path = run_report_pipeline(
            birth_date=data.birth_date,
            birth_time=data.birth_time,
            lat=data.lat,
            lon=data.lon,
            timezone=data.timezone,
            target_year=data.target_year,
            client_name=data.client_name
        )
        
        if not os.path.exists(pdf_path):
            raise HTTPException(status_code=500, detail="Failed to generate report file")
            
        return FileResponse(
            path=pdf_path,
            filename=os.path.basename(pdf_path),
            media_type='application/pdf'
        )
    except Exception as e:
        print(f"Report generation error: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Internal server error during report generation: {str(e)}")

@app.get("/")
async def root():
    return {"message": "AstroTech API is running"}

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
