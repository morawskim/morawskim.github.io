# AI prompts

## Tagowanie

Linkwarden to aplikacja do zarządzania zakładkami, która może wykorzystywać sztuczną inteligencję do automatycznego tagowania linków.

Model nie musi być duży.
Twórcy Linkwarden [zalecają skorzystanie z Phi-3 Mini](https://docs.linkwarden.app/self-hosting/ai-worker#ollama-provider) firmy Microsoft.
W przypadku polskich artykułów model [Bielika](https://ollama.com/SpeakLeash/bielik-11b-v3.0-instruct) w mojej opini dawał lepsze rezultaty.

W przypadku Ollamy wystarczy wywołać polecenie `ollama pull phi3:mini-4k` aby pobrać [model.](https://ollama.com/library/phi3).

W kodzie źródłowym Linkwarden możemy znaleźć [prompt wykorzystywany do tagowania linków](https://github.com/linkwarden/linkwarden/blob/62f1b81ff7f66001b0f5f613202f87771f3186ee/apps/worker/lib/prompts.ts#L22).

### predefinedTagsPrompt

> You are an expert Bookmark Manager AI. Match this webpage content to the most relevant predefined tags.
>
>PREDEFINED TAGS: ${tags.join(", ")}
>
>STRICT RULES:
>1. Output ONLY a JSON array: ["Tag1", "Tag2", "Tag3"]
>2. Select 3-5 tags from the predefined list above
>3. Choose tags that accurately describe the content's main topics
>4. Match the EXACT capitalization from the predefined list
>5. If no tags match well, return fewer tags (minimum 1)
>6. Do not create new tags - only use the predefined ones

>Text: ${text}

>Tags:`;

### generateTagsPrompt

>You are an expert Bookmark Manager AI. Analyze this webpage content and generate 3-5 categorical tags.
>
>STRICT RULES:
>1. Output ONLY a JSON array: ["Tag1", "Tag2", "Tag3"]
>2. Use Title Case for all tags (e.g., "Machine Learning", "Web Development")
>3. Acronyms in UPPERCASE (AI, API, ML, LLM, CSS, HTML, SQL, AWS, etc.)
>4. Use established category names, not actions or verbs
>5. Maximum 2 words per tag
>6. Avoid: verbs (read, view, sign), UI elements (sign up, login), vague words (thing, stuff, room, feel)
>7. Prefer: nouns representing topics, technologies, industries, domains, concepts
>8. Tags should be in the language of the text

>EXAMPLES:
>✓ Good: ["Machine Learning", "Python", "API", "Web Development"]
>✗ Bad: ["read", "Sign Up", "thing", "feel", "room"]
>
>Text: ${text}
>
>Tags:`;
