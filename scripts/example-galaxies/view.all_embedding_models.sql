create or replace view all_embedding_models as
select a.input_data, a.onnx_target, m.*
from
(
    select * from
    all_mining_models 
    where mining_function = 'EMBEDDING' and algorithm = 'ONNX'
) m
join
(
    select model_name, input_data, onnx_target
    from
    (
    select model_name, attribute_name, case when attribute_type = 'VECTOR' then vector_info else data_type || '('||data_length||')' end as attribute_type
    from 
    all_mining_model_attributes
    )
    pivot (
        max(attribute_type) for attribute_name in ('DATA' as input_data, 'ORA$ONNXTARGET' as onnx_target)
    )
) a on m.model_name = a.model_name 
order by m.model_name
/

