//
//  HomeViewModel.swift
//  TxMaster
//
//  Created by Ramanan on 29/09/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewModel {

    let disposeBag = DisposeBag()
    
    static let shared = HomeViewModel()
    
    var validationClass = Validation.shared
    
    var viewModel = ViewModel.shared
    
    private init() {}
    
    let id_Relay = BehaviorRelay<String?>(value: "")
    let fName_Relay = BehaviorRelay<String?>(value: "")
    let lName_Relay = BehaviorRelay<String?>(value: "")
    let mail_Relay = BehaviorRelay<String?>(value: "")
    let mobile_Relay = BehaviorRelay<String?>(value: "")
    let password_Relay = BehaviorRelay<String?>(value: "")
    let repeatpassword_Relay = BehaviorRelay<String?>(value: "")
    let address_Relay = BehaviorRelay<String?>(value: "")
    let pincode_Relay = BehaviorRelay<String?>(value: "")
    let dob_Relay = BehaviorRelay<String?>(value: "")
   
    var formResult = [Bool]()
    
    let current_ID = BehaviorRelay<String?>(value: "")
    
    let fnameColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let lnameColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mailColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mobileColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let addressColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let pincodeColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    
    let fnameInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let lnameInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mailInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mobileInactive_Color_Relay = BehaviorRelay<UIColor>(value:.clear)
    let addressInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let pincodeInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)

    var firstFlag = BehaviorRelay<Bool>(value: true)
    
    let fname_flag = BehaviorRelay<Bool>(value: true)
    let lname_flag = BehaviorRelay<Bool>(value: true)
    let mail_flag = BehaviorRelay<Bool>(value: true)
    let mobile_flag = BehaviorRelay<Bool>(value: true)
    let address_flag = BehaviorRelay<Bool>(value: true)
    let pincode_flag = BehaviorRelay<Bool>(value: true)
   
    let editFlag = BehaviorRelay<Bool>(value: false)
    let editButton_Flag = BehaviorRelay<Bool>(value: true)
    
    var formUpdateFlag : Observable<Bool> {
        return
            Observable.combineLatest([id_Relay,fName_Relay,lName_Relay,mail_Relay,mobile_Relay,password_Relay,repeatpassword_Relay,address_Relay,pincode_Relay,dob_Relay]){ [weak self] value in
                    
               // print("value", value)
                
                self!.formResult.removeAll()
                
                for (idx,eValue) in value.enumerated(){
                    guard let newValue = eValue else {return false}
                   
                    if idx == 0{
                        self!.formResult.append(self!.validationClass.validateID(with: newValue))
                    }
                    
                    if idx == 1{
                        
                        self!.formResult.append(self!.validationClass.validateName(with: newValue))
                        
                        if self!.validationClass.validateName(with: newValue){
                            self?.firstFlag.value == true ?
                                self?.fnameColor_Relay.accept(.clear) :  self?.fnameColor_Relay.accept(.green)
                            self?.fnameInactiveColor_Relay.accept(.clear)
                        }else{
                            self?.fnameColor_Relay.accept(.red)
                            self?.fname_flag.value == true ?
                                self?.fnameInactiveColor_Relay.accept(.clear) : self?.fnameInactiveColor_Relay.accept(.red)
                        }
                        
                    }
                    
                    if idx == 2{
                        
                        self!.formResult.append(self!.validationClass.validateName(with: newValue))
                        
                        if self!.validationClass.validateName(with: newValue){
                            self?.firstFlag.value == true ?
                                self?.lnameColor_Relay.accept(.clear) : self?.lnameColor_Relay.accept(.green)
                            self?.lnameInactiveColor_Relay.accept(.clear)
                        }else{
                            self?.lnameColor_Relay.accept(.red)
                            self?.lname_flag.value == true ?
                                self?.lnameInactiveColor_Relay.accept(.clear) : self?.lnameInactiveColor_Relay.accept(.red)
                        }
                        
                    }
                    
                    if idx == 3{
                        
                        self!.formResult.append(self!.validationClass.validateEmail(with: newValue))
                        
                        if self!.validationClass.validateEmail(with: newValue){
                            self?.firstFlag.value == true ?
                                self?.mailColor_Relay.accept(.clear) :   self?.mailColor_Relay.accept(.green)
                            self?.mailInactiveColor_Relay.accept(.clear)
                        }else{
                            self?.mailColor_Relay.accept(.red)
                            self?.mail_flag.value == true ?
                                self?.mailInactiveColor_Relay.accept(.clear) :  self?.mailInactiveColor_Relay.accept(.red)
                        }
                        
                    }
                    
                    if idx == 4{
                        
                        self!.formResult.append(self!.validationClass.validateMobile(with: newValue))
                        
                        if self!.validationClass.validateMobile(with: newValue){
                            self?.firstFlag.value == true ?
                                self?.mobileColor_Relay.accept(.clear) : self?.mobileColor_Relay.accept(.green)
                            self?.mobileInactive_Color_Relay.accept(.clear)
                        }else{
                            self?.mobileColor_Relay.accept(.red)
                            self?.mobile_flag.value == true ?
                                self?.mobileInactive_Color_Relay.accept(.clear) :  self?.mobileInactive_Color_Relay.accept(.red)
                        }
                        
                    }
                    
                    if idx == 5{
                        self!.formResult.append(self!.validationClass.validatePassword(with: newValue))
                    }
                    
                    if idx == 6{
                        self!.formResult.append(self!.validationClass.validateRepeatPassword_update(with: newValue, from: self!.current_ID.value!))
                    }
                    
                    if idx == 7{
                        self!.formResult.append(self!.validationClass.validateAddress(with: newValue))
                        if self!.validationClass.validateAddress(with: newValue){
                            self?.firstFlag.value == true ?
                                self?.addressColor_Relay.accept(.clear) :  self?.addressColor_Relay.accept(.green)
                            self?.addressInactiveColor_Relay.accept(.clear)
                        }else{
                            self?.addressColor_Relay.accept(.red)
                            self?.address_flag.value == true ?
                                self?.addressInactiveColor_Relay.accept(.clear) :  self?.addressInactiveColor_Relay.accept(.red)
                        }
                    }
                    
                    if idx == 8{
                        self!.formResult.append(self!.validationClass.validatePincode(with: newValue))
                        if self!.validationClass.validatePincode(with: newValue){
                            self?.firstFlag.value == true ?
                                self?.pincodeColor_Relay.accept(.clear) :  self?.pincodeColor_Relay.accept(.green)
                            self?.pincodeInactiveColor_Relay.accept(.clear)
                        }else{
                            self?.pincodeColor_Relay.accept(.red)
                            self?.pincode_flag.value == true ?
                                self?.pincodeInactiveColor_Relay.accept(.clear) :  self?.pincodeInactiveColor_Relay.accept(.red)
                        }
                    }
                    
                    if idx == 9{
                        self!.formResult.append(self!.validationClass.validateDob(with: newValue))
                    }
                
                
            }//for
                
                //print("from result =  ", self!.formResult)
                                
                let flagData =  self!.formResult.allSatisfy { bool in
                    bool == true
                }
                
                if flagData{
                    return true
                }
        
        return false
        }
    
    }
    
    
    
    func load_Data(enter Id:String){
        
        let tempValueList =  viewModel.list.value
    
        //print("load all key == ",tempValueList.keys)
        //print("load all value == ",tempValueList.values)
        
        guard let key_Int = Int(Id) else {return}
        //print("key == load",key_Int)
        
        current_ID.accept(String(key_Int))

        if let _ = tempValueList[key_Int]{
            id_Relay.accept(tempValueList[key_Int]?.id)
            fName_Relay.accept(tempValueList[key_Int]?.fName)
            lName_Relay.accept(tempValueList[key_Int]?.lName)
            mail_Relay.accept(tempValueList[key_Int]?.mail)
            mobile_Relay.accept(tempValueList[key_Int]?.mobile)
            password_Relay.accept(tempValueList[key_Int]?.password)
            repeatpassword_Relay.accept(tempValueList[key_Int]?.repeatPassword)
            address_Relay.accept(tempValueList[key_Int]?.address)
            pincode_Relay.accept(tempValueList[key_Int]?.pincode)
            dob_Relay.accept(tempValueList[key_Int]?.dob)
        }
            
    }
    
    
    func update(with Id:String){
        
        var tempValueList = viewModel.list.value
    
        guard let key_Int = Int(Id) else {return}
        //print("key int == update ",key_Int)
        
        if let _ = tempValueList[key_Int]{
            //print("current ",current)
            tempValueList[key_Int]?.fName = fName_Relay.value!
            tempValueList[key_Int]?.lName = lName_Relay.value!
            tempValueList[key_Int]?.mail =  mail_Relay.value!
            tempValueList[key_Int]?.mobile = mobile_Relay.value!
            tempValueList[key_Int]?.address = address_Relay.value!
            tempValueList[key_Int]?.pincode = pincode_Relay.value!
        }
        
        ViewModel.shared.list.accept(tempValueList)
        print("UPDATE ===> ",ViewModel.shared.list.value)
        
        sectionData(with: key_Int)
    }
    
    func sectionData(with Id:Int){
        // list view data..
        var tempTotalValue = viewModel.totalSectionList.value
        
        tempTotalValue[Id].items = ["First Name: \(fName_Relay.value!)","Last Name: \(lName_Relay.value!) ","Mail: \(mail_Relay.value!)","Mobile: \(mobile_Relay.value!)","Address: \(address_Relay.value!)","Pincode: \(pincode_Relay.value!)","Dob: \(dob_Relay.value!)"]

        viewModel.totalSectionList.accept(tempTotalValue)
        
        //print("section added update ==> ",viewModel.totalSectionList.value)
    }
    
}










/*
 load data
 //        for val in tempValueList{
 //
 //            current_ID.accept(String(val.key))
 //
 //            if Id == String(val.key){
 //                id_Relay.accept(val.value.id)
 //                fName_Relay.accept(val.value.fName)
 //                lName_Relay.accept(val.value.lName)
 //                mail_Relay.accept(val.value.mail)
 //                mobile_Relay.accept(val.value.mobile)
 //                password_Relay.accept(val.value.password)
 //                repeatpassword_Relay.accept(val.value.repeatPassword)
 //                address_Relay.accept(val.value.address)
 //                pincode_Relay.accept(val.value.pincode)
 //                dob_Relay.accept(val.value.dob)
 //            }
 //        }
 */
