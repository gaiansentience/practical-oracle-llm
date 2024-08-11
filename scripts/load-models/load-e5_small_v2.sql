begin
    dbms_vector.load_onnx_model(
        'ML_MODELS_DIR',
        'e5_small_v2.onnx',
        'e5_small_v2');
end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where model_name = 'E5_SMALL_V2'
order by model_name
/

select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name = 'E5_SMALL_V2'
order by attribute_name
/