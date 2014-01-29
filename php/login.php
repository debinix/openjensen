<?php include("assets/class.php"); ?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SCRUM</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/main.css" rel="stylesheet">
    <link href="assets/css/login.css" rel="stylesheet">
  </head>
  <body>
    <div class="container">
      <form class="form-signin" method="POST" action="./process.php?function=Login">
        <div class="center-block"><img src="assets/img/education.png" alt="Jensen Logga"></div>
        <hr>
        <?php
        $Error->show();
        $Success->show();
        ?>
        <input type="text" name="username" class="form-control" placeholder="Användarnamn" required autofocus>
        <input type="password" name="password" class="form-control" placeholder="Lösenord" required>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Logga in</button>
        <br>
        <div class="btn-group btn-group-justified">
          <a class="btn btn-default" href="#" title="">Glömt lösenord?</a>
          <a class="btn btn-default" href="#" title="">Ny användare?</a>
        </div>
        <a class="btn btn-default" href="" data-toggle="modal" data-target="#Cookies">Om Cookies</a>
      </form>
    </div>
    <div class="modal fade" id="Cookies" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  <h4 class="modal-title" id="myModalLabel">Cookies</h4>
                </div>
                <div class="modal-body">
                Denna webbplats använder sig av sessions-cookies<br>
                <br>
                Enligt EU direktiv 5.3 (etc) måste vi informera dig om att JENSENeducation.se/online2 använder sessions-cookies även kallat minnescookies.<br>
                <br>
                <strong>Vad är en cookie?</strong><br>
                En cookie är en textfil som lagras på datorn av en webbserver, information vars syfte är att webbservern kan "komma ihåg" saker om dig nästa gång du besöker webbsiten eller under tiden du är där. Det finns alltså två typer av cookies; de temporära som endast existerar under den session du har med siten (dessa kallas också minnescookies) och de permanenta som lagras på din hårddisk, de man normalt sett förknippar med cookies.
                <br>
                <br>
                <strong>Hur skyddar man sig mot cookies?</strong><br>
                Det är faktiskt mycket enkelt, det går att ställa in i webbläsaren. I Internet Explorer finns inställningarna under Verktyg->Internetinställningar->Sekretess. Ställer man det i botten är det fritt fram för alla cookies att lagras på hårddisken och läsas av de webbplatser som la in dem. Högst upp är det tvärt om - inga cookies tillåts överhuvudtaget. Du kan också gå in på knappen Avancerat och själv bestämma om och hur cookies ska accepteras. 
                </div>

                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
              </div>
            </div>
          </div>
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
  </body>
</html>
