//
//  Store.swift
//  TxMaster
//
//  Created by Ramanan on 05/10/21.
//

import Foundation
import ReSwift

let store = Store(
    reducer: appReducer,
    state: AppState()
)

