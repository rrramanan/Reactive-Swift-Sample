//
//  ViewModel.swift
//  TxMaster
//
//  Created by Ramanan on 28/09/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


class ViewModel  {
    
   
    static let shared = ViewModel()
    private init() {}
    
    static var validate = Validation.shared
    
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
    
    let disposeBag = DisposeBag()
   
    var dataResult = [Bool]()
    //var dataValue = [String]()
        
    var list = BehaviorRelay<[Int: Model]>.init(value: [:])
       
    var count = 0
        
    let fnameColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let lnameColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mailColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mobileColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let passwordColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let repeatPasswordColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let addressColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let pincodeColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let dobColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    
    let fnameInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let lnameInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mailInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let mobileInactive_Color_Relay = BehaviorRelay<UIColor>(value:.clear)
    let passwordInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let repeatInactivePasswordColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let addressInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let pincodeInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    let dobInactiveColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    
    let fname_flag = BehaviorRelay<Bool>(value: true)
    let lname_flag = BehaviorRelay<Bool>(value: true)
    let mail_flag = BehaviorRelay<Bool>(value: true)
    let mobile_flag = BehaviorRelay<Bool>(value: true)
    let password_flag = BehaviorRelay<Bool>(value: true)
    let repeatPassword_flag = BehaviorRelay<Bool>(value: true)
    let address_flag = BehaviorRelay<Bool>(value: true)
    let pincode_flag = BehaviorRelay<Bool>(value: true)
    let dob_flag = BehaviorRelay<Bool>(value: true)
    
    var totalSectionList = BehaviorRelay<[SectionModel]>.init(value: [SectionModel(model: "", items: [])])
   
