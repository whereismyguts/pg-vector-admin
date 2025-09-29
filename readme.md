# PostgreSQL Vector Database with Mathesar DB UI

A production-ready PostgreSQL vector database setup with pgvector extension and Mathesar web UI for managing vector tables and embeddings.

## Features

- PostgreSQL with pgvector extension for vector similarity search
- Mathesar web UI for intuitive database management
- Dockerized setup for easy deployment
- Automated vector table creation utilities
- Secure environment-based configuration

## Tech Stack

- PostgreSQL + pgvector
- Mathesar DB UI
- Docker & Docker Compose
- SQL utilities for vector operations

## Prerequisites

- Docker and Docker Compose
- PostgreSQL client tools (optional, for manual operations)

## Setup

### 1. Configure Main PostgreSQL Vector Database

Copy the example environment file and update with your configuration:

```bash
cp .env.example .env
```

Edit `.env` with your PostgreSQL settings (host, port, credentials, database name).

### 2. Configure Mathesar DB UI

```bash
cp db-ui/.env.example db-ui/.env
```

Edit `db-ui/.env` with your Mathesar-specific settings.

### 3. Start Services

```bash
docker-compose up -d
```

## Usage

### Creating a New Vector Table

1. Edit `create_new_vector_table.sql` to specify the table name and vector dimensions:

```sql
SELECT create_new_vector_table('moto_vectors');
```

2. Execute the SQL script:

```bash
docker exec -i postgres_vector_db psql -U postgres -d vector_db < create_new_vector_table.sql
```

**Note:** Update the path `/home/karmanov/pg_vector_store/` to match your local setup.

### Accessing Mathesar UI

After starting the services, access the Mathesar interface at the URL configured in your `db-ui/.env` file (typically `http://localhost:8000`).

## Environment Variables

This project uses environment variables to manage sensitive configuration data, preventing secrets from being committed to version control.

**Required files:**
- `.env` - Main database configuration
- `db-ui/.env` - Mathesar UI configuration


## Use Cases

- Vector similarity search for AI/ML embeddings
- Semantic search infrastructure
- Recommendation systems
- Document similarity matching
- Image/text embedding storage and retrieval

## License

MIT
