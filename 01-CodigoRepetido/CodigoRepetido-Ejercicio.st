!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!
!CantSuspend commentStamp: '<historical>' prior: 0!
CantSuspend class!



!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'testing' stamp: 'N S 9/6/2023 22:36:42'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds

	| customerBook |

	customerBook := CustomerBook new.
	self theExecutionOf: [ customerBook addCustomerNamed: 'John Lennon' ] takesLessThan: 50 * millisecond.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N S 9/6/2023 17:20:47'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds

	| customerBook |

	customerBook := self createNewBookAndAddCustomerNamed: 'Paul McCartney'.

	self theExecutionOf: [ customerBook removeCustomerNamed: 'Paul McCartney' ] takesLessThan: 100 * millisecond.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'HernanWilkinson 5/9/2012 18:12'!
test03CanNotAddACustomerWithEmptyName

	| customerBook |

	customerBook := CustomerBook new.

	[ customerBook addCustomerNamed: ''.
	self fail ]
		on: Error
		do: [ :anError |
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'gg 9/5/2023 23:30:09'!
test04CanNotRemoveAnInvalidCustomer

	| customerBook |

	customerBook := self createNewBookAndAddCustomerNamed: 'John Lennon'.

	[ customerBook removeCustomerNamed: 'Paul McCartney'.
	self fail ]
		on: NotFound
		do: [ :anError |
			self customerBookOnlyHasJohnLennon: customerBook ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N S 9/6/2023 22:28:13'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook |

	customerBook := self createNewBookAddAndSuspendPaulMcCartney.

	self verifyCustomerBook: customerBook hasActive: 0 hasSuspended: 1 hasTotal: 1.
	self assert: (customerBook includesCustomerNamed: 'Paul McCartney').



! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N S 9/6/2023 22:28:54'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook |

	customerBook := self createNewBookAddAndSuspendPaulMcCartney.

	customerBook removeCustomerNamed: 'Paul McCartney'.
	self verifyCustomerBook: customerBook hasActive: 0 hasSuspended: 0 hasTotal: 0.

	self deny: (customerBook includesCustomerNamed: 'Paul McCartney').



! !

!CustomerBookTest methodsFor: 'testing' stamp: 'gg 9/5/2023 23:20:24'!
test07CanNotSuspendAnInvalidCustomer

	| customerBook |

	customerBook := self createNewBookAndAddCustomerNamed: 'John Lennon'.

	self cantSuspendCustomerNamed: 'George Harrison' inBook: customerBook.
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'N S 9/6/2023 22:36:24'!
test08CanNotSuspendAnAlreadySuspendedCustomer

	| customerBook |

	customerBook := self createNewBookAndAddCustomerNamed: 'John Lennon'.
	customerBook suspendCustomerNamed: 'John Lennon'.

	self cantSuspendCustomerNamed: 'John Lennon' inBook: customerBook.! !


!CustomerBookTest methodsFor: 'testing abstractions' stamp: 'N S 9/6/2023 17:20:08'!
cantSuspendCustomerNamed: aCustomerName inBook: aCustomerBook

	[ aCustomerBook suspendCustomerNamed: aCustomerName .
		self fail ]
			on: CantSuspend
			do: [ :anError |
				self customerBookOnlyHasJohnLennon: aCustomerBook ]! !

!CustomerBookTest methodsFor: 'testing abstractions' stamp: 'N S 9/6/2023 22:27:42'!
createNewBookAddAndSuspendPaulMcCartney

	| customerBook paulMcCartney |

	paulMcCartney := 'Paul McCartney'.
	customerBook := self createNewBookAndAddCustomerNamed: paulMcCartney.
	customerBook suspendCustomerNamed: paulMcCartney.
	^customerBook! !

!CustomerBookTest methodsFor: 'testing abstractions' stamp: 'gg 9/5/2023 23:37:44'!
createNewBookAndAddCustomerNamed: aName

	| customerBook |

	customerBook := CustomerBook new.
	customerBook addCustomerNamed: aName.
	^customerBook! !

!CustomerBookTest methodsFor: 'testing abstractions' stamp: 'gg 9/5/2023 23:28:59'!
customerBookOnlyHasJohnLennon: aCustomerBook

	self assert: aCustomerBook numberOfCustomers = 1.
	self assert: (aCustomerBook includesCustomerNamed: 'John Lennon')! !

!CustomerBookTest methodsFor: 'testing abstractions' stamp: 'gg 9/6/2023 00:03:13'!
theExecutionOf: aClosure takesLessThan: anAmountOfTime
	| millisecondsBeforeRunning millisecondsAfterRunning |

	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	aClosure value.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.

	self assert: (millisecondsAfterRunning-millisecondsBeforeRunning) < anAmountOfTime
! !

!CustomerBookTest methodsFor: 'testing abstractions' stamp: 'gg 9/5/2023 23:48:51'!
verifyCustomerBook: aCustomerBook hasActive: anAmountOfActiveCustomers hasSuspended: anAmountOfSuspendedCustomers hasTotal: anAmountOfCustomers

	self assert: anAmountOfActiveCustomers equals: aCustomerBook numberOfActiveCustomers.
	self assert: anAmountOfSuspendedCustomers equals: aCustomerBook numberOfSuspendedCustomers.
	self assert: anAmountOfCustomers equals: aCustomerBook numberOfCustomers.! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty

	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 9/17/2020 07:23:04'!
initialize

	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	((active includes: aName) or: [suspended includes: aName]) ifTrue: [ self signalCustomerAlreadyExists ].

	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers

	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'N S 9/6/2023 00:40:44'!
numberOfCustomers
	^self numberOfActiveCustomers + self numberOfSuspendedCustomers! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers

	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'N S 9/6/2023 17:19:53'!
removeCustomerNamed: aName
	[ self findAndRemoveInCollection: active aCustomerNamed: aName ]
	on: NotFound
	do: [ self findAndRemoveInCollection: suspended aCustomerNamed: aName ]! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
suspendCustomerNamed: aName

	(active includes: aName) ifFalse: [^CantSuspend signal].

	active remove: aName.

	suspended add: aName
! !


!CustomerBook methodsFor: 'collection abstraction' stamp: 'N S 9/6/2023 17:18:19'!
findAndRemoveInCollection: anOrderedCollection aCustomerNamed: aName

	1 to: anOrderedCollection size do:
	[ :index |
		aName = (anOrderedCollection at: index)
			ifTrue: [
				anOrderedCollection removeAt: index.
				^ aName
			]
	].

	^ NotFound signal! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/4/2023 17:02:48'!
customerAlreadyExistsErrorMessage

	^'Customer already exists!!!!!!'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 9/4/2023 17:02:52'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty!!!!!!'! !
