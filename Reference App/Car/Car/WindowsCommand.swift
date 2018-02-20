//
//  WindowsClass.swift
//  Car
//
//  Created by Mikk Rätsep on 27/09/2017.
//  Copyright © 2017 High-Mobility GmbH. All rights reserved.
//

import AutoAPI
import Foundation


public class WindowClass {

    public let isOpen: Bool

    public var positionStr: String {
        return position.stringValue
    }


    let position: Position


    init(window: Window) {
        isOpen = window.openClosed == .open
        position = window.position
    }
}


public class WindowsCommand: CommandClass {

    public private(set) var open: Bool = false
    public private(set) var windows: [WindowClass] = []
}

extension WindowsCommand: Parser {

}

extension WindowsCommand: CapabilityParser {

    func update(from capability: Capability) {
        guard capability.command is Windows.Type else {
            return
        }

        guard capability.supportsAllMessageTypes(for: Windows.self) else {
            return
        }

        isAvailable = true
    }
}

extension WindowsCommand: ResponseParser {

    @discardableResult func update(from response: Command) -> CommandType? {
        guard let windows = response as? Windows else {
            return nil
        }

        guard let array = windows.windows else {
            return nil
        }

        self.open = array.filter { $0.position != .hatch }.contains { $0.openClosed == .open }
        self.windows = array.map { WindowClass(window: $0) }

        return .other(self)
    }
}