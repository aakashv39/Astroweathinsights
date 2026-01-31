import razorpay
from fastapi import HTTPException, status
import os
from dotenv import load_dotenv

load_dotenv()

# Replace with your actual credentials or use env vars
RAZORPAY_KEY_ID = os.getenv("RAZORPAY_KEY_ID")
RAZORPAY_KEY_SECRET = os.getenv("RAZORPAY_KEY_SECRET")

client = razorpay.Client(auth=(RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET))

def create_order(amount: float, currency: str = "INR"):
    data = {
        "amount": int(amount * 100),  # Razorpay expects amount in paise
        "currency": currency,
        "payment_capture": 1
    }
    try:
        order = client.order.create(data=data)
        return order
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

def verify_payment_signature(order_id: str, payment_id: str, signature: str):
    try:
        client.utility.verify_payment_signature({
            'razorpay_order_id': order_id,
            'razorpay_payment_id': payment_id,
            'razorpay_signature': signature
        })
        return True
    except razorpay.errors.SignatureVerificationError:
        return False
