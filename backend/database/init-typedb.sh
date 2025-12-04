#!/bin/bash

# Enable job control
set -m

# Function to log messages with timestamp
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log "Locating TypeDB binaries..."

# Find the server binary
# We look for a directory that looks like the server distribution (typedb-server-linux)
# This handles both Intel and ARM distributions which might have slightly different naming conventions
SERVER_DIR=$(find /opt -maxdepth 1 -type d -name "typedb-server-linux*" | head -n 1)

if [ -n "$SERVER_DIR" ]; then
    TYPEDB_SERVER_BIN="$SERVER_DIR/typedb"
else
    # Fallback: try to find 'typedb' not in a console directory
    TYPEDB_SERVER_BIN=$(find /opt -type f -name "typedb" -not -path "*console*" 2>/dev/null | head -n 1)
fi

# Find the console binary (specifically in console paths)
TYPEDB_CONSOLE_BIN=$(find /opt -type f -name "typedb" -path "*console*" 2>/dev/null | head -n 1)

log "Found Server Binary Candidate: $TYPEDB_SERVER_BIN"
log "Found Console Binary Candidate: $TYPEDB_CONSOLE_BIN"

if [ -z "$TYPEDB_SERVER_BIN" ] || [ ! -f "$TYPEDB_SERVER_BIN" ]; then
    log "Error: Could not find TypeDB server binary."
    # List /opt to help debugging if it fails again
    log "Listing /opt contents:"
    ls -R /opt
    exit 1
fi

if [ -z "$TYPEDB_CONSOLE_BIN" ]; then
    log "Error: Could not find TypeDB console binary."
    exit 1
fi

log "Starting TypeDB Server..."
"$TYPEDB_SERVER_BIN" server &
SERVER_PID=$!

log "Waiting for TypeDB to be ready on port 1729..."
# Wait for the server to start listening
RETRIES=0
MAX_RETRIES=60
while ! nc -z localhost 1729; do
    sleep 1
    RETRIES=$((RETRIES+1))
    if [ $RETRIES -ge $MAX_RETRIES ]; then
        log "Error: TypeDB Server did not start within $MAX_RETRIES seconds."
        exit 1
    fi
    log "Waiting for TypeDB... ($((MAX_RETRIES-RETRIES)))s"
done
log "TypeDB Server is up and running."

# Give it a moment to fully initialize internal components
sleep 2

ADMIN_USER="admin"

# Step 2: Check if user 'admin' can log into the database with the password from .env.
if [ -z "$ADMIN_PASSWORD" ]; then
    log "Skipping initialization: ADMIN_PASSWORD environment variable is not set or empty."
    wait $SERVER_PID
    exit 0
fi

log "Step 2: Checking if user '$ADMIN_USER' can log into the database with the provided password..."

# Attempt to list users to check authentication
if echo "user list" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled > /dev/null 2>&1; then
    log "Success: User '$ADMIN_USER' can log in with the provided password."
    log "Skipping initialization steps (3-6)."
    wait $SERVER_PID
    exit 0
fi

log "Info: User '$ADMIN_USER' cannot log in with the provided password. Proceeding with initialization."

# Step 3: Change default admin password
log "Step 3: Changing default admin password..."
# Try with default password 'password'
if ! echo "user update-password $ADMIN_USER $ADMIN_PASSWORD" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "password" --tls-disabled; then
    log "Error: Failed to update admin password. Default password might not be 'password' or server is unreachable."
    exit 1
fi
log "Success: Admin password updated."

# Step 4: Create database
if [ -z "$DATABASE_NAME" ]; then
    log "Skipping Step 4 (Create Database) and subsequent steps: DATABASE_NAME is not set."
    wait $SERVER_PID
    exit 0
fi

log "Step 4: Creating database '$DATABASE_NAME'..."
if ! echo "database create $DATABASE_NAME" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled; then
    log "Error: Failed to create database '$DATABASE_NAME'."
    exit 1
fi
log "Success: Database '$DATABASE_NAME' created."

# Step 5: Install schema
if [ -z "$SCHEMA_NAME" ]; then
    log "Skipping Step 5 (Install Schema) and subsequent steps: SCHEMA_NAME is not set."
    wait $SERVER_PID
    exit 0
fi

SCHEMA_FILE="/schema/${SCHEMA_NAME}"
log "Step 5: Installing schema from $SCHEMA_FILE..."
if [ ! -f "$SCHEMA_FILE" ]; then
    log "Error: Schema file '$SCHEMA_FILE' not found."
    exit 1
fi

# Read schema file content, strip empty lines (including tabs/CR), and pipe it into the transaction
SCHEMA_CONTENT=$(sed '/^[ \t\r]*$/d' "$SCHEMA_FILE")
if ! echo -e "transaction schema $DATABASE_NAME\n$SCHEMA_CONTENT\n\n\ncommit" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled; then
    log "Error: Failed to install schema."
    exit 1
fi
log "Success: Schema installed."

# Step 6: Install seed data
if [ -z "$SEED_NAME" ]; then
    log "Skipping Step 6 (Install Seed Data): SEED_NAME is not set."
    wait $SERVER_PID
    exit 0
fi

SEED_FILE="/schema/${SEED_NAME}"
log "Step 6: Installing seed data from $SEED_FILE..."
if [ ! -f "$SEED_FILE" ]; then
    log "Error: Seed file '$SEED_FILE' not found."
    exit 1
fi

# Read seed file content, strip empty lines (including tabs/CR), and pipe it into the transaction
SEED_CONTENT=$(sed '/^[ \t\r]*$/d' "$SEED_FILE")
if ! echo -e "transaction write $DATABASE_NAME\n$SEED_CONTENT\n\n\ncommit" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled; then
    log "Error: Failed to install seed data."
    exit 1
fi
log "Success: Seed data installed."

log "Initialization script finished. Keeping TypeDB Server running..."
# Wait for the server process to exit (which it shouldn't unless stopped)
wait $SERVER_PID