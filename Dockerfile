# Stage 1 - Build
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

# Install packages
RUN npm install

# 1. Update the database BEFORE building the application
RUN npx update-browserslist-db@latest

COPY . .

# Set memory limits inside the container to prevent OOM / SIGTERM crashes
ENV NODE_OPTIONS="--max-old-space-size=1024"
RUN npm run build

# Stage 2 - Run (Production optimized)
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Create a system user for security (best practice)
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# 2. Leverage Next.js Standalone feature outputs to reduce image size drastically
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# 3. Next.js standalone produces a minimal server.js file instead of needing npm start
CMD ["node", "server.js"]
