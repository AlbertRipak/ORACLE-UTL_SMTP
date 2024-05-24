--CALL send_mail('my@post.test.com', 'You need to increase the size of the database files!', 'test');
--CALL check_tablespace_size();

--Show local time!
SELECT  localtimestamp  FROM dual;

-- Check all jobs in database!
SELECT * FROM DBA_SCHEDULER_JOB_CLASSES;

-- Show all procedures;
SELECT * FROM dba_procedures WHERE OBJECT_NAME like '%mai%';
desc dba_procedures