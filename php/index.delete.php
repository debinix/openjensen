<?php
include('assets/class.php');

$news_id = pg_escape_literal($_GET['news_id']);

// Not yet implemented in Cobol back-end

// pg_query("DELETE FROM tbl_news WHERE news_id = $news_id LIMIT 1");

$Success->set("Emma, Jessica, Peter och Bertil");
header('location: index.php');
?>