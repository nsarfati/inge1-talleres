!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:35'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: self itemSellByTheStore withOcurrences: 0  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:46'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add:  self itemNotSellByTheStore withOcurrences: 2  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HAW 11/2/2023 17:12:59'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore withOcurrences: 2.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !

!CartTest methodsFor: 'tests' stamp: 'NMS 11/2/2023 21:41:08'!
test09TotalCostIsZeroForAnEmptyCart
	self assert: self createCart totalCost equals: 0! !

!CartTest methodsFor: 'tests' stamp: 'NMS 11/2/2023 21:41:55'!
test10TotalCostForACartWithABookWithTwoOcurrences

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore withOcurrences: 2.
	self assert: cart totalCost equals: 200! !

!CartTest methodsFor: 'tests' stamp: 'NMS 11/2/2023 21:45:36'!
test11TotalCostGeneralCase

	| cart aCatalog |
	aCatalog := self defaultCatalog.
	aCatalog at: 'isbn1' put: 93.
	aCatalog at: 'isbn2' put: 15.

	cart := 	Cart acceptingItemsOf: aCatalog.

	cart add: self itemSellByTheStore withOcurrences: 2.
	cart add: 'isbn1' withOcurrences: 5.
	cart add: 'isbn2' withOcurrences: 3.

	self assert: cart totalCost equals: 710! !


!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!CartTest methodsFor: 'support' stamp: 'NMS 11/2/2023 21:37:15'!
defaultCatalog
	| aCatalogue |
	aCatalogue := Dictionary new.
	aCatalogue at: self itemSellByTheStore put: 100.

	^aCatalogue! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!CartTest methodsFor: 'support' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:31:01'!
test01CanNotCheckoutAnEmptyCart	
	self 
		should: [ Cashier
				for: (Cart acceptingItemsOf: self catalog)
				from: (self aNotExpiredCard)
				andDate: Date today
				forMerchantProcessor: self merchantProcessor
		]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier canNotCreateACashierForAnEmptyCartError
		]! !

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:31:36'!
test02CheckoutACartWithOneBook
	
	| aCashier aCart |

	aCart := Cart acceptingItemsOf: self catalog.
	aCart add: 'isbn1' withOcurrences: 1.
	aCashier := Cashier
					for: aCart
					from: self aNotExpiredCard
					andDate: Date today
					forMerchantProcessor: self merchantProcessor.

	self assert: (aCashier checkout) equals: 100! !

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:31:55'!
test03CheckoutACartWithSameBookTwice

	| aCashier aCart |

	aCart := Cart acceptingItemsOf: self catalog.
	aCart add: 'isbn1' withOcurrences: 2.
	aCashier := Cashier
				for: aCart
				from: self aNotExpiredCard
				andDate: Date today
				forMerchantProcessor: self merchantProcessor.

	self assert: (aCashier checkout) equals: 200! !

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:33:45'!
test04CheckoutACartWithManyBooks

	| aCashier aCart |

	aCart := Cart acceptingItemsOf: self catalog.
	aCart add: 'isbn1' withOcurrences: 2.
	aCart add: 'isbn3' withOcurrences: 5.
	aCashier := Cashier
				for: aCart
				from: self aNotExpiredCard
				andDate: Date today
				forMerchantProcessor: self merchantProcessor.

	self assert: (aCashier checkout) equals: 4555! !

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:34:02'!
test05CheckoutWithExpiredCreditCard

	| aCart |

	aCart := Cart acceptingItemsOf: (self catalog).
	aCart add: 'isbn1' withOcurrences: 2.
	aCart add: 'isbn3' withOcurrences: 5.

	self 
		should: [ Cashier
					for: aCart
					from: self expiredCard
					andDate: Date today
					forMerchantProcessor: self merchantProcessor.
		]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier canNotCreateACashierWithExpiredCard
		]
