# Use the official Node.js base image from Docker Hub
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code to the working directory
COPY . .

# Expose port 3000 to the host (replace 3000 if your app runs on a different port)
EXPOSE 3000

# Command to run the application when the container starts
CMD ["npm", "start"]
