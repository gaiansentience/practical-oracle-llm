begin
   DBMS_VECTOR.LOAD_ONNX_MODEL(
    'ML_MODELS_DIR',
    'multi_qa_MiniLM_L6_cos_v1.onnx',
    'multi_qa_minilm_l6_cos_v1');
end;
/


SELECT model_name, mining_function, algorithm,
algorithm_type, model_size
FROM user_mining_models
WHERE model_name = 'MULTI_QA_MINILM_L6_COS_V1'
ORDER BY model_name;



SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
WHERE model_name = 'MULTI_QA_MINILM_L6_COS_V1'
ORDER BY attribute_name;