! !

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:49:45'!
test06CanNotcheckoutFromAnStolenCard
	
	| aCashier aCart aMerchantProcessor |

	aMerchantProcessor := self merchantProcessor.

	aCart := Cart acceptingItemsOf: self catalog.
	aCart add: 'isbn1' withOcurrences: 1.
	aCashier := Cashier
				for: aCart
				from: self anStolenCard
				andDate: Date today
				forMerchantProcessor: aMerchantProcessor.

	self 
		should: [ aCashier checkout ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = aMerchantProcessor canNotDebitFromAnStolenCard.
			self assert: aCashier transactionId isEmpty
		]! !

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:53:57'!
test07CanNotcheckoutFromACardWithoutCredit
	
	| aCashier aCart aMerchantProcessor |

	aMerchantProcessor := self merchantProcessor.

	aCart := Cart acceptingItemsOf: self catalog.
	aCart add: 'isbn1' withOcurrences: 1.
	aCashier := Cashier
				for: aCart
				from: self aCardWithoutCredit
				andDate: Date today
				forMerchantProcessor: aMerchantProcessor.

	self 
		should: [ aCashier checkout ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = aMerchantProcessor canNotDebitFromACardWithoutCredit.
			self assert: aCashier transactionId isEmpty
		]! !

!CashierTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:59:59'!
test08CheckoutAndDebitFromAValidCard
	
	| aCashier aCart aMerchantProcessor |

	aMerchantProcessor := self merchantProcessor.

	aCart := Cart acceptingItemsOf: self catalog.
	aCart add: 'isbn1' withOcurrences: 1.
	aCashier := Cashier
				for: aCart
				from: self aNotExpiredCard
				andDate: Date today
				forMerchantProcessor: aMerchantProcessor.

	self assert: aCashier checkout equals: 100.
	self assert: aCashier transactionId equals: 'id1'! !


!CashierTest methodsFor: 'support' stamp: 'NMS 11/3/2023 13:52:04'!
aCardWithoutCredit
	| aMonthOfYearInTheFuture |
	aMonthOfYearInTheFuture := GregorianMonthOfYear year: ((Date today yearNumber) + 3) monthNumber: (Date today monthIndex).

	^CreditCard
		for: 'A Valid Name'
		withExpirationMonthOfYear: aMonthOfYearInTheFuture
		andDigits: '1111888877772231' ! !

!CashierTest methodsFor: 'support' stamp: 'NMS 11/3/2023 12:33:44'!
aNotExpiredCard
	| aMonthOfYearInTheFuture |
	aMonthOfYearInTheFuture := GregorianMonthOfYear year: ((Date today yearNumber) + 3) monthNumber: (Date today monthIndex).

	^CreditCard
		for: 'A Valid Name'
		withExpirationMonthOfYear: aMonthOfYearInTheFuture
		andDigits: '4444888877772231' ! !

!CashierTest methodsFor: 'support' stamp: 'NMS 11/3/2023 13:37:13'!
anStolenCard
	| aMonthOfYearInTheFuture |
	aMonthOfYearInTheFuture := GregorianMonthOfYear year: ((Date today yearNumber) + 3) monthNumber: (Date today monthIndex).

	^CreditCard
		for: 'A Valid Name'
		withExpirationMonthOfYear: aMonthOfYearInTheFuture
		andDigits: '6666888877772231' ! !

!CashierTest methodsFor: 'support' stamp: 'NMS 11/2/2023 21:53:39'!
catalog
	| aCatalogue |
	aCatalogue := Dictionary new.
	aCatalogue at: 'isbn1' put: 100.
	aCatalogue at: 'isbn2' put: 66.
	aCatalogue at: 'isbn3' put: 871.

	^aCatalogue! !

!CashierTest methodsFor: 'support' stamp: 'NMS 11/3/2023 12:39:39'!
expiredCard
	| aMonthOfYearInTheFuture |
	aMonthOfYearInTheFuture := GregorianMonthOfYear year: ((Date today yearNumber) - 3) monthNumber: (Date today monthIndex).

	^CreditCard
		for: 'A Valid Name'
		withExpirationMonthOfYear: aMonthOfYearInTheFuture
		andDigits: '4444888877772231' ! !

!CashierTest methodsFor: 'support' stamp: 'NMS 11/3/2023 13:30:20'!
merchantProcessor
	^MPInterface new.
! !


