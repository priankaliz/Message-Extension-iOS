//
//  GameStateVM.swift
//  TicTacToeSample
//
//  Created by Prianka Liz Kariat on 7/15/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import Messages

class GameStateVM {
    
    var gameStateArray: [Int] = []
    var player: Int = 0
    var queryItems: [URLQueryItem] = []
    
    let rowCount = 3
    
    init(queryItems: [URLQueryItem]) {
        
        gameStateArray = [Int](repeating: 0, count: (rowCount * 2) + 2)
        
        guard queryItems.count > 0 else {
            
            player = 1
            
            self.queryItems = [URLQueryItem](repeating: URLQueryItem(name: "0", value: "0"), count: rowCount * rowCount)
            return
            
        }
        
        for i in 0...queryItems.count - 1 {
            
            let queryItem = queryItems[i]
            
            let player = Int(queryItem.name)
            
            if i == queryItems.count - 1 {
                
                self.player = player! == 1 ? -1 : 1
            }
            else {
                self.queryItems.append(queryItem)
            }
        }
        
        for index in 0...self.queryItems.count - 1 {
            
            changeGameArrayWithRow(row: index / rowCount, column: index % rowCount, player: Int(self.queryItems[index].value!)!)
            
        }
    }
    
    convenience init(message: MSMessage?) {
        
        guard let messageURL = message?.url else {
            
            self.init(queryItems: [])
            return
            
        }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), queryItems = urlComponents.queryItems else {
            
            self.init(queryItems: [])
            return
        }
        
        self.init(queryItems: queryItems)
    }
    
    
    func  placeItemAtRow(row: Int, column col: Int, player: Int) {
        
        changeGameArrayWithRow(row: row, column: col, player: player)
        queryItems[(row * rowCount) + col] = URLQueryItem(name: "\(self.player)", value: "\(player)")
        print(queryItems)
    }
    
    
    func decideWinner() -> Int {
        
        for state in gameStateArray {
            
            if state == -rowCount {
                
                return -1
            }
            else if state == rowCount {
                
                return 1
            }
        }
        
        return 0
    }
    
    //MARK: Private Methods
    private func  changeGameArrayWithRow(row: Int, column col: Int, player: Int) {
        
        gameStateArray[row] += player
        gameStateArray[rowCount + col] += player
        
        if row == col {
            
            gameStateArray[rowCount * 2] += player
            
        }
        
        if (rowCount - 1 - col) == row {
            
            gameStateArray[(rowCount * 2) + 1] += player
        }
        
    }
    
}
