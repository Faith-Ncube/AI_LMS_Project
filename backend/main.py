from fastapi import FastAPI
from pydantic import BaseModel
import openai
import os
from dotenv import load_dotenv

load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")

app = FastAPI()

class FeedbackRequest(BaseModel):
    score: float
    topic: str

class FeedbackRequest(BaseModel):
    score: float

@app.post("/ai/feedback")
def ai_feedback(data: FeedbackRequest):
    score = data.score

    if score >= 0.8:
        message = "Excellent performance. You are ready for advanced content."
    elif score >= 0.5:
        message = "Good progress. AI suggests reviewing weak areas."
    else:
        message = "AI recommends revisiting fundamentals."

    return {
        "feedback": message,
        "predicted_next_score": round(score + 0.05, 2)
    }

