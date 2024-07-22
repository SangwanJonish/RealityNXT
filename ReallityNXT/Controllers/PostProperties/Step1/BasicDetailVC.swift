//
//  BasicDetailVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 03/07/24.
//

import UIKit
import MaterialComponents
import PhotosUI
import AVFoundation

class BasicDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var propertyCollectionView: UICollectionView!
    @IBOutlet weak var projectCollectionView: UICollectionView!
    
    var imagePicker: UIImagePickerController!
    var propertyData: PropertyInfo?
    var headerArr = ["What kind of property?","Select Property Type","What kind of commercial property it is?"]
    var selecetedCatory: Int?
    var selectedPropertyType = -1
    var selectedCommericialPropertyType: Int?
    var selectedPropertyImages = [PropertyImages]()
    var selectedProjectImages = [PropertyImages]()
    var isSelectToPropertyCollection: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiForBasicDetailUI()
    }
    
    func apiForBasicDetailUI() {
        
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            WebService.shared.apiForBasicDetailUI { result in
                self.stopAnimation()
                self.propertyData = result
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 44
                self.setDelegates()
                
            } failure: { error in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            }
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
      
    }
    
    func deletePropertyImage(_ index: Int,_ id: Int){
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            WebService.shared.deletePropertyImages(id) { result in
                self.stopAnimation()
                if self.isSelectToPropertyCollection {
                    self.selectedPropertyImages.remove(at: index)
                    self.propertyCollectionView.reloadData()
                }else{
                    self.selectedProjectImages.remove(at: index)
                    self.projectCollectionView.reloadData()
                }
            } failure: { error in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            }
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
    }
    
    func setDelegates(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.propertyCollectionView.dataSource = self
        self.propertyCollectionView.delegate = self
        self.projectCollectionView.dataSource = self
        self.projectCollectionView.delegate = self
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.pop(animated: true)
    }

    @IBAction func didTapContinueButton(_ sender: Any) {
        
        if self.selecetedCatory == nil{
            Toast.show(text: "Please select the category", type: .info)
            return
        }else if self.selectedPropertyType == -1 && /self.selecetedCatory > 0{
            Toast.show(text: "Please select Property type", type: .info)
            return
        }else if self.selectedCommericialPropertyType == nil && /self.selecetedCatory > 0{
            Toast.show(text: "Please select the commercial property type", type: .info)
            return
        }
        postBasicDetail()
    }
    
    @IBAction func didTapChangeAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BottomPopUpLogoutVC") as! BottomPopUpLogoutVC
        self.present(vc, animated: true)
    }
    
    func postBasicDetail() {
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            var dict = [String: Any]()
            dict["id"] = 0
            dict["category"] = self.propertyData?.opropertyCategories?[/self.selecetedCatory].id
            dict["type"] = self.propertyData?.opropertyCategories?[/self.selecetedCatory].oPropertyType?[self.selectedPropertyType].id
            if self.selectedCommericialPropertyType == nil{
                dict["kind"] = 0
            }else{
                dict["kind"] = self.propertyData?.opropertyCategories?[/self.selecetedCatory].oPropertyType?[self.selectedPropertyType].oPropertyKind?[self.selectedCommericialPropertyType ?? 0].id
            }
            dict["userId"] = Utility.shared.user?.id
            WebService.shared.postUserBasicDetail(data: dict) { result in
                self.stopAnimation()
                Toast.show(text: result, type: .info)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AddPhotosPricingVC") as! AddPhotosPricingVC
                self.navigationController?.pushViewController(vc, animated: true)
            } failure: { error in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            }
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
    }
}

