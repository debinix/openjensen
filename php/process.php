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
		$username = pg_escape_literal($_POST['username']);
		$password = pg_escape_literal($_POST['password']);

		// $query = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' AND user_password = '$password'");
		// $count = mysql_num_rows($query);
		
		$query = pg_query("SELECT * FROM tbl_user WHERE user_username = $username AND user_password = $password");
		$count = pg_num_rows($query);		

		if($count == 1)
		{
			// $result = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' LIMIT 1");
			// $row = mysql_fetch_assoc($result);
			
			$result = pg_query("SELECT * FROM tbl_user WHERE user_username = $username LIMIT 1");
			$row = pg_fetch_assoc($result);			
			
			$date = date('Y-m-d');
			
			// $sql = "UPDATE tbl_user SET user_lastlogin = '".$date."' WHERE user_id = ".$row['user_id'];
			// $result = mysql_query($sql);

			$sql = "UPDATE tbl_user SET user_lastlogin = '".$date."' WHERE user_id = ".$row['user_id'];
			$result = pg_query($sql);			
			
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

	$fname = pg_escape_literal($_POST['firstname']);
	$lname = pg_escape_literal($_POST['lastname']);
	$email = pg_escape_literal($_POST['email']);
	$phone = pg_escape_literal($_POST['phone']);	

	if(empty($fname) OR empty($lname) OR empty($email) OR empty($phone))
	{
		$Error->set("Alla fält måste vara ifyllda.");
		header('location: profile.php');
	}
	else
	{
		$user_id = $_SESSION['user_id'];

		// mysql_query("UPDATE tbl_user SET user_firstname = '$fname', user_lastname = '$lname', user_email = '$email', user_phonenumber = '$phone' WHERE user_id = '$user_id'") or die(mysql_error());

		pg_query("UPDATE tbl_user SET user_firstname = $fname, user_lastname = $lname, user_email = $email, user_phonenumber = $phone WHERE user_id = $user_id") or die(mysql_error());
		
		$username = $_SESSION['username'];
		
		// $result = mysql_query("SELECT * FROM tbl_user WHERE user_username = '$username' LIMIT 1");
		// $row = mysql_fetch_assoc($result);
		
		$result = pg_query("SELECT * FROM tbl_user WHERE user_username = $username LIMIT 1");
		$row = pg_fetch_assoc($result);	

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

	$user_id = pg_escape_literal($_GET['user_id']);
	$firstname = pg_escape_literal($_POST['firstname']);
	$lastname = pg_escape_literal($_POST['lastname']);
	$email = pg_escape_literal($_POST['email']);
	$phone = pg_escape_literal($_POST['phone']);
	$username = pg_escape_literal($_POST['username']);
	$password = pg_escape_literal($_POST['password']);
	$program = pg_escape_literal($_POST['program']);
	

	if(empty($user_id) OR empty($firstname) OR empty($lastname) OR empty($email) OR empty($phone) OR empty($username) OR empty($password) OR empty($program))
	{
		$Error->set("Alla fält måste vara ifyllda.");
		header('location: users.edit.php?user_id='.$user_id);
	}
	else
	{
		//mysql_query("UPDATE tbl_user SET 
		//	user_firstname = '$firstname',
		//	user_lastname = '$lastname',
		//	user_email = '$email',
		//	user_phonenumber = '$phone',
		//	user_username = '$username',
		//	user_password = '$password',
		//	user_program = '$program'
		//WHERE user_id = '$user_id'") or die(mysql_error());
		
		pg_query("UPDATE tbl_user SET 
			user_firstname = $firstname,
			user_lastname = $lastname,
			user_email = $email,
			user_phonenumber = $phone,
			user_username = $username,
			user_password = $password,
			user_program = $program
		WHERE user_id = $user_id") or die(pg_last_error());		

		$Success->set("Användarens uppgifter har nu ändrats.");
		header('location: users.edit.php?user_id='.$user_id);
	}
}
elseif($function == "addUser")
{
	$firstname = pg_escape_literal($_POST['firstname']);
	$lastname = pg_escape_literal($_POST['lastname']);
	$email = pg_escape_literal($_POST['email']);
	$phone = pg_escape_literal($_POST['phone']);
	$username = pg_escape_literal($_POST['username']);
	$password = pg_escape_literal($_POST['password']);
	$program = pg_escape_literal($_POST['program']);
	$usertype = pg_escape_literal($_POST['usertype']);

	if(empty($firstname) OR empty($lastname) OR empty($email) OR empty($phone) OR empty($username) OR empty($password) OR empty($program) OR empty($usertype))
	{
		$Error->set("Alla fält måste vara ifyllda.");
		header('location: users.create.php');
	}
	else
	{
		// mysql_query("INSERT INTO tbl_user (user_firstname, user_lastname, user_email, user_phonenumber, user_username, user_password, user_lastlogin, user_program, usertype_id) VALUES ('".$firstname."', '".$lastname."', '".$email."', '".$phone."', '".$username."', '".$password."', '0000-00-00 00:00:00', '".$program."', '".$usertype."')") or die(mysql_error());  
		pg_query("INSERT INTO tbl_user (user_firstname, user_lastname, user_email, user_phonenumber, user_username, user_password, user_lastlogin, user_program, usertype_id)
				 VALUES ('".$firstname."', '".$lastname."', '".$email."', '".$phone."', '".$username."', '".$password."', '1970-01-01 00:00:00', '".$program."', '".$usertype."')") or die(pg_last_error());  

		
		$Success->set("Användarens uppgifter har nu ändrats.");
		header('location: users.php');
	}
}
elseif($function == "addGrade")
{

	$user_id = pg_escape_literal($_GET['user_id']);
	$course_id = pg_escape_literal($_GET['course_id']);
	
	// POST data via form
	$grade_grade = pg_escape_literal($_POST['grade']);
	$grade_comment = pg_escape_literal($_POST['grade_comment']);	

	if(empty($user_id) OR empty($course_id))
	{
		$Error->set("Något gick fel, försök igen.");
		header('location: course.php');	
	}
	else
	{
		if(empty($grade_grade) OR empty($grade_comment))
		{
			$Error->set("Du måste sätta ett betyg och lämna en kommentar på eleven.");
			header('location: users.create.php');	
		}
		else
		{
			
			$url = 'http://www.mc-butter.se/cgi-bin/cgi-add-betyg.cgi';
			$fields = array( 'grade_grade' => $grade_grade,
							 'grade_comment' => $grade_comment,
							 'user_id' => $user_id,
							 'course_id' => $course_id
							);
			// url-ify the data for the POST with php built-in function
			$php_url_string = http_build_query($fields);
			// remove %27 i.e. the ' which php adds around post string :-( 
			$fields_string = preg_replace('/%27/', '', $php_url_string);
			//open connection
			$ch = curl_init();
			
			//set the url, number of POST vars, POST data
			curl_setopt($ch,CURLOPT_URL, $url);
			curl_setopt($ch,CURLOPT_POST, count($fields));
			curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
			
			//execute post
			$result = curl_exec($ch);
			if($result === false) $Error->set("Kan ej kontakta servern: $url") ;
			
			// We dont really know status (TODO implement)
			$Success->set("Ett nytt betyget har nu satts.");
			
			//close connection
			curl_close($ch);
			
			// move back to main course page to re-read change
			header('location: course.php');				
			
			
		}
	}
}
elseif($function == "editGrade")
{
	$grade_id = pg_escape_literal($_GET['grade_id']);
	
	// POST data via form
	$grade_grade = pg_escape_literal($_POST['grade']);
	$grade_comment = pg_escape_literal($_POST['grade_comment']);

	if(empty($grade_id))
	{
		$Error->set("Något gick fel, försök igen.");
		header('location: course.php');	
	}
	else
	{
		if(empty($grade_grade) OR empty($grade_comment))
		{
			$Error->set("Du måste sätta ett betyg och lämna en kommentar på eleven.");
			header('location: course.edit.php?id='.$grade_id);	
		}
		else
		{				
			$url = 'http://www.mc-butter.se/cgi-bin/cgi-edit-betyg.cgi';
			$fields = array( 'grade_id' => $grade_id,
							 'grade_grade' => $grade_grade,
							 'grade_comment' => $grade_comment
							);
			// url-ify the data for the POST with php built-in function
			$php_url_string = http_build_query($fields);
			// remove %27 i.e. the ' which php adds around post string :-( 
			$fields_string = preg_replace('/%27/', '', $php_url_string);
			//open connection
			$ch = curl_init();
			
			//set the url, number of POST vars, POST data
			curl_setopt($ch,CURLOPT_URL, $url);
			curl_setopt($ch,CURLOPT_POST, count($fields));
			curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
			
			//execute post
			$result = curl_exec($ch);
			if($result === false) $Error->set("Kan ej kontakta servern: $url") ;
			
			// We dont really know status (TODO implement)
			$Success->set("Betyget har nu ändrats.");
			
			//close connection
			curl_close($ch);
			
			// move back to main course page to re-read change
			header('location: course.php');	
			

		}
	}
}
elseif($function == "addNews")
{
	$news_title = pg_escape_literal($_POST['news_title']);
	$news_content = pg_escape_literal($_POST['news_content']);
	$news_author = pg_escape_literal($_SESSION['user_id']);

	if(empty($news_author) OR empty($news_content) OR empty($news_title))
	{
		$Error->set("Fyll i alla fält.");
		header('location: index.create.php');	
	}
	else
	{
		$date = date('H:i:s - Y/m/d');
		mysql_query("INSERT INTO T_NYHETER (news_title, news_content, news_author, news_date) VALUES ('".$news_title."', '".$news_content."', '".$news_author."', '".$date."')") or die(pg_last_error());  

		$Success->set("Nyheten har skapats.");
		header('location: index.php');
	}
}
else
{
	header('location: /index.php');
}
?>