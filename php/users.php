<?php include("assets/_header.php"); ?>
<?php if($_SESSION['usertype_id'] >= 3) { ?><a href="users.create.php"><span class="label label-primary">Skapa en användare</span></a><?php } ?>
<h1>Användare</h1>
<?php
$Error->show();
$Success->show();
?>
<table class="table table-hover">
  <thead>
    <tr>
      <td><strong>Rank</strong></td>
      <td><strong>Förnamn</strong></td>
      <td><strong>Efternamn</strong></td>
      <td><strong>Program</strong></td>
      <td><strong>Email</strong></td>
      <td><strong>Telefonnummer</strong></td>
      <td><strong>Senast aktiv</strong></td>
    </tr>
  </thead>
  <tbody>
    <?php
    if($_SESSION['usertype_id'] == 2)
    {
      $result = mysql_query("SELECT * FROM tbl_user WHERE usertype_id = 1 ORDER BY user_lastname, user_firstname");
    }
    else
    {
      $result = mysql_query("SELECT * FROM tbl_user ORDER BY user_lastname, user_firstname");
    }
    while($row = mysql_fetch_array( $result ))
    {
      ?>
      <tr>
        <td><?php echo $Users->usertype($row['usertype_id']); ?></td>
        <td><?php echo $row['user_firstname']; ?></td>
        <td><?php echo $row['user_lastname']; ?></td>
        <td><?php echo $Users->program($row['user_program']); ?></td>
        <td><?php echo $row['user_email']; ?></td>
        <td><?php echo $row['user_phonenumber']; ?></td>
        <td><?php if($row['user_lastlogin'] == "0000-00-00 00:00:00") { echo "Aldrig"; } else { echo $row['user_lastlogin']; } ?></td>
        <?php if($_SESSION['usertype_id'] >= 3) { ?><td><a href="users.edit.php?user_id=<?php echo $row['user_id']; ?>"><span class="label label-info">Ändra</span></a></td><?php } ?>
      </tr>
      <?php
    }
    ?>
  </tbody>
</table>
<?php include("assets/_footer.php"); ?>