DROP TABLE if exists genvec PURGE;

CREATE TABLE genvec (
  id number,           -- id of the generated vector
  v VECTOR,            -- generated vector
  name VARCHAR2(500),  -- name for the generated vector: C1 to Cn are centroids, Cx_y is vector number y in cluster number x
  nv VECTOR,           -- normalized version of th generated vector
  ly number            -- random number you can use to filter out rows in addiion to similarity search on vectors
);


CREATE OR REPLACE PACKAGE vector_gen_pkg AS

  TYPE t_vectors IS TABLE OF vector INDEX BY PLS_INTEGER;

  FUNCTION get_coordinate(
    input_string CLOB,
    i PLS_INTEGER
  ) RETURN NUMBER;

  PROCEDURE generate_vectors(
    num_vectors IN PLS_INTEGER,  -- Number of vectors to generate
    dimensions IN PLS_INTEGER,   -- Number of dimensions of each vector
    num_clusters IN PLS_INTEGER, -- Number of clusters to create
    cluster_spread IN NUMBER,    -- Relative closeness of each vector in each cluster (using standard deviation)
    min_value IN NUMBER,         -- Minimum value for a vector coordinate
    max_value IN NUMBER          -- Maximum value for a vector coordinate
  );

END vector_gen_pkg;
/

CREATE OR REPLACE PACKAGE BODY vector_gen_pkg AS

  -------------------------------------------
  -------------------------------------------
  ---- V E C T O R    G E N E R A T O R -----
  -------------------------------------------
  -------------------------------------------
  -- Version 1.0                    ---------
  -------------------------------------------
  -------------------------------------------
  ---- DO NOT USE ON PRODUCTION DATABASES ---
  ---- ONLY FOR TESTING AND DEMO PURPOSES ---
  -------------------------------------------


  FUNCTION get_coordinate(
    input_string CLOB,
    i PLS_INTEGER
  ) RETURN NUMBER IS
    start_pos NUMBER;
    end_pos NUMBER;
    comma_pos NUMBER;
    coord VARCHAR2(100);
    comma_count NUMBER := 0;
    commas NUMBER;
    working_string CLOB;
  BEGIN
    -- Remove leading and trailing brackets
    working_string := input_string;
    working_string := TRIM(BOTH '[]' FROM working_string);
    commas := LENGTH(working_string) - LENGTH(REPLACE(working_string, ',', ''));

    -- Initialize positions
    start_pos := 1;
    end_pos := INSTR(working_string, ',', start_pos);
  
    IF i<=0 OR i>commas+1 THEN RETURN NULL;
    END IF;

    -- Loop through the string to find the i-th coordinate
    LOOP
      IF comma_count + 1 = i THEN
        IF end_pos = 0 THEN
          -- If there's no more comma, the coordinate is the rest of the string
          coord := SUBSTR(working_string, start_pos);
        ELSE
          coord := SUBSTR(working_string, start_pos, end_pos - start_pos);
        END IF;
        RETURN coord;
      END IF;

      -- Move to the next coordinate
      comma_count := comma_count + 1;
      start_pos := end_pos + 1;
      end_pos := INSTR(working_string, ',', start_pos);

      -- Exit loop if no more coordinates
      EXIT WHEN start_pos > LENGTH(working_string);
    END LOOP;

    -- If the function hasn't returned yet, the index was out of bounds
    RETURN NULL;

  END;



  PROCEDURE generate_random_vector(
    dimensions IN PLS_INTEGER,
    min_value IN NUMBER,
    max_value IN NUMBER,
    vec OUT vector
    ) IS
    e CLOB;
  BEGIN
    e := '[';
    FOR i IN 1..dimensions-1 LOOP
      e := e || DBMS_RANDOM.VALUE(min_value, max_value) ||',';
    END LOOP;
    e := e || DBMS_RANDOM.VALUE(min_value, max_value) ||']';
    vec := VECTOR(e);
  END generate_random_vector;



  PROCEDURE generate_clustered_vector(
    centroid IN vector,
    cluster_spread IN NUMBER,
    vec OUT vector
  ) IS
    e CLOB;
    d number;
    BEGIN
      d := VECTOR_DIMENSION_COUNT(centroid);
      e := '[';
      FOR i IN 1 .. d-1 LOOP
        e := e || (get_coordinate(to_clob(centroid),i) + (DBMS_RANDOM.NORMAL * cluster_spread)) ||',';
      END LOOP;
      e := e || (get_coordinate(to_clob(centroid),VECTOR_DIMENSION_COUNT(centroid)) + (DBMS_RANDOM.NORMAL * cluster_spread)) || ']';
      vec := VECTOR(e);
  END generate_clustered_vector;



  FUNCTION normalize_vector(vec IN vector) RETURN vector IS
    e CLOB;
    v CLOB;
    n number;
    d number;
  BEGIN
    n := VECTOR_NORM(vec);
    v := to_clob(vec);
    d := VECTOR_DIMENSION_COUNT(vec);
    e := '[';
    FOR i IN 1 .. d-1 LOOP
      e := e || (get_coordinate(v,i)/n) ||',';
    END LOOP;
    e := e || (get_coordinate(v,d)/n) || ']';
    RETURN VECTOR(e);
  END normalize_vector;



  PROCEDURE generate_vectors(
    num_vectors IN PLS_INTEGER,  -- Must be 1 or above
    dimensions IN PLS_INTEGER,   -- Must be above 1 but less than 500
    num_clusters IN PLS_INTEGER, -- Must be 1 or above
    cluster_spread IN NUMBER,    -- Must be grather than 0
    min_value IN NUMBER,
    max_value IN NUMBER
  ) IS
    centroids t_vectors;
    vectors_per_cluster PLS_INTEGER;
    remaining_vectors PLS_INTEGER;
    vec vector;
    idx PLS_INTEGER := 1;
    max_id NUMBER;
    working_vector VECTOR;

  BEGIN
    IF (num_vectors) <=0 OR (num_clusters < 1) OR (num_vectors < num_clusters) OR (dimensions <= 0) OR (dimensions > 500) OR (cluster_spread <= 0) OR (min_value >= max_value) THEN RETURN;
    END IF;

