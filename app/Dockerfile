# ==== CONFIGURE ====
# pull official base image
FROM node:18-alpine AS builder
# Set the working directory to /app inside the container
WORKDIR /app

# Copy files from repo to container
COPY . .
# ==== BUILD =====
# Set ENV variables
ENV GENERATE_SOURCEMAP false
# Install dependencies (npm ci makes sure the exact versions in the lockfile gets installed)
RUN npm ci 
# Build the app
RUN npm run build

FROM nginx:1.23.2-alpine AS server
COPY --from=builder ./app/build /usr/share/nginx/html