<?php
// mysql_connect("localhost", "root", "") or die(mysql_error());
// mysql_select_db("scrum") or die(mysql_error());
pg_connect("host=localhost dbname=openjensen user=jensen") or die('Could not connect: ' . pg_last_error());

// mysql_query("SET NAMES utf8");
pg_query("SET NAMES UTF8");

// mysql_query("SET CHARACTER SET utf8");

session_start();
?>