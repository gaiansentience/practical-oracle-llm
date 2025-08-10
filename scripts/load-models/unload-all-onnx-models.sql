set serveroutput on;

declare
    cursor c is
    select model_name
    from user_mining_models
    where mining_function = 'EMBEDDING' and algorithm = 'ONNX'
    order by model_name;
begin


for r in c loop 

    dbms_vector.drop_onnx_model(model_name  => r.model_name);
    
    dbms_output.put_line('Dropped onnx model: ' || r.model_name);
    
end loop;

end;
/

select model_name, mining_function, algorithm, algorithm_type, model_size
from user_mining_models
where mining_function = 'EMBEDDING' and algorithm = 'ONNX'
order by model_name
/

select model_name, attribute_name, attribute_type, data_type, vector_info
from user_mining_model_attributes
where model_name in (
    select model_name
    from user_mining_models
    where mining_function = 'EMBEDDING' and algorithm = 'ONNX'
    )
order by model_name, attribute_name
/