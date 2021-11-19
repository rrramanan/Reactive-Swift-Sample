//
//  LoginViewController.swift
//  TxMaster
//
//  Created by Ramanan on 28/09/21.
//

import UIKit
import TextFieldEffects
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift
import Lottie
import Spring
import Toast_Swift
import ReSwift

class LoginViewController: UIViewController,UITextFieldDelegate,StoreSubscriber {

    typealias StoreSubscriberStateType = AppState
    
    @IBOutlet weak var splashLabel: SpringLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var login_textfield: HoshiTextField!
    @IBOutlet weak var loginButton: SpringButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var loginVM = LoginViewModel.shared
    var homeVM = HomeViewModel.shared
    var viewModel = ViewModel.shared
    
    var validation = Validation.shared
    
    var submit_relay = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lottie()
        
        login_textfield.delegate = self
        
        login_textfield.rx.text.bind(to: loginVM.id_Relay).disposed(by:disposeBag)
        
        //loginVM.loginFlag.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        loginVM.loginFlag.bind(to: submit_relay).disposed(by: disposeBag)
        
        loginVM.textBool.bind(to: loginLabel.rx.isHidden).disposed(by: disposeBag)
        
        //textFieldValidationEffects()
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        store.subscribe(self)
    }

   
    @IBAction func enter(_ sender: Any) {
        IQKeyboardManager.shared.resignFirstResponder()
        
        if submit_relay.value{
            
            if loginVM.Login(){
                loginLabel.isHidden = true
                homeVM.firstFlag.accept(true)
                homeTFClear()
                homeVM.editFlag.accept(false)
                homeVM.editButton_Flag.accept(true)
                let home = self.storyboard?.instantiateViewController(identifier: "homeVC") as! HomeViewController
                guard let value = loginVM.id_Relay.value  else {return}
                home.keyText = value
                navigationController?.pushViewController(home, animated: true)
                login_textfield.text = ""
                store.dispatch(getLoginStatus(newLoginState: true))
            }else{
                print("login failed")
            }
            
        }else{
            animateButton()
        }
        

        
    }
    
    @IBAction func signup(_ sender: Any) {
        loginVM.textBool.accept(false)
        IQKeyboardManager.shared.resignFirstResponder()
        registerTFClear()
        let vc = self.storyboard?.instantiateViewController(identifier: "registerVC") as! ViewController
        navigationController?.present(vc, animated: true, completion: nil)
        loginVM.id_Relay.accept("")
        login_textfield.text = ""
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count - range.length
        
        if textField == login_textfield {
            return newLength >= 0 && newLength <= 5 && validation.onlyNumbers(add: string)
        }
        return true
    }
    
    
    func registerTFClear(){
        viewModel.fname_flag.accept(true)
        viewModel.lname_flag.accept(true)
        viewModel.mail_flag.accept(true)
        viewModel.mobile_flag.accept(true)
        viewModel.password_flag.accept(true)
        viewModel.repeatPassword_flag.accept(true)
        viewModel.address_flag.accept(true)
        viewModel.pincode_flag.accept(true)
        viewModel.dob_flag.accept(true)
    }
    
    func homeTFClear(){
        homeVM.fname_flag.accept(true)
        homeVM.lname_flag.accept(true)
        homeVM.mail_flag.accept(true)
        homeVM.mobile_flag.accept(true)
        homeVM.address_flag.accept(true)
        homeVM.pincode_flag.accept(true)
    }
    
    func lottie(){
        //splashLabel.isHidden = false
        animationView.isHidden = false
        titleLabel.isHidden = true
        login_textfield.isHidden = true
        loginLabel.isHidden = true
        loginButton.isHidden = true
        signUpButton.isHidden = true
        
        splashLabel.animation = "pop"
        splashLabel.curve = "linear"
        splashLabel.duration = 0.7
        splashLabel.animate()
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.8
        animationView.play { [weak self] finish in
                    //print("finished")
            self?.animationView.isHidden = true
            self?.titleLabel.isHidden = false
            self?.login_textfield.isHidden = false
            self?.loginLabel.isHidden = true
            self?.loginButton.isHidden = false
            self?.signUpButton.isHidden = false
            self?.splashLabel.isHidden = true
        }
    }
    
    func animateButton(){
        loginButton.animation = "shake"
        loginButton.curve = "easeIN"
        loginButton.duration = 0.5
        loginButton.animate()
    }
    
    
    func newState(state: AppState) {
        guard let boolValue = state.appLoginState else { return }
        if !boolValue{
            self.view.makeToast("Logged Out",duration:1)
        }else{
            self.view.makeToast("Error",duration:1)
        }
    }
    
    /*
    func textFieldValidationEffects(){
        let login = login_textfield.rx.borderActiveColor
        loginVM.loginColor_Relay.bind(to: login).disposed(by: disposeBag)
    }
    */
    
}




















//        for (key,value) in ViewModel.shared.list.value{
//            print("key \(key), value \(value)")
//
//            if login_textfield.text == String(key){
//                print("enter")
//                logKey = login_textfield.text ?? "NA"
//
//                let home = self.storyboard?.instantiateViewController(identifier: "homeVC") as! HomeViewController
//                home.keyText = logKey
//                navigationController?.pushViewController(home, animated: true)
//            }
//
//        }
