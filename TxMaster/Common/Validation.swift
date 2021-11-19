//
//  Validation.swift
//  TxMaster
//
//  Created by Ramanan on 29/09/21.
//

import Foundation

class Validation {
    
    static let shared = Validation()
    
    private init() {

    }
    
    let vm = ViewModel.shared
    
    
    func validateID(with Id:String) ->  Bool{
        if !Id.isEmpty{
            return true
        }
        return false
    }
    
    func validateName(with name: String) -> Bool{
        if !name.isEmpty && name.count > 1 && name.count <= 15{
            let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
            let characterSet = CharacterSet(charactersIn: name)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return false
    }
    
    func validateEmail(with email: String) -> Bool {
      let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
      let predicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
      return predicate.evaluate(with: email)
    }
    
    func validateMobile(with mobile:String) ->  Bool{
        if !mobile.isEmpty && mobile.count == 10{
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: mobile)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return false
    }
    
    func validatePassword(with password:String) -> Bool{
        if !password.isEmpty && password.count > 6 && password.count <= 20 {
            return true
        }
        return false
    }
    
    func validateRepeatPassword(with password:String) -> Bool{
        if !password.isEmpty && password.count > 6 && password.count <= 20 {
            guard let value = vm.password_Relay.value else {return false }
            if password == value{
                return true
            }
        }
        return false
    }
    
    func validateRepeatPassword_update(with password:String, from ID: String) -> Bool{
        if !password.isEmpty && password.count > 6 && password.count <= 20 {
            let tempValue = ViewModel.shared.list.value
            guard let key_Int = Int(ID) else {return false}
            guard let value = tempValue[key_Int]?.repeatPassword else { return false }
            if password == value{
                return true
            }
        }
        return false
    }
    
    func validateAddress(with address:String) -> Bool{
        if !address.isEmpty && address.count > 6 && address.count <= 20{
            return true
        }
        return false
    }
    
    func validatePincode(with pincode:String) -> Bool{
        if !pincode.isEmpty && pincode.count == 6{
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789")
            let characterSet = CharacterSet(charactersIn: pincode)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return false
    }
    
    func validateDob(with dob:String) -> Bool{
        if !dob.isEmpty{
            return true
        }
        return false
    }
    
    
    func onlyAlphabets(add string:String) -> Bool{
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func onlyNumbers(add string:String) -> Bool{
        let allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}
