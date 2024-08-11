begin
   DBMS_VECTOR.LOAD_ONNX_MODEL(
    'ML_MODELS_DIR',
    'all_MiniLM_L12_v2.onnx',
    'all_minilm_l12_v2');
end;
/


SELECT model_name, mining_function, algorithm,
algorithm_type, model_size
FROM user_mining_models
WHERE model_name = 'ALL_MINILM_L12_V2'
ORDER BY model_name;



SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
WHERE model_name = 'ALL_MINILM_L12_V2'
ORDER BY attribute_name;