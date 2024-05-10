CREATE OR REPLACE PROCEDURE send_mail (
    msg_to      VARCHAR2,
    msg_text    VARCHAR2,
    msg_body    VARCHAR2)
IS
    c UTL_SMTP.connection;
    msg_from VARCHAR2(50) := '192.168.1.194'; -- ip address database server 
    msg_subject VARCHAR2(100) := 'Oracle Database (DBUP).'; 
    mailhost    VARCHAR2(30) := 'post.test.com'; --domain address or ip address for post server
    mailport    INTEGER := 8080;
    base64username VARCHAR2(30) := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw('alerto.mail')));
    base64password VARCHAR2(30) := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw('sldkjfldsjf435#$#@%$#')));
BEGIN
    c  := UTL_SMTP.open_connection(mailhost, mailport);
    UTL_SMTP.helo(c, mailhost);
    UTL_SMTP.command(c, 'AUTH', 'LOGIN');
    UTL_SMTP.command(c, base64username);
    UTL_SMTP.command(c, base64password);
    UTL_SMTP.mail(c, msg_from);
    UTL_SMTP.rcpt(c, msg_to);
    
    UTL_SMTP.open_data(c);
    UTL_SMTP.write_data(c, 'From: Oracle Database DBUP' || UTL_TCP.crlf);
    UTL_SMTP.write_data(c, 'To: ' || msg_to || UTL_TCP.crlf);
    UTL_SMTP.write_data(c, 'Subject: ' || msg_subject || UTL_TCP.crlf);

    UTL_SMTP.write_data(c, msg_text  || UTL_TCP.crlf);
    UTL_SMTP.write_data(c, UTL_TCP.crlf || msg_body);
    UTL_SMTP.write_data(c, UTL_TCP.crlf || UTL_TCP.crlf);
    
    UTL_SMTP.close_data(c);
    UTL_SMTP.quit(c);
END;
/
