//
//  SelectedImagesVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 15/07/24.
//

import UIKit

class SelectedImagesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var selectedImages = [PropertyImages]()
    var didTapSubmitBlock:((_ obj: [PropertyImages])->Void)?
    var didTapCancelButton:(()->Void)?
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func postProppertyImages(_ data: PropertyImages, completionHandler: @escaping (PostPropertyModel?)->Void) {
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            WebService.shared.postPropertyImages(data, success: { result in
                print(result)
                Utility.shared.propertyId = /result?.data?.propertyId
                for index in 0..<self.selectedImages.count{
                    self.selectedImages[index].propertyId = Utility.shared.propertyId
                }
                if self.currentIndex == self.selectedImages.count - 1{
                    Toast.show(text: result?.message, type: .info)
                }
                completionHandler(result?.data)
            }, failure: { (error) in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
                completionHandler(nil)
            }, uploadProgress: { (process) in
                if process == 1.0{
                    let queue = DispatchQueue.main
                    let deadline = DispatchTime.now() + .seconds(2)
                    queue.asyncAfter(deadline: deadline) {
                        if self.currentIndex < self.selectedImages.count{
                            self.currentIndex += 1
                            self.uploadNextImage()
                        }else{
                            self.stopAnimation()
                        }
                    }
                }
                data.uploadProgress = /process
            })
        }else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
            completionHandler(nil)
        }
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        backToController()
    }
    
    func backToController() {
        self.showAlert(title: "RealityNXT".localizedString, message: "Are you sure you want to Close?".localizedString) { (status) in
            if status{
                self.dismiss(animated: true)
            }else{
              
            }
        }
    }
    
    @IBAction func didTapUplodButton(_ sender: Any) {
        uploadNextImage()
    }
    
    func uploadNextImage(){
        if selectedImages.count > 0{
            if currentIndex < selectedImages.count{
                self.postProppertyImages(selectedImages[self.currentIndex]) { response in
                    if response != nil{
                        self.selectedImages[self.currentIndex].id = response?.id
                    }
                }
                if self.currentIndex == selectedImages.count - 1{
                    self.dismiss(animated: true)
                    didTapSubmitBlock?(self.selectedImages)
                }
            }
        }
    }
}

extension SelectedImagesVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedImageCollectionCell", for: indexPath) as! selectedImageCollectionCell
        cell.assignData(self.selectedImages[indexPath.row],indexPath.row)
        cell.updateTagValue = { (obj,index) in
            self.selectedImages[index] = obj
            let filterdArr = self.selectedImages.filter({$0.picType == ""})
            if filterdArr.count > 0{
                self.uploadButton.isUserInteractionEnabled = false
                self.uploadButton.alpha = 0.4
            }else{
                self.uploadButton.isUserInteractionEnabled = true
                self.uploadButton.alpha = 1.0
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 48)/2, height: (self.view.frame.width - 48)/2)
    }
    
}

class selectedImageCollectionCell: UICollectionViewCell,UITextFieldDelegate{
    
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var tagTextField: UITextField!
    
    var obj = PropertyImages()
    var indexValue: Int?
    var updateTagValue:((_ obj: PropertyImages, _ index: Int)->Void)?
    
    func assignData(_ obj: PropertyImages,_ index: Int){
        self.indexValue = index
        self.obj = obj
        tagTextField.delegate = self
        if let dataDecoded : Data = Data(base64Encoded: /obj.files, options: .ignoreUnknownCharacters){
            let decodedimage = UIImage(data: dataDecoded)
            selectedImg.image = decodedimage
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        self.obj.picType = updatedText
        self.updateTagValue?(self.obj,/self.indexValue)
        return true
    }
}
