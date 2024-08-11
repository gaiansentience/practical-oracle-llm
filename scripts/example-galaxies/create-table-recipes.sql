CREATE TABLE if not exists recipes (id NUMBER, name VARCHAR2(100), doc VARCHAR2(4000), embedding VECTOR, embedding_model varchar2(100));


truncate table recipes;

INSERT INTO recipes (id, name, doc) VALUES (1, 'Oatmeal Cookies', 'Use oatmeal and raisins with flour, oil and egg equivalent.  Bake for a special treat');
INSERT INTO recipes (id, name, doc) VALUES (2, 'Strawberry Pie', 'Strawberries in a light syrup and a flaky crust are a great after dinner option');
INSERT INTO recipes (id, name, doc) VALUES (3, 'Grilled Cheese Sandwiches', 'Cheese, tomato slices and bread for a quick and delicious lunch');
INSERT INTO recipes (id, name, doc) VALUES (4, 'Miso Soup', 'Miso with tofu cubes and sliced green onions are the perfect complement to a sushi dinner');
INSERT INTO recipes (id, name, doc) VALUES (5, 'Curried Tofu', 'Tofu, vegetables and a light curry sauce served over rice is a nutritious and easy to prepare meal for anytime');
INSERT INTO recipes (id, name, doc) VALUES (6, 'Raspberry Tarts', 'Fresh raspberries in a folded pie crust are a great fall snack');

commit;



   
update recipes g
set embedding = vector_embedding(ALL_MINILM_L12_V2 using g.doc as data), embedding_model = 'ALL_MINILM_L12_V2';


commit;