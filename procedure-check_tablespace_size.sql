CREATE OR REPLACE PROCEDURE check_tablespace_size  (
    msg_ttt      VARCHAR2)
IS
    CURSOR c_size IS
    SELECT ddf.tablespace_name, 
        ROUND(SUM(ddf.bytes/(1024*1024)) - SUM(dfs.bytes/(1024*1024)), 2) AS Usage_MB, 
        ROUND(SUM(ddf.bytes/(1024*1024)), 2) Size_Allocated_MB,
        ROUND(SUM(ddf.maxbytes/1024/1024), 2) AS Maximum_Allocated_MB,
        SUM(dfs.bytes/1024/1024) AS Free_Space
    FROM dba_tablespaces dt
        LEFT OUTER JOIN dba_data_files ddf
            ON ddf.tablespace_name = dt.tablespace_name
        LEFT OUTER JOIN dba_free_space dfs
            ON ddf.file_id = dfs.file_id
    WHERE dt.tablespace_name IN ('SYSTEM', 'SYSAUX', 'USERS', 'TEST', 'SIMPLE_TEST')
    GROUP BY ddf.tablespace_name;
    
    v_tablespace_name dba_data_files.tablespace_name%TYPE;
    v_usage_mb VARCHAR2(50);
    v_size_allocated_mb VARCHAR2(50);
    v_maximum_allocated_mb VARCHAR2(50);
    v_free_space VARCHAR2(50);
    v_count FLOAT(5);
    v_result VARCHAR2(300);
    v_newline VARCHAR2(2);
BEGIN
    v_newline := CHR(10);
    OPEN c_size;
        LOOP 
            FETCH c_size 
                INTO  v_tablespace_name,
                           v_usage_mb, 
                           v_size_allocated_mb, 
                           v_maximum_allocated_mb,
                           v_free_space;
        EXIT WHEN c_size%NOTFOUND;
        v_count := v_usage_mb/v_maximum_allocated_mb * 100;
        v_result := 'Tablespace name = '  || v_tablespace_name || v_newline ||
                           'Usage MB = '              || v_usage_mb || v_newline ||
                           'Allocated size MB = ' || v_size_allocated_mb || v_newline ||
                           'Allocated maximum MB = ' || v_maximum_allocated_mb || v_newline ||
                           'Free space = '            || v_free_space || v_newline ||
                           'Usage size in % = '    || v_count;
        CASE 
            WHEN v_count > 80 THEN 
                send_mail('my@post.mail.com', 'You need to increase the size of the database files!', v_result);
            WHEN v_count > 90 THEN
                send_mail('my@post.mail.com', 'CRITICAL ATTANTHION! You need to increase the size of the database files!', v_result);
            ELSE
                v_date;
         END CASE;
        END LOOP;
    CLOSE c_size;
END;
/