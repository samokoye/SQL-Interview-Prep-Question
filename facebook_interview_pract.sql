-- 26> Write SQL to find out what percent of students attend school 
-- on their birthday from attendance_events and all_students tables?
SELECT  (count(at.student_id)*100/(select count(student_id) from attendance_events) )as percent
FROM attendance_events at
JOIN all_students s
ON at.student_id = s.student_id
where SUBSTR(at.date_event, -5, 2) = SUBSTR(s.date_of_birth, -5, 2)
and SUBSTR(at.date_event, -2, 2) = SUBSTR(s.date_of_birth, -2, 2);

-- CAST(SUBSTR('2008-05-15', -5, 2) AS int);
SELECT DATE('now');

SELECT date('now','start of month','+2 month','-1 day');
SELECT date('now','-2 day');

-- Which grade level had the largest drop in attendance between yesterday and today?
SELECT  grade_level, attendance, date_event
from (select s.grade_level, at.attendance, at.date_event from all_students s join attendance_events at
ON at.student_id = s.student_id 
where at.attendance = 'present' );



SELECT date, grade, today, yesterday, today - yesterday diff
FROM 
    (SELECT a.date, s.grade, COUNT(a.attendance) today, 
            LAG(COUNT(a.attendance), 1) OVER (PARTITION BY grade ORDER BY date) yesterday
     FROM attendance a JOIN students s ON a.student_id = s.student_id     
     WHERE a.attendance = 'present' 
       AND a.date >= DATE_SUB(DATE(NOW()), INTERVAL 1 DAY)    
     GROUP BY a.date, s.grade) last_days 
WHERE date = date(now()) 
ORDER BY diff LIMIT 1;