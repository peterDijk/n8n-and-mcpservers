# Use alpine node base image
FROM node:22-alpine
# Set working directory inside the docker node
WORKDIR /app
# Copy package files and install dependencies
COPY package*.json ./
RUN npm install
# Copy the rest of the application code
COPY . .
# Expose the application port
EXPOSE 3002
# Command to run node.js in a docker container
ENTRYPOINT npm run start