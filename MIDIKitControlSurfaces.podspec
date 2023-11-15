Pod::Spec.new do |spec|
  	spec.name             = 'MIDIKitControlSurfaces'
  	spec.version          = '0.9.4'
  	spec.summary          = 'An elegant and modern CoreMIDI wrapper in pure Swift supporting MIDI 1.0 and MIDI 2.0.'
  	spec.homepage         = 'https://github.com/orchetect/MIDIKit'
  	spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  	spec.author           = { 'orchetect' => 'https://github.com/orchetect' }
  	spec.source           = { :git => 'https://github.com/orchetect/MIDIKit.git', :tag => spec.version.to_s }
  	spec.swift_version = '5.7'
    spec.frameworks = 'CoreMIDI'  
    spec.static_framework = true

    spec.tvos.deployment_target = '11.0'
    spec.ios.deployment_target = '11.0'
    spec.macos.deployment_target = '10.13'

    spec.source_files = 'Sources/MIDIKitControlSurfaces/**/*'
    spec.dependency 'MIDIKitCore'
end