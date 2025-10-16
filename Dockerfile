FROM ghcr.io/astral-sh/uv:python3.11-bookworm-slim

WORKDIR /app

# Set cache directory
ENV UV_CACHE_DIR=/tmp/uv-cache

# Create cache directory and ensure full access
RUN mkdir -p /tmp/uv-cache && chmod -R 777 /tmp/uv-cache

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN uv pip install --system -r requirements.txt --no-cache-dir

# Cleanup cache as root (to prevent permission problems later)
RUN rm -rf /tmp/uv-cache && mkdir -p /tmp/uv-cache && chmod -R 777 /tmp/uv-cache

# ✅ Now switch to non-root user
USER 1000

# Copy application code
COPY . .

EXPOSE 7860

CMD ["uv", "run", "main.py"]
