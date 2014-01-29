<?php include("assets/_header.php"); ?>
<a href="users.php"><span class="label label-default">Tillbaka</span></a>
<?php
$user_id = mysql_real_escape_string($_GET['user_id']);
$user_result = mysql_query("SELECT * FROM tbl_user WHERE user_id='".$user_id."' LIMIT 1");
$user_row = mysql_fetch_assoc($user_result);
?>
<h1><?php echo $user_row['user_firstname']." ".$user_row['user_lastname'] ?></h1>
<form method="POST" action="./process.php?function=editUser&user_id=<?php echo $user_row['user_id']; ?>">
  <?php
  $Error->show();
  $Success->show();
  ?>
  <input type="text" name="firstname" class="form-control" placeholder="Förnamn" value="<?php echo $user_row['user_firstname'] ?>">
  <br>
  <input type="text" name="lastname" class="form-control" placeholder="Efternamn" value="<?php echo $user_row['user_lastname'] ?>">
  <br>
  <input type="text" name="email" class="form-control" placeholder="Email" value="<?php echo $user_row['user_email'] ?>">
  <br>
  <input type="text" name="phone" class="form-control" placeholder="Telefonnummer" value="<?php echo $user_row['user_phonenumber'] ?>">
  <br>
  <input type="text" name="username" class="form-control" placeholder="Användarnamn" value="<?php echo $user_row['user_username'] ?>">
  <br>
  <input type="text" name="password" class="form-control" placeholder="Lösenord" value="<?php echo $user_row['user_password'] ?>">
  <?php 
  $result = mysql_query("SELECT * FROM tbl_program");
  while($row = mysql_fetch_array($result))
  {
    ?>
    <div class="radio">
      <label>
        <input type="radio" name="program" id="<?php echo $row['program_id']; ?>" value="<?php echo $row['program_id']; ?>" <?php if($user_row['user_program'] == $row['program_id']) { echo "checked"; } ?>><?php echo $row['program_name']; ?>
      </label>
    </div>
    <?php
  }
  ?>
  <br>
  <button class="btn btn-lg btn-primary" type="submit">Spara ändringar</button> <a class="btn btn-danger btn-lg" href="users.delete.php?user_id=<?php echo $user_id; ?>">Radera användare</a>
</form>
<?php include("assets/_footer.php"); ?>
