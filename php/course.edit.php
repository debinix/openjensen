<?php include("assets/_header.php"); ?>
<a href="course.php"><span class="label label-default">Tillbaka</span></a>
<?php
$grade_id = mysql_real_escape_string($_GET['id']);

$grade_result = mysql_query("SELECT * FROM tbl_grade WHERE grade_id = '".$grade_id."' LIMIT 1");
$grade_row = mysql_fetch_assoc($grade_result);
?>
<form method="POST" action="./process.php?function=editGrade&grade_id=<?php echo $grade_id; ?>">
  <?php
  $Error->show();
  $Success->show();
  ?>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="IG" <?php if($grade_row['grade_grade'] == "IG") { echo "checked"; } ?>>IG</label>
  </div>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="G" <?php if($grade_row['grade_grade'] == "G") { echo "checked"; } ?>>G</label>
  </div>
  <div class="radio">
    <label><input type="radio" name="grade" id="grade" value="VG" <?php if($grade_row['grade_grade'] == "VG") { echo "checked"; } ?>>VG</label>
  </div>
  <br>
  <input type="text" name="grade_comment" class="form-control" placeholder="Kommentar" value="<?php echo $grade_row['grade_comment']; ?>">
  <br>
  <button class="btn btn-lg btn-primary" type="submit">Spara ändringar</button>
</form>
<?php include("assets/_footer.php"); ?>
