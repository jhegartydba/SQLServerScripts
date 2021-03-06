/* *****************************************
*  Finding and deleting duplicate records   *
*  *****************************************
*/ 

-- Create test table
CREATE TABLE #Employee(
	Employee_ID [int] Null,
	Employee_Name varchar(20) Null,
	Employee_Dept varchar(20) Null 
) ;

Insert into #Employee VALUES (1, 'Marky Mark', 'HR');
Insert into #Employee VALUES (1, 'Marky Mark', 'HR');
Insert into #Employee VALUES (2, 'John Doe', 'Production');
Insert into #Employee VALUES (2, 'John Doe', 'Production');
Insert into #Employee VALUES (2, 'John Doe', 'Production');
Insert into #Employee VALUES (3, 'Anna Nana', 'Manufacturing');


-- Selecting Distinct Records
With CTE_Employee
AS
(
	Select	Employee_ID, Employee_Name, Employee_Dept,
			ROW_NUMBER()
				OVER (PARTITION BY Employee_ID, Employee_Name, Employee_Dept
						ORDER BY Employee_ID, Employee_Name, Employee_Dept) AS RowNumber
	from	#Employee
)

SELECT	Employee_ID, Employee_Name, Employee_Dept
FROM	CTE_Employee
WHERE	RowNumber = 1;


-- Selecting Duplicate Records
With CTE_Employee
AS
(
	Select	Employee_ID, Employee_Name, Employee_Dept,
			ROW_NUMBER()
				OVER (PARTITION BY Employee_ID, Employee_Name, Employee_Dept
						ORDER BY Employee_ID, Employee_Name, Employee_Dept) AS RowNumber
	from	#Employee
)

SELECT	Employee_ID, Employee_Name, Employee_Dept
FROM	CTE_Employee
WHERE	RowNumber > 1;


-- Deleting Duplicate Records
With CTE_Employee
AS
(
	Select	Employee_ID, Employee_Name, Employee_Dept,
			ROW_NUMBER()
				OVER (PARTITION BY Employee_ID, Employee_Name, Employee_Dept
						ORDER BY Employee_ID, Employee_Name, Employee_Dept) AS RowNumber
	from	#Employee
)

DELETE
FROM	CTE_Employee
WHERE	RowNumber > 1;