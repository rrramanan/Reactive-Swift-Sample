//
//  HomeViewController.swift
//  TxMaster
//
//  Created by Ramanan on 29/09/21.
//

import UIKit
import TextFieldEffects
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift
import Spring
import Lottie
import Toast_Swift
import ReSwift

class HomeViewController: UIViewController,UITextFieldDelegate,StoreSubscriber {
   
    typealias StoreSubscriberStateType = AppState
    
    @IBOutlet weak var id: HoshiTextField!
    @IBOutlet weak var fname: HoshiTextField!
    @IBOutlet weak var lname: HoshiTextField!
    @IBOutlet weak var mail: HoshiTextField!
    @IBOutlet weak var mobile: HoshiTextField!
    @IBOutlet weak var address: HoshiTextField!
    @IBOutlet weak var pincode: HoshiTextField!
    @IBOutlet weak var dob: HoshiTextField!
    @IBOutlet weak var updateButton: SpringButton!

    @IBOutlet weak var loadingView: AnimationView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollVIew: UIScrollView!
    
    
    var keyText = ""
    
    let disposeBag = DisposeBag()
    
    var homeVM = HomeViewModel.shared
    var validation = Validation.shared
    
    var barButton_logout = UIBarButtonItem()
    var barButton_edit = UIBarButtonItem()
    var barButton_super = UIBarButtonItem()
    
    var submit_relay = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        store.subscribe(self)
        print("keyText ",keyText)
        
