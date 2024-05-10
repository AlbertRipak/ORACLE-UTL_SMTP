SELECT dba_df.tablespace_name                                                      AS   "Tablespace Name",
    SUM(dba_df.bytes)/1024/1024                                                         AS   "Size (MB)",
    NVL(SUM(Used.used_bytes)/1024/1024,0)                                    AS   "Used (MB)",
    NVL(SUM(Free.free_bytes)/1024/1024,0)                                       AS   "Free (MB)",
    NVL((SUM(Used.used_bytes) * 100) / SUM(dba_df.bytes),0)       AS    "Used %"
    
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