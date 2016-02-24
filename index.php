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
  $photo = $updateArray["message"]["photo"];
    [1]["file_id"]; 

  //  Helper.
  //  Photo.
  if ($photo) {
    //  Put the pointer the the end element of photo array.
    end($photo);
    //  Get last element index.
    $lastIndex = key($photo);
    $photoFileId = $photo[$lastIndex]["file_id"];
    $getPhotoRequest = $website."/getFile?file_id=".$photoFileId;
    $photoFile = file_get_contents($getPhotoRequest);
    $photoArray = json_decode($photoFile, TRUE);
    $photoFilePath = $photoArray["result"]["file_path"];
    $photoUrl = "https://api.telegram.org/file/bot".$botToken."/".$photoFilePath;

    file_put_contents(realpath("../../public_ftp/telegram_photo").'/'.$messageDateId.substr($photoFilePath, -4), file_get_contents($photoUrl));

    $savePhotoReply = $website."/sendMessage?chat_id=".$chatId."&text=You da driver!"."&reply_to_message_id=".$messageId;
    $sentMessage = file_get_contents($savePhotoReply);
  }

##//  Cuckoo
  $lastText = file_get_contents('cuckoo');
  if (strcmp($lastText, $text) == 0) {
    $cuckooMessageRequest = $website."/sendMessage?chat_id=".$chatId."&text=".$text;
    $sentMessage = file_get_contents($cuckooMessageRequest);
  }
  $myfile = fopen("cuckoo", "w") or die("Unable to open file!");
  fwrite($myfile, $text);
  fclose($myfile);

  //  Conditional sending.
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

  //  Straight replying.
##//  Joy tit.
  if (stripos($text, '#果汁上大胸') !== false) {
    $joyTitReply = $website."/sendSticker?chat_id=".$chatId."&sticker=BQADBQADqAIAAmdqYwRLjLaU-biukAI&reply_to_message_id=".$messageId;
    $sentMessage = file_get_contents($joyTitReply);
  }

  //  Straight sending.
  //  lbs is typing.
  if (stripos($text, '#朝君istyping') !== false) {
    $lbsTypingReply = $website."/sendSticker?chat_id=".$chatId."&sticker=BQADBQADoA8AAq4QPgWOqb6HborVKwI";
    $sentMessage = file_get_contents($lbsTypingReply);
  }

//  $myfile = fopen("debug", "w") or die("Unable to open file!");
//  fwrite($myfile, $update);
//  fclose($myfile);
//  $debugMessageRequest = $website."/sendMessage?chat_id=80548625&text=".$text;
//  $debugMessage = file_get_contents($cuckooMessageRequest);
?>
