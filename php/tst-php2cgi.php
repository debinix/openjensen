<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Test1</title>
  </head>
  <body>
<h1>Test form to CGI</h1>
  <form method="POST" action="http://www.mc-butter.se/cgi-bin/listenv.cgi">

    <input type="text" name="title" placeholder="Subject">
    <br>
    <textarea name="content" placeholder="Content"></textarea>
    <br>
    <button type="submit">Skicka text till CGI</button>
  </form>
  </body>
</html>