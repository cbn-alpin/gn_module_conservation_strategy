BEGIN;


\echo '--------------------------------------------------------------------------------'
\echo 'Delete from t_territory'
DELETE FROM :moduleSchema.t_territory WHERE code = :'code';


\echo '--------------------------------------------------------------------------------'
\echo 'COMMIT if ALL is OK:'
COMMIT;
