# TypeDB 3.5.5 Dockerfile with multi-architecture support
FROM typedb/typedb:3.5.5

# Declare TARGETARCH after FROM to make it available in RUN commands
ARG TARGETARCH

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Download and install TypeDB Console 3.5.4 (architecture-aware)
RUN CONSOLE_VERSION="3.5.4" && \
    DETECTED_ARCH="${TARGETARCH:-amd64}" && \
    if [ "$DETECTED_ARCH" = "arm64" ]; then \
        ARCH_SUFFIX="arm64"; \
    else \
        ARCH_SUFFIX="x86_64"; \
    fi && \
    echo "Detected architecture: $DETECTED_ARCH, using suffix: $ARCH_SUFFIX" && \
    curl -L -o /tmp/typedb-console.tar.gz \
    "https://repo.typedb.com/public/public-release/raw/names/typedb-console-linux-${ARCH_SUFFIX}/versions/${CONSOLE_VERSION}/typedb-console-linux-${ARCH_SUFFIX}-${CONSOLE_VERSION}.tar.gz" && \
    tar -xzf /tmp/typedb-console.tar.gz -C /opt/ && \
    rm /tmp/typedb-console.tar.gz && \
    find /opt -name "typedb" -path "*/typedb-console*/typedb" -type f | head -1 | xargs -I {} ln -sf {} /usr/local/bin/typedb-console

# Find and create symlink for typedb server command
RUN find /opt -name "typedb" -type f -executable 2>/dev/null | head -1 | xargs -I {} ln -sf {} /usr/local/bin/typedb

# Copy initialization script
COPY init-typedb.sh /usr/local/bin/init-typedb.sh
RUN chmod +x /usr/local/bin/init-typedb.sh

# Copy schema and seed files
COPY schema/ /schema/

# Expose TypeDB server ports
# Note: These are defaults, but can be overridden at runtime if the server supports it
EXPOSE 1729
EXPOSE 8000

# Data directory is managed by docker-compose volume

# Run the initialization script
CMD ["/usr/local/bin/init-typedb.sh"]