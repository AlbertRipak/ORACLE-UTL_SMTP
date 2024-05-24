BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name                           => 'check_tablespace_size_job',
        job_type                             => 'PLSQL_BLOCK',
        job_action                          => 'CALL check_tablespace_size();',
        start_date                           => SYSTIMESTAMP,
        repeat_interval                   => 'FREQ=MINUTELY; INTERVAL=1',
        end_date                            => NULL,
        auto_drop                           => FALSE,
        job_class                            => 'batch_update_jobs',
        comments                          => 'This is job checking size of databases tablespace!');
    DBMS_SCHEDULER.ENABLE('check_tablespace_size_job');
END;
/


