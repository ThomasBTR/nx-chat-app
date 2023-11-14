# To build the image, run the following command:
# docker build -t frontend-chatapp .
#
# Then to run the image, set port to 4200 and with this command :
# docker run -p 4200:4200 --name frontend frontend-chatapp
#
# You will need to run the backend docker image as well to be able to run the app correctly.


# Use a specific version of the official Node.js image based on the slim variant
FROM node:18.18.2-bullseye-slim AS build

# Set the working directory
WORKDIR /usr/src/root

# Copy required files for installing dependencies
COPY package.json package-lock.json nx.json tsconfig.base.json ./
COPY frontend/chatapp/ ./frontend/chatapp/
# Be sure to include all the necessary components your project targets, such as e2e tests. Otherwise, the Docker image build may fail.
COPY frontend/chatapp-e2e/ ./frontend/chatapp-e2e/

# Install npm dependencies
RUN npm ci

# Install nx globally
RUN npm install -g nx

# Set NX_DAEMON environment variable to false to prevent nx from running in daemon mode
ENV NX_DAEMON=false

# Build the application
RUN nx run frontend--chatapp:build

# Create a new stage for the runtime image
FROM node:18.18.2-bullseye-slim AS runtime

# Set the working directory
WORKDIR /usr/src/root

# Copy build artifacts from the build stage
COPY --from=build /usr/src/root/dist/frontend/chatapp /usr/src/root/dist/frontend/chatapp

# Expose ports
EXPOSE 4200

# Install serve globally
RUN npm install -g serve

# Start the application using serve
CMD ["serve", "-s", "dist/frontend/chatapp", "--listen", "tcp://0.0.0.0:4200"]
