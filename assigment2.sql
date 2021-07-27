create view  number_of_stituations as
select user_id,
		sum(case when action = 'publish' then 1
				when action = 'cancel' then 0
					end) as Puplish_number, 
		sum(case when action = 'cancel' then 1
		when action = 'publish' then 0
		end) as cancel_number,
		count(case when action = 'start' then 'start'
		end) as starts_number
from  dbo.users
group by user_id

select * from number_of_stituations

select user_id, cast(Puplish_number as float) / number_of_starts as Publish_rate,
		cast(cancel_number as float) / number_of_starts as Cancel_rate
from number_of_stituations

drop view cancellation_rate