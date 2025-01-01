//
//  ImpactTrackerViewController.swift
//  Sustain
//
//  Created by Ganesh Raju Galla on 29/12/24.
//

import UIKit

class ImpactTrackerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Store",
            style: .plain,
            target: self,
            action: #selector(openStore)
        )
    }
    
    @objc func openStore() {
        let intent = ProductsNavigationIntent()
        NavigationManager.show(intent, on: self.navigationController, animation: .push)
    }
    
    // MARK: - IBActions
    @IBAction func addProductAction(_ sender: UIButton) {
        let intent = NonAppTableNavigationIntent()
        NavigationManager.show(intent, on: self.navigationController, animation: .push)
    }
}
