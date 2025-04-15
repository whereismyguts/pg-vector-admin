-- enable the vector extension
CREATE EXTENSION IF NOT EXISTS vector;

--- --- --- uncomment
-- -- Create mathesar user and database
-- DO $$
-- BEGIN
--     -- Create user if not exists
--     IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'mathesar') THEN
--         CREATE USER mathesar WITH PASSWORD 'mathesar';
--     END IF;
    
--     -- Grant privileges
--     ALTER USER mathesar CREATEDB SUPERUSER;
-- END
-- $$;

-- -- Create mathesar_django database if it doesn't exist
-- CREATE DATABASE mathesar_django WITH OWNER = mathesar;

-- -- Connect to the mathesar_django database to set up permissions
-- \c mathesar_django

-- -- Grant usage on language c to mathesar user
-- GRANT USAGE ON LANGUAGE c TO mathesar;

--- --- ---

GRANT USAGE ON LANGUAGE c TO postgres;

-- pass dimensions from environment variable
CREATE OR REPLACE FUNCTION initialize_vector_table() RETURNS void AS $$
DECLARE
  dim integer;
  vector_values text;
BEGIN
    dim := 1024;
  
  -- generate vector values string
  SELECT string_agg('0.1', ',') INTO vector_values FROM generate_series(1, dim);
  
  -- create dynamic sql for table creation with proper dimensions
  EXECUTE format('
    CREATE TABLE IF NOT EXISTS n8n_vectors (
        id SERIAL PRIMARY KEY,
        text TEXT,
        metadata JSONB,
        embedding VECTOR(%s)
    )', dim);
    
  -- create index
  EXECUTE format('
    CREATE INDEX IF NOT EXISTS n8n_vectors_embedding_idx ON n8n_vectors 
    USING hnsw (embedding vector_cosine_ops)
  ');
  
  -- insert test item with proper dimensions
  EXECUTE format('
    INSERT INTO n8n_vectors (text, metadata, embedding) 
    VALUES (
      ''example text'', 
      ''{"source": "init"}'',
      ''[%s]''::vector
    ) ON CONFLICT DO NOTHING
  ', vector_values);
END;
$$ LANGUAGE plpgsql;

-- run the initialization
SELECT initialize_vector_table();