//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import ResearchKit.Private

internal class TimedWalkContentView: UIView {
    internal init() {
        super.init(frame: CGRect())
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func setupConstraints() {
    }
}
