//
//  ViewController.swift
//  MemeMe
//
//  Created by Byron Ajin on 3/15/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    private let topTextValue = "TOP"
    private let bottomTextValue = "BOTTOM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        initTextField(textField: topTextField, textValue: topTextValue)
        initTextField(textField: bottomTextField, textValue: bottomTextValue)
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        openImagePickerController(sourceType: .photoLibrary)
    }
    
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        openImagePickerController(sourceType: .camera)
    }
    
    private func openImagePickerController(sourceType: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    private func dismissPicker() {
        dismiss(animated: true, completion: nil)
    }
    
    private func initTextField(textField: UITextField, textValue: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -1.0,
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.borderStyle = .none
        textField.text = textValue
        textField.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = pickedImage
        }
        
        dismissPicker()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPicker()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == topTextValue || textField.text == bottomTextValue) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}

