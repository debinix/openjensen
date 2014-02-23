<?php include("assets/_header.php"); ?>
<a href="course.php"><span class="label label-default">Tillbaka</span></a>
<?php
$course_id = $_GET['course_id'];
$user_id = $_GET['user_id'];
$user_firstname = $_GET['user_firstname'];
$user_lastname = $_GET['user_lastname'];

?>
<h3><?php echo $user_firstname." ".$user_lastname ?></h3>
<form method="POST" action="./process.php?function=addGrade&user_id=<?php echo $user_id; ?>&course_id=<?php echo $course_id; ?>">
  <?php
  $Error->show();
  $Success->show();
  ?>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="IG">IG</label>
  </div>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="G">G</label>
  </div>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="VG">VG</label>
  </div>
  <br>
  <input type="text" name="grade_comment" class="form-control" placeholder="Kommentar">
  <br>
  <button class="btn btn-lg btn-primary" type="submit">Ge betyg</button>
</form>
<?php include("assets/_footer.php"); ?>
