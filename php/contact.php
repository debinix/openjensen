<?php include("assets/_header.php"); ?>
  <h1>Kontakta support</h1>
  <form method="POST" action="./process.php?function=contactSupport">
    <?php
    $Error->show();
    $Success->show();
    ?>
    <input type="text" name="title" class="form-control" placeholder="Ämne">
    <br>
    <textarea class="form-control" name="content" placeholder="Meddelande"></textarea>
    <br>
    <button class="btn btn-lg btn-primary" type="submit">Skicka mail</button>
  </form>
<?php include("assets/_footer.php"); ?>