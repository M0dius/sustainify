//
//  AddNonAppController.swift
//  Sustainify
//
//  Created by User on 24/06/1446 AH.
//

import UIKit

class DeliveryController: UITableViewController {
    
    func createFloatingButton() {
        let floatingButton = UIButton()
        floatingButton.setTitle("Add"
        , for: .normal)
        floatingButton.backgroundColor = .black
        floatingButton.layer.cornerRadius = 25
        view.addSubview(floatingButton)
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.bottomAnchor.constraint(equalTo:self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        floatingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        //floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//            createFloatingButton()
        
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
