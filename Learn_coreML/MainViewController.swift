//
//  ViewController.swift
//  Learn_coreML
//
//  Created by Mac on 9/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreML
import Vision

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        }
        else{
            imagePicker.sourceType = .photoLibrary
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            
            guard let ciImage = CIImage(image: selectedImage) else {
                fatalError("Could not convert the UIImage to CIImage!")
            }
            
            classifyImage(ciImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func classifyImage(_ image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("Error initializing the model!")
        }
        
        // create a vision CoreML request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Could not get the VNCoreMLRequest")
            }
            
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
}

