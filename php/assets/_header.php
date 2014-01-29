<?php
include("assets/class.php");

if($Check->loggedIn() == false)
{
  header('location: login.php');
}

?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SCRUM</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/main.css" rel="stylesheet">
  </head>
  <body>
    <div class="container">
      <div class="navbar navbar-default" role="navigation">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="index.php"><img src="assets/img/education_vit.png" alt="Jensen Logga"></a>
        </div>
        <div class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li><a href="index.php"><b>Nyheter</b></a></li>
            <li><a href="course.php"><b>Betyg</b></a></li>
            <?php if($_SESSION['usertype_id'] >= 3) { ?><li><a href="program.php">Program</a></li><?php } ?>
            <?php if($_SESSION['usertype_id'] >= 2) { ?><li><a href="users.php">Användare</a></li><?php } ?>
            <li><a href="contact.php"><b>Kontakt</b></a></li>
          </ul>
          <ul class="nav navbar-nav navbar-right">
            <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Inloggad som <b><?php echo $_SESSION['user_firstname']; ?></b><b class="caret"></b></a>
              <ul class="dropdown-menu">
                <li><a href="profile.php">Min profil</a></li>
                <li class="divider"></li>
                <li><a href="logout.php">Logga ut</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
      <div class="well">