<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
            "http://www.w3.org/TR/html4/loose.dtd">
<html lang="sv">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">	
<title>Post with curl</title>
</head>
<body>
<?php    

$first_name = 'Open';    
$last_name = 'Jensen';
$country_code = 'åäö';

    
//set POST variables
$url = 'http://www.mc-butter.se/cgi-bin/listenv.cgi';
$fields = array(
            'lname' => urlencode($last_name),
            'fname' => urlencode($first_name),
            'country' => urlencode($country_code)
				);

//url-ify the data for the POST
foreach($fields as $key=>$value) { $fields_string .= $key.'='.$value.'&'; }
rtrim($fields_string, '&');

//open connection
$ch = curl_init();

//set the url, number of POST vars, POST data
curl_setopt($ch,CURLOPT_URL, $url);
curl_setopt($ch,CURLOPT_POST, count($fields));
curl_setopt($ch,CURLOPT_POSTFIELDS, $fields_string);

//execute post
$result = curl_exec($ch);
if($result === false)
    echo "We have a problem to reach $url" ;

//close connection
curl_close($ch);

// sleep to make sure we can continue with our php code
sleep(2);

?>
</body>
</html>