extension BasicDetailVC: UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 && selectedPropertyType == -1{
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyTypeTableCell", for: indexPath) as! PropertyTypeTableCell
        cell.configureCell(data: self.propertyData?.opropertyCategories, section: indexPath.section, selectedCategory: self.selecetedCatory, selectedPropertyType: self.selectedPropertyType)
        cell.onDidTappedOnCategory = { (selectedCatery) in
            self.selecetedCatory = selectedCatery
            self.tableView.reloadData()
        }
        cell.onDidTappedOnPropertyType = { (selectedPropertyIndex) in
            self.selectedPropertyType = /selectedPropertyIndex
            self.tableView.reloadData()
        }
        cell.onDidTappedOnCommercialPropertyType = { (selectedPropertyIndex) in
            self.selectedCommericialPropertyType = selectedPropertyIndex
            self.tableView.reloadData()
        }
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        cell.chipsCollectionView.reloadData()
        cell.collectionViewHeight.constant = cell.chipsCollectionView.contentSize.height + 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 2 && self.selecetedCatory == 0{
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedPropertyType == -1 && section == 2{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            return headerView
        }else if selecetedCatory == 0 && section == 2{
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            return headerView
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.clear // Set your desired background color
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width - 30, height: 30))
        titleLabel.textColor = UIColor.black // Set your desired text color
        titleLabel.font = CustomFont.medium13 // Set your desired font
        titleLabel.text = headerArr[section] // Set your section title here
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if selectedPropertyType == -1 && section == 2{
            return 0
        }else if selecetedCatory == 0 && section == 2{
            return 0
        }
        return 30
    }
}

class PropertyTypeTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var chipsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var onDidTappedOnCategory: ((_ index: Int?) -> ())?
    var onDidTappedOnPropertyType: ((_ index: Int?) -> ())?
    var onDidTappedOnCommercialPropertyType: ((_ index: Int?) -> ())?
    var data: [Propertytype]?
    var selectedCategory = 0
    var selectedPropertyType = -1
    var selectedCommercialProprtyType = 0
    var section:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = MDCChipCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        self.chipsCollectionView.collectionViewLayout = layout
        self.chipsCollectionView.allowsSelection = false
        self.chipsCollectionView.reloadData()
        self.chipsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MDCChipCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension PropertyTypeTableCell {
    
    func configureCell(data: [Propertytype]?,section: Int?,selectedCategory: Int?,selectedPropertyType: Int?) {
        self.selectedPropertyType = /selectedPropertyType
        self.selectedCategory = selectedCategory ?? 0
        self.section = section
        self.data = data
        self.chipsCollectionView.reloadData()
    }
    
    
    func configureChipView(chipView: MDCChipView,index: Int) {
        chipView.titleFont = UIFont(name: "Poppins-Regular", size: 13.0)
        chipView.setTitleColor(#colorLiteral(red: 0.1879999936, green: 0.1840000004, blue: 0.2469999939, alpha: 1), for: .normal)
        //        chipView.setTitleColor(Constants.AppColors.labelColor, for: .selected)
        chipView.setBackgroundColor(#colorLiteral(red: 0.9570000172, green: 0.9649999738, blue: 0.976000011, alpha: 1), for: .normal)
        chipView.setBackgroundColor(UIColor.white, for: .selected)
        chipView.setBorderWidth(1, for: .normal)
        chipView.setBorderWidth(1, for: .selected)
        //chipView.selectedImageView.image = #imageLiteral(resourceName: "Weekly Check")
        chipView.setBorderColor(UIColor.clear, for: .normal)
        chipView.setBorderColor(#colorLiteral(red: 0.9369999766, green: 0.4860000014, blue: 0, alpha: 1), for: .selected)
        //chipView.imageView.image = UIImage(named: "AddColored")
        let crossButton = UIButton(type: .custom)
        crossButton.setImage(UIImage(named: "cross"), for: .normal)
        //crossButton.tintColor = Constants.AppColors.appRedColor
        crossButton.isUserInteractionEnabled = true
        crossButton.tag = index
        crossButton.addTarget(self, action: #selector(crossButtonTapped(_:)), for: .touchUpInside)
        chipView.accessoryView = crossButton
    }
    
    @objc func crossButtonTapped(_ sender: UIButton) {
        switch self.section {
        case 0:
            self.selectedPropertyType = sender.tag == 0 ? -1 : self.selectedPropertyType
            self.selectedCategory = sender.tag
            for idx in 0 ..< /data?.count{
                if self.selectedCategory == idx{
                    self.data?[idx].isSelected.toggle()
                }else{
                    self.data?[idx].isSelected = false
                }
            }
            self.onDidTappedOnCategory?(self.selectedCategory)
        case 1:
            
            self.selectedPropertyType = sender.tag
            for idx in 0 ..< /data?[self.selectedCategory].oPropertyType?.count{
                if self.selectedPropertyType == idx{
                    self.data?[self.selectedCategory].oPropertyType?[idx].isSelected.toggle()
                }else{
                    self.data?[self.selectedCategory].oPropertyType?[idx].isSelected = false
                }
            }
            self.onDidTappedOnPropertyType?(self.selectedPropertyType)
        default:
            self.selectedCommercialProprtyType = sender.tag
            for idx in 0 ..< /data?[self.selectedCategory].oPropertyType?[self.selectedPropertyType].oPropertyKind?.count{
                if self.selectedCommercialProprtyType == idx{
                    self.data?[self.selectedCategory].oPropertyType?[self.selectedPropertyType].oPropertyKind?[idx].isSelected.toggle()
                }else{
                    self.data?[self.selectedCategory].oPropertyType?[self.selectedPropertyType].oPropertyKind?[idx].isSelected = false
                }
            }
            self.onDidTappedOnCommercialPropertyType?(self.selectedCommercialProprtyType)
        }
    }
    
}

// MARK: - Extensions

// MARK: - Collection View DataSources

extension PropertyTypeTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.section {
        case 0:
            return /self.data?.count
        case 1:
            return /self.data?[selectedCategory].oPropertyType?.count
        default:
            if self.selectedPropertyType == -1{
                return 0
            }
            return self.data?[selectedCategory].oPropertyType?[selectedPropertyType].oPropertyKind?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDCChipCollectionViewCell", for: indexPath) as! MDCChipCollectionViewCell
        switch self.section {
        case 0:
            let obj = data?[indexPath.row]
            let text = "\(/obj?.propertyCategory)"
            cell.chipView.titleLabel.text = text
            let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            cell.chipView.titleLabel.tag = indexPath.row
            cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
            cell.chipView.titleLabel.isUserInteractionEnabled = true
            cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
            configureChipView(chipView: cell.chipView, index: indexPath.row)
            if obj?.isSelected == false{
                cell.chipView.accessoryView?.isHidden = true
                //cell.chipView.imageView.isHidden = true
            }else{
                cell.chipView.accessoryView?.isHidden = false
                //cell.chipView.imageView.isHidden = false
            }
        case 1:
            let obj = data?[selectedCategory].oPropertyType?[indexPath.row]
            let text = "\(/obj?.propertyType)"
            cell.chipView.titleLabel.text = text
            let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            cell.chipView.titleLabel.tag = indexPath.row
            cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
            cell.chipView.titleLabel.isUserInteractionEnabled = true
            cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
            configureChipView(chipView: cell.chipView, index: indexPath.row)
            if obj?.isSelected == false{
                cell.chipView.accessoryView?.isHidden = true
                //cell.chipView.imageView.isHidden = true
            }else{
                cell.chipView.accessoryView?.isHidden = false
                //cell.chipView.imageView.isHidden = false
            }
        default:
            if selectedPropertyType != -1{
                let obj = data?[selectedCategory].oPropertyType?[selectedPropertyType].oPropertyKind?[indexPath.row]
                let text = "\(/obj?.propertyKind)"
                cell.chipView.titleLabel.text = text
                let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                cell.chipView.titleLabel.tag = indexPath.row
                cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
                cell.chipView.titleLabel.isUserInteractionEnabled = true
                cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
                configureChipView(chipView: cell.chipView, index: indexPath.row)
                if obj?.isSelected == false{
                    cell.chipView.accessoryView?.isHidden = true
                    //cell.chipView.imageView.isHidden = true
                }else{
                    cell.chipView.accessoryView?.isHidden = false
                    //cell.chipView.imageView.isHidden = false
                }
            }
            
        }
        cell.chipView.layoutIfNeeded()
        cell.alwaysAnimateResize = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else {
            return // In case tag is not set or view is not UILabel
        }
        switch self.section {
        case 0:
            self.selectedPropertyType = index == 0 ? -1 : self.selectedPropertyType
            self.selectedCategory = index
            for idx in 0 ..< /data?.count{
                if self.selectedCategory == idx{
                    self.data?[idx].isSelected.toggle()
                }else{
                    self.data?[idx].isSelected = false
                }
            }
            self.onDidTappedOnCategory?(self.selectedCategory)
        case 1:
            
            self.selectedPropertyType = index
            for idx in 0 ..< /data?[self.selectedCategory].oPropertyType?.count{
                if self.selectedPropertyType == idx{
                    self.data?[self.selectedCategory].oPropertyType?[idx].isSelected.toggle()
                }else{
                    self.data?[self.selectedCategory].oPropertyType?[idx].isSelected = false
                }
            }
            self.onDidTappedOnPropertyType?(self.selectedPropertyType)
        default:
            self.selectedCommercialProprtyType = index
            for idx in 0 ..< /data?[self.selectedCategory].oPropertyType?[self.selectedPropertyType].oPropertyKind?.count{
                if self.selectedCommercialProprtyType == idx{
                    self.data?[self.selectedCategory].oPropertyType?[self.selectedPropertyType].oPropertyKind?[idx].isSelected.toggle()
                }else{
                    self.data?[self.selectedCategory].oPropertyType?[self.selectedPropertyType].oPropertyKind?[idx].isSelected = false
                }
            }
            self.onDidTappedOnCommercialPropertyType?(self.selectedCommercialProprtyType)
        }
        print("Tapped on index: \(index)")
    }
}

extension BasicDetailVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == propertyCollectionView{
            return /self.selectedPropertyImages.count + 1
        }else{
            return /self.selectedProjectImages.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == propertyCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCollectionCell", for: indexPath) as! PropertyCollectionCell
            cell.crossBtn.tag = indexPath.row
            if selectedPropertyImages.count == 0 || selectedPropertyImages.count == indexPath.row{
                cell.crossBtn.isHidden = true
                cell.propertyImg.isHidden = true
                return cell
            }
            if let dataDecoded : Data = Data(base64Encoded: /self.selectedPropertyImages[indexPath.row].files, options: .ignoreUnknownCharacters){
                let decodedimage = UIImage(data: dataDecoded)
                cell.assignData(decodedimage)
            }
            cell.didTapDeletePropertyImageBlock = { (index) in
                self.isSelectToPropertyCollection = true
                self.deletePropertyImage(index,/self.selectedPropertyImages[index].id)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCollectionCell", for: indexPath) as! ProjectCollectionCell
            cell.crossBtn.tag = indexPath.row
            if selectedProjectImages.count == 0 || selectedProjectImages.count == indexPath.row{
                cell.crossBtn.isHidden = true
                cell.projectImg.isHidden = true
                return cell
            }
            if let dataDecoded : Data = Data(base64Encoded: /self.selectedProjectImages[indexPath.row].files, options: .ignoreUnknownCharacters){
                let decodedimage = UIImage(data: dataDecoded)
                cell.assignData(decodedimage)
            }
            cell.didTapDeleteProjectImageBlock = { (index) in
                self.isSelectToPropertyCollection = false
                self.deletePropertyImage(index,/self.selectedProjectImages[index].id)
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == propertyCollectionView{
                isSelectToPropertyCollection = true
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BottomSheetPopUpForSelectCameraGallry") as! BottomSheetPopUpForSelectCameraGallry
                vc.didTapCameraBlock = {
                    self.imagePicker = UIImagePickerController()
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .camera
                    
                    if let presentedVC = self.presentedViewController {
                      presentedVC.dismiss(animated: true) {
                          self.present(self.imagePicker, animated: true, completion: nil)
                      }
                    } else {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
                vc.didTapGallaryBlock = {
                    var configuration = PHPickerConfiguration()
                    configuration.selectionLimit = 0 // 0 means no limit
                    configuration.filter = .images
                    let picker = PHPickerViewController(configuration: configuration)
                    picker.delegate = self
                    if let presentedVC = self.presentedViewController {
                      presentedVC.dismiss(animated: true) {
                          self.present(picker, animated: true, completion: nil)
                      }
                    } else {
                        self.present(picker, animated: true, completion: nil)
                    }
                }
                self.present(vc, animated: true)
                
                
            }else{
            isSelectToPropertyCollection = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BottomSheetPopUpForSelectCameraGallry") as! BottomSheetPopUpForSelectCameraGallry
            vc.didTapCameraBlock = {
                self.imagePicker = UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                
                if let presentedVC = self.presentedViewController {
                  presentedVC.dismiss(animated: true) {
                      self.present(self.imagePicker, animated: true, completion: nil)
                  }
                } else {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
            vc.didTapGallaryBlock = {
                var configuration = PHPickerConfiguration()
                configuration.selectionLimit = 0 // 0 means no limit
                configuration.filter = .images
                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                if let presentedVC = self.presentedViewController {
                  presentedVC.dismiss(animated: true) {
                      self.present(picker, animated: true, completion: nil)
                  }
                } else {
                    self.present(picker, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true)
            
            
        }
        
    }
}

extension BasicDetailVC: PHPickerViewControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        for index in 0..<results.count {
            results[index].itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        // Handle the selected image here
                        self.handleSelectedImage(image)
                        let queue = DispatchQueue.main
                        let deadline = DispatchTime.now() + .seconds(0)
                        queue.asyncAfter(deadline: deadline) {
                            if index == results.count - 1{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "SelectedImagesVC") as! SelectedImagesVC
                                if self.isSelectToPropertyCollection{
                                    vc.selectedImages = self.selectedPropertyImages
                                }else{
                                    vc.selectedImages = self.selectedProjectImages
                                }
                                vc.didTapSubmitBlock = { (obj) in
                                    if self.isSelectToPropertyCollection{
                                        self.selectedPropertyImages = obj
                                        self.propertyCollectionView.reloadData()
                                    }else{
                                        self.selectedProjectImages = obj
                                        self.projectCollectionView.reloadData()
                                    }
                                }
                                self.present(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func handleSelectedImage(_ image: UIImage) {
        // Handle your selected image here
        // For example, you can add it to an array or display it in an image view
        print("Selected image: \(image)")
        if isSelectToPropertyCollection{
            let imgeData = image.pngData()
            let obj = PropertyImages.make(files: (imgeData?.base64EncodedString(options: .lineLength64Characters))!, picType: "", propertyId: /Utility.shared.propertyId, propertyType: "InteriorImages")
            self.selectedPropertyImages.append(obj)
        }else{
            let imgeData = image.pngData()
            let obj = PropertyImages.make(files: (imgeData?.base64EncodedString(options: .lineLength64Characters))!, picType: "", propertyId: /Utility.shared.propertyId, propertyType: "ExterierImages")
            self.selectedProjectImages.append(obj)
        }
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        print(image)
    }
}

extension BasicDetailVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 95)
    }
}

class PropertyCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var propertyImg: UIImageView!
    @IBOutlet weak var crossBtn: UIButton!
    var didTapDeletePropertyImageBlock:((_ index: Int)->Void)?
    
    func assignData(_ obj: UIImage?){
        propertyImg.image = obj
        crossBtn.isHidden = false
        propertyImg.isHidden = false
        
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        didTapDeletePropertyImageBlock?(sender.tag)
    }
}

class ProjectCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var projectImg: UIImageView!
    @IBOutlet weak var crossBtn: UIButton!
    var didTapDeleteProjectImageBlock:((_ index: Int)->Void)?
    
    func assignData(_ obj: UIImage?){
        projectImg.image = obj
        crossBtn.isHidden = false
        projectImg.isHidden = false
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        didTapDeleteProjectImageBlock?(sender.tag)
    }
}
