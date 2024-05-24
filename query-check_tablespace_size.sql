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