<?php
    
    // Filename (phpunlinktest.OK ) is hard coded in:
    // test-php-unlink.cbl
    //
    // To run this test, first run Cobol file in /cgi-bin:
    //
    // ./cgi-test-php-unlink.cgi
    //
    // and then in the browser:
    //
    // mc-butter.se/tst-phpunlink.php
    //
    
    $removefilename = "/home/jensen/www.mc-butter.se/public_html/phpunlinktest.OK" ;    

    if(!file_exists($removefilename)) {
        echo "Missing testfile $removefilename (Run: cgi-bin/cgi-test-php-unlink.cgi first)<br>" ; 
    }
    else {
        echo "BEFORE unlink test: Found test file $removefilename <br><br>" ;         
        
        // Delete the file
        unlink($removefilename);
        
        if(file_exists($removefilename)) {
            echo "SUCCESS: File $removefilename is DELETED! <br>";
        }
        else {
            echo "ERROR: Could not remove $removefilename <br>";
        }
        
    }
    
    echo "<br>";
    echo "Test finished! <br>"


?>
