FROM python:3.8-slim as builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

RUN pip install --no-cache-dir --extra-index-url https://download.pytorch.org/whl/cpu torch

COPY requirements.txt .

RUN grep -v '^torch' requirements.txt > /tmp/requirements.txt && \
    pip install --no-cache-dir -r /tmp/requirements.txt

FROM python:3.8-slim
COPY --from=builder /venv /venv
ENV PATH="/venv/bin:$PATH"
COPY ./app /app
WORKDIR /app

CMD ["python", "main.py"]
