# Use aws public image
FROM public.ecr.aws/docker/library/node:slim
# Copy application code.
COPY . /app/
# Change the working directory
WORKDIR /app
# Install dependencies.
RUN npm install
# Start the Express app test
CMD ["node", "server.js"]
