# S617 Docker demo image - a tiny web server you build yourself
# A Dockerfile is a recipe for building a container IMAGE, step by step.
# Read it top to bottom - each instruction adds a layer.

# 1. Start FROM a tiny base image (Alpine Linux is ~5 MB).
FROM alpine:3.20

# 2. Install what the app needs. --no-cache keeps the image small.
RUN apk add --no-cache python3

# 3. Set the working directory inside the image.
WORKDIR /app

# 4. COPY our web page and entrypoint script in; make the script executable.
COPY index.html /app/index.html
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 5. SECURITY: create a normal user and run as it, not as root.
#    (A container that runs as root is a bigger prize if it's ever breached.)
RUN adduser -D appuser
USER appuser

# 6. Document the port the app listens on.
EXPOSE 8080

# 7. ENTRYPOINT = the program that always runs. CMD = its default arguments.
#    entrypoint.sh does any setup, then runs whatever CMD is passed to it.
#    python's http.server serves index.html at "/" automatically.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["python3", "-m", "http.server", "8080"]
