-- Function to create a new vector table with the same schema as n8n_vectors
CREATE OR REPLACE FUNCTION create_new_vector_table(table_name text) RETURNS void AS $$
DECLARE
  dim integer := 1024;
  vector_values text;
BEGIN
  -- Generate vector values string for sample data
  SELECT string_agg('0.1', ',') INTO vector_values FROM generate_series(1, dim);
  
  EXECUTE format('
    CREATE TABLE IF NOT EXISTS %I (
        id SERIAL PRIMARY KEY,
        text TEXT,
        metadata JSONB,
        embedding VECTOR(%s)
    )', table_name, dim);
    
  -- Create the HNSW index on the embedding column
  EXECUTE format('
    CREATE INDEX IF NOT EXISTS "%s_embedding_idx" ON %I 
    USING hnsw (embedding vector_cosine_ops)
  ', table_name, table_name);
  
  -- Insert a test record with proper dimensions
  -- EXECUTE format('
  --   INSERT INTO %I (text, metadata, embedding) 
  --   VALUES (
  --     ''example text for %I'', 
  --     ''{"source": "manual_creation"}'',
  --     ''[%s]''::vector
  --   ) ON CONFLICT DO NOTHING
  -- ', table_name, table_name, vector_values);

  RAISE NOTICE 'Table % created successfully with vector dimensions: %', table_name, dim;
END;
$$ LANGUAGE plpgsql;

-- Create tables from vectors_table_001 to vectors_table_020
-- DO $$
-- DECLARE
--   i integer;
--   table_name text;
-- BEGIN
--   FOR i IN 2..20 LOOP
--     table_name := 'vectors_table_' || LPAD(i::text, 3, '0');
--     PERFORM create_new_vector_table(table_name);
--     RAISE NOTICE 'Created table %', table_name;
--   END LOOP;
-- END;
-- $$;

-- Create a new vector table named vectors_table_001
SELECT create_new_vector_table('vectors_table_001');
