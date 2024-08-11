--distance between m31 and other galaxies
SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
VECTOR_DISTANCE(g2.embedding, g1.embedding) AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;

SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
VECTOR_DISTANCE(g2.embedding, g1.embedding, COSINE )  AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;

SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
g2.embedding <=>  g1.embedding  AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;


SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
VECTOR_DISTANCE(g2.embedding, g1.embedding, EUCLIDEAN) AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;

SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
g2.embedding <-> g1.embedding AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;


SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
VECTOR_DISTANCE(g2.embedding, g1.embedding, EUCLIDEAN_SQUARED) AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;



SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
VECTOR_DISTANCE(g2.embedding, g1.embedding, DOT) AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;

SELECT
g1.name AS galaxy_1,
g2.name AS galaxy_2,
g2.embedding <#> g1.embedding AS distance
FROM galaxies g1, galaxies g2
WHERE g1.id = 1 and g2.id <> 1
ORDER BY distance ASC;