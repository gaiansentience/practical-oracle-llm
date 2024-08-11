begin
   DBMS_VECTOR.LOAD_ONNX_MODEL(
    'ML_MODELS_DIR',
    'clinical_bert.onnx',
    'clinical_bert');
end;
/


SELECT model_name, mining_function, algorithm,
algorithm_type, model_size
FROM user_mining_models
WHERE model_name = 'CLINICAL_BERT'
ORDER BY model_name;



SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
WHERE model_name = 'CLINICAL_BERT'
ORDER BY attribute_name;