<?php include("assets/_header.php"); ?>
<?php if($_SESSION['usertype_id'] >= 3) { ?><a href="users.create.php"><span class="label label-primary">Skapa en användare</span></a><?php }?>
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
    // We need to set the filename because the COBOl CGI needs it.
    $ses_id = session_id();
    $filename = $ses_id."-list-user.txt";
    // Get users from DB
    $usertype_id = $_SESSION['usertype_id'];
    $url = 'http://www.mc-butter.se/cgi-bin/cgi-list-users.cgi';
    $fields = array('usertype_id' => $usertype_id,
                    'filename' => $filename);
    // url-ify the data for the POST with php built-in function
    $php_url_string = http_build_query($fields);
    // remove %27 i.e. the ' which php adds around post string :-(
    $fields_string = preg_replace('/%27/', '', $php_url_string);
    //open connection
    $ch = curl_init();

    //set the url, number of POST vars, POST data
    curl_setopt($ch,CURLOPT_URL, $url);
    curl_setopt($ch,CURLOPT_POST, count($fields));
    curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);

    //execute post
    $result = curl_exec($ch);
    if($result === false) $Error->set("Kan ej kontakta servern: $url") ;

    $Success->set("Användarlistan hämtad.");
    
    //Query is executed and the CGI has created a file we sleep
    // max 5s to make sure that the file exists before continue
    //with our php code below
    /*
    for ($f=0; $f <= 5; $f++)
    {
      $file_exists=file_exists($filename);
      if($file_exists)
      {
          break;
      }
      sleep(1);
    }
    //Include the files contenst once
    include_once($filename);
    */
    //header('location: users.php');
    ?>
  </tbody>
</table>
<?php include("assets/_footer.php"); ?>
