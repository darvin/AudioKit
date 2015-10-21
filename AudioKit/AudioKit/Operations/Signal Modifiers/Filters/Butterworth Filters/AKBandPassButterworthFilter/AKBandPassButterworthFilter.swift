//
//  AKBandPassButterworthFilter.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import AVFoundation

/** These filters are Butterworth second-order IIR filters. They offer an almost flat passband and very good precision and stopband attenuation. */
public class AKBandPassButterworthFilter: AKOperation {

    // MARK: - Properties

    /** The underlying AudioUnit */
    private var internalAU: AKBandPassButterworthFilterAudioUnit?

    /** A generic parameter observer token */
    private var token: AUParameterObserverToken?

    /** Center frequency. (in Hertz) */
    var centerFrequencyParameter: AUParameter?
    /** Bandwidth. (in Hertz) */
    var bandwidthParameter:       AUParameter?

    /** Center frequency. (in Hertz) */
    public var centerFrequency: Float = 2000 {
        didSet {
            centerFrequencyParameter?.setValue(centerFrequency, originator: token!)
        }
    }
    /** Bandwidth. (in Hertz) */
    public var bandwidth: Float = 100 {
        didSet {
            bandwidthParameter?.setValue(bandwidth, originator: token!)
        }
    }

    // MARK: - Initializers

    /** Initialize this filter operation */
    public init(_ input: AKOperation) {
        super.init()

        var description = AudioComponentDescription()
        description.componentType         = kAudioUnitType_Effect
        description.componentSubType      = 0x62746270 /*'btbp'*/
        description.componentManufacturer = 0x41754b74 /*'AuKt'*/
        description.componentFlags        = 0
        description.componentFlagsMask    = 0

        AUAudioUnit.registerSubclass(
            AKBandPassButterworthFilterAudioUnit.self,
            asComponentDescription: description,
            name: "Local AKBandPassButterworthFilter",
            version: UInt32.max)

        AVAudioUnit.instantiateWithComponentDescription(description, options: []) {
            avAudioUnit, error in

            guard let avAudioUnitEffect = avAudioUnit else { return }

            self.output = avAudioUnitEffect
            self.internalAU = avAudioUnitEffect.AUAudioUnit as? AKBandPassButterworthFilterAudioUnit
            AKManager.sharedInstance.engine.attachNode(self.output!)
            AKManager.sharedInstance.engine.connect(input.output!, to: self.output!, format: nil)
        }

        guard let tree = internalAU?.parameterTree else { return }

        centerFrequencyParameter = tree.valueForKey("centerFrequency") as? AUParameter
        bandwidthParameter       = tree.valueForKey("bandwidth")       as? AUParameter

        token = tree.tokenByAddingParameterObserver {
            address, value in

            dispatch_async(dispatch_get_main_queue()) {
                if address == self.centerFrequencyParameter!.address {
                    self.centerFrequency = value
                }
                else if address == self.bandwidthParameter!.address {
                    self.bandwidth = value
                }
            }
        }

    }
}
