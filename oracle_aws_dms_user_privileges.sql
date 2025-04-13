
GRANT CREATE SESSION TO oracle_dms_user;
GRANT SELECT ANY TRANSACTION TO oracle_dms_user;
GRANT SELECT on V_$ARCHIVED_LOG TO oracle_dms_user;
GRANT SELECT on V_$LOG TO oracle_dms_user;
GRANT SELECT on V_$LOGFILE TO oracle_dms_user;
GRANT SELECT on V_$DATABASE TO oracle_dms_user;
GRANT SELECT on V_$THREAD TO oracle_dms_user;
GRANT SELECT on V_$PARAMETER TO oracle_dms_user;
GRANT SELECT on V_$NLS_PARAMETERS TO oracle_dms_user;
GRANT SELECT on V_$TIMEZONE_NAMES TO oracle_dms_user;
GRANT SELECT on V_$TRANSACTION TO oracle_dms_user;
GRANT SELECT on ALL_INDEXES TO oracle_dms_user;
GRANT SELECT on ALL_OBJECTS TO oracle_dms_user;
GRANT SELECT on ALL_TABLES TO oracle_dms_user;
GRANT SELECT on ALL_USERS TO oracle_dms_user;
GRANT SELECT on ALL_CATALOG TO oracle_dms_user;
GRANT SELECT on ALL_CONSTRAINTS TO oracle_dms_user;
GRANT SELECT on ALL_CONS_COLUMNS TO oracle_dms_user;
GRANT SELECT on ALL_TAB_COLS TO oracle_dms_user;
GRANT SELECT on ALL_IND_COLUMNS TO oracle_dms_user;
GRANT SELECT on ALL_LOG_GROUPS TO oracle_dms_user;
GRANT SELECT on SYS.DBA_REGISTRY TO oracle_dms_user;
GRANT SELECT on SYS.OBJ$ TO oracle_dms_user;
GRANT SELECT on DBA_TABLESPACES TO oracle_dms_user;
GRANT SELECT on ALL_TAB_PARTITIONS TO oracle_dms_user;
GRANT SELECT on ALL_ENCRYPTED_COLUMNS TO oracle_dms_user;

GRANT EXECUTE on DBMS_LOGMNR TO oracle_dms_user;
GRANT EXECUTE on DBMS_LOGMNR_D TO oracle_dms_user;
GRANT SELECT on V_$LOGMNR_LOGS TO oracle_dms_user;
GRANT SELECT on V_$LOGMNR_CONTENTS TO oracle_dms_user;
GRANT LOGMINING TO oracle_dms_user;

-- SELECT on all tables migrated

GRANT SELECT ON CO.CUSTOMERS TO oracle_dms_user;
GRANT SELECT ON CO.STORES TO oracle_dms_user;
GRANT SELECT ON CO.PRODUCTS TO oracle_dms_user;
GRANT SELECT ON CO.ORDERS TO oracle_dms_user;
GRANT SELECT ON CO.SHIPMENTS TO oracle_dms_user;
GRANT SELECT ON CO.ORDER_ITEMS TO oracle_dms_user;
GRANT SELECT ON CO.INVENTORY TO oracle_dms_user;
GRANT SELECT ON HR.REGIONS TO oracle_dms_user;
GRANT SELECT ON HR.COUNTRIES TO oracle_dms_user;
GRANT SELECT ON HR.LOCATIONS TO oracle_dms_user;
GRANT SELECT ON HR.DEPARTMENTS TO oracle_dms_user;
GRANT SELECT ON HR.JOBS TO oracle_dms_user;
GRANT SELECT ON HR.EMPLOYEES TO oracle_dms_user;
GRANT SELECT ON HR.JOB_HISTORY TO oracle_dms_user;
GRANT SELECT ON HR.TIME_RANGE_SALES TO oracle_dms_user;


