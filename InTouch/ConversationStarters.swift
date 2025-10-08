import Foundation

struct ConversationStarters {
    static let starters: [String] = [
        "Hey! Been thinking about you. How have you been?",
        "Just wanted to check in and see how things are going.",
        "Hope you're doing well! What's new with you?",
        "It's been too long! How's everything been?",
        "Was just reminiscing about good times. How are you?",
        "Hey there! Would love to catch up. What's going on?",
        "Hi! Just wanted to say hello and see how you're doing.",
        "Thinking of you! Hope all is well on your end.",
        "Hey! Long time no talk. How's life treating you?",
        "Just checking in! What have you been up to lately?",
        "Hi! Hope this finds you well. How are things?",
        "Hey! Been meaning to reach out. What's new?",
        "Hope you're having a great day! How's everything?",
        "Hi there! Just wanted to reconnect. How are you?",
        "Hey! Would love to hear what you've been up to.",
        "Thinking it's time we caught up! How's it going?",
        "Hi! Hope things are going well for you lately.",
        "Hey there! Just wanted to touch base. How are you?",
        "Was thinking about you today. How have you been?",
        "Hi! Hope you're doing amazing. What's happening?",
        "Hey! Miss our chats. How's life been?",
        "Just wanted to reach out and say hello!",
        "Hey! Hope you're having a wonderful week!",
        "Hi! Would be great to catch up soon. How are things?",
        "Hey there! Just checking in. Hope all is good!",
        "Hi! Been a while. How have things been going?",
        "Hey! Hope you're well. What's been keeping you busy?",
        "Hi there! Just wanted to see how you're doing.",
        "Hey! Hope everything's going great for you!",
        "Hi! Would love to hear from you. How are things?"
    ]

    static func random() -> String {
        starters.randomElement() ?? "Hey! How have you been?"
    }
}
