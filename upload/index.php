<!DOCTYPE html>
<?php
/*
 * Description: One Time Secret Scytl's Software
 * Author: mario.vazquez[at]scytl.com
 * Date: 10/12/2014
 */
include ('secret.php');
?>
<html>
    <head>
        <meta charset="UTF-8">
        <title><?php $configArray = parse_ini_file("config"); echo $configArray["siteName"];?></title>
        <link rel="stylesheet" type="text/css" media="all" href="css/styles.css">
        <link rel="icon" type="image/x-icon" href="images/favicon.ico">
        <script src="js/functions.js"></script>
        <script src="js/jquery.js"></script>
        <script src="js/autosize.js"></script>
    </head>
    <body>
        <?php
        $configArray = parse_ini_file("config");
        echo '<a href="' . $configArray["appUrl"] . '"><img src="images/' . $configArray["logo"] . '"/></a>';
        if (isset($_POST["submit"])) {
            $data = htmlspecialchars($_POST["data"]);
            $trimmedData = trim($data);
            $finalData = nl2br($trimmedData);
            $password = htmlspecialchars($_POST["password"]);
            $timetolive = htmlspecialchars($_POST["timetolive"]);
            $token = createSecret("$finalData", "$password", "$timetolive");
            echo '
            <div id="wrapper">
              <form id="mainForm" action="index.php" method="POST">
                <div class="col-2">
                  <label>
                  Sharing URL
                  <input readonly name="sharingUrl" value="'.$configArray["appUrl"].'/view.php?secret='.$token.'" tabindex="1">
                  </label>
                </div>
                <div class="col-2">
                  <label>
                  Send by Mail
                  <input type="email" placeholder="Type email recipient" id="email" name="email" tabindex="1">
                  </label>
                </div>
            ';
            if (strlen($password) > 0)
            {
                echo '
                <div class="col-1">
                <label>
                Password (It will not be shown again)
                <input readonly name="sharingPassword" value="'.$password.'" tabindex="1">
                </label>
                </div>
                ';
            }
            echo '
            <div class="col-2">
            <div class="col-submit-2">
              <button class="submitbtn">Create a new secret</button>
              <button class="submitbtn" name="dropSecret" value="'.$token.'" style="margin-left:2em;" onClick="return dropConfirmation();">Drop this secret</button>
            </div>
            </div>
            <div class="col-2">
            <div class="col-submit-2">
              <button class="submitbtn" name="sendMail" value="sendMail" id="sendMail">Send Mail</button>
            </div>
            </div>
            ';
            echo '
            </form>
            </div>';
        } 
        elseif(isset($_POST["sendMail"]))
        {
           $recipient = htmlspecialchars($_POST["email"]);
           $sharingUrl = htmlspecialchars($_POST["sharingUrl"]);
           $sharingPassword="";
           if (isset($_POST["sharingPassword"]))
           {
              $sharingPassword = htmlspecialchars($_POST["sharingPassword"]);
           }
           
           $mailSended = sendMail("$recipient","$sharingUrl","$sharingPassword"); 
           if ($mailSended != 0)
           {
               echo '<div id="wrapper">
                       <form id="mailError" action="index.php" method="POST">
                         <div class="col-1">
                           <label>We couldn\'t send the email
                           <p>Your sharing URL is: ' . $sharingUrl . '</p>';
               if ($sharingPassword)
               {
                   echo "<p>And your sharing password is: $sharingPassword</p>";
               }
               echo '</div>
                     <div class="col-submit">
                       <button class="submitbtn" name="goHome" value="goHome" id="goHome">Go Home</button>
                     </div>
                     </form>
                     </div>';
           }
           else {
               header('Refresh: 1;' . $_SERVER['HTTP_REFERER']);
           }
        }
        elseif(isset($_POST["dropSecret"]))
        {
          $tokenToDrop = htmlspecialchars($_POST["dropSecret"]);
          if (secretExist($tokenToDrop))
          {
            removeSecret($tokenToDrop);
          } 
          header('Refresh: 1;' . $_SERVER['HTTP_REFERER']);
        }
 
      else {
            echo ' 
     <div id="wrapper"> 
     <form autocomplete="off" action="index.php" method="POST">
     <div class="col-1">
       <label>
         Secret Data
         <textarea required placeholder="Insert your secret data here" class="auto-size" id="data" name="data" tabindex="1"></textarea>
       </label>
     </div>
     <div class="col-1">
       <label>
         Password
         <input placeholder="Protect your secret by password (if you want)" id="password" type="password" name="password" value="" tabindex="1">
       </label>
     </div>
     <div class="col-1">
       <label>
         Time To Live (if nobody see it)
         <select tabindex="5" name="timetolive">
           <option value="30">30 minutes</option>
           <option value="120">2 hours</option>
           <option value="480">8 hours</option>
           <option value="1440">1 day</option>
           <option value="4320">3 days</option>
           <option value="10080" selected="selected">7 days</option>
         </select>
       </label>
     </div>
     <div class="col-submit">
       <button type="submit" class="submitbtn" name="submit" value="submit">Create a secret</button>
     </div>
     </form>
     </div>
     <script>$(\'textarea.auto-size\').textareaAutoSize();</script>
     ';
        }
        ?>
    </body>
</html>
