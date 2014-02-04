<?php
include('assets/class.php');

$user_id = pg_escape_literal($_GET['user_id']);

// mysql_query("DELETE FROM tbl_user WHERE user_id = '$user_id' LIMIT 1");

pg_query("DELETE FROM tbl_user WHERE user_id = $user_id LIMIT 1");

$Success->set("Användaren är nu borttagen.");
header('location: users.php');
?>