    var formFlag : Observable<Bool> {
       let randomNo = Int.random(in: 1...99)
        self.id_Relay.accept(String(randomNo))
        //print("ID value random == ",self.id_Relay.value!)
        
        return
            Observable.combineLatest([id_Relay,fName_Relay,lName_Relay,mail_Relay,mobile_Relay,password_Relay,repeatpassword_Relay,address_Relay,pincode_Relay,dob_Relay]){ [self] value in
                //print("value", value)
               
                self.dataResult.removeAll()
                //self.dataValue.removeAll()
               
                   for (idx,eValue) in value.enumerated(){
       
                    guard let newValue = eValue else { return false }
       
                    if idx == 0{
                        self.dataResult.append(ViewModel.validate.validateID(with: newValue))
                    }


                    if idx == 1{
                
                        self.dataResult.append(ViewModel.validate.validateName(with: newValue))
                        
                        if ViewModel.validate.validateName(with:newValue){
                            //self.dataValue.append(newValue)
                            fnameColor_Relay.accept(.green)
                            fnameInactiveColor_Relay.accept(.clear)
                        }else{
                            fnameColor_Relay.accept(.red)
                            self.fname_flag.value == true ?
                                fnameInactiveColor_Relay.accept(.clear) : fnameInactiveColor_Relay.accept(.red)
                        }
                        
                    }

                    if idx == 2{
                     
                        self.dataResult.append(ViewModel.validate.validateName(with: newValue))
                        
                        if ViewModel.validate.validateName(with: newValue){
                            lnameColor_Relay.accept(.green)
                            lnameInactiveColor_Relay.accept(.clear)
                        }else{
                            lnameColor_Relay.accept(.red)
                            self.lname_flag.value == true ?
                                lnameInactiveColor_Relay.accept(.clear) : lnameInactiveColor_Relay.accept(.red)
                        }
                     
                    }
                    if idx == 3{
                     
                        self.dataResult.append(ViewModel.validate.validateEmail(with: newValue))
                        
                        if ViewModel.validate.validateEmail(with: newValue){
                            mailColor_Relay.accept(.green)
                            mailInactiveColor_Relay.accept(.clear)
                       }else{
                            mailColor_Relay.accept(.red)
                        self.mail_flag.value == true ?
                            mailInactiveColor_Relay.accept(.clear) : mailInactiveColor_Relay.accept(.red)
                       }
                     
                    }

                    if idx == 4{
                       
                        self.dataResult.append(ViewModel.validate.validateMobile(with: newValue))
                        
                        if ViewModel.validate.validateMobile(with: newValue){
                            mobileColor_Relay.accept(.green)
                            mobileInactive_Color_Relay.accept(.clear)
                        }else{
                            mobileColor_Relay.accept(.red)
                            self.mobile_flag.value == true ?
                                mobileInactive_Color_Relay.accept(.clear) :  mobileInactive_Color_Relay.accept(.red)
                        }
                        
                    }

                    if idx == 5{
                        
                        self.dataResult.append(ViewModel.validate.validatePassword(with: newValue))
                        
                        if ViewModel.validate.validatePassword(with: newValue){
                            passwordColor_Relay.accept(.green)
                            passwordInactiveColor_Relay.accept(.clear)
                        }else{
                            passwordColor_Relay.accept(.red)
                            self.password_flag.value == true ?
                                passwordInactiveColor_Relay.accept(.clear) : passwordInactiveColor_Relay.accept(.red)
                        }
                     
                    }

                    if idx == 6{
                        
                        self.dataResult.append(ViewModel.validate.validateRepeatPassword(with: newValue))
                        
                        if ViewModel.validate.validateRepeatPassword(with: newValue){
                            repeatPasswordColor_Relay.accept(.green)
                            repeatInactivePasswordColor_Relay.accept(.clear)
                        }else{
                            repeatPasswordColor_Relay.accept(.red)
                            self.repeatPassword_flag.value == true ?
                                repeatInactivePasswordColor_Relay.accept(.clear) :  repeatInactivePasswordColor_Relay.accept(.red)
                        }
                        
                    }

                    if idx == 7 {

                        self.dataResult.append(ViewModel.validate.validateAddress(with: newValue))
                        
                        if ViewModel.validate.validateAddress(with: newValue){
                            addressColor_Relay.accept(.green)
                            addressInactiveColor_Relay.accept(.clear)
                        }else{
                            addressColor_Relay.accept(.red)
                            self.address_flag.value == true ?
                                addressInactiveColor_Relay.accept(.clear) : addressInactiveColor_Relay.accept(.red)
                        }
                        
                    }

                    if idx == 8 {
                      
                        self.dataResult.append(ViewModel.validate.validatePincode(with: newValue))
                        
                        if ViewModel.validate.validatePincode(with: newValue){
                            pincodeColor_Relay.accept(.green)
                            pincodeInactiveColor_Relay.accept(.clear)
                        }else{
                            pincodeColor_Relay.accept(.red)
                            self.pincode_flag.value == true ?
                                pincodeInactiveColor_Relay.accept(.clear) : pincodeInactiveColor_Relay.accept(.red)
                        }
                        
                    }

                    if idx == 9{
                      
                        self.dataResult.append(ViewModel.validate.validateDob(with: newValue))
                        
                        if ViewModel.validate.validateDob(with: newValue){
                            dobColor_Relay.accept(.green)
                            dobInactiveColor_Relay.accept(.clear)
                        }else{
                            dobColor_Relay.accept(.red)
                            self.dob_flag.value == true ?
                                dobInactiveColor_Relay.accept(.clear) :  dobInactiveColor_Relay.accept(.red)
                        }
                        
                    }
                   
                    
                   }//for
                
               //print("bool array = ",self.dataResult)
              //print("value array = ",self.dataValue)
                            
              let flagData = self.dataResult.allSatisfy { resultBool in
                    resultBool == true
                }
                
                if flagData{
                    return true
                }
                   
            return false
               
        }
        
    }//
    
  
    
    
    func buttonAction(){
        
        let modelData =  Model.init(
            id: id_Relay.value!,
            fName: fName_Relay.value!,
            lName: lName_Relay.value!,
            mail: mail_Relay.value!,
            mobile: mobile_Relay.value!,
            password: password_Relay.value!,
            repeatPassword: repeatpassword_Relay.value!,
            address: address_Relay.value!,
            pincode: pincode_Relay.value!,
            dob: dob_Relay.value!)
        //print("on register ==>  ",modelData)
        
        self.count += 1
    
        var tempList = self.list.value // ## - value used for login not "password"
        
        tempList[self.count] = modelData
        
        self.list.accept(tempList)
         
        print("list added ==> ",self.list.value)
        
        sectionData(with: count)
    }//
    
    func sectionData(with ID: Int){
        // list view data..
        var tempTotalValue = totalSectionList.value
        
        tempTotalValue.append(contentsOf: [SectionModel<String, Any>(model:  String(ID), items: ["First Name: \(fName_Relay.value!)","Last Name: \(lName_Relay.value!) ","Mail: \(mail_Relay.value!)","Mobile: \(mobile_Relay.value!)","Address: \(address_Relay.value!)","Pincode: \(pincode_Relay.value!)","Dob: \(dob_Relay.value!)"])])
        
        totalSectionList.accept(tempTotalValue)
        
       // print("section added ==> ",totalSectionList.value)
    }
    
    
}






