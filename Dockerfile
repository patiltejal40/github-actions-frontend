# Use a smaller base image
FROM node:18.16.0-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Use a new, smaller base image for the final stage
FROM node:18.16.0-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app ./

# Remove unnecessary files to reduce image size
RUN rm -rf /app/test /app/docs /app/.git /app/node_modules/.cache

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
