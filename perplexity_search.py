import os
import requests
from dotenv import load_dotenv
from settings import Settings

load_dotenv()

def search_perplexity(query: str, 
                      model: str = None,
                      system_message: str = None,
                      temperature: float = None,
                      top_p: float = None,
                      return_citations: bool = None,
                      search_domain_filter: list = None,
                      return_images: bool = None,
                      return_related_questions: bool = None,
                      search_recency_filter: str = None,
                      top_k: int = None,
                      stream: bool = None,
                      presence_penalty: int = None,
                      frequency_penalty: int = None,
                      max_tokens: int = None) -> dict:
    # For each option use the provided argument,
    # or default to the value from Settings if None.
    model = model if model is not None else Settings.model
    system_message = system_message if system_message is not None else Settings.system_message
    temperature = temperature if temperature is not None else Settings.temperature
    top_p = top_p if top_p is not None else Settings.top_p
    return_citations = return_citations if return_citations is not None else Settings.return_citations
    search_domain_filter = search_domain_filter if search_domain_filter is not None else Settings.search_domain_filter
    return_images = return_images if return_images is not None else Settings.return_images
    return_related_questions = return_related_questions if return_related_questions is not None else Settings.return_related_questions
    search_recency_filter = search_recency_filter if search_recency_filter is not None else Settings.search_recency_filter
    top_k = top_k if top_k is not None else Settings.top_k
    stream = stream if stream is not None else Settings.stream
    presence_penalty = presence_penalty if presence_penalty is not None else Settings.presence_penalty
    frequency_penalty = frequency_penalty if frequency_penalty is not None else Settings.frequency_penalty
    max_tokens = max_tokens if max_tokens is not None else Settings.max_tokens

    # Validate query: if empty, return an empty results list
    if not query.strip():
        return {"results": []}

    # Get API key from environment variables
    api_key = os.getenv("PERPLEXITY_API_KEY")
    if not api_key:
        print("Error: No API key found. Please update your .env file with your Perplexity API key.")
        return {}
    
    # Use the BASE_URL from Settings
    base_url = Settings.BASE_URL
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    payload = {
        "model": model,
        "messages": [
            {
                "role": "system",
                "content": system_message
            },
            {
                "role": "user",
                "content": query
            }
        ],
        "temperature": temperature,
        "top_p": top_p,
        "return_citations": return_citations,
        "search_domain_filter": search_domain_filter,
        "return_images": return_images,
        "return_related_questions": return_related_questions,
        "search_recency_filter": search_recency_filter,
        "top_k": top_k,
        "stream": stream,
        "presence_penalty": presence_penalty,
        "frequency_penalty": frequency_penalty
    }
    
    if max_tokens is not None:
        payload["max_tokens"] = max_tokens
    
    try:
        response = requests.post(base_url, headers=headers, json=payload)
        response.raise_for_status()
        data = response.json()

        # Transform the chat completions result to mimic expected "results" structure
        if "choices" in data:
            results_list = []
            for choice in data["choices"]:
                message = choice.get("message", {})
                content = message.get("content", "")
                # Use the first sentence (up to the first period) as title or "N/A" if empty.
                title = content.split('.')[0] if content else "N/A"
                results_list.append({
                    "title": title,
                    "url": "N/A",
                    "snippet": content
                })
            return {"results": results_list}
        return data
    except requests.exceptions.RequestException as err:
        print(f"API request error: {err}")
        return {"results": []}

if __name__ == "__main__":
    query = input("Enter your query: ")
    result = search_perplexity(query)
    print(result)