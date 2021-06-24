//
//  AtomicAccess.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Darwin

// Derived from: https://stackoverflow.com/a/60814063/2805570

extension MIDI {
	
	/// A property wrapper that ensures atomic access to a value, meaning thread-safe with implicit serial read/write access.
	/// Multiple read accesses can potentially read at the same time, just not during a write.
	/// By using `pthread` to do the locking, this safer than using a `DispatchQueue/barrier` as there isn't a chance of priority inversion.
	@propertyWrapper
	public final class AtomicAccess<T> {
		
		private var value: T
		private let lock: ThreadLock = RWThreadLock()
		
		public init(wrappedValue value: T) {
			self.value = value
		}
		
		public var wrappedValue: T {
			
			get {
				self.lock.readLock()
				defer { self.lock.unlock() }
				return self.value
			}
			set {
				self.lock.writeLock()
				self.value = newValue
				self.lock.unlock()
			}
			
		}
		
		/// Provides a closure that will be called synchronously.
		/// This closure will be passed in the current value and it is free to modify it.
		/// Any modifications will be saved back to the original value.
		/// No other reads/writes will be allowed between when the closure is called and it returns.
		public func mutate(_ closure: (inout T) -> Void) {
			
			self.lock.writeLock()
			closure(&value)
			self.lock.unlock()
			
		}
		
	}
	
}


/// Defines a basic signature to which all locks will conform. Provides the basis for atomic access to stuff.
fileprivate protocol ThreadLock {
	
	init()
	
	/// Lock a resource for writing. So only one thing can write, and nothing else can read or write.
	func writeLock()
	
	/// Lock a resource for reading. Other things can also lock for reading at the same time, but nothing else can write at that time.
	func readLock()
	
	/// Unlock a resource
	func unlock()
	
}

fileprivate final class RWThreadLock: ThreadLock {
	
	private var lock = pthread_rwlock_t()
	
	init() {
		guard pthread_rwlock_init(&lock, nil) == 0 else {
			preconditionFailure("Unable to initialize the lock")
		}
	}
	
	deinit {
		pthread_rwlock_destroy(&lock)
	}
	
	func writeLock() {
		pthread_rwlock_wrlock(&lock)
	}
	
	func readLock() {
		pthread_rwlock_rdlock(&lock)
	}
	
	func unlock() {
		pthread_rwlock_unlock(&lock)
	}
	
}
