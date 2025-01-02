DROP TABLE if exists genbvec PURGE;
DROP TABLE if exists genbvec_i PURGE;

CREATE TABLE genbvec (
  id NUMBER,            -- id of the generated vector
  v VECTOR(*, BINARY),  -- generated vector
  name VARCHAR2(500),   -- name for the generated vector: C1 to Cn are centroids, Cx_y is vector number y in cluster number x
  bv VARCHAR2(1000),          -- normalized version of th generated vector
  ly NUMBER             -- random number you can use to filter out rows in addiion to similarity search on vectors
);

CREATE TABLE genbvec_i (
  id NUMBER,            -- id of the generated vector
  v VARCHAR2(4000),           -- generated vector
  name VARCHAR2(500),   -- name for the generated vector: C1 to Cn are centroids, Cx_y is vector number y in cluster number x
  bv VARCHAR2(1000),          -- bit version of generated vector
  ly NUMBER             -- random number you can use to filter out rows in addition to similarity search on vectors
);



create or replace package generate_vectors as 

 PROCEDURE generate_random_binary_vector(
dimensions IN NUMBER,
result_int OUT VARCHAR2,
result_binary OUT VARCHAR2
);

 PROCEDURE generate_binary_cluster(
  centroid IN VARCHAR2,            -- a string of 1 and 0
  spread IN NUMBER,                -- Maximum Hamming distance between centroid and other vectors in the same cluster
  cluster_size IN NUMBER,          -- Number of vectors to generate in addition to the centroid
  result_binary OUT SYS_REFCURSOR,
  result_int8 OUT SYS_REFCURSOR
);

PROCEDURE generate_binary_vectors_i(
  num_vectors NUMBER,   -- If numbers of vector is not a multiple of num_clusters, remaining vectors are not generated
  num_clusters NUMBER,  -- Must be greater than 0
  dimensions NUMBER,    -- Must be a multiple of 8
  cluster_spread NUMBER -- Maximum Hamming distance between centroid and other vectors in the same cluster: max number of bits flipped
);

end generate_vectors;
/

create or replace package body generate_vectors as 


 PROCEDURE generate_random_binary_vector(
dimensions IN NUMBER,
result_int OUT VARCHAR2,
result_binary OUT VARCHAR2
) IS
    binary_vector VARCHAR2(32000);
    int8_value NUMBER;
    number_of_bits NUMBER;
    char_vector VARCHAR2(32000);
BEGIN
  -- Validate dimension is a multiple of 8
  IF MOD(dimensions, 8) != 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Number of dimensions must be a multiple of 8');
  END IF;

  -- Generate the random binary vector
  binary_vector := '';
  FOR i IN 1 .. dimensions LOOP
    IF DBMS_RANDOM.VALUE(0, 1) < 0.5 THEN
      binary_vector := binary_vector || '0';
    ELSE
      binary_vector := binary_vector || '1';
    END IF;
  END LOOP;

  -- Convert 8-bit packets to their int8 values and build the result string
  number_of_bits := dimensions/8;
  char_vector := '[';
  FOR i IN 0 .. number_of_bits - 1 LOOP
    int8_value := 0;
    FOR j IN 0 .. 7 LOOP
      int8_value := int8_value + TO_NUMBER(SUBSTR(binary_vector, i*8+j+1, 1)) * POWER(2, j);
    END LOOP;
    char_vector := char_vector || int8_value;
    IF i < number_of_bits - 1 THEN
      char_vector := char_vector || ',';
    END IF;
  END LOOP;
  char_vector := char_vector || ']';
  
  -- Return the generated vector value
  result_int := char_vector;
  result_binary := binary_vector;
END generate_random_binary_vector;


 PROCEDURE generate_binary_cluster(
  centroid IN VARCHAR2,            -- a string of 1 and 0
  spread IN NUMBER,                -- Maximum Hamming distance between centroid and other vectors in the same cluster
  cluster_size IN NUMBER,          -- Number of vectors to generate in addition to the centroid
  result_binary OUT SYS_REFCURSOR,
  result_int8 OUT SYS_REFCURSOR
) IS
    dimension NUMBER;
    max_spread NUMBER;
    vector VARCHAR2(32000);
    char_vector VARCHAR2(32000);
    flip_positions DBMS_SQL.VARCHAR2_TABLE;
    random_position NUMBER;
    tresult_binary DBMS_SQL.VARCHAR2_TABLE;
    tresult_int8 DBMS_SQL.VARCHAR2_TABLE;
    binary_vector VARCHAR2(32000);
    cluster_index NUMBER := 1;
    number_of_bits NUMBER;
    int8_value NUMBER;
