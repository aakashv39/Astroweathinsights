# core/prediction_formatter.py
"""
Formatter for readable horoscope-style predictions.
Style B: 2–3 paragraphs per topic
"""

topic_titles = {
    "Health": "🩺 Health & Vitality",
    "Money": "💰 Finances & Wealth",
    "Career": "🏢 Career & Professional Life",
    "Marriage": "💞 Marriage & Partnerships",
    "Children": "👶 Children & Family Growth",
    "Travel": "✈️ Travel & Foreign Connections",
    "Overall": "🌟 Overall Annual Theme"
}


def rating_tone(rating):
    tones = {
        "very_positive": "very supportive and promising",
        "positive": "generally favorable and progressive",
        "mixed": "a blend of progress and challenges",
        "negative": "a challenging period requiring caution",
        "very_negative": "a critical period that needs patience and care"
    }
    return tones.get(rating, "neutral")


def format_predictions(rule_output):
    """
    rule_output = list of (topic, rating, explanation)
    returns grouped readable text
    """
    topics = {}
    for topic, rating, explanation in rule_output:
        topics.setdefault(topic, []).append((rating, explanation))

    final = []
    for topic, entries in topics.items():
        if topic not in topic_titles:
            continue

        final.append("\n" + topic_titles[topic])
        final.append("-" * len(topic_titles[topic]))

        for rating, explanation in entries[:3]:  # max 3 per topic
            tone = rating_tone(rating)
            final.append(f"• The planetary pattern appears **{tone}** because {explanation}.")

    return "\n".join(final) if final else "No prediction signals detected."
