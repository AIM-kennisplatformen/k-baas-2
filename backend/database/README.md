# TypeDB Docker Setup

This directory contains the Docker configuration for running TypeDB 3.5.5 with automatic initialization.

## Quick Start

1. **Start the database:**
   ```bash
   docker-compose up -d
   ```

2. **View logs:**
   ```bash
   docker-compose logs -f typedb
   ```

3. **Stop the database:**
   ```bash
   docker-compose down
   ```

## Configuration

Configure TypeDB through environment variables in your `.env` file (copy from `.env.example`):

### Required Configuration
- `TYPEDB_PORT` - TypeDB server port (default: 1729)

### Optional Initialization Variables
These variables are only used on **first startup** to initialize the database:

- `TYPEDB_ADMIN_PASSWORD` - Changes the default admin password
- `TYPEDB_DATABASE_NAME` - Creates a database with this name
- `TYPEDB_USER_NAME` - Creates a user for the database
- `TYPEDB_USER_PASSWORD` - Password for the database user
- `TYPEDB_SCHEMA_FILE` - Schema file to load (default: schema.tql)
- `TYPEDB_SEED_FILE` - Seed data file to load (default: seed.tql)

## Schema and Seed Files

Place your TypeDB schema and seed files in `backend/database/schema/`:

- `schema.tql` - Your TypeDB schema definition
- `seed.tql` - Your initial seed data

These files are copied into the Docker image during build, so you'll need to **rebuild the image** after modifying them:

```bash
docker-compose build typedb
docker-compose up -d
```

Example schema file structure:
```typeql
define

entity person
  owns name,
  owns email;

attribute name sub attribute, value string;
attribute email sub attribute, value string;
```

## How Initialization Works

On first startup, the initialization script (`init-typedb.sh`):

1. Starts the TypeDB server
2. Checks if initialization has already been done (looks for marker file)
3. If not initialized:
   - Changes admin password (if `TYPEDB_ADMIN_PASSWORD` is set)
   - Creates database (if `TYPEDB_DATABASE_NAME` is set)
   - Creates user with full permissions (if credentials are set)
   - Loads schema file (if exists in `/schema` directory)
   - Loads seed data (if exists in `/schema` directory)
   - Creates marker file to prevent re-initialization

**Note:** If any step fails (except changing admin password), subsequent steps are skipped to prevent partial initialization.

## Exposed Ports

- **1729** - TypeDB server (mapped to host port 1729)
- **8000** - Additional service port (mapped to host port 1728)

## Data Persistence

Database data is persisted in the `typedb-data` Docker volume. To completely reset the database:

```bash
docker-compose down -v
```

This will remove the volume and allow re-initialization on next startup.

## Troubleshooting

### Database won't start
Check logs: `docker-compose logs typedb`

### Reset initialization
Remove the initialization marker:
```bash
docker-compose exec typedb rm /opt/typedb-all-linux/server/data/.initialized
docker-compose restart typedb
```

### Connect to TypeDB console
```bash
docker-compose exec typedb /opt/typedb-all-linux/typedb console --server=localhost:1729