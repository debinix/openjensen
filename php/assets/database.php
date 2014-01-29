<?php
mysql_connect("localhost", "root", "") or die(mysql_error());
mysql_select_db("scrum") or die(mysql_error());

mysql_query("SET NAMES utf8");
mysql_query("SET CHARACTER SET utf8");

session_start();
?>