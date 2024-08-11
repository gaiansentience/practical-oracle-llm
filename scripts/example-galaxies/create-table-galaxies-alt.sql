CREATE TABLE if not exists galaxies_alt (id NUMBER, name VARCHAR2(50), doc VARCHAR2(4000), embedding VECTOR, embedding_model varchar2(100));


truncate table galaxies_alt;

INSERT INTO galaxies_alt (id, name, doc) VALUES (1, 'M31', 'Messier 31 is a barred spiral galaxy in the Andromeda constellation which has a lot of barred spiral galaxies.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (2, 'M33', 'Messier 33 is a spiral galaxy in the Triangulum constellation.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (3, 'M58', 'Messier 58 is an intermediate barred spiral galaxy in the Virgo constellation.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (4, 'M63', 'Messier 63 is a spiral galaxy in the Canes Venatici constellation.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (5, 'M77', 'Messier 77 is a barred spiral galaxy in the Cetus constellation.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (6, 'M91', 'Messier 91 is a barred spiral galaxy in the Coma Berenices constellation.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (7, 'M49', 'Messier 49 is a giant elliptical galaxy in the Virgo constellation.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (8, 'M60', 'Messier 60 is an elliptical galaxy in the Virgo constellation.');
INSERT INTO galaxies_alt (id, name, doc) VALUES (9, 'NGC1073', 'NGC 1073 is a barred spiral galaxy in Cetus constellation.');

commit;



   
update galaxies_alt g
set embedding = vector_embedding(ALL_MINILM_L12_V2 using g.doc as data), embedding_model = 'ALL_MINILM_L12_V2';


commit;