/* ***************************************************************************************************************************
*  Execute a statement as a specific user.                                                                                    *
*  When an EXECUTE AS statement is run, the execution context of the session is switched to the specified login or user name. *
*  User / login account is impersonated for the duration of the session or until the context switch is explicitly reverted.   *
*  ***************************************************************************************************************************
*/ 

USE database_name;
EXECUTE AS USER = 'dave';
SELECT * from my_table;
REVERT;
GO