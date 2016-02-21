<?php
  include 'token.php';
  $website = "https://api.telegram.org/bot".$botToken;

  $update = file_get_contents("php://input");
  $updateArray = json_decode($update,TRUE);
  
  $text = $updateArray["message"]["text"];
  $chatId = $updateArray["message"]["chat"]["id"];
  $messageId = $updateArray["message"]["message_id"];
  $replyToMessageID = $updateArray["message"]["reply_to_message"]["message_id"];

  //  Jake.
  if (stripos($text, '/jake') !== false) {
    if ($replyToMessageID) {
      $jakeReply = $website."/sendMessage?chat_id=".$chatId."&reply_to_message_id=".$replyToMessageID."&text=🙄️";
    } else {
      $jakeReply = $website."/sendMessage?chat_id=".$chatId."&text=🙄️";
    }
    $sentMessage = file_get_contents($jakeReply);
  }

  //  Kr.
  if (stripos($text, '/kr') !== false) {
    if ($replyToMessageID) {
      $krReply = $website."/sendSticker?chat_id=".$chatId."&reply_to_message_id=".$replyToMessageID."&sticker=BQADBQADogIAAmdqYwStx5TlmCMy0gI";
    } else {
      $krReply = $website."/sendSticker?chat_id=".$chatId."&sticker=BQADBQADogIAAmdqYwStx5TlmCMy0gI";
    }
    $sentMessage = file_get_contents($krReply);
  }

//  if ($replyToMessageID) { $tof = 1; }
//  else { $tof = 2; }
//  $myfile = fopen("debug", "w") or die("Unable to open file!");
//  fwrite($myfile, $tof);
//  fclose($myfile);
?>
