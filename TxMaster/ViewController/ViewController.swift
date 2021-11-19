//
//  ViewController.swift
//  TxMaster
//
//  Created by Ramanan on 28/09/21.
//

import UIKit
import TextFieldEffects
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift
import Spring

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var id_texfield: HoshiTextField!
    @IBOutlet weak var fname_textfield: HoshiTextField!
    @IBOutlet weak var lname_textfield: HoshiTextField!
    @IBOutlet weak var mail_textfield: HoshiTextField!
    @IBOutlet weak var mobile_textfield: HoshiTextField!
    @IBOutlet weak var password_textfield: HoshiTextField!
    @IBOutlet weak var repeatPassword_textfield: HoshiTextField!
    @IBOutlet weak var address_textfield: HoshiTextField!
    @IBOutlet weak var pincode_textfield: HoshiTextField!
    @IBOutlet weak var dob_textfield: HoshiTextField!
    @IBOutlet weak var registerButton: SpringButton!
    @IBOutlet weak var closeButton: UIButton!
    
    
    let datePicker = UIDatePicker()
    let disposeBag = DisposeBag()
    let viewModel = ViewModel.shared
    let validation = Validation.shared
    
    var relay_submit = BehaviorRelay<Bool>.init(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        showDatePicker()

        fname_textfield.delegate = self
        lname_textfield.delegate = self
        mail_textfield.delegate  = self
        mobile_textfield.delegate = self
        password_textfield.delegate = self
        repeatPassword_textfield.delegate = self
        address_textfield.delegate = self
        pincode_textfield.delegate = self
        dob_textfield.delegate = self
        
                
        id_texfield.rx.text.bind(to: viewModel.id_Relay).disposed(by: disposeBag)
        fname_textfield.rx.text.bind(to: viewModel.fName_Relay).disposed(by: disposeBag)
        lname_textfield.rx.text.bind(to: viewModel.lName_Relay).disposed(by: disposeBag)
        mail_textfield.rx.text.bind(to: viewModel.mail_Relay).disposed(by: disposeBag)
        mobile_textfield.rx.text.bind(to: viewModel.mobile_Relay).disposed(by: disposeBag)
        password_textfield.rx.text.bind(to: viewModel.password_Relay).disposed(by: disposeBag)
        repeatPassword_textfield.rx.text.bind(to: viewModel.repeatpassword_Relay).disposed(by: disposeBag)
        address_textfield.rx.text.bind(to: viewModel.address_Relay).disposed(by: disposeBag)
        pincode_textfield.rx.text.bind(to: viewModel.pincode_Relay).disposed(by: disposeBag)
        dob_textfield.rx.text.bind(to: viewModel.dob_Relay).disposed(by: disposeBag)
        
        
       // viewModel.formFlag.bind(to: registerButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.formFlag.bind(to: relay_submit).disposed(by: disposeBag)
        
        id_texfield.text = viewModel.id_Relay.value!
    
        
        textFieldValidationEffects()
        textFielValidationEffects_Inactive()
        
        
    }
    
    
    @IBAction func registerAction(_ sender: Any) {
        IQKeyboardManager.shared.resignFirstResponder()
        
        if relay_submit.value{
             viewModel.buttonAction()
             alertSuccess()
        }else{
            animateButton()
        }
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showDatePicker(){
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date


       let toolbar = UIToolbar();
       toolbar.sizeToFit()
        
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
       let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

      toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dob_textfield.inputAccessoryView = toolbar
        dob_textfield.inputView = datePicker

     }
    
    @objc func donedatePicker(){
       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
        dob_textfield.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length
        
        if textField == fname_textfield || textField == lname_textfield {
            textField == fname_textfield ? viewModel.fname_flag.accept(false) : viewModel.lname_flag.accept(false)
            return newLength <= 15 && validation.onlyAlphabets(add: string)
        }
        if textField == mail_textfield {
            viewModel.mail_flag.accept(false)
            return newLength <= 30
        }
        if textField == mobile_textfield {
            viewModel.mobile_flag.accept(false)
            return newLength <= 10 && validation.onlyNumbers(add: string)
        }
        if textField == password_textfield || textField == repeatPassword_textfield {
            textField == password_textfield ? viewModel.password_flag.accept(false) : viewModel.repeatPassword_flag.accept(false)
            return newLength <= 20
        }
        if textField == address_textfield {
            viewModel.address_flag.accept(false)
            return newLength <= 20
        }
        if textField == pincode_textfield {
            viewModel.pincode_flag.accept(false)
            return newLength <= 6 && validation.onlyNumbers(add: string)
        }
        if textField == dob_textfield {
            viewModel.dob_flag.accept(false)
            return newLength <= 0
        }
        return true
    }
    
    
    func textFieldValidationEffects(){
        let fname = fname_textfield.rx.borderActiveColor
        let lname = lname_textfield.rx.borderActiveColor
        let mail = mail_textfield.rx.borderActiveColor
        let mobile = mobile_textfield.rx.borderActiveColor
        let password = password_textfield.rx.borderActiveColor
        let repeatPassword = repeatPassword_textfield.rx.borderActiveColor
        let address = address_textfield.rx.borderActiveColor
        let pincode = pincode_textfield.rx.borderActiveColor
        let dob = dob_textfield.rx.borderActiveColor
        
        viewModel.fnameColor_Relay.bind(to: fname).disposed(by: disposeBag)
        viewModel.lnameColor_Relay.bind(to: lname).disposed(by: disposeBag)
        viewModel.mailColor_Relay.bind(to: mail).disposed(by: disposeBag)
        viewModel.mobileColor_Relay.bind(to: mobile).disposed(by: disposeBag)
        viewModel.passwordColor_Relay.bind(to: password).disposed(by: disposeBag)
        viewModel.repeatPasswordColor_Relay.bind(to: repeatPassword).disposed(by: disposeBag)
        viewModel.addressColor_Relay.bind(to: address).disposed(by: disposeBag)
        viewModel.pincodeColor_Relay.bind(to: pincode).disposed(by: disposeBag)
        viewModel.dobColor_Relay.bind(to: dob).disposed(by: disposeBag)
    }
    
    
    func textFielValidationEffects_Inactive(){
        let fname = fname_textfield.rx.borderInactiveColor
        let lname = lname_textfield.rx.borderInactiveColor
        let mail = mail_textfield.rx.borderInactiveColor
        let mobile = mobile_textfield.rx.borderInactiveColor
        let password = password_textfield.rx.borderInactiveColor
        let repeatPassword = repeatPassword_textfield.rx.borderInactiveColor
        let address = address_textfield.rx.borderInactiveColor
        let pincode = pincode_textfield.rx.borderInactiveColor
        let dob = dob_textfield.rx.borderInactiveColor
        
        viewModel.fnameInactiveColor_Relay.bind(to: fname).disposed(by: disposeBag)
        viewModel.lnameInactiveColor_Relay.bind(to: lname).disposed(by: disposeBag)
        viewModel.mailInactiveColor_Relay.bind(to: mail).disposed(by: disposeBag)
        viewModel.mobileInactive_Color_Relay.bind(to: mobile).disposed(by: disposeBag)
        viewModel.passwordInactiveColor_Relay.bind(to: password).disposed(by: disposeBag)
        viewModel.repeatInactivePasswordColor_Relay.bind(to: repeatPassword).disposed(by: disposeBag)
        viewModel.addressInactiveColor_Relay.bind(to: address).disposed(by: disposeBag)
        viewModel.pincodeInactiveColor_Relay.bind(to: pincode).disposed(by: disposeBag)
        viewModel.dobInactiveColor_Relay.bind(to: dob).disposed(by: disposeBag)
    }
    
    func animateButton(){
        registerButton.animation = "shake"
        registerButton.curve = "easeIN"
        registerButton.duration = 0.5
        registerButton.animate()
    }
    
    func alertSuccess(){
        let vc = UIAlertController.init(title: "Signup Completed", message: "Login to view your account.", preferredStyle: .alert)
        vc.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(vc, animated: true, completion: nil)
    }
    
//    func removeData(){
//        viewModel.id_Relay.accept("")
//        viewModel.fName_Relay.accept("")
//        viewModel.lName_Relay.accept("")
//        viewModel.mail_Relay.accept("")
//        viewModel.mobile_Relay.accept("")
//        viewModel.password_Relay.accept("")
//        viewModel.repeatpassword_Relay.accept("")
//        viewModel.address_Relay.accept("")
//        viewModel.pincode_Relay.accept("")
//        viewModel.pincode_Relay.accept("")
//        viewModel.pincode_Relay.accept("")
//    }
    
}