         barButton_logout = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(logout))
        barButton_edit = UIBarButtonItem.init(title: "Edit: 🔴", style: .plain, target: self, action: #selector(editButton))
        navigationItem.rightBarButtonItems = [barButton_logout,barButton_edit]
     
        barButton_super = UIBarButtonItem.init(title: "List", style: .plain, target: self, action: #selector(superView))
        navigationItem.leftBarButtonItem = barButton_super
        
        id.delegate = self
        fname.delegate = self
        lname.delegate = self
        mail.delegate = self
        mobile.delegate = self
        address.delegate = self
        pincode.delegate = self
        
     
        id.rx.text.bind(to: homeVM.id_Relay).disposed(by: disposeBag)
        fname.rx.text.bind(to: homeVM.fName_Relay).disposed(by: disposeBag)
        lname.rx.text.bind(to: homeVM.lName_Relay).disposed(by: disposeBag)
        mail.rx.text.bind(to: homeVM.mail_Relay).disposed(by: disposeBag)
        mobile.rx.text.bind(to: homeVM.mobile_Relay).disposed(by: disposeBag)
        address.rx.text.bind(to: homeVM.address_Relay).disposed(by: disposeBag)
        pincode.rx.text.bind(to: homeVM.pincode_Relay).disposed(by: disposeBag)
        dob.rx.text.bind(to: homeVM.dob_Relay).disposed(by: disposeBag)

       // homeVM.formUpdateFlag.bind(to: updateButton.rx.isEnabled).disposed(by: disposeBag)
        
        homeVM.formUpdateFlag.bind(to: submit_relay).disposed(by: disposeBag)
        
        homeVM.load_Data(enter: keyText)
        
        id.text = homeVM.id_Relay.value
        fname.text = homeVM.fName_Relay.value
        lname.text = homeVM.lName_Relay.value
        mail.text = homeVM.mail_Relay.value
        mobile.text = homeVM.mobile_Relay.value
        address.text = homeVM.address_Relay.value
        pincode.text = homeVM.pincode_Relay.value
        dob.text = homeVM.dob_Relay.value
        
        textFieldValidationEffects()
        textFielValidationEffects_Inactive()
 

        // edit binding
        homeVM.editFlag.bind(to: fname.rx.isEnabled).disposed(by: disposeBag)
        homeVM.editFlag.bind(to: lname.rx.isEnabled).disposed(by: disposeBag)
        homeVM.editFlag.bind(to: mail.rx.isEnabled).disposed(by: disposeBag)
        homeVM.editFlag.bind(to: mobile.rx.isEnabled).disposed(by: disposeBag)
        homeVM.editFlag.bind(to: address.rx.isEnabled).disposed(by: disposeBag)
        homeVM.editFlag.bind(to: pincode.rx.isEnabled).disposed(by: disposeBag)
        homeVM.editButton_Flag.bind(to: updateButton.rx.isHidden).disposed(by: disposeBag)
        
    }
    
    func newState(state: AppState) {
        guard let boolValue = state.appLoginState else {return}
        if boolValue{
            self.view.makeToast("Welcome",duration:1)
        }else{
            self.view.makeToast("Error",duration:1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
        title = "Profile"
    }
    
    @objc func superView(){
        let vc = self.storyboard?.instantiateViewController(identifier: "listVC") as! ListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logout(){
        navigationController?.popToRootViewController(animated: true)
        LoginViewModel.shared.id_Relay.accept("")
        store.dispatch(getLoginStatus(newLoginState: false))
    }
    
    @objc func editButton(){
        
        if homeVM.editFlag.value{
            
            barButton_edit.title = "Edit: 🔴"
           
            homeVM.firstFlag.accept(true)
            homeVM.editFlag.accept(false)
            homeVM.editButton_Flag.accept(true)
           
            homeVM.editFlag.bind(to: fname.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: lname.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: mail.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: mobile.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: address.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: pincode.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editButton_Flag.bind(to: updateButton.rx.isHidden).disposed(by: disposeBag)
            

            homeVM.formUpdateFlag.bind(to: submit_relay).disposed(by: disposeBag)
            
            loader()
            
        }else{
           
            barButton_edit.title = "Edit: 🟢"
            
            homeVM.editFlag.accept(true)
            homeVM.editButton_Flag.accept(false)
            
            homeVM.editFlag.bind(to: fname.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: lname.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: mail.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: mobile.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: address.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editFlag.bind(to: pincode.rx.isEnabled).disposed(by: disposeBag)
            homeVM.editButton_Flag.bind(to: updateButton.rx.isHidden).disposed(by: disposeBag)
            
            loader()
        }
        
    }
    
    
    @IBAction func update(_ sender: Any) {
        IQKeyboardManager.shared.resignFirstResponder()
        
        if submit_relay.value{
            homeVM.update(with: keyText)
            alertSuccess()
        }else{
            animateButton()
        }
        
    }
    
    func alertSuccess(){
        let vc = UIAlertController.init(title: "Success", message: "Profile Updated", preferredStyle: .alert)
        vc.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak self] _ in
            self?.homeVM.editFlag.accept(true)
            self?.editButton()
        }))
        present(vc, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length
 
        homeVM.firstFlag.accept(false)
        
        if textField == fname || textField == lname {
            textField == fname ? homeVM.fname_flag.accept(false) : homeVM.lname_flag.accept(false)
            return newLength <= 15 && validation.onlyAlphabets(add: string)
        }
        if textField == mail {
            homeVM.mail_flag.accept(false)
            return newLength <= 30
        }
        if textField == mobile {
            homeVM.mobile_flag.accept(false)
            return newLength <= 10 && validation.onlyNumbers(add: string)
        }
        if textField == address {
            homeVM.address_flag.accept(false)
            return newLength <= 20
        }
        if textField == pincode {
            homeVM.pincode_flag.accept(false)
            return newLength <= 6 &&  validation.onlyNumbers(add: string)
        }
       
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {

        if textField == fname || textField == lname {
            textField == fname ? homeVM.fname_flag.accept(false) : homeVM.lname_flag.accept(false)
        }
        if textField == mail || textField == mobile{
            textField == mail ?  homeVM.mail_flag.accept(false) :  homeVM.mobile_flag.accept(false)
        }
        if textField == address ||  textField == pincode {
            textField == address ?  homeVM.address_flag.accept(false) :  homeVM.pincode_flag.accept(false)
        }

        return true
    }
    
    func textFieldValidationEffects(){
        let fname = fname.rx.borderActiveColor
        let lname = lname.rx.borderActiveColor
        let mail = mail.rx.borderActiveColor
        let mobile = mobile.rx.borderActiveColor
        let address = address.rx.borderActiveColor
        let pincode = pincode.rx.borderActiveColor
    
        homeVM.fnameColor_Relay.bind(to: fname).disposed(by: disposeBag)
        homeVM.lnameColor_Relay.bind(to: lname).disposed(by: disposeBag)
        homeVM.mailColor_Relay.bind(to: mail).disposed(by: disposeBag)
        homeVM.mobileColor_Relay.bind(to: mobile).disposed(by: disposeBag)
        homeVM.addressColor_Relay.bind(to: address).disposed(by: disposeBag)
        homeVM.pincodeColor_Relay.bind(to: pincode).disposed(by: disposeBag)
    }
    
    func textFielValidationEffects_Inactive(){
        let fname = fname.rx.borderInactiveColor
        let lname = lname.rx.borderInactiveColor
        let mail = mail.rx.borderInactiveColor
        let mobile = mobile.rx.borderInactiveColor
        let address = address.rx.borderInactiveColor
        let pincode = pincode.rx.borderInactiveColor
        
        homeVM.fnameInactiveColor_Relay.bind(to: fname).disposed(by: disposeBag)
        homeVM.lnameInactiveColor_Relay.bind(to: lname).disposed(by: disposeBag)
        homeVM.mailInactiveColor_Relay.bind(to: mail).disposed(by: disposeBag)
        homeVM.mobileInactive_Color_Relay.bind(to: mobile).disposed(by: disposeBag)
        homeVM.addressInactiveColor_Relay.bind(to: address).disposed(by: disposeBag)
        homeVM.pincodeInactiveColor_Relay.bind(to: pincode).disposed(by: disposeBag)
    }
    
    func animateButton(){
        updateButton.animation = "shake"
        updateButton.curve = "easeIN"
        updateButton.duration = 0.5
        updateButton.animate()
    }
   
    func loader(){
        mainView.isUserInteractionEnabled = false
        
        loadingView.backgroundColor = .black.withAlphaComponent(0.7)
        loadingView.layer.cornerRadius = 20
        loadingView.layer.masksToBounds = true
        
        scrollVIew.insertSubview(loadingView, at: 1)
        scrollVIew.isScrollEnabled = false
        scrollVIew.scrollRectToVisible(CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), animated: false)
        
        barButton_logout.isEnabled = false
        barButton_edit.isEnabled = false
        
        loadingView.contentMode = .scaleAspectFill
        loadingView.loopMode = .playOnce
        loadingView.animationSpeed = 1
        loadingView.play { [weak self] finish in
                    //print("finished")
            self?.mainView.isUserInteractionEnabled = true
            self?.scrollVIew.insertSubview(self!.loadingView, at: 0)
            self?.scrollVIew.isScrollEnabled = true
            self?.barButton_logout.isEnabled = true
            self?.barButton_edit.isEnabled = true
        }
    }
    
}
















//    func loadData(){
//        let demo =  ViewModel.shared.list.value
//
//        for val in demo{
//
//            if keyText == String(val.key){
//                id.text = val.value.id
//                fname.text = val.value.fName
//                lname.text = val.value.lName
//                mail.text = val.value.mail
//                mobile.text = val.value.mobile
//                address.text = val.value.address
//                pincode.text = val.value.pincode
//                dob.text = val.value.dob
//            }
//        }
//
//       // editData()
//    }
//
    
    
    
//    func editData(){
//
//        var tempValueList = ViewModel.shared.list.value
//        print(tempValueList)
//
//        if let current = tempValueList[1]{
//            print("indi",current)
//            tempValueList[1]?.lName = "soop"
//        }
//
//        ViewModel.shared.list.accept(tempValueList)
//        print("UPDATE = ",ViewModel.shared.list.value)
//    }
//
    
