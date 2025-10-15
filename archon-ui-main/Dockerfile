# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Set API URL for production build
ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

# Install apache2-utils for htpasswd
RUN apk add --no-cache apache2-utils

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Create htpasswd file with default credentials (will be overridden by env vars)
RUN htpasswd -bc /etc/nginx/.htpasswd user pass

# Create startup script
COPY <<'EOF' /start.sh
#!/bin/sh
set -e

PORT=${PORT:-80}

# Update htpasswd if credentials provided
if [ -n "$AUTH_USER" ] && [ -n "$AUTH_PASSWORD" ]; then
  htpasswd -bc /etc/nginx/.htpasswd "$AUTH_USER" "$AUTH_PASSWORD"
fi

# Generate nginx config with API proxy
cat > /etc/nginx/conf.d/default.conf <<NGINX
server {
    listen ${PORT};

    # Frontend with Basic Auth
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files \$uri \$uri/ /index.html;
        auth_basic "Restricted Access";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }

    # API Proxy to Backend (no auth required for API)
    location /api/ {
        proxy_pass https://archon-production-877b.up.railway.app/api/;
        proxy_set_header Host archon-production-877b.up.railway.app;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_ssl_server_name on;
    }
}
NGINX

exec nginx -g "daemon off;"
EOF

RUN chmod +x /start.sh

# Expose port
EXPOSE 80

CMD ["/start.sh"]
