

# 🚀 LLM-Powered GitHub App Generator & Updater

This project is a FastAPI-based service that leverages an LLM to generate and revise deployable static web applications from user prompts. It creates GitHub repositories, pushes generated files, enables GitHub Pages, and supports multi-round task workflows — all via API.



## 📦 Features

* 🔐 Secure endpoint with secret-based validation
* 🧠 Uses GPT-4o-mini via AIPipe to generate HTML & README from briefs
* 🛠️ Automatically creates public GitHub repositories
* 🪄 Supports round-based code updates using user feedback
* 🌐 Enables GitHub Pages for live previews
* 📤 Posts results to an evaluation server
* 📂 Handles attachments and decodes binary data for LLM context

---

## 🖥️ API Overview

### `POST /handle_task`

Triggers creation or update of a GitHub-hosted static web app.

#### Request Body (JSON)

```json
{
  "secret": "your-shared-secret",
  "email": "user@example.com",
  "task": "unique-task-name",
  "brief": "Short description of what the app should do",
  "round": 1,
  "nonce": "unique-id-per-submission",
  "evaluation_url": "https://your-evaluation-server.com/submit",
  "checks": ["App must be responsive", "Should include a contact form"],
  "attachments": [
    {
      "name": "data.csv",
      "url": "data:text/csv;base64,..."
    }
  ]
}
```

#### Response

```json
{
  "task": "unique-task-name",
  "round": 1,
  "status": "processing"
}
```

> 💡 The app runs asynchronously in the background. Results are POSTed to the provided `evaluation_url`.

---

## 📁 Generated Files

The LLM produces two required files:

* `index.html`: A complete, inlined static webpage
* `README.md`: Documentation with Overview, Features, Setup, Usage, and License

These files are committed to a new or existing GitHub repository and deployed to GitHub Pages.

---

## 🔄 Update Mode (Round 2+)

If a repo already exists and contains the required files, the app enters **update mode**:

* Existing `index.html` and `README.md` are fetched with SHA
* LLM receives old files + new prompt + new attachments
* Updated files are pushed back to GitHub

---

## 🔧 Environment Setup

### 🔑 Required Environment Variables

| Variable          | Description                                         |
| ----------------- | --------------------------------------------------- |
| `GITHUB_TOKEN`    | GitHub personal access token (with `repo` scope)    |
| `GITHUB_USERNAME` | Your GitHub username                                |
| `AIPIPE_API_KEY`  | API key for AIPipe GPT-4o-mini                      |
| `SECRET`          | Shared secret used for validating incoming requests |

Use a `.env` file to set these:

```env
GITHUB_TOKEN=ghp_...
GITHUB_USERNAME=your-username
AIPIPE_API_KEY=api_...
SECRET=your-secret
```

---

## 🐳 Deployment (Docker)

Use the following `Dockerfile` for Hugging Face or containerized deployment:

```Dockerfile
FROM ghcr.io/astral-sh/uv:python3.11-bookworm-slim

WORKDIR /app

# Cache directory with correct permissions
ENV UV_CACHE_DIR=/app/.cache/uv
RUN mkdir -p /app/.cache/uv && chown -R 1000:1000 /app/.cache

COPY requirements.txt .
RUN uv pip install --system -r requirements.txt

USER 1000
COPY . .

EXPOSE 7860
CMD ["uv", "run", "main.py"]
```

---

## ▶️ Local Development

1. Install dependencies:

```bash
uv pip install --system -r requirements.txt
```

2. Run the app:

```bash
uvicorn main:app --host 0.0.0.0 --port 7860
```

---

## 🔐 Security Notes

* Ensure the `SECRET` is kept private
* Validate that your GitHub token has the correct scopes (e.g. `repo`, `workflow` if needed)
* Rate limits on AIPipe or GitHub may affect processing

---

## 📜 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you’d like to change.

---


