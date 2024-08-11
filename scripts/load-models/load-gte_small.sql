begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'gte_small.onnx',
        'gte_small');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'GTE_SMALL'
order by model_name
/

select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'GTE_SMALL'
order by attribute_name
/