//
//  GameModel.swift
//  CodeMessages MessagesExtension
//
//  Created by Sarju Thakkar on 6/19/23.
//

import Foundation
import SwiftUI
import Messages

struct GameModel {
    var playerNumber: String
    var hintText: String
    var words: [String]
    var cardColors: [String]
    var selected: [String]
    var gameOver: String
    var player1UUID: String
    
    init(playerNumber: String, hintText: String, words: [String], cardColors: [String], selected: [String], gameOver: String, player1UUID: String) {
        self.playerNumber = playerNumber
        self.hintText = hintText
        self.words = words
        self.cardColors = cardColors
        self.selected = selected
        self.gameOver = gameOver
        self.player1UUID = player1UUID
    }
}

extension GameModel {
    
    // MARK: Computed properties
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        // Player Number
        let playerNumberItem = URLQueryItem(name: "playerNumber", value: playerNumber)
        items.append(playerNumberItem)
        
        // Hint Text
        let hintTextItem = URLQueryItem(name: "hintText", value: hintText)
        items.append(hintTextItem)
        
        // Words
        for (index, word) in words.enumerated() {
            let wordItem = URLQueryItem(name: "word_\(index)", value: word)
            items.append(wordItem)
        }
        
        // Card Colors
        for (index, color) in cardColors.enumerated() {
            let cardColorItem = URLQueryItem(name: "colors_\(index)", value: color)
            items.append(cardColorItem)
        }
        
        // Selected
        for (index, selected) in selected.enumerated() {
            let selectedValueItem = URLQueryItem(name: "selected_\(index)", value: selected)
            items.append(selectedValueItem)
        }
        
        // Waiting
        let gameOverItem = URLQueryItem(name: "gameOver", value: gameOver)
        items.append(gameOverItem)
        
        let player1UUIDItem = URLQueryItem(name: "player1UUID", value: player1UUID)
        items.append(player1UUIDItem)
        
        return items
    }
    
    init?(queryItems: [URLQueryItem]) {
        // Populate the game model from the query items
        var playerNumber: String = ""
        var hintText: String = ""
        var words: [String] = []
        var cardColors: [String] = []
        var selected: [String] = []
        var gameOver: String = ""
        var player1UUID: String = ""
        
        for item in queryItems {
           switch item.name {
           case "playerNumber":
               playerNumber = item.value ?? ""
           case "hintText":
               hintText = item.value ?? ""
           case let name where name.hasPrefix("word_"):
               words.append(item.value ?? "")
           case let name where name.hasPrefix("colors_"):
               cardColors.append(item.value ?? "")
           case let name where name.hasPrefix("selected_"):
               selected.append(item.value ?? "")
           case "gameOver":
               gameOver = item.value ?? ""
           case "player1UUID":
               player1UUID = item.value ?? ""
           default:
               break
           }
       }
    
        self.playerNumber = playerNumber
        self.hintText = hintText
        self.words = words
        self.cardColors = cardColors
        self.selected = selected
        self.gameOver = gameOver
        self.player1UUID = player1UUID
    }
}

extension GameModel {

    // MARK: Initialization

    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false) else { return nil }
        guard let queryItems = urlComponents.queryItems else { return nil }
        self.init(queryItems: queryItems)
    }
    
}


