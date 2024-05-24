BEGIN
  DBMS_SCHEDULER.CREATE_JOB_CLASS (
    job_class_name => 'batch_update_jobs',
    comments       => 'This is a batch update job class'
  );
END;
/