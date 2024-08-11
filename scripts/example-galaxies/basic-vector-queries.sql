select * from galaxies;

  SELECT vector_embedding(ALL_MINILM_L6_V2 using 'hello world' as data);
  
  
   SELECT g.doc, vector_embedding(ALL_MINILM_L12_V2 using g.doc as data) as l6embedding from galaxies g;
   
   
   
   SELECT * from galaxies_alt g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'spiral galaxy' as data), cosine)
   fetch first 3 rows only;
   
      SELECT * from galaxies_alt g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'twirly stars' as data), cosine)
   fetch first 3 rows only;
   
   
         SELECT * from galaxies_alt g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'triangle' as data), cosine)
   fetch first 3 rows only;
   
            SELECT * from galaxies_alt g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'three sides' as data), cosine)
   fetch first 3 rows only;
   
         SELECT * from galaxies_alt g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'ellipsoid stars' as data), cosine)
   fetch first 3 rows only;
   
            SELECT * from recipes g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'yummy dessert' as data), cosine)
   fetch first 3 rows only;
   
               SELECT * from recipes g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'serious nutrition' as data), cosine)
   fetch first 3 rows only;
   
                  SELECT * from recipes g
   order by vector_distance(g.embedding, vector_embedding(all_minilm_l12_v2 using 'healthy snack' as data), cosine)
   fetch first 3 rows only;