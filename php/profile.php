<?php
include("assets/_header.php");
$result = mysql_query("SELECT * FROM tbl_user WHERE user_id='".$_SESSION['user_id']."' LIMIT 1");
$row = mysql_fetch_assoc($result);
?>
<h1><?php echo $row['user_firstname']." ".$row['user_lastname'] ?></h1>
<form method="POST" action="./process.php?function=editProfile">
    <?php
    $Error->show();
    $Success->show();
    ?>
    <input type="text" name="firstname" class="form-control" placeholder="Förnamn" value="<?php echo $row['user_firstname'] ?>">
    <br>
    <input type="text" name="lastname" class="form-control" placeholder="Efternamn" value="<?php echo $row['user_lastname'] ?>">
    <br>
    <input type="text" name="email" class="form-control" placeholder="Email" value="<?php echo $row['user_email'] ?>">
    <br>
    <input type="text" name="phone" class="form-control" placeholder="Telefonnummer" value="<?php echo $row['user_phonenumber'] ?>">
    <br>
    <button class="btn btn-lg btn-primary" type="submit">Spara ändringar</button>
</form>
<?php include("assets/_footer.php"); ?>