!classDefinition: #CreditCardTest category: 'TusLibros'!
TestCase subclass: #CreditCardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCardTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 12:32:03'!
test01CreditCardDetectsWhenIsNotExpired
	| aNotExpiredCard aMonthOfYearInTheFuture |

	aMonthOfYearInTheFuture := GregorianMonthOfYear year: ((Date today yearNumber) + 3) monthNumber: (Date today monthIndex).

	aNotExpiredCard := CreditCard
						for: 'A Valid Name'
						withExpirationMonthOfYear: aMonthOfYearInTheFuture
						andDigits: '4444888877772231'.

	self deny: (aNotExpiredCard isExpired: Date today)! !

!CreditCardTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 12:32:21'!
test02CreditCardDetectsWhenIsExpired
	| anExpiredCard aMonthOfYearInThePast |

	aMonthOfYearInThePast := GregorianMonthOfYear year: ((Date today yearNumber) - 3) monthNumber: (Date today monthIndex).

	anExpiredCard := CreditCard
						for: 'A Valid Name'
						withExpirationMonthOfYear: aMonthOfYearInThePast
						andDigits: '4444888877772231'.

	self assert: (anExpiredCard isExpired: Date today)! !

!CreditCardTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 12:46:46'!
test03CanNotCreateACardWithoutAName
	| aMonthOfYearInTheFuture |

	aMonthOfYearInTheFuture := GregorianMonthOfYear year: ((Date today yearNumber) + 3) monthNumber: (Date today monthIndex).

	self 
		should: [ CreditCard
						for: ''
						withExpirationMonthOfYear: aMonthOfYearInTheFuture
						andDigits: '4444888877772231'
		]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = CreditCard canNotCreateACardWithoutAName
		]! !

!CreditCardTest methodsFor: 'testing' stamp: 'NMS 11/3/2023 12:47:04'!
test04CanNotCreateACardWithInvalidAmountOfDigits
	| aMonthOfYearInTheFuture |

	aMonthOfYearInTheFuture := GregorianMonthOfYear year: ((Date today yearNumber) + 3) monthNumber: (Date today monthIndex).

	self 
		should: [ CreditCard
						for: 'A valid Name'
						withExpirationMonthOfYear: aMonthOfYearInTheFuture
						andDigits: '4472231'
		]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = CreditCard canNotCreateACardWithAnAmountOfDigitsDifferentToSixteen 
		]! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 'NMS 11/2/2023 21:39:41'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'NMS 11/2/2023 19:47:19'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := Bag new.! !


!Cart methodsFor: 'queries' stamp: 'NMS 11/2/2023 19:44:18'!
items
	^items copy! !

!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !

!Cart methodsFor: 'queries' stamp: 'NMS 11/2/2023 21:32:36'!
totalCost
	^items inject: 0 into: [:aPartialCost :aBook |
		aPartialCost + (catalog at: aBook)
	]! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HAW 11/2/2023 17:13:30'!
add: anItem

	^ self add: anItem withOcurrences: 1 ! !

!Cart methodsFor: 'adding' stamp: 'HAW 11/2/2023 17:13:19'!
add: anItem withOcurrences: aQuantity

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity .
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart creditCard merchantProcessor transactionId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 'NMS 11/3/2023 13:59:33'!
initializeFor: aCart andCreditCard: aCreditCard andMerchantProcessor: aMerchantProcessor
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	transactionId := ''
	! !


!Cashier methodsFor: 'checkout' stamp: 'NMS 11/3/2023 13:59:11'!
checkout
	transactionId := merchantProcessor debit: (cart totalCost) from: creditCard.
	^cart totalCost! !


!Cashier methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:59:22'!
transactionId
	^transactionId! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'error messages' stamp: 'NMS 11/3/2023 11:51:34'!
canNotCreateACashierForAnEmptyCartError
	^'Can not create a Cashier with an empty cart!!'! !

!Cashier class methodsFor: 'error messages' stamp: 'NMS 11/3/2023 11:51:44'!
canNotCreateACashierWithExpiredCard
	^'Can not create a Cashier with expired card!!'! !


!Cashier class methodsFor: 'instance creation' stamp: 'NMS 11/3/2023 11:50:39'!
assertCartIsEmpty: aCart

	^ (aCart isEmpty) ifTrue: [self error: self canNotCreateACashierForAnEmptyCartError]! !

