<?php
include('database.php');

class Error {
	function show() {
		if(@$_SESSION['error']){
			echo '<div class="alert alert-danger">'.@$_SESSION['error'].'</div>';
			unset($_SESSION['error']);
		}
	}

	function set($error) {
		$_SESSION['error'] = $error;
	}
}

class Success {
	function show() {
		if(@$_SESSION['success']){
			echo '<div class="alert alert-success">'.@$_SESSION['success'].'</div>';
			unset($_SESSION['success']);
		}
	}

	function set($success) {
		$_SESSION['success'] = $success;
	}
}

class Admin
{

}

class Count 
{
	function users()
	{
		$result = mysql_query("SELECT id FROM users");
		$num_rows = mysql_num_rows($result);

		if($num_rows < 1){
			return 0;
		} else {
			return $num_rows;
		}
	}
}

class Users
{
	function program($id)
	{
		if(empty($id))
		{
			$result = mysql_query("SELECT program_name FROM tbl_program WHERE program_id = '".$_SESSION['user_program']."' LIMIT 1");
			$row = mysql_fetch_assoc($result);

			return $row['program_name'];
		}
		else
		{
			$result = mysql_query("SELECT program_name FROM tbl_program WHERE program_id = '".$id."' LIMIT 1");
			$row = mysql_fetch_assoc($result);

			return $row['program_name'];
		}
	}

	function usertype($id)
	{
		if(empty($id))
		{
			$result = mysql_query("SELECT usertype_name FROM tbl_usertype WHERE usertype_id = '".$_SESSION['usertype_id']."' LIMIT 1");
			$row = mysql_fetch_assoc($result);

			return $row['usertype_name'];
		}
		else
		{
			$result = mysql_query("SELECT usertype_name FROM tbl_usertype WHERE usertype_id = '".$id."' LIMIT 1");
			$row = mysql_fetch_assoc($result);

			return $row['usertype_name'];
		}
	}

	function username($id)
	{
		if(empty($id))
		{
			$result = mysql_query("SELECT username FROM users WHERE id = '".$_SESSION['user_id']."' LIMIT 1");
			$row = mysql_fetch_assoc($result);

			return $row['username'];
		}
		else
		{
			$result = mysql_query("SELECT username FROM users WHERE id = '".$id."' LIMIT 1");
			$row = mysql_fetch_assoc($result);

			return $row['username'];
		}
	}
}

class Check
{
	function loggedIn()
	{
		if(!isset($_SESSION['username']) OR !isset($_SESSION['user_id']))
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	function username($username)
	{
		$username = mysql_real_escape_string($username);

		$result = mysql_query("SELECT username FROM users WHERE username = '".$username."'");
		$num_rows = mysql_num_rows($result);

		if($num_rows < 1){
			return "0";
		} else {
			return $num_rows;
		}
	}

	function email($email)
	{
		$email = mysql_real_escape_string($email);

		$result = mysql_query("SELECT email FROM users WHERE email = '".$email."'");
		$num_rows = mysql_num_rows($result);

		if($num_rows < 1){
			return "0";
		} else {
			return $num_rows;
		}
	}

	function length($input)
	{
		$count = strlen($input);
		return $count;
	}
}

$Error = new Error;
$Success = new Success;
$Admin = new Admin;
$Count = new Count;
$Users = new Users;
$Check = new Check;
?>