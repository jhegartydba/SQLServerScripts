/*
*	Read error log and report multiple failed login attemps 
*/

begin

	create table #errorLog (
		LogDate datetime, 
		ProcessInfo varchar(250), 
		[Text] varchar(8000)
	)
		
	
	--read the current error log 
	insert into #errorLog (LogDate, ProcessInfo, [Text])
	exec sp_readerrorlog 0, 1 --0 = current(0), 1 = error log
	
	
	--find brute force attempts to guess a password
	select 
		replace(right([Text],charindex(' ', reverse([Text]))-1), ']', '') as IP,		
		substring([Text], charindex('''', [Text]) + 1,  charindex('.', [Text]) - charindex('''', [Text]) - 2  ) as [User],
		count(LogDate) as [Number of login attempts],
		min(LogDate) as [Attack started],
		max(LogDate) as [Attack ended],
		datediff(minute, min(LogDate), max(LogDate)) as [Attack duration in minutes],
		cast(cast(count(LogDate) as decimal(18,2))/isnull(nullif(datediff(minute, min(LogDate), max(LogDate)),0),1) as decimal(18,2)) as [Attack intensity - Login attempts per minute]
		  
	from #errorLog
	
	where
		--limit data to unsuccessful login attempts in the last 24 hours
		ProcessInfo = 'Logon'
		and [Text] like 'Login failed for user%'
		and datediff(hour, LogDate, getdate()) <= 24 
		
	group by		
		[Text]
		
	having
		count(LogDate) > 3 --filter out users just typing their passwords incorrectly
		
	order by		
		[Number of login attempts] desc,
		[Attack ended] desc	

	

	--clean up temp tables created
	drop table #errorLog


end