!Cashier class methodsFor: 'instance creation' stamp: 'NMS 11/3/2023 12:41:56'!
assertCreditCardIsNotExpired: aCreditCard andDate: aDate

	^ (aCreditCard isExpired: aDate) ifTrue: [ self error: self canNotCreateACashierWithExpiredCard ]! !

!Cashier class methodsFor: 'instance creation' stamp: 'NMS 11/3/2023 13:21:36'!
for: aCart from: aCreditCard andDate: aDate forMerchantProcessor: aMerchantProcessor
	self assertCartIsEmpty: aCart.
	self assertCreditCardIsNotExpired: aCreditCard andDate: aDate.
	^self new initializeFor: aCart andCreditCard: aCreditCard andMerchantProcessor: aMerchantProcessor ! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'ownerName expirationDate number'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'NMS 11/3/2023 12:28:21'!
isExpired: aDate
	| aMonthOfYearOfDate |
	aMonthOfYearOfDate := GregorianMonthOfYear year: (aDate yearNumber) monthNumber: (aDate monthIndex).
	^expirationDate < aMonthOfYearOfDate! !

!CreditCard methodsFor: 'testing' stamp: 'NMS 11/3/2023 13:40:22'!
number
	^number! !


!CreditCard methodsFor: 'initialization' stamp: 'NMS 11/3/2023 12:22:50'!
initializeWithAName: aName expirationMonthOfYear: aMonthOfYear andDigits: aCreditCardNumber
	ownerName := aName.
	expirationDate := aMonthOfYear.
	number := aCreditCardNumber! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'error messages' stamp: 'NMS 11/3/2023 12:46:14'!
canNotCreateACardWithAnAmountOfDigitsDifferentToSixteen
	^'Can not create a card when amount of digits is different to sixteen'! !

!CreditCard class methodsFor: 'error messages' stamp: 'NMS 11/3/2023 12:43:43'!
canNotCreateACardWithoutAName
	^'Can not create a card without a name'! !


!CreditCard class methodsFor: 'instance creation' stamp: 'NMS 11/3/2023 12:48:08'!
assertAmountOfDigitsIsSixteen: aCreditCardNumber
	^ (aCreditCardNumber size = 16) ifFalse: [ self error: self canNotCreateACardWithAnAmountOfDigitsDifferentToSixteen ]! !

!CreditCard class methodsFor: 'instance creation' stamp: 'NMS 11/3/2023 12:48:05'!
assertCreditCardNameNotEmpty: aName
	^ (aName isEmpty) ifTrue: [ self error: self canNotCreateACardWithoutAName ]! !

!CreditCard class methodsFor: 'instance creation' stamp: 'NMS 11/3/2023 12:48:01'!
for: aName withExpirationMonthOfYear: aMonthOfYear andDigits: aCreditCardNumber
	self assertCreditCardNameNotEmpty: aName.
	self assertAmountOfDigitsIsSixteen: aCreditCardNumber.
	^self new initializeWithAName: aName expirationMonthOfYear: aMonthOfYear andDigits: aCreditCardNumber! !


!classDefinition: #MPInterface category: 'TusLibros'!
Object subclass: #MPInterface
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MPInterface methodsFor: 'card assertion' stamp: 'NMS 11/3/2023 13:53:31'!
assertCardHasCredit: aCreditCard
	(aCreditCard number = '1111888877772231') ifTrue: [ self error: self canNotDebitFromACardWithoutCredit ]! !

!MPInterface methodsFor: 'card assertion' stamp: 'NMS 11/3/2023 13:45:09'!
assertCardNotStolen: aCreditCard
	(aCreditCard number = '6666888877772231') ifTrue: [ self error: self canNotDebitFromAnStolenCard ]! !


!MPInterface methodsFor: 'debit' stamp: 'NMS 11/3/2023 13:58:53'!
debit: anAmountToDebit from: aCreditCard
	self assertCardNotStolen: aCreditCard.
	self assertCardHasCredit: aCreditCard.
	^'id1'! !


!MPInterface methodsFor: 'error messages' stamp: 'NMS 11/3/2023 13:53:45'!
canNotDebitFromACardWithoutCredit
	^'Can not debit from a card without credit'! !

!MPInterface methodsFor: 'error messages' stamp: 'NMS 11/3/2023 13:41:38'!
canNotDebitFromAnStolenCard
	^'Can not debit from an stolen card'! !
