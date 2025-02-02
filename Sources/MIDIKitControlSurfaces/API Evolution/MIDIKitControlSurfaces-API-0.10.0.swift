//
//  MIDIKitControlSurfaces-API-0.10.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.StereoLevelMeter {
    @available(*, deprecated, renamed: "StereoLevelMeterSide")
    public typealias Side = HUISurfaceModelState.StereoLevelMeterSide
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.Assign {
    @available(*, deprecated, renamed: "defaultBtn")
    public var `default`: Bool {
        get { defaultBtn }
        set { defaultBtn = newValue }
    }
}

extension HUISwitch.Assign {
    @available(*, deprecated, renamed: "defaultBtn")
    public static var `default`: Self { .defaultBtn }
}
