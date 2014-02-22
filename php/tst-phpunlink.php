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
    $removefilename = "1111111111111111.OK-ta-bort-mig" ;    

    $ok_file_exists=file_exists($removefilename);
    if(!ok_file_exists) {
        echo "Before unlink test: Missing $removefilename " ; 
    }
    else {
        echo "Before unlink test: Found file $removefilename " ;         
        unlink($removefilename);

        $ok_file_exists=file_exists($removefilename);
        echo "After unlink test: File $removefilename is deleted!";
    }
    
    echo "Test finished!"


?>
