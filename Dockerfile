# Stage 1: Build the Flutter web app
FROM ghcr.io/cirruslabs/flutter:3.22.0 AS build

WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

# Configure Nginx to listen on the PORT env var provided by Railway
RUN echo 'server { listen ${PORT}; location / { root /usr/share/nginx/html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/templates/default.conf.template

EXPOSE 8080
