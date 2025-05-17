# Use Node.js 16 slim image as the base image
FROM node:16-slim

# Create a non-root user
RUN groupadd -r nodejs && useradd -r -g nodejs nodejs

# Create app directory and set permissions
WORKDIR /usr/src/app
RUN chown -R nodejs:nodejs /usr/src/app

# Copy package files
COPY --chown=nodejs:nodejs package*.json ./

# Install dependencies
RUN npm ci --only=production && \
    npm cache clean --force

# Copy the rest of the application code
COPY --chown=nodejs:nodejs . .

# Switch to non-root user
USER nodejs

# Expose the port your app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"] 