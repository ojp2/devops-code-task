# Specify the base image to use
FROM --platform=linux/amd64 node:16

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the dependencies
RUN npm ci --only=production

# Copy the rest of the application files to the container
COPY . .

# Expose the port that the application listens on
EXPOSE 8080

# Start the application
CMD ["npm", "start"]
