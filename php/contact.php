<?php include("assets/_header.php"); ?>
<div class="row">
  <div class="col-md-8">
  <h1>Kontakta support</h1>
  <form method="POST" action="./process.php?function=contactSupport">
    <?php
    $Error->show();
    $Success->show();
    ?>
    <input type="text" name="title" class="form-control" placeholder="Ämne">
    <br>
    <textarea class="form-control" name="content" placeholder="Meddelande"></textarea>
    <br>
    <button class="btn btn-lg btn-primary" type="submit">Skicka mail</button>
  </form>
    </br>
    </br>
 <iframe width="100%" height="350" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.se/maps?f=q&amp;source=s_q&amp;hl=sv&amp;geocode=&amp;q=Karlbergsv%C3%A4gen+77,+113+35+Stockholm&amp;aq=0&amp;oq=Karlbergsv%C3%A4gen+77,+113+35+Stockholm&amp;sll=62.032975,17.378555&amp;sspn=25.321613,86.572266&amp;t=h&amp;ie=UTF8&amp;hq=&amp;hnear=Karlbergsv%C3%A4gen+77,+113+35+Stockholm&amp;ll=59.342612,18.029243&amp;spn=0.003299,0.010568&amp;z=14&amp;output=embed"></iframe>
 <br />


  </div>
  <div class="col-md-4">
    <h2>Kontakta oss</h2>            
                  <p>Karlbergsvägen 77, 113 35 Stockholm</p>
                  <p>Tel. 08-450 22 30. Telefontid: mån-fre kl. 9-12 och 13-16</p>
                  <p><b>Vanliga frågor & svar</b></br>
                  <a href="mailto:komvux@jenseneducation.se" target="_top">komvux@jenseneducation.se</p></a>
                <p>T-bana: S:t Eriksplan uppgång Torsgatan, </br>Buss: 72, 42, 69, 3 och 4, </br>Pendeltåg: Karlbergs station.</p></div>
</div>
<?php include("assets/_footer.php"); ?>