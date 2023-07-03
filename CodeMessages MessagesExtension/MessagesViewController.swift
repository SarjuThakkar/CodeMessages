//
//  MessagesViewController.swift
//  CodeMessages MessagesExtension
//
//  Created by Sarju Thakkar on 6/17/23.
//

import Messages
import SwiftUI

class MessagesViewController: MSMessagesAppViewController {
    var myUUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        self.myUUID = conversation.localParticipantIdentifier.uuidString
        var gameModel = GameModel(message: conversation.selectedMessage) ?? nil
        if gameModel == nil {
            let participantIdentifier = conversation.localParticipantIdentifier
            let myUUIDString = participantIdentifier.uuidString
            let words = chooseRandomWords()
            let cardColors = shuffledColors()
            let selected = Array(repeating: "False", count: 25)
            // Initialize a default or initial game model
            gameModel = GameModel(playerNumber: "1", hintText: "N/A", words: words, cardColors: cardColors, selected: selected, gameOver: "0", player1UUID: myUUIDString)
        }
        presentGameView(with: gameModel!)
    }
    
    private func chooseRandomWords() -> [String] {
        var codenamesWords = [
            "Africa", "Agent", "Air", "Alien", "Alps", "Amazon", "Ambulance", "America", "Angel", "Antarctica",
            "Apple", "Arm", "Atlantis", "Australia", "Aztec", "Back", "Ball", "Banana", "Band", "Bank",
            "Bar", "Bark", "Bat", "Battery", "Beach", "Bear", "Beat", "Bed", "Beijing", "Bell",
            "Belt", "Berlin", "Bermuda", "Berry", "Bill", "Block", "Board", "Bolt", "Bomb", "Bond",
            "Boom", "Boot", "Bottle", "Bow", "Box", "Brick", "Bridge", "Brush", "Buck", "Bug",
            "Bugle", "Button", "Calf", "Canada", "Cap", "Capital", "Car", "Card", "Carrot", "Casino",
            "Cast", "Castle", "Cat", "Cell", "Centaur", "Center", "Chair", "Change", "Charge", "Check",
            "Chest", "Chick", "China", "Chocolate", "Church", "Circle", "Cliff", "Cloak", "Club", "Code",
            "Cold", "Comic", "Compound", "Concert", "Conductor", "Cone", "Contrast", "Cook", "Copper", "Cotton",
            "Court", "Cover", "Crane", "Crash", "Cricket", "Cross", "Crown", "Cycle", "Czech", "Dance",
            "Date", "Day", "Death", "Deck", "Degree", "Diamond", "Dice", "Dinosaur", "Disease", "Doctor",
            "Dog", "Doll", "Dolphin", "Door", "Draft", "Dragon", "Dress", "Dresser", "Drill", "Drop",
            "Drum", "Duck", "Dwarf", "Eagle", "Ear", "Earth", "Easter", "Egg", "Egypt", "Einstein",
            "Elephant", "Elf", "Engine", "England", "Europe", "Eye", "Face", "Factory", "Fair", "Fall",
            "Fan", "Fence", "Field", "Fighter", "Figure", "File", "Film", "Fire", "Fish", "Flute",
            "Fly", "Foot", "Force", "Forest", "Fork", "France", "Game", "Gas", "Genius", "Germany",
            "Ghost", "Giant", "Glass", "Glove", "Gold", "Grace", "Grass", "Greece", "Green", "Ground",
            "Ham", "Hand", "Hawk", "Head", "Heart", "Helicopter", "Himalayas", "Hole", "Hollywood", "Honey",
            "Hood", "Hook", "Horn", "Horse", "Horseshoe", "Hospital", "Hotel", "Ice", "Ice Cream", "India",
            "Iron", "Ivory", "Jack", "Jam", "Jelly", "Jet", "Jupiter", "Kangaroo", "Ketchup", "Key",
            "Kid", "King", "Kiss", "Kitchen", "Kite", "Knife", "Knight", "Knot", "Lab", "Lap",
            "Laser", "Lawyer", "Lead", "Leather", "Leg", "Lemon", "Leopard", "Letter", "Library", "Life",
            "Light", "Limb", "Line", "Link", "Lion", "Litter", "Liver", "Lock", "Log", "London",
            "Luck", "Mail", "Mammoth", "Maple", "Marble", "March", "Mass", "Match", "Mercury", "Mexico",
            "Microscope", "Milk", "Millionaire", "Mine", "Mint", "Mist", "Model", "Mole", "Moon", "Moscow",
            "Mount", "Mouse", "Mouth", "Mug", "Nail", "Needle", "Net", "New York", "Night", "Ninja",
            "Note", "Novel", "Nurse", "Nut", "Octopus", "Oil", "Olive", "Olympus", "Opera", "Orange",
            "Organ", "Palm", "Pan", "Pants", "Paper", "Parachute", "Park", "Part", "Pass", "Paste",
            "Penguin", "Phoenix", "Piano", "Picasso", "Pie", "Pilot", "Pin", "Pipe", "Pirate", "Pistol",
            "Pitch", "Plane", "Plastic", "Plate", "Platypus", "Play", "Plot", "Point", "Poison", "Pole",
            "Police", "Pool", "Port", "Post", "Potato", "Princess", "Pumpkin", "Punch", "Pupil", "Pyramid",
            "Queen", "Rabbit", "Racket", "Ray", "Razor", "Red", "Revolution", "Ring", "Roach", "Roof",
            "Room", "Root", "Rose", "Roulette", "Round", "Row", "Ruler", "Russia", "Saddle", "Salt",
            "Satellite", "Saturn", "Scale", "School", "Scientist", "Scorpion", "Screen", "Scuba Diver", "Seal", "Server",
            "Shadow", "Shakespeare", "Shark", "Ship", "Shoe", "Shop", "Shot", "Sink", "Skyscraper", "Slip",
            "Slipper", "Sloth", "Smuggler", "Snake", "Sneeze", "Snow", "Snowman", "Socks", "Solar", "Soldier",
            "Soul", "Sound", "Space", "Spell", "Spider", "Spike", "Spine", "Spot", "Spring", "Spy",
            "Square", "Stadium", "Staff", "Star", "State", "Stick", "Stock", "Straw", "Stream", "Strike",
            "String", "Sub", "Sugar", "Suit", "Superhero", "Swing", "Switch", "Table", "Tablet", "Tag",
            "Tail", "Tap", "Teacher", "Telescope", "Temple", "Theater", "Thief", "Thumb", "Tick", "Tie",
            "Time", "Tokyo", "Tooth", "Torch", "Tower", "Track", "Train", "Triangle", "Trip", "Trunk",
            "Tube", "Turkey", "Undertaker", "Unicorn", "Vacuum", "Vampire", "Van", "Vet", "Wake", "Wall",
            "War", "Washer", "Washington", "Watch", "Water", "Wave", "Web", "Well", "Whale", "Whip",
            "Wind", "Wine", "Witch", "Wizard", "Wolf", "Wood", "Worm", "Yard", "Year", "Yellow",
            "Yoga", "Zoo"
        ]
        
        codenamesWords.shuffle()
        
        return Array(codenamesWords.prefix(25))
    }
    
    private func shuffledColors() -> [String] {
        var colorsArray: [String] = Array(repeating: "Tan", count: 7)
        + ["Black"]
        + Array(repeating: "Red", count: 8)
        + Array(repeating: "Blue", count: 9)
        
        colorsArray.shuffle()
        
        return colorsArray
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        self.myUUID = conversation.localParticipantIdentifier.uuidString
        let gameModel = GameModel(message: conversation.selectedMessage) ?? nil
        // Update the game view with the updated model
        presentGameView(with: gameModel!)
    }
    
    private func presentGameView(with model: GameModel) {
        var contentView = ContentView(model: model, myUUID: myUUID!)
        contentView.messagesViewController = self
        let hostingController = UIHostingController(rootView: contentView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingController.didMove(toParent: self)
    }
    
    func sendHint(model: GameModel, hintText: String, numberOfCards: Int) {
        let hint = hintText.capitalized + " for " + String(numberOfCards)
        let caption = "Your clue is " + hint
        let sendModel = GameModel(playerNumber: "2", hintText: hint, words: model.words, cardColors: model.cardColors, selected: model.selected, gameOver: model.gameOver, player1UUID: model.player1UUID)
        if let conversation = activeConversation {
            let message = composeMessage(with: sendModel, caption: caption, session: conversation.selectedMessage?.session, scenario: 0)
            conversation.insert(message) { error in
                if let error = error {
                    print("Error inserting message: \(error)")
                } else {
                    self.dismiss()
                }
            }
        }
    }
    
    func endGuessing(model: GameModel, scenario: Int) {
        var updatedModel = GameModel(playerNumber: "1", hintText: "NA", words: model.words, cardColors: model.cardColors, selected: model.selected, gameOver: model.gameOver, player1UUID: model.player1UUID)
        var gameOver = scenario
        if gameOver == 0 {
            updatedModel = redGuessesCardsCorrectly(model: updatedModel)
            if didColorWin(model: updatedModel, color: "Red") {
                gameOver = 1
            }
        }
        updatedModel.gameOver = String(gameOver)
        if let conversation = activeConversation {
            let message = composeMessage(with: updatedModel, caption: "Guessing ended. Give another clue!", session: conversation.selectedMessage?.session, scenario: gameOver)
            conversation.insert(message) { error in
                if let error = error {
                    print("Error inserting message: \(error)")
                } else {
                    self.dismiss()
                }
            }
        }
    }
    
    func cardClicked(model: GameModel, index: Int) {
        var gameModel = model
        if gameModel.playerNumber == "2" && myUUID != gameModel.player1UUID && gameModel.selected[index] == "False" && gameModel.gameOver == "0"{
            gameModel.selected[index] = "True"
            let redWin = didColorWin(model: gameModel, color: "Red")
            let blueWin = didColorWin(model: gameModel, color: "Blue")
            let blackWin = didColorWin(model: gameModel, color: "Black")
            if gameModel.cardColors[index] != "Blue" || redWin || blueWin || blackWin {
                var scenario = 0
                if redWin {
                    scenario = 1
                }
                if blueWin {
                    scenario = 2
                }
                if blackWin {
                    scenario = 3
                }
                endGuessing(model: gameModel, scenario: scenario)
            }
            presentGameView(with: gameModel)
        }
    }
    
    private func didColorWin(model: GameModel, color: String) -> Bool {
        let indices = model.cardColors.indices.filter {model.cardColors[$0] == color}
        let win = checkIfAllSelected(array: model.selected, indices: indices)
        return win
    }
    
    private func redGuessesCardsCorrectly(model: GameModel) -> GameModel{
        var updatedModel = model
        let indices = model.cardColors.indices.filter {model.cardColors[$0] == "Red"}
        var notSelectedIndices : [Int] = []
        for index in indices {
            if model.selected[index] != "True" {
                notSelectedIndices.append(index)
            }
        }
        notSelectedIndices.shuffle()
        for i in 0...1 {
            if notSelectedIndices.indices.contains(i) {
                updatedModel.selected[notSelectedIndices[i]] = "True"
            }
        }
        return updatedModel
    }
    
    private func checkIfAllSelected(array: [String], indices: [Int]) -> Bool {
        for index in indices {
            if array[index] != "True" {
                return false
            }
        }
        return true
    }
    /// - Tag: ComposeMessage
    fileprivate func composeMessage(with model: GameModel, caption: String, session: MSSession? = nil, scenario: Int) -> MSMessage {
        var components = URLComponents()
        components.queryItems = model.queryItems
        
        let layout = MSMessageTemplateLayout()
        switch scenario {
        case 0:
            layout.image = UIImage(named: "Icon Rectangle")
            layout.caption = caption
        case 1:
            layout.image = UIImage(named: "Icon Rectangle Red")
            layout.caption = "You lose. The red enemy team identified all their agents first."
        case 2:
            layout.image = UIImage(named: "Icon Rectangle Blue")
            layout.caption = "You Win! Blue team succesfully identified all ally operatives!"
        case 3:
            layout.image = UIImage(named: "Icon Rectangle Black")
            layout.caption = "You lose. The black card was chosen and the assasin was mistakenly identified!"
        default:
            layout.image = UIImage(named: "Icon Rectangle")
            layout.caption = caption
        }
        
        let message = MSMessage(session: session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        return message
    }
}
