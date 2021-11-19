//
//  ListViewMOdel.swift
//  TxMaster
//
//  Created by Ramanan on 11/10/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ListViewModel {
    
    static let shared = ListViewModel()
    
    let viewModel = ViewModel.shared
    
    let totalList = BehaviorRelay<[SectionModel]>.init(value: [SectionModel(model: "", items: [])])
    
    init(){}
    
    func loadData(){
        
        totalList.accept([SectionModel(model: "", items: [])])
        
        let tempValueList =  viewModel.list.value
        var tempTotalValue = totalList.value
        
        for (_,evalue) in tempValueList.enumerated(){
         
            tempTotalValue.append(SectionModel<String, Any>(model:  String(evalue.key), items: ["First Name: \(evalue.value.fName)","Last Name: \(evalue.value.lName) ","Mail: \(evalue.value.mail)","Mobile: \(evalue.value.mobile)","Address: \(evalue.value.address)","Pincode: \(evalue.value.pincode)","Dob: \(evalue.value.dob)"]))
        }
       
        totalList.accept(tempTotalValue)

    }
    
    
}
