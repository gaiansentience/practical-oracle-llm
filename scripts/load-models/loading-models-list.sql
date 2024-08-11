--loading-models-list.sql
set pagesize 100
 column model_name format a40
 column mining_function format a20
 column algorithm format a10
 column algorithm_type format a15
 column model_size format 999,999,999
 column model_attributes format a30
 
 /* filelist from the linux box to compare loaded model sizes to filesizes
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

select model_name, mining_function, algorithm, algorithm_type, model_size
    , ( select vector_info
        from user_mining_model_attributes a
        where a.model_name = m.model_name and a.attribute_name = 'ORA$ONNXTARGET' and a.attribute_type = 'VECTOR'
        ) as model_attributes
from user_mining_models m
order by model_name;

/*

MODEL_NAME                               MINING_FUNCTION      ALGORITHM  ALGORITHM_TYPE    MODEL_SIZE MODEL_ATTRIBUTES              
---------------------------------------- -------------------- ---------- --------------- ------------ ------------------------------
ALL_MINILM_L12_V2                        EMBEDDING            ONNX       NATIVE           133,322,334 VECTOR(384,FLOAT32)           
ALL_MINILM_L6_V2                         EMBEDDING            ONNX       NATIVE            90,621,438 VECTOR(384,FLOAT32)           
ALL_MPNET_BASE_V2                        EMBEDDING            ONNX       NATIVE           109,760,678 VECTOR(768,FLOAT32)           
BERT_TINY                                EMBEDDING            ONNX       NATIVE            17,762,251 VECTOR(128,FLOAT32)           
BGE_BASE_EN_V1_5                         EMBEDDING            ONNX       NATIVE           109,753,887 VECTOR(768,FLOAT32)           
BGE_MICRO_V2                             EMBEDDING            ONNX       NATIVE            34,812,289 VECTOR(384,FLOAT32)           
BGE_SMALL_EN_V1_5                        EMBEDDING            ONNX       NATIVE           133,322,334 VECTOR(384,FLOAT32)           
CLINICAL_BERT                            EMBEDDING            ONNX       NATIVE           136,069,956 VECTOR(768,FLOAT32)           
DISTILUSE_BASE_MULTILINGUAL_CASED_V2     EMBEDDING            ONNX       NATIVE           136,466,629 VECTOR(512,FLOAT32)           
E5_BASE_V2                               EMBEDDING            ONNX       NATIVE           109,753,887 VECTOR(768,FLOAT32)           
E5_SMALL_V2                              EMBEDDING            ONNX       NATIVE           133,322,334 VECTOR(384,FLOAT32)           
FINBERT                                  EMBEDDING            ONNX       NATIVE           109,753,887 VECTOR(768,FLOAT32)           
GTE_BASE                                 EMBEDDING            ONNX       NATIVE           218,347,715 VECTOR(768,FLOAT32)           
GTE_SMALL                                EMBEDDING            ONNX       NATIVE            66,988,691 VECTOR(384,FLOAT32)           
GTE_TINY                                 EMBEDDING            ONNX       NATIVE            45,537,359 VECTOR(384,FLOAT32)           
MULTILINGUAL_E5_SMALL                    EMBEDDING            ONNX       NATIVE           123,029,194 VECTOR(384,FLOAT32)           
MULTI_QA_MINILM_L6_COS_V1                EMBEDDING            ONNX       NATIVE            90,621,438 VECTOR(384,FLOAT32)           
STELLA_BASE_EN_V2                        EMBEDDING            ONNX       NATIVE           218,347,715 VECTOR(768,FLOAT32)           

18 rows selected. 

*/















