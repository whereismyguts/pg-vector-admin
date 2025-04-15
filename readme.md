# PostgreSQL Vector Database with Mathesar DB UI

## Environment Variables

This project uses environment variables to manage sensitive configuration data. This approach prevents committing secrets to version control.

### Setup Instructions:

1. Main PostgreSQL Vector Database:
   - Copy `.env.example` to `.env` in the root directory
   - Update the values in `.env` with your specific configuration

2. DB UI Component:
   - Copy `db-ui/.env.example` to `db-ui/.env`
   - Update the values in `db-ui/.env` with your specific configuration


## Create a new vector table in PostgreSQL

1. edit `create_new_vector_table.sql` file to set the name of the new table and the number of dimensions:

```sql
...

SELECT create_new_vector_table('moto_vectors');
```

2. run the following command to create a new vector table in PostgreSQL:


```bash
docker exec -i postgres_vector_db psql -U postgres -d vector_db < /home/karmanov/pg_vector_store/create_new_vector_table.sql
```