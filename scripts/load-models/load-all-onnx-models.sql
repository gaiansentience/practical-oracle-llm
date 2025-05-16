set serveroutput on;

declare
    l_models_dir varchar2(50) := 'ML_MODELS_DIR';
    type t_model is record(onnx_filename varchar2(100), model_name varchar2(100));
    type t_models is table of t_model;
    l_models t_models := t_models();

begin

l_models := t_models(
    t_model('all_MiniLM_L12_v2.onnx', 'all_MiniLM_L12_v2')
    , t_model('all_MiniLM_L6_v2.onnx', 'all_MiniLM_L6_v2')
    , t_model('all_mpnet_base_v2.onnx', 'all_mpnet_base_v2')
    , t_model('bert_tiny.onnx', 'bert_tiny')
    , t_model('bge_base_en_v1_5.onnx', 'bge_base_en_v1_5')
    , t_model('bge_micro_v2.onnx', 'bge_micro_v2')
    , t_model('bge_small_en_v1_5.onnx', 'bge_small_en_v1_5')
    , t_model('clinical_bert.onnx', 'clinical_bert')
    , t_model('distiluse_base_multilingual_cased_v2.onnx', 'distiluse_base_multilingual_cased_v2')
    , t_model('e5_base_v2.onnx', 'e5_base_v2')
    , t_model('e5_small_v2.onnx', 'e5_small_v2')
    , t_model('finbert.onnx', 'finbert')
    , t_model('gte_base.onnx', 'gte_base')
    , t_model('gte_small.onnx', 'gte_small')
    , t_model('gte_tiny.onnx', 'gte_tiny')
    , t_model('multi_qa_MiniLM_L6_cos_v1.onnx', 'multi_qa_MiniLM_L6_cos_v1')
    , t_model('multilingual_e5_small.onnx', 'multilingual_e5_small')
    , t_model('stella_base_en_v2.onnx', 'stella_base_en_v2')
    );

dbms_output.put_line('Loading ' || l_models.count || ' onnx models');

for v in values of l_models loop

    dbms_vector.load_onnx_model(l_models_dir, v.onnx_filename, v.model_name);
    
    dbms_output.put_line(v.onnx_filename || ' loaded successfully as ' || v.model_name);
    
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