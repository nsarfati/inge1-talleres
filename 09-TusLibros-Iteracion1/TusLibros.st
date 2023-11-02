!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:14:02'!
test01CartIsCreatedEmpty
	
	|catalogue|
	
	catalogue := OrderedCollection with: '123' with: '456'.
	
	self assert: (Cart forCatalogue: catalogue) isEmpty! !

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:14:34'!
test02CartIsNotEmptyWhenABookIsAdded

	|cart catalogue|
	
	catalogue := OrderedCollection with: '123' with: '456'.

	cart := Cart forCatalogue: catalogue.
	cart addBook: '123'.
	
	self deny: cart isEmpty! !

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:15:36'!
test03BooksInCartAreListedCorrectly

	|cart catalogue|
	
	catalogue := OrderedCollection with: '123' with: '456' with: '789' with: '112'. 
	
	cart := Cart forCatalogue: catalogue.
	cart addBook: '123'.
	cart addBook: '456'.
	cart addBook: '789'.
	
	self assert: cart amountOfBooks equals: 3.
	self assert: (cart containsBook: '123').
	self assert: (cart containsBook: '456').
	self assert: (cart containsBook: '789').! !

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:19:20'!
test04CantAddABookNotIncludedInCatalogue

	|cart catalogue|
	
	catalogue := OrderedCollection with: '456'.
	
	cart := Cart forCatalogue: catalogue.
	
	self should: [cart addBook: '123']  
		raise: Error 
		withExceptionDo: [:anError | 
			self assert: anError messageText equals: Cart bookNotAvailableErrorDescription.
			self assert: cart isEmpty].
	! !

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:30:33'!
test05CartCanStoreMultipleOcurrencesOfABook

	|cart catalogue|
	
	catalogue := OrderedCollection with: '123' with: '456' with: '789'.
	
	cart := Cart forCatalogue: catalogue.
	
	cart addBook: '123'; addBook: '123'; addBook: '456'.
	
	self assert: cart amountOfBooks equals: 3.
	self assert: (cart timesBookIsIncluded: '123') equals: 2.
	self assert: (cart timesBookIsIncluded: '456') equals: 1.	! !

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:36:15'!
test06CanAddABookMultipleTimes

	|cart catalogue|
	
	catalogue := OrderedCollection with: '123' with: '456' with: '789'.
	
	cart := Cart forCatalogue: catalogue.
	
	cart addBook: '123' times: 5.
	cart addBook: '456' times: 1.
	
	self assert: cart amountOfBooks equals: 6.
	self assert: (cart timesBookIsIncluded: '123') equals: 5.
	self assert: (cart timesBookIsIncluded: '456') equals: 1.	! !

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:43:59'!
test07CantAddABookZeroTimes

	|cart catalogue|
	
	catalogue := OrderedCollection with: '123' with: '456' with: '789'.
	
	cart := Cart forCatalogue: catalogue.
	
	self should: [cart addBook: '123' times: 0.]  
		raise: Error 
		withExceptionDo: [:anError | 
			self assert: anError messageText equals: Cart ocurrencesOfBookNotPositiveErrorDescription.
			self assert: cart isEmpty].
	
! !

!CartTest methodsFor: 'testing' stamp: 'GG 10/30/2023 20:45:10'!
test08CantAddABookNegativeTimes

	|cart catalogue|
	
	catalogue := OrderedCollection with: '123' with: '456' with: '789'.
	
	cart := Cart forCatalogue: catalogue.
	
	self should: [cart addBook: '123' times: -10.]  
		raise: Error 
		withExceptionDo: [:anError | 
			self assert: anError messageText equals: Cart ocurrencesOfBookNotPositiveErrorDescription.
			self assert: cart isEmpty].
	
! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'books catalogue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'initialization' stamp: 'GG 10/30/2023 20:12:38'!
initializeWithCatalogue: aCatalogue 
	
	books := OrderedCollection new.
	catalogue := aCatalogue.! !


!Cart methodsFor: 'testing' stamp: 'GG 10/30/2023 19:35:41'!
amountOfBooks 

	^ books size! !

!Cart methodsFor: 'testing' stamp: 'GG 10/30/2023 19:33:58'!
containsBook: aBook

	^ books includes: aBook! !

!Cart methodsFor: 'testing' stamp: 'GG 10/30/2023 19:27:34'!
isEmpty
	
	^ books isEmpty! !

!Cart methodsFor: 'testing' stamp: 'GG 10/30/2023 20:26:34'!
timesBookIsIncluded: aBook

	^ books occurrencesOf: aBook 

! !


!Cart methodsFor: 'manage' stamp: 'GG 10/30/2023 20:19:49'!
addBook: aBook
	
	self assertBookIsAvailable: aBook.
	books add: aBook ! !

!Cart methodsFor: 'manage' stamp: 'GG 10/30/2023 20:46:46'!
addBook: aBook times: anAmountOfTimesToAdd

	self assertValidOcurrences: anAmountOfTimesToAdd.
	anAmountOfTimesToAdd timesRepeat: [self addBook: aBook]! !


!Cart methodsFor: 'assertions' stamp: 'GG 10/30/2023 20:19:49'!
assertBookIsAvailable: aBook

	^ (catalogue includes: aBook) ifFalse: [self error: self class bookNotAvailableErrorDescription]! !

!Cart methodsFor: 'assertions' stamp: 'GG 10/30/2023 20:46:46'!
assertValidOcurrences: anAmountOfTimesToAdd

	^ anAmountOfTimesToAdd < 1 ifTrue: [self error: self class ocurrencesOfBookNotPositiveErrorDescription]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'GG 10/30/2023 20:12:18'!
forCatalogue: aCatalogue 
	
	^self new initializeWithCatalogue: aCatalogue! !


!Cart class methodsFor: 'error messages' stamp: 'GG 10/30/2023 20:18:36'!
bookNotAvailableErrorDescription

	^'Book is not included in catalogue!!'! !

!Cart class methodsFor: 'error messages' stamp: 'GG 10/30/2023 20:43:22'!
ocurrencesOfBookNotPositiveErrorDescription

	^ 'Number of ocurrences must be positive!!'! !
