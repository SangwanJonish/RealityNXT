//
//  AddPhotosPricingVC.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 09/07/24.
//

import UIKit
import MaterialComponents
import DropDown

class AddPhotosPricingVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var localityName: UITextField!
    @IBOutlet weak var apartmentName: UITextField!
    @IBOutlet weak var houseNumberName: UITextField!
    
    @IBOutlet weak var areaDetailTF: UITextField!
    @IBOutlet weak var areaUnitTF: UITextField!
    
    @IBOutlet weak var buildUpAreaTF: UITextField!
    @IBOutlet weak var buildUpAreaUnitTF: UITextField!
    
    @IBOutlet weak var superBuildUpAreaTF: UITextField!
    @IBOutlet weak var superBuildUpAreaUnitTF: UITextField!
    
    @IBOutlet weak var expectedPriceTF: UITextField!
    @IBOutlet weak var pricePerSqTF: UITextField!
    @IBOutlet weak var pricePerSqUnitTF: UITextField!
    
    @IBOutlet weak var superBuildupAreaStackHeight: NSLayoutConstraint!
    @IBOutlet weak var buildupAreaStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var localityView: UIView!
    @IBOutlet weak var apartmentView: UIView!
    @IBOutlet weak var houseNumberView: UIView!
    
    @IBOutlet weak var HeaderView: UIView!
        
    var propertyData: OwnershipArrays?
    var headerArr = ["Ownership"]
    var selecetedCatory: Int?
    var selectedPropertyType = -1
    var headerViewUpdated: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiForPhotosAndPriceUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("updateAddress"), object: nil)
        headerViewUpdated = false
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        localityView.isHidden = false
        apartmentView.isHidden = false
        houseNumberView.isHidden = false
        headerViewUpdated = true
        self.tableView.reloadData()
        if let info = notification.userInfo as? Dictionary<String,String> {
            if let country = info["address"] {
                let addressArr = country.components(separatedBy: ",")
                cityName.text = addressArr[addressArr.count - 3]
                localityName.text = info["name"]
                apartmentName.text = addressArr.first
                houseNumberName.text = ""
            }
        }
        else {
          print("wrong userInfo type")
        }
    }
    
    func apiForPhotosAndPriceUI() {
        
        self.startAnimation()
        if Connectivity.isConnectedToInternet {
            WebService.shared.apiForPhotosAndPriceUI { result in
                self.stopAnimation()
                self.propertyData = result
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.rowHeight = UITableView.automaticDimension
                self.tableView.estimatedRowHeight = 44
            } failure: { error in
                self.stopAnimation()
                Toast.show(text: error?.localizedDescription, type: .info)
            }
        } else {
            self.stopAnimation()
            Toast.show(text: APP_MESSAGES.noInternetMessage, type: .info)
        }
      
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.pop(animated: true)
    }
    
    @IBAction func didTapSearchLocationButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapViewVC") as! MapViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapDropDownButton(_ sender: UIButton) {
        
        if let areaArr = self.propertyData?.areaUnit?.map({$0.areaUnit ?? ""}){
            Utility.shared.showDropDown(anchorView: sender, dataSource: areaArr, width: 100) { index, strVal in
            
                switch sender.tag{
                case 1:
                    self.areaUnitTF.text = strVal
                case 2:
                    self.buildUpAreaUnitTF.text = strVal
                case 3:
                    self.superBuildUpAreaUnitTF.text = strVal
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func didTapCarpetAreaButton(_ sender: Any) {
    }
    
    @IBAction func didTapBuildUpAreaButton(_ sender: Any) {
        buildupAreaStackHeight.constant = buildupAreaStackHeight.constant == 0 ? 55 : 0
    }
    
    @IBAction func didTapSuperBuildUpAreaButton(_ sender: Any) {
        superBuildupAreaStackHeight.constant = superBuildupAreaStackHeight.constant == 0 ? 55 : 0
    }

}

extension AddPhotosPricingVC: UITableViewDelegate,UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OwnershipTableCell", for: indexPath) as! OwnershipTableCell
        cell.configureCell(data: self.propertyData?.ownerTypes, section: indexPath.section, selectedCategory: self.selecetedCatory)
        cell.onDidTappedOnCategory = { (selectedCatery) in
            self.selecetedCatory = selectedCatery
            self.tableView.reloadData()
        }
        cell.frame = tableView.bounds
        cell.layoutIfNeeded()
        cell.chipsCollectionView.reloadData()
        cell.collectionViewHeight.constant = cell.chipsCollectionView.contentSize.height + 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
//        headerView.backgroundColor = UIColor.clear // Set your desired background color
//
//        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width - 30, height: 50))
//        titleLabel.textColor = UIColor.black // Set your desired text color
//        titleLabel.font = CustomFont.medium13 // Set your desired font
//        titleLabel.text = headerArr[section] // Set your section title here
//
//        headerView.addSubview(titleLabel)
        
        return HeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerViewUpdated == false ? 300 : 488
    }
}

class OwnershipTableCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var chipsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var onDidTappedOnCategory: ((_ index: Int?) -> ())?
    var data: [OwnerTypes]?
    var selectedCategory = 0
    var section:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = MDCChipCollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        self.chipsCollectionView.collectionViewLayout = layout
        self.chipsCollectionView.allowsSelection = false
        self.chipsCollectionView.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "MDCChipCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension OwnershipTableCell {
    
    func configureCell(data: [OwnerTypes]?,section: Int?,selectedCategory: Int?) {
        self.selectedCategory = selectedCategory ?? 0
        self.section = section
        self.data = data
        self.chipsCollectionView.reloadData()
    }
    
    
    func configureChipView(chipView: MDCChipView,index: IndexPath) {
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
        crossButton.tag = index.row
        crossButton.addTarget(self, action: #selector(crossButtonTapped(_:)), for: .touchUpInside)
        chipView.accessoryView = crossButton
    }
    
    @objc func crossButtonTapped(_ sender: UIButton) {
        self.data?[sender.tag].isSelected.toggle()
        self.chipsCollectionView.reloadData()
        print("cross")
    }
    
}

// MARK: - Extensions

// MARK: - Collection View DataSources

extension OwnershipTableCell: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return /self.data?.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDCChipCollectionViewCell", for: indexPath) as! MDCChipCollectionViewCell
        let obj = data?[indexPath.row]
        let text = "\(/obj?.ownership)"
        cell.chipView.titleLabel.text = text
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        cell.chipView.titleLabel.tag = indexPath.row
        cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
        cell.chipView.titleLabel.isUserInteractionEnabled = true
        cell.chipView.titleLabel.addGestureRecognizer(labelTapGesture)
        configureChipView(chipView: cell.chipView, index: indexPath)
        if obj?.isSelected == false{
            cell.chipView.accessoryView?.isHidden = true
            //cell.chipView.imageView.isHidden = true
        }else{
            cell.chipView.accessoryView?.isHidden = false
            //cell.chipView.imageView.isHidden = false
        }
        cell.chipView.layoutIfNeeded()
        cell.alwaysAnimateResize = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else {
            return // In case tag is not set or view is not UILabel
        }
        self.selectedCategory = index
        for idx in 0 ..< /data?.count{
            self.data?[idx].isSelected = self.selectedCategory == idx
        }
        self.onDidTappedOnCategory?(self.selectedCategory)
        
    }
}
