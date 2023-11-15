Pod::Spec.new do |spec|
  	spec.name             = 'MIDIKit'
  	spec.version          = '0.9.4'
  	spec.summary          = 'An elegant and modern CoreMIDI wrapper in pure Swift supporting MIDI 1.0 and MIDI 2.0.'
  	spec.homepage         = 'https://github.com/orchetect/MIDIKit'
  	spec.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  	spec.author           = { 'orchetect' => 'https://github.com/orchetect' }
  	spec.source           = { :git => 'https://github.com/orchetect/MIDIKit.git', :tag => s.version.to_s }
  	spec.ios.deployment_target = '13.0'
  	spec.swift_version = '5.0'
    spec.frameworks = 'CoreMIDI'  
    #spec.platform = :osx

    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |subspec|
    	subspec.source_files = 'Sources/MIDIKit/**/*'
    	subspec.dependency 'MIDIKitCore'
    	subspec.dependency 'MIDIKitIO'
    	subspec.dependency 'MIDIKitControlSurfaces'
    	subspec.dependency 'MIDIKitSMF'
    	subspec.dependency 'MIDIKitSync'
    	subspec.dependency 'MIDIKitUI'
  	end

    spec.subspec 'MIDIKitInternals' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitInternals/**/*'
  	end

  	spec.subspec 'MIDIKitCore' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitCore/**/*'
    	subspec.dependency 'MIDIKitInternals'
  	end

  	spec.subspec 'MIDIKitIO' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitIO/**/*'
    	subspec.dependency 'MIDIKitInternals'
    	subspec.dependency 'MIDIKitCore'
  	end

  	spec.subspec 'MIDIKitControlSurfaces' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitControlSurfaces/**/*'
    	subspec.dependency 'MIDIKitCore'
  	end

  	spec.subspec 'MIDIKitSMF' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitSMF/**/*'
    	subspec.dependency 'MIDIKitCore'
    	subspec.dependency 'TimecodeKit'
  	end

  	spec.subspec 'MIDIKitSync' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitSync/**/*'
    	subspec.dependency 'MIDIKitCore'
    	subspec.dependency 'TimecodeKit'
  	end

  	spec.subspec 'MIDIKitUI' do |subspec|
    	subspec.source_files = 'Sources/MIDIKitUI/**/*'
    	subspec.dependency 'MIDIKitIO'
  	end

end