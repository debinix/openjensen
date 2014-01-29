<?php include("assets/_header.php"); ?>
<?php if($_SESSION['usertype_id'] >= 3) { ?><a href="index.create.php"><span class="label label-primary">Skriv en nyhet</span></a><?php } ?>
<?php
$Error->show();
$Success->show();

$news_result = mysql_query("SELECT * FROM tbl_news ORDER BY news_id DESC");
while($news_row = mysql_fetch_array($news_result))
{
	?>
	<h1><?php echo $news_row['news_title']; ?></h1>
	<p><?php echo $news_row['news_content']; ?></p>
	<span class="label label-info"><?php echo $news_row['news_date']; ?></span> <?php if($_SESSION['usertype_id'] >= 3) { ?><a href="index.delete.php?news_id=<?php echo $news_row['news_id']; ?>"><span class="label label-danger">Ta bort</span></a><?php } ?>
	<hr>
	<?php
}

include("assets/_footer.php");
?>