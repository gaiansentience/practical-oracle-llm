 
 /*
 133322334 Aug 10 13:53 all_MiniLM_L12_v2.onnx           loaded-mining-model
  90621438 Aug 10 13:55 all_MiniLM_L6_v2.onnx            loaded-mining-model
 109760678 Aug 10 13:54 all_mpnet_base_v2.onnx           loaded-mining-model
  17762251 Aug 10 14:34 bert_tiny.onnx                   loaded-mining-model
 109753887 Aug 10 14:54 bge_base_en_v1_5.onnx            loaded-mining-model
  34812289 Aug 10 14:03 bge_micro_v2.onnx                loaded-mining-model
 133322334 Aug 10 14:53 bge_small_en_v1_5.onnx           loaded-mining-model
 136069956 Aug 10 14:37 clinical_bert.onnx               loaded-mining-model
 136466629 Aug 10 14:05 distiluse_base_multilingual_cased_v2.onnx    loaded-mining-model
 109753887 Aug 10 14:42 e5_base_v2.onnx                  loaded-mining-model
 133322334 Aug 10 14:41 e5_small_v2.onnx                 loaded-mining-model
 109753887 Aug 10 14:39 finbert.onnx                     loaded-mining-model
 218347715 Aug 10 14:40 gte_base.onnx                    loaded-mining-model
  66988691 Aug 10 14:40 gte_small.onnx                   loaded-mining-model
  45537359 Aug 10 15:17 gte_tiny.onnx                    loaded-mining-model
 123029194 Aug 10 14:45 multilingual_e5_small.onnx       loaded-mining-model
  90621438 Aug 10 13:56 multi_qa_MiniLM_L6_cos_v1.onnx   loaded-mining-model
 218347715 Aug 10 14:38 stella_base_en_v2.onnx           loaded-mining-model
*/

SELECT model_name, mining_function, algorithm, algorithm_type, model_size
    , ( select vector_info
        from user_mining_model_attributes a
        where a.model_name = m.model_name and a.attribute_name = 'ORA$ONNXTARGET' and a.attribute_type = 'VECTOR'
        ) as model_attributes
FROM user_mining_models m
ORDER BY model_name;



SELECT model_name, attribute_name, attribute_type, data_type, vector_info
FROM user_mining_model_attributes
ORDER BY model_name, attribute_name;

















