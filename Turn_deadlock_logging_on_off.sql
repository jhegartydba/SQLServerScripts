/*
* Identify Deadlocks in SQL Server Using Trace Flag 1222 and 1204
*/

-- Scope of a Trace Flag can be either set to Global or Session Only. However, 1204 & 1222 trace flags can be set Global Only.
-- Turn deadlock logging on (-1 is global flag)

-- Trace Flag 1204:- Focused on the nodes involved in the deadlock. Each node has a dedicated section, and the final section describes the deadlock victim.

-- Trace Flag 1222:- Returns information in an XML-like format. The format has three major sections. 
-- The first section declares the deadlock victim. The second section describes each process involved in the deadlock. 
-- The third section describes the resources that are synonymous with nodes in trace flag 1204.


dbcc traceon (1204,-1)
dbcc traceon (1222,-1)

-- Cycle error log. This will ensure that the locks are written to the SQL Error log.

sp_cycle_errorlog

-- This will log the locks to the SQL Error log


-- Turn deadlock OFF
-- The following example disables trace flag 1204 & 1222 globally (-1 is global flag)

dbcc traceoff (1204,-1)
dbcc traceoff (1222,-1)

