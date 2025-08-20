-- TUK starter queries (us-east-1)

-- Replace <your_table_name> with your actual table (e.g., cloudtrail_logs or cloudtrail_logs_cutul_buck_log)

-- Today’s events in us-east-1 (partitioned table)
SELECT count(*)
FROM <your_table_name>
WHERE region='us-east-1'
  AND year = date_format(current_date, '%Y')
  AND month = date_format(current_date, '%m')
  AND day = date_format(current_date, '%d');

-- Console logins (today)
SELECT eventtime, useridentity.arn, sourceipaddress
FROM <your_table_name>
WHERE region='us-east-1'
  AND year = date_format(current_date, '%Y')
  AND month = date_format(current_date, '%m')
  AND day = date_format(current_date, '%d')
  AND eventname='ConsoleLogin'
ORDER BY from_iso8601_timestamp(eventtime) DESC
LIMIT 50;

-- S3 PutObject events (if data events enabled)
SELECT eventtime, useridentity.arn, requestparameters
FROM <your_table_name>
WHERE region='us-east-1'
  AND year = date_format(current_date, '%Y')
  AND month = date_format(current_date, '%m')
  AND day = date_format(current_date, '%d')
  AND eventsource='s3.amazonaws.com' AND eventname='PutObject'
ORDER BY from_iso8601_timestamp(eventtime) DESC
LIMIT 50;

-- Top services used in last 7 days (non-partitioned)
SELECT eventsource, count(*) AS events
FROM <your_table_name>
WHERE from_iso8601_timestamp(eventtime) >= current_timestamp - interval '7' day
GROUP BY eventsource
ORDER BY events DESC;
