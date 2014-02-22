<?php
    
    // This name is hard coded in: test-php-unlink.cbl
    // To run this test, first run Cobol file in /cgi-bin:
    //
    // ./cgi-test-php-unlink.cgi
    //
    // and then in the browser:
    //
    // mc-butter.se/tst-phpunlink.php
    //
    $removefilename = "/home/jensen/www.mc-butter.se/public_html/1111111111111111.OK-ta-bort-mig" ;    

    $ok_file_exists=file_exists($removefilename);
    if(!ok_file_exists) {
        echo "Before unlink test: Missing $removefilename <br>" ; 
    }
    else {
        echo "Before unlink test: Found file $removefilename <br>" ;         
        unlink($removefilename);

        $ok_file_exists=file_exists($removefilename);
        echo "";
        echo "After unlink test: File $removefilename is deleted! <br>";
    }
    
    echo "";
    echo "Test finished! <br>"


?>
