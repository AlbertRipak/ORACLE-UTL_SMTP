/*<TOAD_FILE_CHUNK>*/
BEGIN
    DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (
        acl                                     => 'send_mails2.xml',
        description                       => 'Allow mail to be send',
        principal                           => 'DBUP',
        is_grant                            => TRUE,
        privilege                           => 'connect');
    COMMIT;
    
    DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'send_mails2.xml', principal => 'DBUP', is_grant => TRUE, privilege => 'connect');
    DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl => 'send_mails2.xml', principal => 'DBUP', is_grant => TRUE, privilege => 'resolve');
    DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(acl => 'send_mails2.xml', host => '*');
END;
/