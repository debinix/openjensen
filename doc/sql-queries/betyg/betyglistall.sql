----------------------------------------------------------------------------
-- Cobol queries for List Betyg (login level = elev = 1)
----------------------------------------------------------------------------

--
-- Sudent id (user_id=3) query for received grades
-- 

select g.course_id, c.course_name, 
       c.course_startdate, c.course_enddate,
       g.grade_grade, g.grade_comment
from tbl_course c
inner join tbl_grade g
on c.course_id = g.course_id
and g.user_id = 3
;


--
-- All courses without grade (but exclude if already given - see above) 
-- 

select course_id, course_name, course_startdate,
       course_enddate
from tbl_course
where program_id = 1
;
-- given that elev i.e. student is on program_id=1 (alt. program_id=2)


----------------------------------------------------------------------------
-- Cobol queries for List Betyg (login level > elev, i.e >= 2)
----------------------------------------------------------------------------


-- All students on program 1 - and the corresponding courses (without info about grade)
select c.course_name, u.user_firstname, u.user_lastname, u.user_id, c.course_id, u.user_program
from tbl_user u
join tbl_course c
on c.program_id = u.user_program
and ( u.usertype_id = 1 and u.user_program = 1 )
order by c.course_name, u.user_lastname, u.user_firstname
;

-- All students on program 2 - and the corresponding courses (without info about grade)
select c.course_name, u.user_firstname, u.user_lastname, u.user_id, c.course_id, u.user_program
from tbl_user u
join tbl_course c
on c.program_id = u.user_program
and ( u.usertype_id = 1 and u.user_program = 2 )
order by c.course_name, u.user_lastname, u.user_firstname
;

-- All students, courses and programs with given grade
select u.user_id, u.user_firstname, u.user_lastname, g.grade_grade, g.course_id, c.course_name, u.user_program
from tbl_user u
left join tbl_grade g
on u.user_id = g.user_id
join tbl_course c
on g.course_id = c.course_id 
and u.usertype_id = 1
order by c.course_name, u.user_lastname, u.user_firstname
;

-- Find a specific users grade (Frida)
select u.user_id, u.user_firstname, u.user_lastname, g.grade_grade, g.course_id, c.course_name, u.user_program
from tbl_user u
left join tbl_grade g
on u.user_id = g.user_id
join tbl_course c
on g.course_id = c.course_id 
and (u.usertype_id = 1 and u.user_id = 6 and c.course_id = 1)
order by c.course_name, u.user_lastname, u.user_firstname
;

-- Find a specific users grade (Bosse)
select u.user_id, u.user_firstname, u.user_lastname, g.grade_grade, g.course_id, c.course_name, u.user_program
from tbl_user u
left join tbl_grade g
on u.user_id = g.user_id
join tbl_course c
on g.course_id = c.course_id 
and (u.usertype_id = 1 and u.user_id = 4 and c.course_id = 3)
order by c.course_name, u.user_lastname, u.user_firstname
;