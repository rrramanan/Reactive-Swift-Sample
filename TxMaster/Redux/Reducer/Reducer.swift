//
//  Reducer.swift
//  TxMaster
//
//  Created by Ramanan on 05/10/21.
//

import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState{
    var state = state ?? AppState(appLoginState: nil)
    
    switch action {
    case let value as getLoginStatus:
        state.appLoginState =  value.newLoginState
    default:
        break
    }
    
    return state
}
