<?php include("assets/_header.php"); ?>
<a href="course.php"><span class="label label-default">Tillbaka</span></a>
<?php
$grade_id = $_GET['id'];
$grade_grade = $_GET['grade_grade'];
$grade_comment = $_GET['grade_comment'];

?>
<form method="POST" action="./process.php?function=editGrade&grade_id=<?php echo $grade_id; ?>&grade_grade=<?php echo $grade_grade; ?>">
  <?php
  $Error->show();
  $Success->show();
  ?>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="IG" <?php if($grade_grade == "IG") { echo "checked"; } ?>>IG</label>
  </div>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="G" <?php if($grade_grade == "G") { echo "checked"; } ?>>G</label>
  </div>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="VG" <?php if($grade_grade == "VG") { echo "checked"; } ?>>VG</label>
  </div>
  <br>
  <input type="text" name="grade_comment" class="form-control" placeholder="Kommentar" value="<?php echo $grade_comment; ?>">
  <br>
  <button class="btn btn-lg btn-primary" type="submit">Spara ändringar</button>
</form>
<?php include("assets/_footer.php"); ?>
