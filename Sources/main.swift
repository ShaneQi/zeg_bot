import ZEGBot

let bot = ZEGBot(token: secret)

var cuckoo = ""

var mode = 0

bot.run(with: {
	update, bot in
	
	let plugin = ZEGBotPlugin(bot: bot)
	
	if case 1 = mode { print(update) }
	
	if let message = update.message {
		
		if let locationA = message.location,
			let locationB = message.reply_to_message?.location,
			let userB = message.reply_to_message?.from?.first_name {
			
			let distance = Int(plugin.distance(between: locationA, and: locationB))
			
			let _ = bot.send(message: "\(userB) is *\(distance)* miles away from you.", to: message)
			
		}
		
//		if message.from?.id == tumei && message.voice != nil {
//			
//			do {
//				
//				let sqlite = try SQLite(DB_PATH)
//				
//				let sql = "INSERT INTO tmvoice(update_string) values ('\(request.postBodyString)');"
//				
//				try sqlite.execute(sql)
//				
//				// Dev mode feedback.
//				if case 1 = mode {
//					
//					ZEGResponse.sendMessage(to: (update?.message)!, text: "嗯～", parse_mode: nil, disable_web_page_preview: nil, disable_notification: true)
//					
//				}
//				
//			} catch let e {
//				
//				print("\(e)")
//				
//			}
//			
//		}
		
		if let text = message.text {
			
			var isCommand = true
			
			switch text.uppercased() {
				
				/* Rules go here (order sensitive). */
			case "/学长", "/学长@ZEG_BOT":
				plugin.smartReply(to: message, content: "눈_눈", type: .Text)
				
			case "/JOY", "/JOY@ZEG_BOT":
				plugin.smartReply(to: message, content: joy, type: .PhotoSize)
				
			case "/JAKE", "/JAKE@ZEG_BOT":
				plugin.smartReply(to: message, content: jake, type: .PhotoSize)
				
			case "/DUYAOO", "/DUYAOO@ZEG_BOT":
				plugin.smartReply(to: message, content: "哎呦喂，不得了了！妖妖灵！", type: .Text)
				
			case "/KR", "/KR@ZEG_BOT":
				plugin.smartReply(to: message, content: kr, type: .Sticker)
				
			case "#朝君ISTYPING":
				let _ = bot.send(sticker: cjtyping, to: message.chat)
				
			case "/TAO", "/TAO@ZEG_BOT":
				let _ = bot.send(photo: tao, to: message.chat)
				
//			case "/TMVOICE", "/TMVOICE@ZEG_BOT":
//				do {
//					
//					let sqlite = try SQLite(DB_PATH)
//					
//					var messageQueue = [Message]()
//					
//					try sqlite.forEachRow("SELECT * FROM tmvoice ORDER BY id DESC LIMIT 5;") {
//						(statement: SQLiteStmt, i:Int) -> () in
//						
//						
//						let fetchedUpdateObject = ZEGDecoder.decodeUpdate(statement.columnText(1))
//						
//						if let fetchedMessage = fetchedUpdateObject?.message {
//							
//							messageQueue.append(fetchedMessage)
//							
//						}
//						
//						
//					}
//					
//					if let chat = update?.message?.chat {
//						
//						while messageQueue.count != 0 {
//							
//							ZEGResponse.forwardMessage(to: chat, message: messageQueue.popLast()!, disable_notification: nil)
//							
//						}
//						
//					}
//					
//					
//				} catch let e {
//					
//					print("\(e)")
//					
//				}
				
			case "/WHOSYOURDADDY":
				guard message.from?.id == shane else { break }
				mode = (mode + 1) % 2
				if mode == 1 { print("Switched to dev mode.") }
				else { print("Switched to normal mode.") }
				
			default:
				isCommand = false
				break
				
			}
			
			if isCommand {
				
				cuckoo = ""
				
			} else if text == cuckoo {
				
				bot.send(message: "*\(text)*", to: message.chat, parseMode: .MARKDOWN)
				cuckoo = ""
				
			} else {
				
				cuckoo = text
				
			}
			
			
		}
		
	}


})
