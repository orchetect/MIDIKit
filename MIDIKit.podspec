Pod::Spec.new do |s|
  	s.name             = 'MIDIKit'
  	s.version          = '0.9.4'
  	s.summary          = 'An elegant and modern CoreMIDI wrapper in pure Swift supporting MIDI 1.0 and MIDI 2.0.'
  	s.homepage         = 'https://github.com/orchetect/MIDIKit'
  	s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  	s.author           = { 'orchetect' => 'https://github.com/orchetect' }
  	s.source           = { :git => 'https://github.com/orchetect/MIDIKit', :tag => s.version.to_s }
  	s.ios.deployment_target = '13.0'
  	s.swift_version = '5.0'
    s.frameworks = 'CoreMIDI'  
    #spec.platform = :osx

    s.default_subspec = 'Core'

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