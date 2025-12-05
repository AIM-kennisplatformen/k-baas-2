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
FORCE_REINIT="${FORCE_REINIT:-false}"

# Validate required environment variables and report missing ones
MISSING_VARS=""
if [ -z "$ADMIN_PASSWORD" ]; then
    MISSING_VARS="$MISSING_VARS ADMIN_PASSWORD"
fi
if [ -z "$DATABASE_NAME" ]; then
    MISSING_VARS="$MISSING_VARS DATABASE_NAME"
fi
if [ -z "$DATABASE_USER_NAME" ]; then
    MISSING_VARS="$MISSING_VARS DATABASE_USER_NAME"
fi
if [ -z "$DATABASE_USER_PASSWORD" ]; then
    MISSING_VARS="$MISSING_VARS DATABASE_USER_PASSWORD"
fi

if [ -n "$MISSING_VARS" ]; then
    log "ERROR: Required environment variables are not set or empty:$MISSING_VARS"
    log "Please ensure these are set in your .env file:"
    log "  - TYPEDB_ADMIN_PASSWORD (maps to ADMIN_PASSWORD)"
    log "  - TYPEDB_DATABASE_NAME (maps to DATABASE_NAME)"
    log "  - TYPEDB_USER_NAME (maps to DATABASE_USER_NAME)"
    log "  - TYPEDB_USER_PASSWORD (maps to DATABASE_USER_PASSWORD)"
    log "TypeDB server will continue running but database initialization was skipped."
    wait $SERVER_PID
    exit 0
fi

log "Step 2: Checking if user '$ADMIN_USER' can log into the database with the provided password..."

# Attempt to list users to check authentication
ADMIN_AUTH_OK=false
if echo "user list" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled > /dev/null 2>&1; then
    log "Success: User '$ADMIN_USER' can log in with the provided password."
    ADMIN_AUTH_OK=true
fi

if [ "$ADMIN_AUTH_OK" = "false" ]; then
    log "Info: User '$ADMIN_USER' cannot log in with the provided password. Proceeding with password update."

    # Step 3: Change default admin password
    log "Step 3: Changing default admin password..."
    # Try with default password 'password'
    if ! echo "user update-password $ADMIN_USER $ADMIN_PASSWORD" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "password" --tls-disabled; then
        log "Error: Failed to update admin password. Default password might not be 'password' or server is unreachable."
        exit 1
    fi
    log "Success: Admin password updated."
fi

# Step 4: Check if database exists and create if needed
# (DATABASE_NAME is already validated above, but keep this for safety)

# Check if database already exists
DATABASE_EXISTS=false
if echo "database list" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled 2>&1 | grep -q "$DATABASE_NAME"; then
    log "Database '$DATABASE_NAME' already exists."
    DATABASE_EXISTS=true
fi

if [ "$DATABASE_EXISTS" = "true" ] && [ "$FORCE_REINIT" = "true" ]; then
    log "FORCE_REINIT is set. Deleting existing database '$DATABASE_NAME'..."
    if ! echo "database delete $DATABASE_NAME" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled; then
        log "Warning: Failed to delete database '$DATABASE_NAME'. Continuing anyway."
    fi
    DATABASE_EXISTS=false
fi

if [ "$DATABASE_EXISTS" = "false" ]; then
    log "Step 4: Creating database '$DATABASE_NAME'..."
    if ! echo "database create $DATABASE_NAME" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled; then
        log "Error: Failed to create database '$DATABASE_NAME'."
        exit 1
    fi
    log "Success: Database '$DATABASE_NAME' created."
else
    log "Skipping database creation (already exists). Set FORCE_REINIT=true to recreate."
fi

# Step 5: Install schema (only if database was just created or FORCE_REINIT)
if [ -z "$SCHEMA_NAME" ]; then
    log "Skipping Step 5 (Install Schema) and subsequent steps: SCHEMA_NAME is not set."
    wait $SERVER_PID
    exit 0
fi

SCHEMA_FILE="/schema/${SCHEMA_NAME}"
if [ "$DATABASE_EXISTS" = "false" ] || [ "$FORCE_REINIT" = "true" ]; then
    log "Step 5: Installing schema from $SCHEMA_FILE..."
    if [ ! -f "$SCHEMA_FILE" ]; then
        log "Error: Schema file '$SCHEMA_FILE' not found."
        exit 1
    fi

    # Use TypeDB Console's 'source' command to load schema from file
    # This allows TypeDB's parser to handle the file content properly (including blank lines)
    if ! echo -e "transaction schema $DATABASE_NAME\nsource $SCHEMA_FILE\ncommit" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled; then
        log "Error: Failed to install schema."
        exit 1
    fi
    log "Success: Schema installed."
else
    log "Skipping schema installation (database already exists). Set FORCE_REINIT=true to reinstall."
fi

# Step 6: Install seed data (only if database was just created or FORCE_REINIT)
if [ -z "$SEED_NAME" ]; then
    log "Skipping Step 6 (Install Seed Data): SEED_NAME is not set."
    wait $SERVER_PID
    exit 0
fi

SEED_FILE="/schema/${SEED_NAME}"
if [ "$DATABASE_EXISTS" = "false" ] || [ "$FORCE_REINIT" = "true" ]; then
    log "Step 6: Installing seed data from $SEED_FILE..."
    if [ ! -f "$SEED_FILE" ]; then
        log "Error: Seed file '$SEED_FILE' not found."
        exit 1
    fi

    # Use TypeDB Console's 'source' command to load seed data from file
    # This allows TypeDB's parser to handle the file content properly (including blank lines)
    if ! echo -e "transaction write $DATABASE_NAME\nsource $SEED_FILE\ncommit" | "$TYPEDB_CONSOLE_BIN" console --address localhost:1729 --username "$ADMIN_USER" --password "$ADMIN_PASSWORD" --tls-disabled; then
        log "Error: Failed to install seed data."
        exit 1
    fi
    log "Success: Seed data installed."
else
    log "Skipping seed data installation (database already exists). Set FORCE_REINIT=true to reinstall."
fi

log "Initialization script finished. Keeping TypeDB Server running..."
# Wait for the server process to exit (which it shouldn't unless stopped)
wait $SERVER_PID