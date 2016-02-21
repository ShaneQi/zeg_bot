<?php
  $botToken = "199112411:AAEDEZSHH5daitpM3lrXH2egdn-kNdPtMRc";
  $website = "https://api.telegram.org/bot".$botToken;

  $update = file_get_contents("php://input");
  $updateArray = json_decode($update,TRUE);
  
  $text = $updateArray["message"]["text"];
  $chatId = $updateArray["message"]["chat"]["id"];
  $messageId = $updateArray["message"]["message_id"];

  //  Jake.
  if (stripos($text, '/jake') !== false) {
    $jakeReply = $website."/sendMessage?chat_id=".$chatId."&reply_to_message_id=".$messageId."&text=🙄️";
    $sentMessage = file_get_contents($jakeReply);
  }

//  $myfile = fopen("debug", "w") or die("Unable to open file!");
//  fwrite($myfile, $messageSendRequest);
//  fclose($myfile);
?>
