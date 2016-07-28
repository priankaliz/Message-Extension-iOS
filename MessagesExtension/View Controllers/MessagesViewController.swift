//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Prianka Liz Kariat on 7/15/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        
        presentViewController(for: conversation, with: presentationStyle)
       
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        
        requestPresentationStyle(.expanded)
    }
    
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        // Determine the controller to present.
        let controller: UIViewController
        
        if presentationStyle == .compact {
            controller = instantiateVCWithIdentifier(identifier: "CollapsedVC")
        }
        else {
            
            let gameBoardVM = GameStateVM(message: conversation.selectedMessage)
            
            controller = instantiateVCWithIdentifier(identifier: "GameBoardVC")
            
            let gameBoardVC = controller as! GameBoardVC
            gameBoardVC.gameStateVM = gameBoardVM
            gameBoardVC.delegate = self
            
        }
        
        removeAllChildViewControllers()
        
        embedViewController(viewController: controller)
    }
    
    private func instantiateVCWithIdentifier(identifier: String) -> UIViewController {
        
        let storyBoard = UIStoryboard(name: "MainInterface", bundle: nil)
        let gameBoardVC = storyBoard.instantiateViewController(withIdentifier: identifier)
        
        return gameBoardVC
    }
    
    private func embedViewController(viewController: UIViewController) {
        
        addChildViewController(viewController)
        
        viewController.view.frame = view.bounds
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        
        viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        viewController.didMove(toParentViewController: self)
    }
    
    private func removeAllChildViewControllers() {
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
    }

}

extension MessagesViewController: GameBoardVCDelegate {
   
    func selecteWithGameStateVM(gameStateVM: GameStateVM, image: UIImage) {
        
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }

        var components = URLComponents()
        components.queryItems = gameStateVM.queryItems
        components.queryItems?.append(URLQueryItem(name: "\(gameStateVM.player)", value: "0"))

        
        let layout = MSMessageTemplateLayout()
        layout.image = image
        layout.caption = "Game On"
        
        if gameStateVM.decideWinner() != 0 {
            
            layout.caption = "Game Over"
        }
        
        let message = MSMessage(session: self.activeConversation?.selectedMessage?.session ?? MSSession())
        message.url = components.url!
        message.layout = layout
        
        conversation.insert(message, localizedChangeDescription: nil) { (error) in
        }
        
        dismiss()
    }
    
}
