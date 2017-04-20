import ZEGBot
import SQLite

let bot = ZEGBot(token: secret)
let db = try! SQLite.init(in: "./zeg_bot.db",
                          managing: [Post.self])

var cuckoo = ""
var mode = 0

bot.run { update, bot in

	let plugin = ZEGBotPlugin(bot: bot)

	if case 1 = mode { print(update) }

	if let message = update.message {

		if let senderId = message.from?.id {
			let post = Post(uid: message.message_id,
			                content: message.text ?? "[attachment]",
			                senderId: senderId,
			                updatedAt: message.date,
			                parentUid: message.reply_to_message?.message_id,
			                children: nil)
			do { try post.replace(into: db) } catch { print("error:") }
			dump(post)
		}

		if let locationA = message.location,
			let locationB = message.reply_to_message?.location,
			let userB = message.reply_to_message?.from?.first_name {

			let distance = Int(plugin.distance(between: locationA, and: locationB))

			let _ = bot.send(message: "\(userB) is *\(distance)* miles away from you.", to: message)

		}

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
}
