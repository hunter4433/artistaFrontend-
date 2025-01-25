# Use an official Flutter image as a base
FROM cirrusci/flutter:3.24.4

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Get dependencies
RUN flutter pub get

# Build the app (choose appropriate build command)
RUN flutter build apk
# Or for web: RUN flutter build web
# Or for iOS: RUN flutter build ios

# Expose port if needed (adjust based on your app)
EXPOSE 8080

# Command to run the app
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080"]