//
//  DoorsClass+ControlFunctionable.swift
//  Telematics App
//
//  Created by Mikk Rätsep on 09/07/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import Foundation


extension DoorsCommand: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return {
            guard $0 == .doorsLock else {
                return nil
            }

            return self.locked
        }
    }

    var controlFunctions: [ControlFunction] {
        let mainAction = ControlAction(name: "unlocked", iconName: "DoorlockUNLOCKED") { errorHandler in
            Car.shared.sendDoorsCommand(lock: false) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        let oppositeAction = ControlAction(name: "locked", iconName: "DoorlockLOCKED") { errorHandler in
            Car.shared.sendDoorsCommand(lock: true) {
                if let error = $0 { errorHandler?(error) }
            }
        }

        return [DualControlFunction(kind: .doorsLock, mainAction: mainAction, oppositeAction: oppositeAction, isMainTrue: false)]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}


extension DoorsStatusCommand: ControlFunctionable {

    var boolValue: (ControlFunction.Kind) -> Bool? {
        return { _ in nil }
    }

    var controlFunctions: [ControlFunction] {
        return [FullScreenControlFunction(kind: .doorsStatus, iconName: "DoorlockLOCKED", viewControllerID: "DoorsStatusViewControllerID")]
    }

    var stringValue: (ControlFunction.Kind) -> String? {
        return { _ in nil }
    }
}
