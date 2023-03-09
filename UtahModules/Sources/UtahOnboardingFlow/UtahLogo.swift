//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable accessibility_label_for_image
// swiftlint:disable missing_docs

import SwiftUI

public var utahLogo: Image {
    guard let imagePath = Bundle.module.path(forResource: "UtahLogo", ofType: "jpeg"),
       let image = UIImage(contentsOfFile: imagePath) else {
        return Image(systemName: "building.columns.fill")
    }

    return Image(uiImage: image)
}
