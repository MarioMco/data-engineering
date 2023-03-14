-- Insert data between two dates into dimcalendar table
INSERT INTO dimcalendar (
    date_key, 
    calendar_year, 
    month_no, 
    day_no, 
    day_of_week_no, 
    week_no, 
    week_name
    )
SELECT d, 
	EXTRACT(year FROM d), 
	EXTRACT(month FROM d),
    EXTRACT(day FROM d), 
    EXTRACT(dow FROM d), 
    EXTRACT(week FROM d),
    TO_CHAR(d, 'Day')
FROM generate_series('2007-01-01'::DATE, '2009-12-31'::DATE, '1 day') AS d;
