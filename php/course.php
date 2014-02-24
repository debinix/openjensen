<?php
include("assets/_header.php");

if($_SESSION['usertype_id'] == 1)
{
  ?>
  <h1>Betyg</h1>
  <?php
  $Error->show();
  $Success->show();
  $betyg_elev_file = 'data/betyg-elev.txt';
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
      
      if(file_exists($betyg_elev_file)) {
          unlink($betyg_elev_file) ; 
      }
      
      // POST data to url:
      // http://www.mc-butter.se/cgi-bin/cgi-list-betygelev.cgi
      // wait until file is written at server before continue to read it.
      
      //  Add unique control number with each front-end request
      // seconds since Unix Epoch (1970-01-01)
      $magic_number = time();
      // add 10 more random digits to string
      for($i = 0; $i < 10; $i++) {
      $magic_number .= rand(0, 9);
      }
      
      $time_start = microtime(true);      

      $user_id = $_SESSION['user_id'];
      $user_program = $_SESSION['user_program'];
      $url = 'http://www.mc-butter.se/cgi-bin/cgi-list-betygelev.cgi';
      $fields = array( 'user_id' => $user_id,
                       'user_program' => $user_program,
                       'magic_number' => $magic_number
                      );
      
      //url-ify the data for the POST with php built-in function
      $php_url_string = http_build_query($fields);
      // remove %27 i.e. the ' which php may add around post string :-( 
      $fields_string = preg_replace('/%27/', '', $php_url_string);
      $ch = curl_init();
      
      //set the url, number of POST vars, POST data
      curl_setopt($ch,CURLOPT_URL, $url);
      curl_setopt($ch,CURLOPT_POST, count($fields));
      curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
      
      //execute post
      $result = curl_exec($ch);
      if($result === false) {
          echo "Kan inte få kontakt med $url <br>" ;
      }
      
      //close connection
      curl_close($ch);
      
      // time out after 5s
      for ($f=0; $f <= 50; $f++) {
        $file_exists=file_exists($betyg_elev_file);
        if($file_exists) {
            break;
        }
        // sleep 100 ms
        usleep(100000);      
      }
      if($f === 50) {
          echo "Saknar fil från databas: $betyg_elev_file <br>" ; 
      }
      
      
      $time_mid = microtime(true);
      $mycbltime = number_format($time_mid - $time_start, 5) ;
      
      // read file from database
      $course_row = file($betyg_elev_file);
      
      // is backend data valid
      $session_ok_file = "data/".$magic_number."."."OK";      
      if(!file_exists($session_ok_file)) {
          echo "Ogiltiga data returnerades från databasen.<br>" ; 
      }
      else {
          unlink($session_ok_file);
      }
      
      $time_end = microtime(true);
      $mytime = number_format($time_end - $time_mid, 5) ;
      
           
      // loop through the array
      for ($i = 0; $i < count($course_row); $i++)
      {
        // separate each field
        $tmp = preg_split("/\s*,\s*/", trim($course_row[$i]), -1, PREG_SPLIT_NO_EMPTY);
        // assign each field into a named array key
        $course_row[$i] = array('course_name' => $tmp[0], 'course_startdate' => $tmp[1], 'course_enddate' => $tmp[2], 'grade_grade' => $tmp[3], 'grade_comment' => $tmp[4], 'magic_number' => $tmp[5]);
        
        // check each row for the magic number
        if($course_row[$i]['magic_number'] <> $magic_number) {
            echo "En rad i datat från servern stämmer ej med som var förväntat.<br>" ; 
        }
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
  echo "Väntade på Cobol databas backend: $mycbltime sekunder. Tid för PHP att processa infil: $mytime sekunder<br>";
}
elseif ($_SESSION['usertype_id'] >= 2)
{
  ?>
  <h1>Betyg</h1>
  
  
  
  <?php
  $Error->show();
  $Success->show();
  $betyg_all_file = 'data/betyg-all.txt';
  
  if(file_exists($betyg_all_file)) {
      unlink($betyg_all_file) ; 
  }
  
  //
  // POST data to url: 
  // http://www.mc-butter.se/cgi-bin/cgi-list-betygalla.cgi
  // wait until file is written at server before continue to read it.
  //
  
  //  Add unique control number with each front-end request
  // seconds since Unix Epoch (1970-01-01)
  $magic_number = time();
  // add 10 more random digits to string
  for($i = 0; $i < 10; $i++) {
  $magic_number .= rand(0, 9);
  }
  
  $time_start = microtime(true);
  
  $user_program = $_SESSION['user_program'];
  $url = 'http://www.mc-butter.se/cgi-bin/cgi-list-betygalla.cgi';
  $fields = array( 'user_program' => $user_program,
                   'magic_number' => $magic_number
                  );
  //url-ify the data for the POST with php built-in function
  $php_url_string = http_build_query($fields);
  // remove %27 i.e. the ' which php may add around post string :-( 
  $fields_string = preg_replace('/%27/', '', $php_url_string);
  //open connection
  $ch = curl_init();
  
  //set the url, number of POST vars, POST data
  curl_setopt($ch,CURLOPT_URL, $url);
  curl_setopt($ch,CURLOPT_POST, count($fields));
  curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);
  
  //execute post
  $result = curl_exec($ch);
  if($result === false) {
      echo "Kan inte få kontakt med $url <br>" ;
  }
  
  //close connection
  curl_close($ch);
  
  // time out after 5s
  for ($f=0; $f <= 50; $f++) {
    $file_exists=file_exists($betyg_all_file);
    if($file_exists) {
        break;
    }
    // sleep 100 ms
    usleep(100000);   
  }
    if($f === 50) {
        echo "Saknar fil från databas: $betyg_elev_file <br>" ; 
    }
  
  $time_mid = microtime(true);
  $mycbltime = number_format($time_mid - $time_start, 5) ;

  // read file from database
  $user_row = file($betyg_all_file);
  
  // is backend data valid
  $session_ok_file = "data/".$magic_number."."."OK";       
  if(!file_exists($session_ok_file)) {
      echo "Ogiltiga data returnerades från databasen.<br>" ; 
  }
  else {
      unlink($session_ok_file);
  }  
  
  $time_end = microtime(true);
  $mytime = number_format($time_end - $time_mid, 5) ;

  
    // loop through the array
    for ($i = 0; $i < count($user_row); $i++) {
        // separate each field
        $tmp = preg_split("/\s*,\s*/", trim($user_row[$i]), -1, PREG_SPLIT_NO_EMPTY);
        // assign each field into a named array key
        $user_row[$i] = array('course_name' => $tmp[0], 'user_firstname' => $tmp[1], 'user_lastname' => $tmp[2], 'grade_grade' => $tmp[3], 'grade_id' => $tmp[4],'user_id' => $tmp[5],'course_id' => $tmp[6], 'grade_comment' => $tmp[7], 'magic_number' => $tmp[8]);
        
        // check each row for the magic number
        if($user_row[$i]['magic_number'] <> $magic_number) {
            echo "En rad i datat från servern stämmer ej med som var förväntat.<br>" ; 
        }
    
    }
    
    // initilize to anything except a real course name
    $lastcoursename = '-';
    
    // iterate through all course user data
    for ($i = 0; $i < count($user_row); $i++)
    { ?>
    
    <table class="table table-hover">
      
      <thead>
      <?php
        // only echo if course name different from previous iteration
        if ( $lastcoursename <>  $user_row[$i]['course_name'] ) { ?>
          <h3><?php echo $user_row[$i]['course_name']; ?></h3>
            <tr>
            <td><strong>Förnamn</strong></td>
            <td><strong>Efternamn</strong></td>
            <td><strong>Betyg</strong></td>
            <td></td>
          </tr>
        <?php  
        }
        ?>
      </thead>

      <tbody>        
        <tr>   
          <td>
            <?php echo trim($user_row[$i]['user_firstname'], " "); ?>
          </td>
          
          <td>
            <?php echo trim($user_row[$i]['user_lastname'], " "); ?>
          </td>
          
          <!--
          <td>
            <?php if(trim($user_row[$i]['grade_grade'], " ") == "-") { echo "Ej satt"; } else { echo trim($user_row[$i]['grade_grade'], " "); } ?>
          </td>
          
          <td>
            <?php if(trim($user_row[$i]['grade_grade'], " ") == "-") { ?><a href="course.add.php?user_id=<?php echo $user_row[$i]['user_id']; ?>&course_id=<?php echo $user_row[$i]['course_id']; ?>&user_firstname=<?php echo $user_row[$i]['user_firstname']; ?>&user_lastname=<?php echo $user_row[$i]['user_lastname']; ?>"><span class="label label-primary">Sätt betyg</span></a><?php } else { ?><a href="course.edit.php?id=<?php echo $user_row[$i]['grade_id']; ?>&grade_grade=<?php echo $user_row[$i]['grade_grade']; ?>&grade_comment=<?php echo $user_row[$i]['grade_comment']; ?>"><span class="label label-primary">Ändra betyg</span></a><?php } ?>
          </td>
          -->
        </tr>
      </tbody>           
        
    <?php
    // dump array - debug
    var_dump($user_row[$i]);
    
    // assign current course name for next iteration
    $lastcoursename =  $user_row[$i]['course_name'];
    }
    ?>
    </table>
  <?php
  echo "Väntade på Cobol databas backend: $mycbltime sekunder. Tid för PHP att processa infil: $mytime sekunder<br>";
}
include("assets/_footer.php");
?>