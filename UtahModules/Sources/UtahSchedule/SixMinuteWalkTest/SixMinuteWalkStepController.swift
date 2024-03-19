//
// This source file is part of the CS342 2023 Utah Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

// swiftlint:disable force_cast
// swiftlint:disable line_length
// swiftlint:disable force_unwrapping
// swiftlint:disable type_contents_order
import Foundation
import ResearchKit
import SwiftUI
import UIKit

public class SixMinuteWalkStepViewController: ORKActiveStepViewController { // Or do we want ORKFitnessStepViewController 
    private var startTime: TimeInterval?
    private var endTime: TimeInterval?
    private var results: NSMutableArray?
    private let visionStepView = SixMinuteWalkStepUIView()
    private var restClicks: Int = 0
    private var pedometerRecorder: ORKPedometerRecorder?
    
    override public init(step: ORKStep?) {
        super.init(step: step)
        suspendIfInactive = true
        restClicks = 0
        pedometerRecorder = ORKPedometerRecorder(identifier: "Pedometer", step: step, outputDirectory: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func start() {
        super.start()
        startTime = ProcessInfo.processInfo.systemUptime
    }
    
    override public func stepDidFinish() {
        super.stepDidFinish()
        createResult(id: "Complete_")
        goForward()
    }
    
    @objc
    public func symptomButtonHit() {
        // TODO: Implement the symptomButtonHit function here
        visionStepView.symptomButtonPressedLabel.isHidden = false
        restClicks += 1
        createResult(id: "RestClick" + String(restClicks) + "_")
    }
    
    private func sixMinuteWalkStep() -> SixMinuteWalkStep {
        step as! SixMinuteWalkStep
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        results = NSMutableArray()

        activeStepView?.customContentView = visionStepView
        activeStepView?.customContentFillsAvailableSpace = true
    
        visionStepView.symptomButton.addTarget(self, action: #selector(symptomButtonHit), for: .touchUpInside)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        start()
    }
    
    override public var result: ORKStepResult? {
        let stepResult = super.result
        if results != nil {
            stepResult?.results = results?.copy() as? [ORKResult]
        }
        return stepResult!
    }
    
    private func createResult(id: String) {
        let walkResult = SixMinuteWalkStepResult(identifier: (id + step!.identifier))
        walkResult.steps = pedometerRecorder?.totalNumberOfSteps
        walkResult.distance = pedometerRecorder?.totalDistance
        walkResult.relativeTime = self.runtime
        let date = Date()
        //let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //dateFormatter.dateFormat = "y, MMM d, HH:mm:ss"
        //walkResult.absoluteTime = dateFormatter.string(from: date)
        walkResult.absoluteTime = date
        results?.add(walkResult)
    }
}


public class SixMinuteWalkStepUIView: UIView {
    var visionContentView: SixMinuteWalkContentView?
        
    let symptomButtonCornerRadius: CGFloat = 12.0
    let visionContentTopPadding: CGFloat = 10.0
    let instructionLabelTopPadding: CGFloat = 15.0
    
    let symptomButton = ORKRoundTappingButton()
    let symptomButtonPressedLabel = UILabel()
        
    private let minimumButtonHeight: CGFloat = 60.0
    private let buttonStackViewSpacing: CGFloat = 20.0
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setup() {
        setupVisionContentView()
        setupSymptomButton()
        setupSymptomButtonPressedLabel()
        setupConstraints()
    }
    
    func setupVisionContentView() {
        if visionContentView == nil {
            visionContentView = SixMinuteWalkContentView()
        }
        addSubview(visionContentView!)
    }
    
    func setupSymptomButton() {
        symptomButton.diameter = 160.0
        symptomButton.setTitle("REST", for: UIControl.State.normal)
        symptomButton.backgroundColor = tintColor
        symptomButton.layer.cornerRadius = symptomButtonCornerRadius
        addSubview(symptomButton)
    }
    func setupSymptomButtonPressedLabel() {
        symptomButtonPressedLabel.text = "Rest button was pressed. Resume walking when able."
        symptomButtonPressedLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        symptomButtonPressedLabel.numberOfLines = 0
        symptomButtonPressedLabel.textAlignment = .center
        symptomButtonPressedLabel.isHidden = true
        addSubview(symptomButtonPressedLabel)
    }
    
    private func setupConstraints() {
        visionContentView?.translatesAutoresizingMaskIntoConstraints = false
        symptomButton.translatesAutoresizingMaskIntoConstraints = false
        symptomButtonPressedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += [
            NSLayoutConstraint(
                item: symptomButton,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0
            ),
            NSLayoutConstraint(
                item: symptomButton,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0
            )
        ]
            
        constraints += [
            symptomButtonPressedLabel.topAnchor.constraint(equalTo: symptomButton.bottomAnchor, constant: 16),
            symptomButtonPressedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            symptomButtonPressedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ]

        self.addConstraints(constraints)
        NSLayoutConstraint.activate(constraints)
    }
}
