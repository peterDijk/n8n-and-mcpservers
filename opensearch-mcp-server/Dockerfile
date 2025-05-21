FROM python:3.10-slim

WORKDIR /app

# Create and activate a virtual environment
RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install uv inside the virtual environment
RUN pip install uv

# Copy project files
COPY pyproject.toml LICENSE README.md ./
COPY src/ ./src/

# Install dependencies using uv inside the virtual environment
RUN uv pip install --no-cache-dir -e .

# Set default environment variables (can be overridden at runtime)
ENV PYTHONUNBUFFERED=1

# The default transport is stdio
ENV TRANSPORT="sse"

# Expose port for SSE transport (only used if TRANSPORT=sse)
EXPOSE 9900

# Run the server with the specified transport
CMD ["sh", "-c", "python -m mcp_server_opensearch --transport ${TRANSPORT}"]
