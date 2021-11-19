//
//  LoginViewModel.swift
//  TxMaster
//
//  Created by Ramanan on 29/09/21.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel  {
    
    let id_Relay = BehaviorRelay<String?>(value: "")
    
    let disposeBag = DisposeBag()
    
    static let shared = LoginViewModel()
   
    var textBool = BehaviorRelay<Bool>.init(value: true)
    
    //let loginColor_Relay = BehaviorRelay<UIColor>(value: .clear)
    
    var validation = Validation.shared
    
    private init(){}
    
    var loginFlag : Observable<Bool>{
        return
            Observable.combineLatest([id_Relay]){[weak self] value in
                self?.textBool.accept(true)
                
                for val in value{
                    guard let unwrappedVal = val else {return false}
                    
                    if self!.validation.validateID(with: unwrappedVal){
                        return true
                    }
                }
                return false
            }
    }
    
    func Login() -> Bool{
        
        if ViewModel.shared.list.value.count == 0{
            self.textBool.accept(false)
            return false
        }else{
            for (key,_) in ViewModel.shared.list.value{
                if id_Relay.value! == String(key){
                    self.textBool.accept(true)
                    return true
                }else{
                    self.textBool.accept(false)
                }
            }
        }
        
        return false
    }
    
    
}













/*
 
 if self!.validation.validateID(with: unwrappedVal){
     //self?.loginColor_Relay.accept(.clear)
     return true
 }else{
     //self?.loginColor_Relay.accept(.clear)
 }
 
 */
