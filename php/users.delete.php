<?php
include('assets/class.php');

$user_id = $_SESSION['user_id'];

$url = 'http://www.mc-butter.se/cgi-bin/cgi-remove-user.cgi';
      $fields = array( 'user_id' => $user_id );

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
if($result === false)
    $Error->set("Curl have a problem to reach $url") ;

//close connection
curl_close($ch);



$Success->set("Användaren är nu borttagen.");
header('location: users.php');
?>