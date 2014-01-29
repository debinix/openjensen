<?php
include('assets/class.php');

$news_id = mysql_real_escape_string($_GET['news_id']);

mysql_query("DELETE FROM tbl_news WHERE news_id = '$news_id' LIMIT 1");

$Success->set("Nyheten är nu borttagen.");
header('location: index.php');
?>