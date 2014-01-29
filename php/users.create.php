<?php include("assets/_header.php"); ?>
<a href="users.php"><span class="label label-default">Tillbaka</span></a>
<h1>Ny användare</h1>
<form method="POST" action="./process.php?function=addUser">
  <?php
  $Error->show();
  $Success->show();
  ?>
  <input type="text" name="firstname" class="form-control" placeholder="Förnamn">
  <br>
  <input type="text" name="lastname" class="form-control" placeholder="Efternamn">
  <br>
  <input type="text" name="email" class="form-control" placeholder="Email">
  <br>
  <input type="text" name="phone" class="form-control" placeholder="Telefonnummer">
  <br>
  <input type="text" name="username" class="form-control" placeholder="Användarnmn">
  <br>
  <input type="text" name="password" class="form-control" placeholder="Lösenord">
  <br>
  <p><strong>Program</strong></p>
  <?php 
  $result = mysql_query("SELECT * FROM tbl_program");
  while($row = mysql_fetch_array($result))
  {
    ?>
    <div class="radio">
      <label>
        <input type="radio" name="program" id="<?php echo $row['program_id']; ?>" value="<?php echo $row['program_id']; ?>"><?php echo $row['program_name']; ?>
      </label>
    </div>
    <?php
  }
  ?>
  <br>
  <p><strong>Rank</strong></p>
  <?php
  $result = mysql_query("SELECT * FROM tbl_usertype");
  while($row = mysql_fetch_array($result))
  {
    ?>
    <div class="radio">
      <label>
        <input type="radio" name="usertype" id="<?php echo $row['usertype_id']; ?>" value="<?php echo $row['usertype_id']; ?>"><?php echo $row['usertype_name']; ?>
      </label>
    </div>
    <?php
  }
  ?>
  <button class="btn btn-lg btn-primary" type="submit">Skapa användare</button>
</form>
<?php include("assets/_footer.php"); ?>