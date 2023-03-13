//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SwiftUI

class SheetDismisserProtocol: ObservableObject {
    weak var host: UIHostingController<AnyView>?
    
    func dismiss() {
        host?.dismiss(animated: true)
    }
}
