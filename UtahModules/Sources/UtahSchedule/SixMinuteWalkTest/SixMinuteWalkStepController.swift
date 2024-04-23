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
import CoreMotion
import CoreHaptics

public class SixMinuteWalkStepViewController: ORKActiveStepViewController { // Or do we want ORKFitnessStepViewController 
    private var startTime: TimeInterval?
    private var endTime: TimeInterval?
    private var results: NSMutableArray?
    private let visionStepView = SixMinuteWalkStepUIView()
    private var restClicks: Int = 0
    private let activityManager = CMMotionActivityManager()
    private let pedometerRecorder = CMPedometer()
    private var stepCount: Int? = 0
    private var distance: Int? = 0
    private var engine: CHHapticEngine?
    private var hasAlreadyStarted: Bool = false
    
    override public init(step: ORKStep?) {
        super.init(step: step)
        suspendIfInactive = false
        UIApplication.shared.isIdleTimerDisabled = true
        restClicks = 0
        stepCount = 0
        distance = 0
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func start() {
        if(hasAlreadyStarted)
        {
            // If this task has already started, this is likely being called after a partial swipe down
            // In that case, return before setting any new variables/restarting the timer/etc
            return
        }
        hasAlreadyStarted = true
        super.start()
        startTime = ProcessInfo.processInfo.systemUptime
        if CMPedometer.isStepCountingAvailable() {
            pedometerRecorder.startUpdates(from: Date()) { pedometerData, error in
                guard let pedometerData = pedometerData, error == nil else {return}
                DispatchQueue.main.async {
                    //print("Step count: \(pedometerData.numberOfSteps.intValue)")
                    self.stepCount = pedometerData.numberOfSteps.intValue
                    self.distance = pedometerData.distance?.intValue
                }
            }
        } else {
            stepCount = -1
            distance = -1
        }
        initializeHaptics()
    }
    
    override public func stepDidFinish() {
        super.stepDidFinish()
        pedometerRecorder.stopUpdates()
        createResult(id: "Complete_")
        goForward()
    }
    
    @objc
    public func symptomButtonHit() {
        if(visionStepView.symptomButtonPressedLabel.isHidden == true)
        {
            generateHaptics()
            visionStepView.symptomButtonPressedLabel.isHidden = false
            restClicks += 1
            createResult(id: "RestClick" + String(restClicks) + "_")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.hideRestingText()
            })
        }
    }
    
    override public func suspend() {
        // This function is only called when partially swiping the step card
        // Therefore, we don't want it to suspend so we don't call super.suspend()
        //super.suspend()
    }
    
    override public func resume() {
        // This is called on initial launch and after each partial swipe down
        // Therefore, we don't want it to execute the super.resume() function
        //super.resume()
        //self.hideRestingText()
    }
    
    private func hideRestingText() {
        visionStepView.symptomButtonPressedLabel.isHidden = true
    }
    
    private func initializeHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error creating haptics engine: \(error.localizedDescription)")
        }
    }
    
    private func generateHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {return}

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0, duration:0.5)

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
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
        walkResult.steps = stepCount
        walkResult.distance = distance
        walkResult.relativeTime = self.runtime
        let date = Date()
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
