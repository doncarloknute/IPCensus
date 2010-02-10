SELECT 
-- sum(counts) AS total_counts, 
count(*)
FROM log_denormalized lgd
WHERE user_agent REGEXP '.*(bot|slurp|yandex|reconnoiter|cloudkick|crawler|nutch|monit|spider|mail\.ru|check_http|larbin).*'
-- GROUP BY user_agent
ORDER BY counts DESC
