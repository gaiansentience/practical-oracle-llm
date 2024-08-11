begin
   DBMS_VECTOR.LOAD_ONNX_MODEL(
    'ML_MODELS_DIR',
    'distiluse_base_multilingual_cased_v2.onnx',
    'distiluse_base_multilingual_cased_v2');
end;
/


SELECT model_name, mining_function, algorithm,
algorithm_type, model_size
FROM user_mining_models
WHERE model_name = 'DISTILUSE_BASE_MULTILINGUAL_CASED_V2'
ORDER BY model_name;



SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
WHERE model_name = 'DISTILUSE_BASE_MULTILINGUAL_CASED_V2'
ORDER BY attribute_name;