from pydantic import BaseModel, EmailStr, Field, BeforeValidator
from typing import Optional, Annotated

# Helper to handle ObjectId
PyObjectId = Annotated[str, BeforeValidator(str)]

# User Schemas
class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    is_active: bool

    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None

# Payment Schemas
class OrderCreate(BaseModel):
    amount: float
    currency: str = "INR"

class PaymentVerify(BaseModel):
    razorpay_order_id: str
    razorpay_payment_id: str
    razorpay_signature: str

# Consultation Schemas
class ConsultationCreate(BaseModel):
    first_name: str
    last_name: str
    birth_month: str
    birth_day: str
    birth_year: str
    birth_hour: str
    birth_minutes: str
    birth_period: str # AM/PM
    gender: str
    current_residence: str
    place_of_birth: str

class Consultation(ConsultationCreate):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    user_id: str
    created_at: str

    class Config:
        populate_by_name = True
        arbitrary_types_allowed = True

class ReportRequest(BaseModel):
    birth_date: str # "YYYY-MM-DD"
    birth_time: str # "HH:MM"
    lat: float
    lon: float
    timezone: str
    target_year: int
    client_name: str