delete from genvec;

    SELECT nvl(MAX(id),0) INTO max_id FROM genvec;
    IF max_id IS NULL THEN max_id := 0;
    END IF;

    -- Generate cluster centroids
    FOR i IN 1..num_clusters LOOP

      generate_random_vector(dimensions, min_value, max_value, centroids(i));
      working_vector := normalize_vector(centroids(i));
      INSERT INTO genvec VALUES (max_id + idx, centroids(i), 'C'||i, working_vector, DBMS_RANDOM.VALUE(3,600000000));
      idx := idx + 1;

    END LOOP;

    -- Calculate vectors per cluster
    vectors_per_cluster := TRUNC(num_vectors / num_clusters);
    remaining_vectors := num_vectors MOD num_clusters;

    -- Generate vectors for each cluster
    IF vectors_per_cluster > 1 THEN
      FOR i IN 1..num_clusters LOOP
        FOR j IN 1..(vectors_per_cluster - 1) LOOP
          generate_clustered_vector(centroids(i), cluster_spread, vec);
          working_vector := normalize_vector(vec);
          INSERT INTO genvec VALUES (max_id + idx, vec, 'C'||i||'-'||j, working_vector, DBMS_RANDOM.VALUE(3,600000000));
          idx := idx + 1;
        END LOOP;
      END LOOP;
    END IF;

    -- Handle remaining vectors: all associated with cluster 1
    IF remaining_vectors > 0 THEN
      FOR j IN 1..remaining_vectors LOOP
        generate_clustered_vector(centroids(1), cluster_spread, vec);
        working_vector := normalize_vector(vec);
        INSERT INTO genvec VALUES (max_id + idx, vec, 'C1-'||idx, working_vector, DBMS_RANDOM.VALUE(3,600000000));
        idx := idx + 1;
      END LOOP;
    END IF;
    COMMIT;
  END generate_vectors;

END vector_gen_pkg;
/

BEGIN
  vector_gen_pkg.generate_vectors(
    num_vectors => 100,   -- Number of vectors to generate. Must be 1 or above
    dimensions => 24,      -- Number of dimensions of each vector. Must be above 1 but less than 500
    num_clusters => 6,    -- Number of clusters to create. Must be 1 or above
    cluster_spread => 1,  -- Relative closeness of each vector in each cluster (using standard deviation). Must be grather than 0
    min_value => -100,       -- Minimum value for a vector coordinate
    max_value => 100      -- Maximum value for a vector coordinate. Min value must be smaller than max value
  );
END;
/