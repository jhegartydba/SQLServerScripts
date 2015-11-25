/* *********************************************************************
*  Load records into SQL Server table from a flat file.                 *
*  This is a workaround to a bug in the GUI does not allow you to cast  *
*  data between different types.                                        *
*  *********************************************************************
*/

BULK INSERT my_schema.my_table
FROM '\\backup\directory\filename.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n'    -- Use to shift the control to next row
)


