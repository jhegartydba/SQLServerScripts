-- ****************************************************
-- Convert Number to string ( exp. 9 - 0009 or 9 - 09)
-- By Andrés Novelo, 2015/07/22
-- ****************************************************

/*

This Function convert integer to string with N number of zeros to the left. 
It only needs two parameters, the integer value and the length of the string that you require.

Example:  
 Select dbo.NumberToString (9, 5) you get 00009 
 Select dbo.NumberToString (7, 2) you get 07 

 */

CREATE FUNCTION [dbo].[NumberToString] (
	@value INT
	,@size INT
	)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @TMP VARCHAR(128);

	SET @TMP = CAST(@value AS VARCHAR(20));

	IF @TMP IS NULL
		SET @TMP = 0;

	WHILE LEN(@TMP) < @SIZE
		SET @TMP = '0' + @TMP;

	RETURN @TMP;
END
