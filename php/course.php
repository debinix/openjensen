<?php
include("assets/_header.php");

if($_SESSION['usertype_id'] == 1)
{
  ?>
  <h1>Betyg</h1>
  <?php
  $Error->show();
  $Success->show();
  ?>
  <table class="table table-hover">
    <thead>
      <tr>
        <td><strong>Namn</strong></td>
        <td><strong>Start</strong></td>
        <td><strong>Slut</strong></td>
        <td><strong>Betyg</strong></td>
        <td><strong>Kommentar</strong></td>
      </tr>
    </thead>
    <tbody>
      <?php
      $course_result = mysql_query("SELECT * FROM tbl_course WHERE program_id = '".$_SESSION['user_program']."'");
      while($course_row = mysql_fetch_array($course_result))
      {
        $grade_result = mysql_query("SELECT grade_grade, grade_comment FROM tbl_grade WHERE user_id = '".$_SESSION['user_id']."' AND course_id = '".$course_row['course_id']."' LIMIT 1");
        $grade_row = mysql_fetch_assoc($grade_result);
        ?>
        <tr>
          <td><?php echo $course_row['course_name']; ?></td>
          <td><?php echo $course_row['course_startdate']; ?></td>
          <td><?php echo $course_row['course_enddate']; ?></td>
          <td><?php if($grade_row['grade_grade'] == "") { echo "Ej satt"; } else { echo $grade_row['grade_grade']; } ?></td>
          <td><?php echo $grade_row['grade_comment']; ?></td>
        </tr>
        <?php
      }
      ?>
    </tbody>
  </table>
  <?php
}
elseif ($_SESSION['usertype_id'] >= 2)
{
  ?>
  <h1>Betyg</h1>
  <?php
  $Error->show();
  $Success->show();

  $course_result = mysql_query("SELECT * FROM tbl_course WHERE program_id = '".$_SESSION['user_program']."'");
  while($course_row = mysql_fetch_array($course_result))
  {
    ?>
    <h3><?php echo $course_row['course_name']; ?></h3>
    <table class="table table-hover">
      <thead>
        <tr>
          <td><strong>Förnamn</strong></td>
          <td><strong>Efternamn</strong></td>
          <td><strong>Betyg</strong></td>
          <td></td>
        </tr>
      </thead>
      <tbody>
        <?php
        $user_result = mysql_query("SELECT user_firstname, user_lastname, user_id FROM tbl_user ORDER BY user_lastname, user_firstname");
        while ($user_row = mysql_fetch_array($user_result))
        {
          ?>
          <tr>
            <td><?php echo $user_row['user_firstname']; ?></td>
            <td><?php echo $user_row['user_lastname']; ?></td>
            <?php
            $grade_result = mysql_query("SELECT grade_grade, grade_id FROM tbl_grade WHERE user_id = '".$user_row['user_id']."' AND course_id = '".$course_row['course_id']."' LIMIT 1");
            $grade_row = mysql_fetch_assoc($grade_result);
            ?>
            <td><?php if($grade_row['grade_grade'] == "") { echo "Ej satt"; } else { echo $grade_row['grade_grade']; } ?></td>
            <td><?php if($grade_row['grade_grade'] == "") { ?><a href="course.add.php?user_id=<?php echo $user_row['user_id']; ?>&course_id=<?php echo $course_row['course_id']; ?>"><span class="label label-primary">Sätt betyg</span></a><?php } else { ?><a href="course.edit.php?id=<?php echo $grade_row['grade_id']; ?>"><span class="label label-primary">Ändra betyget</span></a><?php } ?></td>
          </tr>
          <?php
        }
        ?>
      </tbody>
    </table>
    <?php
  }
  ?>
  
  <?php
}
include("assets/_footer.php");
?>