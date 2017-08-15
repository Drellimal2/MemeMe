//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Dane Miller on 8/14/17.
//  Copyright © 2017 Dane Miller. All rights reserved.
//

import Foundation
import UIKit

// MARK: - EmojiTextFieldDelegate : NSObject, UITextFieldDelegate

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    let TOP_TAG = 0
    let BOTTOM_TAG = 1
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == TOP_TAG && textField.text == "TOP") ||
            (textField.tag == BOTTOM_TAG && textField.text == "BOTTOM"){
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
