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
  $voice = $updateArray["message"]["voice"];
  $fromUserId = $updateArray["message"]["from"]["id"];
 
  //  Helper.
  //  SVoice.
  //  Collect.
  if ($fromUserId == 127696982 && $voice) {
    $voiceObject = array('chatId' => $chatId, 'messageId' => $messageId);
    $voiceArray = json_decode(file_get_contents('svoice.json'), true);
    if (count($voiceArray) > 9) {
      $newFile = "svoice_archive/".time().".json"; 
      copy('svoice.json', $newFile);
      $newArray = array($voiceObject);
      $jsonFile=fopen("svoice.json",'w');
      fwrite($jsonFile, json_encode($newArray));
      fclose($jsonFile);
    }
    else {
      array_push($voiceArray, $voiceObject);
      $jsonFile=fopen("svoice.json",'w');
      fwrite($jsonFile, json_encode($voiceArray));
      fclose($jsonFile);
    }
    ##$saveSVoiceReply = $website."/sendMessage?chat_id=".$chatId."&text=:)"."&reply_to_message_id=".$messageId;
    ##$sentMessage = file_get_contents($saveSVoiceReply);
  }
  //  Checkout.
  if (stripos($text, '/svoice') !== false) {
    $voiceArray = json_decode(file_get_contents('svoice.json'), true);
    foreach ($voiceArray as $voiceMsg) {
      $forwardSVoice = $website."/forwardMessage?chat_id=".$chatId."&message_id=".$voiceMsg['messageId']."&from_chat_id=".$voiceMsg['chatId'];
      $sentMessage = file_get_contents($forwardSVoice);
    }    
  }

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

##    $savePhotoReply = $website."/sendMessage?chat_id=".$chatId."&text=You da driver!"."&reply_to_message_id=".$messageId;
##    $sentMessage = file_get_contents($savePhotoReply);
  }

  //  Cuckoo
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

  //  Hybridrbt.
  if (stripos($text, '/学长') !== false) {
    $hybridrbtReply = $website."/sendMessage?chat_id=".$chatId."&text=눈_눈";
    if ($replyToMessageID) {
      $hybridrbtReply = $hybridrbtReply."&reply_to_message_id=".$replyToMessageID;
    }
    $sentMessage = file_get_contents($hybridrbtReply);
  }

  //  ijoy.
  if (stripos($text, '/ijoy') !== false) {
    $ijoyReply = $website."/sendPhoto?chat_id=".$chatId."&photo=AgADAQADoqoxG49wFAWrzpvZPqt9trGS5y8ABE4w87Zf4bpCkz4AAgI";
    if ($replyToMessageID) {
      $ijoyReply = $ijoyReply."&reply_to_message_id=".$replyToMessageID;
    }
    $sentMessage = file_get_contents($ijoyReply);
  }

  //  Straight replying.
  //  Joy tit.
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

	// /sweetie
  if (stripos($text, '/sweetie') !== false) {
		$sweetieMessage = $website."/forwardMessage?message_id=29507&from_chat_id=80548625&chat_id=".$chatId;
    $sentMessage = file_get_contents($sweetieMessage);
	}

//  $myfile = fopen("debug", "w") or die("Unable to open file!");
//  fwrite($myfile, $update);
//  fclose($myfile);
//  $debugMessageRequest = $website."/sendMessage?chat_id=80548625&text=".$text;
//  $debugMessage = file_get_contents($cuckooMessageRequest);
?>
