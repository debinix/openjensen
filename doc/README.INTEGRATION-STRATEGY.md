## Integration strategy

The project mission is to integrate COBOL/postgresql and php/mysql.
Finished solution should contain COBOL, a web front-end and SQL back-end.


### Plan for integration

Keep COBOL and the PostgreSQL database manager. This part of the code have
a high dependency due to the pre-processor and the embedded SQL COBOL statements.

Phase 1: Replace mysql specific database php API functions mysql_* with
corresponding PostgreSQL php pg_* functions.

Phase 2: Adjust database schema by just *adding* required front-end tables.

Phase 3: Test the converted [web application live](http://mc-butter.se/index.php)

Phase 4: Discuss which Scrum stories to support and which to put in backlog.

Phase 5: Review database schema (i.e. merge tables) and decide on name
for each column- and variable-name (the front-end/back-end API).

Phase 6: Gradually replace php API pg_* functions with a solution based
on Common Gateway Interface (CGI) and use of HTML POSTs to COBOL back-end.


### php mysql-functions and postgresql-function for phase 1 port

Utility functions:

```
mysql_real_escape_string() --> pg_escape_literal()

mysql_connect() --> pg_connect()	

mysql_select_db() --> pg_connect()

```


SQL functions:

```
mysql_query() --> pg_query()

mysql_fetch_assoc() --> pg_fetch_assoc()

mysql_fetch_array() --> pg_fetch_array()

mysql_num_rows() --> pg_num_rows()

```


### File dump/grep of existing php mysql_* functions in front-end code

```
-------------------------
contact.php :

-------------------------
course.add.php :

$course_id = mysql_real_escape_string($_GET['course_id']);
$user_id = mysql_real_escape_string($_GET['user_id']);
$user_result = mysql_query("SELECT * FROM tbl_user WHERE user_id='".$user_id."' LIMIT 1");
$user_row = mysql_fetch_assoc($user_result);
-------------------------
course.edit.php :

$grade_id = mysql_real_escape_string($_GET['id']);
$grade_result = mysql_query("SELECT * FROM tbl_grade WHERE grade_id = '".$grade_id."' LIMIT 1");
$grade_row = mysql_fetch_assoc($grade_result);
-------------------------
course.php :

      $course_result = mysql_query("SELECT * FROM tbl_course WHERE program_id = '".$_SESSION['user_program']."'");
      while($course_row = mysql_fetch_array($course_result))
        $grade_result = mysql_query("SELECT grade_grade, grade_comment FROM tbl_grade WHERE user_id = '".$_SESSION['user_id']."' AND course_id = '".$course_row['course_id']."' LIMIT 1");
        $grade_row = mysql_fetch_assoc($grade_result);
  $course_result = mysql_query("SELECT * FROM tbl_course WHERE program_id = '".$_SESSION['user_program']."'");
  while($course_row = mysql_fetch_array($course_result))
        $user_result = mysql_query("SELECT user_firstname, user_lastname, user_id FROM tbl_user ORDER BY user_lastname, user_firstname");
        while ($user_row = mysql_fetch_array($user_result))
            $grade_result = mysql_query("SELECT grade_grade, grade_id FROM tbl_grade WHERE user_id = '".$user_row['user_id']."' AND course_id = '".$course_row['course_id']."' LIMIT 1");
            $grade_row = mysql_fetch_assoc($grade_result);
-------------------------
index.create.php :

-------------------------
index.delete.php :

$news_id = mysql_real_escape_string($_GET['news_id']);
mysql_query("DELETE FROM tbl_news WHERE news_id = '$news_id' LIMIT 1");
-------------------------
index.php :

$news_result = mysql_query("SELECT * FROM tbl_news ORDER BY news_id DESC");
while($news_row = mysql_fetch_array($news_result))
-------------------------
login.php :

-------------------------
logout.php :

-------------------------
process.php :

		$username = mysql_real_escape_string($_POST['username']);
		$password = mysql_real_escape_string($_POST['password']);
		$query = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' AND user_password = '$password'");
		$count = mysql_num_rows($query);
			$result = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' LIMIT 1");
			$row = mysql_fetch_assoc($result);
			$result = mysql_query($sql);
	$fname = mysql_real_escape_string($_POST['firstname']);
	$lname = mysql_real_escape_string($_POST['lastname']);
	$email = mysql_real_escape_string($_POST['email']);
	$phone = mysql_real_escape_string($_POST['phone']);
		mysql_query("UPDATE tbl_user SET user_firstname = '$fname', user_lastname = '$lname', user_email = '$email', user_phonenumber = '$phone' WHERE user_id = '$user_id'") or die(mysql_error());
		$result = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' LIMIT 1");
		$row = mysql_fetch_assoc($result);
	$user_id = mysql_real_escape_string($_GET['user_id']);
	$firstname = mysql_real_escape_string($_POST['firstname']);
	$lastname = mysql_real_escape_string($_POST['lastname']);
	$email = mysql_real_escape_string($_POST['email']);
	$phone = mysql_real_escape_string($_POST['phone']);
	$username = mysql_real_escape_string($_POST['username']);
	$password = mysql_real_escape_string($_POST['password']);
	$program = mysql_real_escape_string($_POST['program']);
		mysql_query("UPDATE tbl_user SET 
		WHERE user_id = '$user_id'") or die(mysql_error());
	$firstname = mysql_real_escape_string($_POST['firstname']);
	$lastname = mysql_real_escape_string($_POST['lastname']);
	$email = mysql_real_escape_string($_POST['email']);
	$phone = mysql_real_escape_string($_POST['phone']);
	$username = mysql_real_escape_string($_POST['username']);
	$password = mysql_real_escape_string($_POST['password']);
	$program = mysql_real_escape_string($_POST['program']);
	$usertype = mysql_real_escape_string($_POST['usertype']);
		mysql_query("INSERT INTO tbl_user (user_firstname, user_lastname, user_email, user_phonenumber, user_username, user_password, user_lastlogin, user_program, usertype_id) VALUES ('".$firstname."', '".$lastname."', '".$email."', '".$phone."', '".$username."', '".$password."', '0000-00-00 00:00:00', '".$program."', '".$usertype."')") or die(mysql_error());  
	$grade = mysql_real_escape_string($_POST['grade']);
	$grade_comment = mysql_real_escape_string($_POST['grade_comment']);
	$user_id = mysql_real_escape_string($_GET['user_id']);
	$course_id = mysql_real_escape_string($_GET['course_id']);
			$result = mysql_query("INSERT INTO tbl_grade (grade_grade, grade_comment, user_id, course_id) VALUES ('".$grade."', '".$grade_comment."', '".$user_id."', '".$course_id."')") or die(mysql_error());
	$grade = mysql_real_escape_string($_POST['grade']);
	$grade_comment = mysql_real_escape_string($_POST['grade_comment']);
	$grade_id = mysql_real_escape_string($_GET['grade_id']);
			mysql_query("UPDATE tbl_grade SET 
			WHERE grade_id = '$grade_id'") or die(mysql_error());
	$news_title = mysql_real_escape_string($_POST['news_title']);
	$news_content = mysql_real_escape_string($_POST['news_content']);
	$news_author = mysql_real_escape_string($_SESSION['user_id']);
		mysql_query("INSERT INTO tbl_news (news_title, news_content, news_author, news_date) VALUES ('".$news_title."', '".$news_content."', '".$news_author."', '".$date."')") or die(mysql_error());  
-------------------------
profile.php :

$result = mysql_query("SELECT * FROM tbl_user WHERE user_id='".$_SESSION['user_id']."' LIMIT 1");
$row = mysql_fetch_assoc($result);
-------------------------
program.php :

$program_result = mysql_query("SELECT * FROM tbl_program");
while($program_row = mysql_fetch_array($program_result))
      $course_result = mysql_query("SELECT * FROM tbl_course WHERE program_id = '".$program_row['program_id']."'");
      while($course_row = mysql_fetch_array($course_result))
-------------------------

users.create.php :

  $result = mysql_query("SELECT * FROM tbl_program");
  while($row = mysql_fetch_array($result))
  $result = mysql_query("SELECT * FROM tbl_usertype");
  while($row = mysql_fetch_array($result))
-------------------------
users.delete.php :

$user_id = mysql_real_escape_string($_GET['user_id']);
mysql_query("DELETE FROM tbl_user WHERE user_id = '$user_id' LIMIT 1");
-------------------------
users.edit.php :

$user_id = mysql_real_escape_string($_GET['user_id']);
$user_result = mysql_query("SELECT * FROM tbl_user WHERE user_id='".$user_id."' LIMIT 1");
$user_row = mysql_fetch_assoc($user_result);
  $result = mysql_query("SELECT * FROM tbl_program");
  while($row = mysql_fetch_array($result))
-------------------------
users.php :

      $result = mysql_query("SELECT * FROM tbl_user WHERE usertype_id = 1 ORDER BY user_lastname, user_firstname");
      $result = mysql_query("SELECT * FROM tbl_user ORDER BY user_lastname, user_firstname");
    while($row = mysql_fetch_array( $result ))
===========================
-------------------------
class.php :

		$result = mysql_query("SELECT id FROM users");
		$num_rows = mysql_num_rows($result);
			$result = mysql_query("SELECT program_name FROM tbl_program WHERE program_id = '".$_SESSION['user_program']."' LIMIT 1");
			$row = mysql_fetch_assoc($result);
			$result = mysql_query("SELECT program_name FROM tbl_program WHERE program_id = '".$id."' LIMIT 1");
			$row = mysql_fetch_assoc($result);
			$result = mysql_query("SELECT usertype_name FROM tbl_usertype WHERE usertype_id = '".$_SESSION['usertype_id']."' LIMIT 1");
			$row = mysql_fetch_assoc($result);
			$result = mysql_query("SELECT usertype_name FROM tbl_usertype WHERE usertype_id = '".$id."' LIMIT 1");
			$row = mysql_fetch_assoc($result);
			$result = mysql_query("SELECT username FROM users WHERE id = '".$_SESSION['user_id']."' LIMIT 1");
			$row = mysql_fetch_assoc($result);
			$result = mysql_query("SELECT username FROM users WHERE id = '".$id."' LIMIT 1");
			$row = mysql_fetch_assoc($result);
		$username = mysql_real_escape_string($username);
		$result = mysql_query("SELECT username FROM users WHERE username = '".$username."'");
		$num_rows = mysql_num_rows($result);
		$email = mysql_real_escape_string($email);
		$result = mysql_query("SELECT email FROM users WHERE email = '".$email."'");
		$num_rows = mysql_num_rows($result);
-------------------------
database.php :

mysql_connect("localhost", "root", "") or die(mysql_error());
mysql_select_db("scrum") or die(mysql_error());
mysql_query("SET NAMES utf8");
mysql_query("SET CHARACTER SET utf8");
-------------------------
_footer.php :

-------------------------
_header.php :

===========================
```

