<?php include("assets/_header.php"); ?>
<h1>Program</h1>
<?php
$program_result = mysql_query("SELECT * FROM tbl_program");
while($program_row = mysql_fetch_array($program_result))
{
  ?>
  <h3><?php echo $program_row['program_name']; ?></h3>
  <table class="table table-hover">
    <thead>
      <tr>
        <td><strong>Namn</strong></td>
        <td><strong>Start</strong></td>
        <td><strong>Slut</strong></td>
      </tr>
    </thead>
    <tbody>
      <?php
      $course_result = mysql_query("SELECT * FROM tbl_course WHERE program_id = '".$program_row['program_id']."'");
      while($course_row = mysql_fetch_array($course_result))
      {
        ?>
        <tr>
          <td><?php echo $course_row['course_name']; ?></td>
          <td><?php echo $course_row['course_startdate']; ?></td>
          <td><?php echo $course_row['course_enddate']; ?></td>
        </tr>
        <?php
      }
      ?>
    </tbody>
  </table>
  <?php
}
?>

<?php include("assets/_footer.php"); ?>