BEGIN
  -- Determine the dimension of the centroid vector
  dimension := LENGTH(centroid);

  -- Ensure dimension is a multiple of 8
  IF MOD(dimension, 8) != 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Number of dimensions must be a multiple of 8');
  END IF;

  -- Generate the cluster of binary vectors
  WHILE cluster_index <= cluster_size LOOP
    binary_vector := centroid;

    -- Randomly flip bits in the centroid vector with a max of spread bits
    max_spread := TRUNC(DBMS_RANDOM.VALUE(1, spread+1));
    flip_positions.DELETE;
    FOR i IN 1 .. max_spread LOOP
      random_position := TRUNC(DBMS_RANDOM.VALUE(1, dimension+1));
      -- Ensure no duplicates
      WHILE flip_positions.EXISTS(random_position) LOOP
        random_position := TRUNC(DBMS_RANDOM.VALUE(1, dimension+1));
      END LOOP;
      flip_positions(random_position) := '1';
    END LOOP;

    -- Apply flips to binary vector
    FOR i IN 1 .. dimension LOOP
      IF flip_positions.EXISTS(i) THEN
        IF SUBSTR(binary_vector, i, 1) = '0' THEN
          binary_vector := SUBSTR(binary_vector, 1, i-1) || '1' || SUBSTR(binary_vector, i+1);
        ELSE
          binary_vector := SUBSTR(binary_vector, 1, i-1) || '0' || SUBSTR(binary_vector, i+1);
        END IF;
      END IF;
    END LOOP;

    -- Convert binary vector to int8 values
    number_of_bits := dimension/8;
    char_vector := '[';
    FOR i IN 0 .. number_of_bits-1 LOOP
      int8_value := 0;
      FOR j IN 0 .. 7 LOOP
        int8_value := int8_value + TO_NUMBER(SUBSTR(binary_vector, i*8+j+1, 1)) * POWER(2, j);
      END LOOP;
      char_vector := char_vector || int8_value;
      IF i < number_of_bits-1 THEN
        char_vector := char_vector || ',';
      END IF;
    END LOOP;
    char_vector := char_vector || ']';

    -- Add generated vectors to result tables
    tresult_binary(cluster_index) := binary_vector;
    tresult_int8(cluster_index) := char_vector;

    cluster_index := cluster_index + 1;
    END LOOP;

    -- Open cursor for binary result set
    OPEN result_binary FOR
      SELECT COLUMN_VALUE AS binary_vector
      FROM TABLE(tresult_binary);
    
    -- Open cursor for int8 result set
    OPEN result_int8 FOR
      SELECT COLUMN_VALUE AS int8_vector
      FROM TABLE(tresult_int8);

END generate_binary_cluster;


PROCEDURE generate_binary_vectors_i(
  num_vectors NUMBER,   -- If numbers of vector is not a multiple of num_clusters, remaining vectors are not generated
  num_clusters NUMBER,  -- Must be greater than 0
  dimensions NUMBER,    -- Must be a multiple of 8
  cluster_spread NUMBER -- Maximum Hamming distance between centroid and other vectors in the same cluster: max number of bits flipped
) IS
    vectors_per_cluster NUMBER;
    remaining_vectors NUMBER;
    i NUMBER := 1;
    j NUMBER := 1;
    idx NUMBER := 1;
    max_id NUMBER;
    ri VARCHAR2(32000);
    rb VARCHAR2(32000);
    result_binary SYS_REFCURSOR;
    result_int8 SYS_REFCURSOR;
    vb VARCHAR2(32000);
    vi VARCHAR2(32000);    
BEGIN

  IF (num_vectors) <=0 OR (num_clusters < 1) OR (num_vectors < num_clusters) 
        OR (dimensions <= 0) OR (dimensions > 504) OR (cluster_spread <= 0) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Issues with arguments provided');
  END IF;

  SELECT MAX(id) INTO max_id FROM genbvec_i;
  IF max_id IS NULL THEN max_id := 0;
  END IF;

  -- Calculate vectors per cluster
  vectors_per_cluster := TRUNC(num_vectors / num_clusters);
  remaining_vectors := num_vectors MOD num_clusters; -- remaining vectors are not generated

  -- Generate cluster centroids
  FOR i IN 1..num_clusters LOOP
    generate_random_binary_vector(dimensions, ri, rb);
    INSERT INTO genbvec_i VALUES (max_id + idx, ri, 'C'||i, rb, DBMS_RANDOM.VALUE(3,600000000));
    idx := idx + 1;

    -- Generate vectors for each cluster
    IF vectors_per_cluster > 1 THEN
      generate_binary_cluster(rb, cluster_spread, vectors_per_cluster, result_binary, result_int8);

      -- Output the binary result
      j:= 1;
      LOOP
        FETCH result_binary INTO vb;
        FETCH result_int8 INTO vi;
        EXIT WHEN result_binary%NOTFOUND;
        INSERT INTO genbvec_i VALUES (max_id + idx, vi, 'C'||i||'-'||j, vb, DBMS_RANDOM.VALUE(3,600000000));
        -- DBMS_OUTPUT.PUT_LINE(v_binary);
        j := j+1;
        idx := idx + 1;
      END LOOP;
      CLOSE result_binary; 
      CLOSE result_int8;
    END IF;
  END LOOP;
  COMMIT;     

END generate_binary_vectors_i;


end generate_vectors;
/

BEGIN
  generate_vectors.generate_binary_vectors_i(
    num_vectors  =>   40,   -- If numbers of vector is not a multiple of num_clusters, remaining vectors are not generated
    num_clusters =>    2,   -- Must be grather than 0
    dimensions   =>   32,   -- Must be a multiple of 8 and less than 504
    cluster_spread =>  3    -- Maximum Hamming distance between centroid and other vectors in the same cluster: max number of bits flipped
  );
END;
/

begin

INSERT INTO genbvec
  SELECT id, TO_VECTOR(v, *, BINARY), name, bv, ly
  FROM genbvec_i;
  
end;
/
