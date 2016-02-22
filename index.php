<?php
  include 'token.php';
  $website = "https://api.telegram.org/bot".$botToken;

  $update = file_get_contents("php://input");
  $updateArray = json_decode($update,TRUE);
  
  $text = $updateArray["message"]["text"];
  $chatId = $updateArray["message"]["chat"]["id"];
  $messageId = $updateArray["message"]["message_id"];
  $messageDateId = $updateArray["message"]["date"];
  $replyToMessageID = $updateArray["message"]["reply_to_message"]["message_id"];
  $photoFileId = $updateArray["message"]["photo"][1]["file_id"]; 

  //  Photo.
  if ($photoFileId) {
    $getPhoto = $website."/getFile?file_id=".$photoFileId;
    $photo = file_get_contents($getPhoto);
    $photoArray = json_decode($photo, TRUE);
    $photoFilePath = $photoArray["result"]["file_path"];
    $photoUrl = "https://api.telegram.org/file/bot".$botToken."/".$photoFilePath;

    file_put_contents(realpath("./photo").'/'.$messageDateId.'.jpg', file_get_contents($photoUrl));

    $savePhotoReply = $website."/sendMessage?chat_id=".$chatId."&text=You da driver!"."&reply_to_message_id=".$messageId;
    $sentMessage = file_get_contents($savePhotoReply);
  }

  //  Jake.
  if (stripos($text, '/jake') !== false) {
    $jakeReply = $website."/sendMessage?chat_id=".$chatId."&text=🙄️";
    if ($replyToMessageID) {
      $jakeReply = $jakeReply."&reply_to_message_id=".$replyToMessageID;
    }
    $sentMessage = file_get_contents($jakeReply);
  }

  //  Kr.
  if (stripos($text, '/kr') !== false) {
    $krReply = $website."/sendSticker?chat_id=".$chatId."&sticker=BQADBQADogIAAmdqYwStx5TlmCMy0gI";
    if ($replyToMessageID) {
      $krReply = $krReply."&reply_to_message_id=".$replyToMessageID;
    }
    $sentMessage = file_get_contents($krReply);
  }

//  if ($replyToMessageID) { $tof = 1; }
//  else { $tof = 2; }
//  $myfile = fopen("debug", "w") or die("Unable to open file!");
//  fwrite($myfile, $photoArray);
//  fclose($myfile);
?>
