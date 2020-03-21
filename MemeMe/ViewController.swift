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
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private let topTextValue = "TOP"
    private let bottomTextValue = "BOTTOM"
    private let emptyTextValue = ""
    private let textFieldFontStyle = "HelveticaNeue-CondensedBlack"
    private let textFieldFontSize: CGFloat = 40.0
    private let textFieldStrokeWidth: CGFloat = -1.0
    private var isBottomTextFieldEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMemeViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        openImagePickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        openImagePickerController(sourceType: .camera)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let imageToShare = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.save(memedImage: imageToShare)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = nil
        initMemeViews()
    }
    
    private func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    private func generateMemedImage() -> UIImage {
        setToolbarVisibility(visible: true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setToolbarVisibility(visible: false)
        return memedImage
    }
    
    private func setToolbarVisibility(visible: Bool){
        bottomToolbar.isHidden = visible
        topToolbar.isHidden = visible
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
    
    private func initMemeViews(){
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        initTextField(textField: topTextField, textValue: topTextValue)
        initTextField(textField: bottomTextField, textValue: bottomTextValue)
        shareButton.isEnabled = false
    }
    
    private func initTextField(textField: UITextField, textValue: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: textFieldFontStyle, size: textFieldFontSize)!,
            NSAttributedString.Key.strokeWidth:  textFieldStrokeWidth,
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.borderStyle = .none
        textField.text = textValue
        textField.delegate = self
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification:Notification) {
        if isBottomTextFieldEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        if isBottomTextFieldEditing {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = pickedImage
            shareButton.isEnabled = true
        }
        dismissPicker()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPicker()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == topTextValue || textField.text == bottomTextValue) {
            textField.text = emptyTextValue
        }
        isBottomTextFieldEditing = textField.tag == 1 ? true : false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
