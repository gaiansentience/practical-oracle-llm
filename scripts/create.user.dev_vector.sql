create user dev_vector identified by oracle;

grant connect, db_developer_role to dev_vector;
grant create domain to dev_vector;
grant create mining model to dev_vector;

alter user dev_vector quota unlimited on users;

--Oracle 23ai VirtualBox Linux Appliance with external data path
CREATE OR REPLACE DIRECTORY ML_MODELS_DIR AS '/home/oracle/ext-data/ora-db-directories/shared/ml-models';

GRANT READ ON DIRECTORY ML_MODELS_DIR TO dev_vector;
GRANT WRITE ON DIRECTORY ML_MODELS_DIR TO dev_vector;

   