//
//  UIViewController+Extension.swift
//  GameListApp
//
//  Created by Berkay Sancar on 20.08.2022.
//

import UIKit.UIViewController

extension UIViewController {
    
    func errorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
