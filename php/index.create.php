<?php include("assets/_header.php"); ?>
<a href="index.php"><span class="label label-default">Tillbaka</span></a>
<h1>Skriv en nyhet</h1>
<form method="POST" action="./process.php?function=addNews">
  <?php
  $Error->show();
  $Success->show();
  ?>
  <input type="text" name="news_title" class="form-control" placeholder="Ämne">
  <br>
  <textarea class="form-control" name="news_content" placeholder="Innehåll"></textarea>
  <br>
  <button class="btn btn-lg btn-primary" type="submit">Skapa nyhet</button>
</form>
<?php include("assets/_footer.php"); ?>