Pod::Spec.new do |spec|
  	spec.name             = 'MIDIKit'
  	spec.version          = '0.9.4'
  	spec.summary          = 'An elegant and modern CoreMIDI wrapper in pure Swift supporting MIDI 1.0 and MIDI 2.0.'
  	spec.homepage         = 'https://github.com/orchetect/MIDIKit'
  	spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  	spec.author           = { 'orchetect' => 'https://github.com/orchetect' }
  	spec.source           = { :git => 'https://github.com/orchetect/MIDIKit.git', :tag => spec.version.to_s }
  	spec.swift_version = '5.7'
    spec.frameworks = 'CoreMIDI'  
    #spec.platform = :osx

    spec.tvos.deployment_target = '11.0'
    spec.ios.deployment_target = '11.0'
    spec.macos.deployment_target = '10.13'

    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |subspec|
    	subspec.source_files = 'Sources/MIDIKit/**/*'
    	subspec.dependency 'MIDIKit/MIDIKitCore'
    	subspec.dependency 'MIDIKit/MIDIKitIO'
    	subspec.dependency 'MIDIKit/MIDIKitControlSurfaces'
    	subspec.dependency 'MIDIKit/MIDIKitSMF'
    	subspec.dependency 'MIDIKit/MIDIKitSync'
    	subspec.dependency 'MIDIKit/MIDIKitUI'
  	end

    spec.subspec 'MIDIKitInternals' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitInternals/**/*'
  	end

  	spec.subspec 'MIDIKitCore' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitCore/**/*'
    	subspec.dependency 'MIDIKit/MIDIKitInternals'
  	end

  	spec.subspec 'MIDIKitIO' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitIO/**/*'
    	subspec.dependency 'MIDIKit/MIDIKitInternals'
    	subspec.dependency 'MIDIKit/MIDIKitCore'
  	end

  	spec.subspec 'MIDIKitControlSurfaces' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitControlSurfaces/**/*'
    	subspec.dependency 'MIDIKit/MIDIKitCore'
  	end

  	spec.subspec 'MIDIKitSMF' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitSMF/**/*'
    	subspec.dependency 'MIDIKit/MIDIKitCore'
    	subspec.dependency 'TimecodeKit'
  	end

  	spec.subspec 'MIDIKitSync' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitSync/**/*'
    	subspec.dependency 'MIDIKit/MIDIKitCore'
    	subspec.dependency 'TimecodeKit'
  	end

  	spec.subspec 'MIDIKitUI' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitUI/**/*'
    	subspec.dependency 'MIDIKit/MIDIKitIO'
  	end

end