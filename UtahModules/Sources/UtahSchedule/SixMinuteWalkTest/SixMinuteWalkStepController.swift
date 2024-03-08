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

public class SixMinuteWalkStepViewController: ORKActiveStepViewController {
    private var startTime: TimeInterval?
    private var endTime: TimeInterval?
    private var results: NSMutableArray?
    private let visionStepView = SixMinuteWalkStepUIView()
    
    override public init(step: ORKStep?) {
        super.init(step: step)
        suspendIfInactive = true
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
        goForward()
    }
    
    @objc
    public func stopButtonHit() {
        endTime = ProcessInfo.processInfo.systemUptime
        let duration = endTime! - startTime!
        visionStepView.continueButton.removeFromSuperview()
        showUserAnswers(time: duration)
    }
    
    private func sixMinuteWalkStep() -> SixMinuteWalkStep {
        step as! SixMinuteWalkStep
    }
    
    @objc
    func showUserAnswers(time: Double) {
        visionStepView.question.text = "You took about " + String(time.rounded()) + " seconds to complete that task. Does this seem right? Choose the best category you feel is most appropriate."
        visionStepView.answerButton1.isHidden = false
        visionStepView.answerButton2.isHidden = false
        visionStepView.answerButton3.isHidden = false
        visionStepView.question.isHidden = false
    }
    
    @objc
    func answer1Chosen() {
        createResult(score: 2)
        stepDidFinish()
    }
    
    @objc
    func answer2Chosen() {
        createResult(score: 1)
        stepDidFinish()
    }
    
    @objc
    func answer3Chosen() {
        createResult(score: 0)
        stepDidFinish()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        results = NSMutableArray()

        activeStepView?.customContentView = visionStepView
        activeStepView?.customContentFillsAvailableSpace = true
    
        visionStepView.continueButton.addTarget(self, action: #selector(stopButtonHit), for: .touchUpInside)
        visionStepView.answerButton1.addTarget(self, action: #selector(answer1Chosen), for: .touchUpInside)
        visionStepView.answerButton2.addTarget(self, action: #selector(answer2Chosen), for: .touchUpInside)
        visionStepView.answerButton3.addTarget(self, action: #selector(answer3Chosen), for: .touchUpInside)
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
    
    private func createResult(score: Int) {
        let walkResult = SixMinuteWalkStepResult(identifier: (step!.identifier))
        walkResult.score = score
        results?.add(walkResult)
    }
}


public class SixMinuteWalkStepUIView: UIView {
    var visionContentView: SixMinuteWalkContentView?
        
    let continueButtonCornerRadius: CGFloat = 12.0
    let visionContentTopPadding: CGFloat = 10.0
    let instructionLabelTopPadding: CGFloat = 15.0
    
    let continueButton = ORKRoundTappingButton()
    let answerButton1 = UIButton()
    let answerButton2 = UIButton()
    let answerButton3 = UIButton()
    let question = UILabel()
        
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
        setupContinueButton()
        setupQuestionLabel()
        setupUserAnswers()
        setupConstraints()
    }
    
    func setupVisionContentView() {
        if visionContentView == nil {
            visionContentView = SixMinuteWalkContentView()
        }
        addSubview(visionContentView!)
    }
    
    func setupContinueButton() {
        continueButton.diameter = 160.0
        continueButton.setTitle("STOP", for: UIControl.State.normal)
        continueButton.backgroundColor = tintColor
        continueButton.layer.cornerRadius = continueButtonCornerRadius
        addSubview(continueButton)
    }
    func setupQuestionLabel() {
        question.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        question.numberOfLines = 0
        question.textAlignment = .center
        question.isHidden = true
        addSubview(question)
    }
    func setupUserAnswers() {
        answerButton1.setTitle("1-10 Seconds", for: UIControl.State.normal)
        answerButton2.setTitle("11-20 Seconds", for: UIControl.State.normal)
        answerButton3.setTitle(">21 Seconds", for: UIControl.State.normal)
        
        [answerButton1, answerButton2, answerButton3].forEach {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            $0.backgroundColor = .tintColor
            $0.isHidden = true
            $0.layer.cornerRadius = 8
            $0.setTitleColor(.white, for: .normal)
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        visionContentView?.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        answerButton2.translatesAutoresizingMaskIntoConstraints = false
        answerButton1.translatesAutoresizingMaskIntoConstraints = false
        answerButton3.translatesAutoresizingMaskIntoConstraints = false
        question.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += [
            NSLayoutConstraint(
                item: continueButton,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0
            )
        ]
                                                    
            
        constraints += [
            question.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            question.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            question.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            answerButton1.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 32),
            answerButton1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            answerButton1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            answerButton2.topAnchor.constraint(equalTo: answerButton1.bottomAnchor, constant: 16),
            answerButton2.leadingAnchor.constraint(equalTo: answerButton1.leadingAnchor),
            answerButton2.trailingAnchor.constraint(equalTo: answerButton1.trailingAnchor),
            answerButton3.topAnchor.constraint(equalTo: answerButton2.bottomAnchor, constant: 16),
            answerButton3.leadingAnchor.constraint(equalTo: answerButton1.leadingAnchor),
            answerButton3.trailingAnchor.constraint(equalTo: answerButton1.trailingAnchor)
        ]

        self.addConstraints(constraints)
        NSLayoutConstraint.activate(constraints)
    }
}
