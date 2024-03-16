# Этап сборки
FROM node:21.7.1 as builder

WORKDIR /app

COPY package*.json ./

RUN npm install --production

# COPY ./src .

FROM node:21.7.1-slim

WORKDIR /app

COPY --from=builder /app .

RUN chown -R node:node /app && \
    chmod -R 755 /app && \
    useradd -m appuser && \
    chown -R appuser:appuser /app

USER appuser

CMD ["npm", "run", "prod"]
