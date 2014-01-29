<?php
include('assets/class.php');

$function = $_GET['function'];

if($function == "Login")
{
	if(empty($_POST['username']) OR empty($_POST['password']))
	{
		$Error->set("Fyll i alla fällt.");
		header('location: /login.php');
	}
	else
	{
		$username = mysql_real_escape_string($_POST['username']);
		$password = mysql_real_escape_string($_POST['password']);

		$query = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' AND user_password = '$password'");
		$count = mysql_num_rows($query);

		if($count == 1)
		{
			$result = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' LIMIT 1");
			$row = mysql_fetch_assoc($result);

			$date = date('Y-m-d H:i:s');
			$sql = "UPDATE tbl_user SET user_lastlogin = '".$date."' WHERE user_id = ".$row['user_id'];
			$result = mysql_query($sql);

			$_SESSION['username'] = $username;
			$_SESSION['user_id'] = $row['user_id'];
			$_SESSION['user_firstname'] = $row['user_firstname'];
			$_SESSION['user_lastname'] = $row['user_lastname'];
			$_SESSION['user_program'] = $row['user_program'];
			$_SESSION['usertype_id'] = $row['usertype_id'];
			header('location: index.php');
		}
		else
		{
			$Error->set("Fel användarnamn eller lösenord.");
			header("Location: /login.php");
		}
	}
}
elseif($function == "editProfile")
{
	$fname = mysql_real_escape_string($_POST['firstname']);
	$lname = mysql_real_escape_string($_POST['lastname']);
	$email = mysql_real_escape_string($_POST['email']);
	$phone = mysql_real_escape_string($_POST['phone']);

	if(empty($fname) OR empty($lname) OR empty($email) OR empty($phone))
	{
		$Error->set("Alla fält måste vara ifyllda.");
		header('location: profile.php');
	}
	else
	{
		$user_id = $_SESSION['user_id'];

		mysql_query("UPDATE tbl_user SET user_firstname = '$fname', user_lastname = '$lname', user_email = '$email', user_phonenumber = '$phone' WHERE user_id = '$user_id'") or die(mysql_error());

		$username = $_SESSION['username'];
		$result = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' LIMIT 1");
		$row = mysql_fetch_assoc($result);

		$_SESSION['user_id'] = $row['user_id'];
		$_SESSION['user_firstname'] = $row['user_firstname'];
		$_SESSION['user_lastname'] = $row['user_lastname'];
		$_SESSION['user_program'] = $row['user_program'];
		$_SESSION['usertype_id'] = $row['usertype_id'];

		$Success->set("Alla ändringar sparades.");
		header('location: profile.php');
	}
}
elseif($function == "contactSupport")
{
	if(empty($_POST['title']) OR empty($_POST['content']))
	{
		$Error->set("Alla fält måste vara ifyllda.");
		header('location: contact.php');
	}
	else
	{
		$to      = 'support@example.com';
		$subject = $_POST['title'];
		$message = $_POST['content']."\r\n Mvh ".$_SESSION['fname']." ".$_SESSION['lname'];
		$headers = 'From: webmaster@example.com' . "\r\n" .
		    'Reply-To: webmaster@example.com' . "\r\n" .
		    'X-Mailer: PHP/' . phpversion();

		mail($to, $subject, $message, $headers);

		$Success->set("Mailet har nu skickats iväg till supporten.<br>Vänligen kolla din mail för svar ifrån supporten.");
		header('location: contact.php');
	}
}
elseif($function == "editUser")
{
	$user_id = mysql_real_escape_string($_GET['user_id']);
	$firstname = mysql_real_escape_string($_POST['firstname']);
	$lastname = mysql_real_escape_string($_POST['lastname']);
	$email = mysql_real_escape_string($_POST['email']);
	$phone = mysql_real_escape_string($_POST['phone']);
	$username = mysql_real_escape_string($_POST['username']);
	$password = mysql_real_escape_string($_POST['password']);
	$program = mysql_real_escape_string($_POST['program']);

	if(empty($user_id) OR empty($firstname) OR empty($lastname) OR empty($email) OR empty($phone) OR empty($username) OR empty($password) OR empty($program))
	{
		$Error->set("Alla fält måste vara ifyllda.");
		header('location: users.edit.php?user_id='.$user_id);
	}
	else
	{
		mysql_query("UPDATE tbl_user SET 
			user_firstname = '$firstname',
			user_lastname = '$lastname',
			user_email = '$email',
			user_phonenumber = '$phone',
			user_username = '$username',
			user_password = '$password',
			user_program = '$program'
		WHERE user_id = '$user_id'") or die(mysql_error());

		$Success->set("Användarens uppgifter har nu ändrats.");
		header('location: users.edit.php?user_id='.$user_id);
	}
}
elseif($function == "addUser")
{
	$firstname = mysql_real_escape_string($_POST['firstname']);
	$lastname = mysql_real_escape_string($_POST['lastname']);
	$email = mysql_real_escape_string($_POST['email']);
	$phone = mysql_real_escape_string($_POST['phone']);
	$username = mysql_real_escape_string($_POST['username']);
	$password = mysql_real_escape_string($_POST['password']);
	$program = mysql_real_escape_string($_POST['program']);
	$usertype = mysql_real_escape_string($_POST['usertype']);

	if(empty($firstname) OR empty($lastname) OR empty($email) OR empty($phone) OR empty($username) OR empty($password) OR empty($program) OR empty($usertype))
	{
		$Error->set("Alla fält måste vara ifyllda.");
		header('location: users.create.php');
	}
	else
	{
		mysql_query("INSERT INTO tbl_user (user_firstname, user_lastname, user_email, user_phonenumber, user_username, user_password, user_lastlogin, user_program, usertype_id) VALUES ('".$firstname."', '".$lastname."', '".$email."', '".$phone."', '".$username."', '".$password."', '0000-00-00 00:00:00', '".$program."', '".$usertype."')") or die(mysql_error());  

		$Success->set("Användarens uppgifter har nu ändrats.");
		header('location: users.php');
	}
}
elseif($function == "addGrade")
{
	$grade = mysql_real_escape_string($_POST['grade']);
	$grade_comment = mysql_real_escape_string($_POST['grade_comment']);
	$user_id = mysql_real_escape_string($_GET['user_id']);
	$course_id = mysql_real_escape_string($_GET['course_id']);

	if(empty($user_id) OR empty($course_id))
	{
		$Error->set("Något gick fel, försök igen.");
		header('location: course.php');	
	}
	else
	{
		if(empty($grade) OR empty($grade_comment))
		{
			$Error->set("Du måste sätta ett betyg och lämna en kommentar på eleven.");
			header('location: users.create.php');	
		}
		else
		{
			$result = mysql_query("INSERT INTO tbl_grade (grade_grade, grade_comment, user_id, course_id) VALUES ('".$grade."', '".$grade_comment."', '".$user_id."', '".$course_id."')") or die(mysql_error());

			if($result)
			{
				$Success->set("Betyget har nu satts.");
				header('location: course.php');
			}
		}
	}
}
elseif($function == "editGrade")
{
	$grade = mysql_real_escape_string($_POST['grade']);
	$grade_comment = mysql_real_escape_string($_POST['grade_comment']);
	$grade_id = mysql_real_escape_string($_GET['grade_id']);

	if(empty($grade_id))
	{
		$Error->set("Något gick fel, försök igen.");
		header('location: course.php');	
	}
	else
	{
		if(empty($grade) OR empty($grade_comment))
		{
			$Error->set("Du måste sätta ett betyg och lämna en kommentar på eleven.");
			header('location: course.edit.php?id='.$grade_id);	
		}
		else
		{
			mysql_query("UPDATE tbl_grade SET 
				grade_grade = '$grade',
				grade_comment = '$grade_comment'
			WHERE grade_id = '$grade_id'") or die(mysql_error());

			$Success->set("Betyget har nu ändrats.");
			header('location: course.edit.php?id='.$grade_id);
		}
	}
}
elseif($function == "addNews")
{
	$news_title = mysql_real_escape_string($_POST['news_title']);
	$news_content = mysql_real_escape_string($_POST['news_content']);
	$news_author = mysql_real_escape_string($_SESSION['user_id']);

	if(empty($news_author) OR empty($news_content) OR empty($news_title))
	{
		$Error->set("Fyll i alla fält.");
		header('location: index.create.php');	
	}
	else
	{
		$date = date('H:i:s - Y/m/d');
		mysql_query("INSERT INTO tbl_news (news_title, news_content, news_author, news_date) VALUES ('".$news_title."', '".$news_content."', '".$news_author."', '".$date."')") or die(mysql_error());  

		$Success->set("Nyheten har skapats.");
		header('location: index.php');
	}
}
else
{
	header('location: /index.php');
}
?>