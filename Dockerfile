# Use the official Node.js 20 image as a parent image
FROM node:20

# Set the working directory in the container
WORKDIR /slidev

# Copy package.json and package-lock.json (if available) to the working directory
COPY package*.json ./

# Install dependencies, including Slidev and Playwright
RUN npm install && npm install -g @slidev/cli

# Copy the rest of your application's source code
# COPY . .

# Set environment variable to ensure compatibility with development tools
ENV CHOKIDAR_USEPOLLING=true

# Expose the port Slidev runs on
EXPOSE 3030

# Copy the entrypoint script into the container and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set custom mirrors if provided as build arguments
ARG DEB_MIRROR=""
ARG NPM_MIRROR=""
RUN if [ -f /etc/apt/sources.list ] && [ "$DEB_MIRROR" != "" ]; then \
        sed -i 's/deb.debian.org/'"${DEB_MIRROR}"'/g' /etc/apt/sources.list; \
    fi && \
    if [ "$NPM_MIRROR" != "" ]; then \
        npm config set registry "${NPM_MIRROR}"; \
    fi


# Use the custom entrypoint script to initialize the application
ENTRYPOINT ["/entrypoint.sh"]
