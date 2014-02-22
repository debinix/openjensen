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
        echo "Before unlink test: Missing $removefilename <br>" ; 
    }
    else {
        echo "Before unlink test: Found file $removefilename <br>" ;         
        unlink($removefilename);

        echo "";
        echo "After unlink test: File $removefilename is deleted! <br>";
    }
    
    echo "";
    echo "Test finished! <br>"


?>
