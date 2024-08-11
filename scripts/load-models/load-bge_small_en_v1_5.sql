begin
   DBMS_VECTOR.LOAD_ONNX_MODEL(
    'ML_MODELS_DIR',
    'bge_small_en_v1_5.onnx',
    'bge_small_en_v1_5');
end;
/


SELECT model_name, mining_function, algorithm,
algorithm_type, model_size
FROM user_mining_models
WHERE model_name = 'BGE_SMALL_EN_V1_5'
ORDER BY model_name;



SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
WHERE model_name = 'BGE_SMALL_EN_V1_5'
ORDER BY attribute_name;