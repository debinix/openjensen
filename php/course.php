<?php
include("assets/_header.php");

if($_SESSION['usertype_id'] == 1)
{
  ?>
  <h1>Betyg</h1>
  <?php
  $Error->show();
  $Success->show();
  $betyg_elev_file = 'betyg-elev.txt';
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
      
      //
      // POST data with: name="user_id" (i.e. $_SESSION['user_id']) 
      //                 and name="program_id" (i.e. $_SESSION['user_program'])
      // to url: http://www.mc-butter.se/cgi-bin/cgi-list-betygelev.cgi
      // wait until file is written at server before continue to read it.
      //
      
      $course_row = file($betyg_elev_file);
           
      // loop through the array
      for ($i = 0; $i < count($course_row); $i++)
      {
        // separate each field
        $tmp = preg_split("/\s*,\s*/", trim($course_row[$i]), -1, PREG_SPLIT_NO_EMPTY);
        // assign each field into a named array key
        $course_row[$i] = array('course_name' => $tmp[0], 'course_startdate' => $tmp[1], 'course_enddate' => $tmp[2], 'grade_grade' => $tmp[3], 'grade_comment' => $tmp[4]);
        ?>
      
        <tr>
          <td><?php echo $course_row[$i]['course_name']; ?></td>
          <td><?php echo $course_row[$i]['course_startdate']; ?></td>
          <td><?php echo $course_row[$i]['course_enddate']; ?></td>
          <td><?php if($course_row[$i]['grade_grade'] == '-') { echo "Ej satt"; } else { echo $course_row[$i]['grade_grade']; } ?></td>
          <td><?php echo $course_row[$i]['grade_comment']; ?></td>
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
  $betyg_all_file = 'betyg-all.txt';
  
  //
  // POST data with: name="program_id" (i.e. $_SESSION['user_program'])
  // to url: http://www.mc-butter.se/cgi-bin/cgi-list-betygelev.cgi
  // wait until file is written at server before continue to read it.
  //  
  
  $course_row = file($betyg_all_file);
  
  
  $course_result = pg_query("SELECT * FROM tbl_course WHERE program_id = '".$_SESSION['user_program']."'");
  while($course_row = pg_fetch_array($course_result))  
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

        $user_result = pg_query("SELECT user_firstname, user_lastname, user_id FROM tbl_user ORDER BY user_lastname, user_firstname");
        while ($user_row = pg_fetch_array($user_result))        
        {
          ?>
          <tr>
            <td><?php echo $user_row['user_firstname']; ?></td>
            <td><?php echo $user_row['user_lastname']; ?></td>
            <?php
            
            $grade_result = pg_query("SELECT grade_grade, grade_id FROM tbl_grade WHERE user_id = '".$user_row['user_id']."' AND course_id = '".$course_row['course_id']."' LIMIT 1");
            $grade_row = pg_fetch_assoc($grade_result);            
            
            ?>
            <td><?php if($grade_row['grade_grade'] == "-") { echo "Ej satt"; } else { echo $grade_row['grade_grade']; } ?></td>
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