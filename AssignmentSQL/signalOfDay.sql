CREATE FUNCTION `signalOfDay`(input_date DATE)
RETURNS varchar(4)
deterministic
begin
declare signal_value varchar(4);
select `Signal` into signal_value from bajaj2
where `Date` = input_date;
return signal_value;
end
;
