begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'multi_qa_MiniLM_L6_cos_v1.onnx',
        'multi_qa_minilm_l6_cos_v1');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'MULTI_QA_MINILM_L6_COS_V1'
order by model_name
/

select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'MULTI_QA_MINILM_L6_COS_V1'
order by attribute_name
/