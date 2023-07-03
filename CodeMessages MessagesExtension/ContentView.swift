import SwiftUI
import Messages

var tan = Color(UIColor(red: 252/255, green: 228/255, blue: 194/255, alpha: 1.0))
struct ContentView: View {
    @State private var selectedNumber = 1
    @State private var inputText = ""
    weak var messagesViewController: MessagesViewController?
    var model: GameModel
    var myUUID: String
    var body: some View {
        let messageSent = (myUUID == model.player1UUID && model.playerNumber == "2") || (myUUID != model.player1UUID && model.playerNumber == "1")
        let gameOver = model.gameOver != "0"
        VStack {
            GridView(model: model, messagesViewController: messagesViewController!, myUUID: myUUID, messageSent: messageSent, gameOver: gameOver)
                .padding(.top, 10)
            if myUUID == model.player1UUID {
                HStack {
                    TextField("Enter a hint", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Picker(selection: $selectedNumber, label: Text("Select number of cards")) {
                        ForEach(1...9, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Button(action: {
                        messagesViewController!.sendHint(model: model, hintText: inputText, numberOfCards: selectedNumber)
                    }) {
                        Text("Send")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(messageSent || gameOver)  // Disable the button if message sent
                    .opacity(messageSent ? 0.5 : 1.0)  // Adjust opacity if message sent
                }
            } else {
                HStack {
                    Text(model.hintText)
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding()
                    
                    Button(action: {
                        messagesViewController!.endGuessing(model: model, scenario: 0)
                    }) {
                        Text("End Guessing")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(messageSent)  // Disable the button if message sent
                    .opacity(messageSent ? 0.5 : 1.0)  // Adjust opacity if message sent
                }
            }
            
            if messageSent && !gameOver {
                WaitingView()
            }
            
            if gameOver {
                GameOverView(scenario: model.gameOver)
            }
                
            Spacer()
        
        }
    }
}

struct GridView: View {
    var model: GameModel
    var messagesViewController: MessagesViewController
    var myUUID: String
    var messageSent: Bool
    var gameOver: Bool
    
    var body: some View {
        let isPlayer1 = myUUID == model.player1UUID
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
            ForEach(0..<model.words.count, id: \.self) { index in
                Button(action: {
                    messagesViewController.cardClicked(model: model, index: index)
               }) {
                   CardView(cardColor: !isPlayer1 && model.selected[index] == "False"  ?  "White" : model.cardColors[index], word: model.words[index], selected: model.selected[index], isPlayer1: isPlayer1)
               }
               .buttonStyle(PlainButtonStyle())
               .id(index)
            }
        }
    }
}
    
struct CardView: View {
    var cardColor: String
    var word: String
    var selected: String
    var isPlayer1: Bool
    
    var body: some View {
        let color = transformToSwiftUIColor(color: cardColor)
        ZStack {
            color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
            
            Text(word)
                .foregroundColor(selected == "True" && isPlayer1 ? color : (color == .white || color == tan) ? Color.black : Color.white)
                .font(.system(size: 18, weight: .bold, design: .default))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

func transformToSwiftUIColor(color: String) -> Color {
    let colorMap: [String: Color] = [
        "White": .white,
        "Tan": tan,
        "Black": .black,
        "Red": .red,
        "Blue": .blue
    ]
    
    return colorMap[color] ?? .clear
}

struct WaitingView: View {
    @State private var dotCount = 1
    @State private var timer: Timer?
    
    let maxDotCount = 3
    
    var dotText: String {
        let dots = String(repeating: ".", count: dotCount)
        return "\(dots)"
    }
    
    var body: some View {
        VStack {
            Text("Waiting for partner \(dotText)")
                .font(.title)
                .foregroundColor(.blue)
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            dotCount = (dotCount % maxDotCount) + 1
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
}

struct GameOverView: View {
    let scenario: String

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text(titleText)
                .font(.title2)
                .foregroundColor(titleColor)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding()
        }
    }

    private var titleText: String {
        switch scenario {
        case "1":
            return "You lose. The enemy identified all their agents first."
        case "2":
            return "You Win! Succesfully identified all ally operatives!"
        case "3":
            return "You lose. The assasin was mistakenly identified!"
        default:
            return "Game Over"
        }
    }

    private var titleColor: Color {
        switch (scenario, colorScheme) {
        case ("1", _):
            return .red
        case ("2", _):
            return .blue
        case ("3", .light):
            return .black
        default:
            return .primary
        }
    }
}

