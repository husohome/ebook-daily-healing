# settings.py

class Settings:
    # API endpoint for chat completions
    BASE_URL = "https://api.perplexity.ai/chat/completions"
    
    # Default settings for the Perplexity API payload
    model = "llama-3.1-sonar-large-32k-online"
    system_message = "Be precise and concise."
    temperature = 0.2
    top_p = 0.9
    return_citations = True
    search_domain_filter = ["perplexity.ai"]
    return_images = False
    return_related_questions = False
    search_recency_filter = "month"
    top_k = 0
    stream = False
    presence_penalty = 0
    frequency_penalty = 1
    max_tokens = None  # Optional: override the max_tokens if needed. 