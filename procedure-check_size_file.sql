DECLARE
    v_table_name            dba_data_files.tablespace_name%TYPE;
    v_size_file             dba_data_files.bytes%TYPE;
    v_used_bytes            dba_extents.bytes%TYPE;
    v_free_bytes            dba_free_space.bytes%TYPE;
    v_procent_used          dba_extents.bytes%TYPE;
    msg_body                VARCHAR2(1000);
    CURSOR c_file_size IS
        SELECT dba_df.tablespace_name                                  AS   "Tablespace Name",
        SUM(dba_df.bytes)/1024/1024                                    AS   "Size (MB)",
        NVL(SUM(Used.used_bytes)/1024/1024,0)                          AS   "Used (MB)",
        NVL(SUM(Free.free_bytes)/1024/1024,0)                          AS   "Free (MB)",
        NVL((SUM(Used.used_bytes) * 100) / SUM(dba_df.bytes),0)        AS    "Used %"
    FROM dba_data_files dba_df,
        (SELECT file_id, SUM(nvl(bytes,0)) used_bytes 
        FROM dba_extents
        GROUP BY file_id) Used,        
        (SELECT MAX(bytes) free_bytes, file_id
        FROM dba_free_space
        GROUP BY file_id) Free        
    WHERE Used.file_id(+) = dba_df.file_id AND
        dba_df.file_id = Free.file_id(+)        
    GROUP BY dba_df.tablespace_name
    ORDER BY 5 DESC;
BEGIN 
    OPEN c_file_size ;
        LOOP   
            FETCH c_file_size
            INTO v_table_name, v_size_file, v_used_bytes, v_free_bytes, v_procent_used;
        EXIT WHEN c_file_size%NOTFOUND;
        msg_body := msg_body || ('Tablespace Name = ' || v_table_name ||
                    ', Size (MB) = ' || v_size_file || 
                    ', Used (MB) = ' || v_used_bytes ||
                    ', Free (MB) = ' || v_free_bytes || 
                    ', Used % = ' || v_procent_used ); 
        END LOOP;
        send_mail('test@post.test.ua', 'Something text', msg_body);
    CLOSE c_file_size;
END;
/