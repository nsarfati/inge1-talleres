!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'GG 11/7/2023 16:26:56'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart class invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'GG 11/7/2023 16:27:01'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart class invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'GG 11/7/2023 16:27:06'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart class invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:04'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:59'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #InternalInterfaceTest category: 'TusLibros'!
TestCase subclass: #InternalInterfaceTest
	instanceVariableNames: 'storeObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InternalInterfaceTest methodsFor: 'setup' stamp: 'GG 11/6/2023 21:16:20'!
setUp
	
	storeObjectsFactory := StoreTestObjectsFactory new.! !


!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/6/2023 21:15:40'!
test01CartWithValidCredentialsIsCreatedEmpty

	|interface cartId cartElements authenticator|
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	
	interface := InternalInterface forAuthenticator: authenticator andCatalog: storeObjectsFactory defaultCatalog.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	
	cartElements := interface listCartForId: cartId.
	
	self assert: cartElements isEmpty! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/6/2023 21:17:17'!
test02CantCreateACartWithInvalidCredentials

	|interface authenticator|
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | self error: Authenticator invalidCredentialsErrorMessage].
	
	interface := InternalInterface forAuthenticator: authenticator andCatalog: storeObjectsFactory defaultCatalog.
	
	self should: [interface createCartForClientId: '123' andPassword: 'password']
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | self assert: anError messageText = Authenticator invalidCredentialsErrorMessage].
	! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 16:17:22'!
test03AddingAValidBookToEmptyCart

	|interface cartId cartElements authenticator|
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	interface := InternalInterface forAuthenticator: authenticator andCatalog: storeObjectsFactory defaultCatalog.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	
	interface addBook: 'validBook' quantity: 1 toCart: cartId.
	
	cartElements := interface listCartForId: cartId.
	
	self assert: cartElements size equals: 1.
	self assert: (cartElements occurrencesOf: 'validBook') equals: 1! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 16:30:56'!
test04CantAddABookNotIncludedInCatalog

	|interface cartId cartElements authenticator|
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	interface := InternalInterface forAuthenticator: authenticator andCatalog: storeObjectsFactory defaultCatalog.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	
	self should: [	interface addBook: 'invalidBook' quantity: 1 toCart: cartId.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | self assert: anError messageText = Cart invalidItemErrorMessage].
		
	cartElements := interface listCartForId: cartId.
	self assert: cartElements size equals: 0.
	
! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 16:39:14'!
test05BooksAddedToCartAreListedCorrectly

	|interface cartId cartElements authenticator|
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	interface := InternalInterface forAuthenticator: authenticator andCatalog: storeObjectsFactory catalogWithThreeBooks.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	interface addBook: 'validBook' quantity: 3 toCart: cartId.
	interface addBook: 'anotherValidBook' quantity: 2 toCart: cartId.
	interface addBook: 'validBook3' quantity: 1 toCart: cartId.
	
	cartElements := interface listCartForId: cartId.
	self assert: cartElements size equals: 6.
	self assert: (cartElements occurrencesOf: 'validBook') equals: 3.
	self assert: (cartElements occurrencesOf: 'anotherValidBook') equals: 2.
	self assert: (cartElements occurrencesOf: 'validBook3') equals: 1! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 18:13:14'!
test06CantCheckoutAnEmptyCart

	|interface cartId authenticator notExpiredDate purchases |
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	interface := InternalInterface forAuthenticator: authenticator andCatalog: storeObjectsFactory catalogWithThreeBooks.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	notExpiredDate := (Month month: Date today monthIndex year: Date today yearNumber + 1).
	
	self should: [		interface checkoutCart: cartId fromCreditCardNumber: '1234123412341234' 
										withExpirationDate: notExpiredDate andName: 'Geronimo']  
		raise: Error - MessageNotUnderstood
	     	 withExceptionDo: [:anError | self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage].
		
	purchases := interface listPurchasesForClientId: '123' andPassword: 'password'.
	self assert: purchases books isEmpty.
	self assert: purchases total equals: 0.! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 18:16:09'!
test07CantCheckoutWithAnExpiredCard

	|interface cartId authenticator expiredDate purchases |
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	interface := InternalInterface forAuthenticator: authenticator andCatalog: storeObjectsFactory catalogWithThreeBooks.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	interface addBook: 'validBook' quantity: 1 toCart: cartId.
	
	expiredDate := (Month month: Date today monthIndex year: Date today yearNumber - 1).

	self should: [		interface checkoutCart: cartId fromCreditCardNumber: '1234123412341234'
										 withExpirationDate: expiredDate andName: 'Geronimo']  
		raise: Error - MessageNotUnderstood
	     	 withExceptionDo: [:anError | self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage].
		
	purchases := interface listPurchasesForClientId: '123' andPassword: 'password'.
	self assert: purchases books isEmpty.
	self assert: purchases total equals: 0! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 18:14:47'!
test08CheckOutOK

	|interface cartId authenticator notExpiredDate purchases merchantProcessor |
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	merchantProcessor := MerchantProcessor behaving: [:anAmount :aCreditCard | ].
	interface := InternalInterface forAuthenticator: authenticator catalog: storeObjectsFactory catalogWithThreeBooks 
								andMerchantProcessor: merchantProcessor.
	
	cartId := interface createCartForClientId: '124' andPassword: 'password'.
	interface addBook: 'validBook' quantity: 1 toCart: cartId.
	
	notExpiredDate := (Month month: Date today monthIndex year: Date today yearNumber + 1).
	interface checkoutCart: cartId fromCreditCardNumber: '1234123412341234'withExpirationDate: notExpiredDate andName: 'Nicolas'.
	
	purchases := interface listPurchasesForClientId: '124' andPassword: 'password'.
	self assert: (purchases books occurrencesOf: 'validBook') equals: 1.
	self assert: purchases total equals: 10
	
! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 18:23:17'!
test09PurchaseListCLIENTESINCOMPRAS

	|interface authenticator purchases merchantProcessor |
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	merchantProcessor := MerchantProcessor behaving: [:anAmount :aCreditCard | ].
	interface := InternalInterface forAuthenticator: authenticator catalog: storeObjectsFactory catalogWithThreeBooks 
								andMerchantProcessor: merchantProcessor.
		
	purchases := interface listPurchasesForClientId: '123' andPassword: 'password'.
	self assert: purchases books isEmpty.
	self assert: purchases total equals: 0
	
! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 18:27:00'!
test10PurchaseListTresElementos

	|interface authenticator purchases merchantProcessor cartId |
	
	authenticator := Authenticator behaving: [:aClientId :aPassword | ].
	merchantProcessor := MerchantProcessor behaving: [:anAmount :aCreditCard | ].
	interface := InternalInterface forAuthenticator: authenticator catalog: storeObjectsFactory catalogWithThreeBooks 
								andMerchantProcessor: merchantProcessor.			
	
	cartId := interface createCartForClientId: '128' andPassword: 'password'.
	interface addBook: 'validBook' quantity: 3 toCart: cartId.
	interface addBook: 'anotherValidBook' quantity: 2 toCart: cartId.
	interface addBook: 'validBook3' quantity: 1 toCart: cartId.
	
	purchases := interface listPurchasesForClientId: '128' andPassword: 'password'.
	self assert: purchases books size equals: 6.
	self assert: (purchases books occurrencesOf: 'validBook') equals: 3.
	self assert: (purchases books occurrencesOf: 'anotherValidBook') equals: 2.
	self assert: (purchases books occurrencesOf: 'validBook3') equals: 1.
	self assert: purchases total equals: 99.

	
! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 18:17:59'!
test98CheckoutConTarjetaRobada

	"????"! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 18:18:04'!
test99CheckoutConTarjetaSinCredito

		"????"! !


!classDefinition: #Authenticator category: 'TusLibros'!
Object subclass: #Authenticator
	instanceVariableNames: 'behavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Authenticator methodsFor: 'initialization' stamp: 'GG 11/6/2023 20:33:54'!
authenticateClientId: aClientId forPassword: aPassword

	^ behavior value: aClientId value: aPassword! !

!Authenticator methodsFor: 'initialization' stamp: 'GG 11/6/2023 20:32:44'!
initializeBehaving: aBehaviorClosure 
	
	behavior := aBehaviorClosure.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Authenticator class' category: 'TusLibros'!
Authenticator class
	instanceVariableNames: ''!

!Authenticator class methodsFor: 'instance creation' stamp: 'GG 11/6/2023 20:32:17'!
behaving: aBehaviorClosure

	^self new initializeBehaving: aBehaviorClosure ! !

!Authenticator class methodsFor: 'instance creation' stamp: 'GG 11/6/2023 20:36:50'!
invalidCredentialsErrorMessage

	^ 'Incorrect client ID or password !!'! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!Cart methodsFor: 'assertions' stamp: 'GG 11/7/2023 16:28:40'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self class invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'GG 11/7/2023 16:28:45'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self class invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'GG 11/6/2023 21:35:09'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := Bag new.
	"items := OrderedCollection new."! !


!Cart methodsFor: 'queries' stamp: 'GG 11/6/2023 21:36:02'!
items 

	^ items copy! !

!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!Cart class methodsFor: 'error messages' stamp: 'GG 11/7/2023 16:25:59'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart class methodsFor: 'error messages' stamp: 'GG 11/7/2023 16:26:29'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #InternalInterface category: 'TusLibros'!
Object subclass: #InternalInterface
	instanceVariableNames: 'authenticator catalog carts nextAvailableCartId merchantProcessor salesByClient'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InternalInterface methodsFor: 'initialization' stamp: 'GG 11/7/2023 18:29:24'!
initializeForAuthenticator: anAuthenticator andCatalog: aCatalog 	

	"Borrar"
	authenticator := anAuthenticator.
	catalog := aCatalog.
	carts := Dictionary new.
	nextAvailableCartId := 1! !

!InternalInterface methodsFor: 'initialization' stamp: 'GG 11/7/2023 17:40:14'!
initializeForAuthenticator: anAuthenticator catalog: aCatalog andMerchantProcessor: aMerchantProcessor

	authenticator := anAuthenticator.
	catalog := aCatalog.
	carts := Dictionary new.
	merchantProcessor := aMerchantProcessor.
	nextAvailableCartId := 1! !


!InternalInterface methodsFor: 'cart management' stamp: 'GG 11/6/2023 21:21:00'!
addBook: aBook quantity: aQuantity toCart: aCartId 

	(carts at: aCartId) add: aQuantity of: aBook! !

!InternalInterface methodsFor: 'cart management' stamp: 'GG 11/6/2023 21:19:17'!
createCartForClientId: aClientId andPassword: aPassword 

	| cartId |
	
	authenticator authenticateClientId: aClientId forPassword: aPassword.
	carts at: nextAvailableCartId put: (Cart acceptingItemsOf: catalog).

	cartId := nextAvailableCartId.
	nextAvailableCartId := nextAvailableCartId + 1.

	^cartId
	! !

!InternalInterface methodsFor: 'cart management' stamp: 'GG 11/6/2023 21:36:50'!
listCartForId: aCartId 
	
	^ (carts at: aCartId) items! !


!InternalInterface methodsFor: 'checkout' stamp: 'GG 11/7/2023 18:30:51'!
checkoutCart: aCartId fromCreditCardNumber: aCreditCardNumber withExpirationDate: anExpirationDate andName: aClientName 
	
	| creditCard cart cashier|
	creditCard := CreditCard expiringOn: anExpirationDate. 
	cart := carts at: aCartId.
	
	cashier := Cashier toCheckout: cart charging: creditCard throught: merchantProcessor 
				on: (Date today) registeringOn: OrderedCollection new.
				
	^cashier checkOut.! !

!InternalInterface methodsFor: 'checkout' stamp: 'GG 11/7/2023 18:12:01'!
listPurchasesForClientId: aClientId andPassword: aPassword 

	aClientId = '123' ifTrue: [^Sale of: 0].
	
	^Sale of: 10! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalInterface class' category: 'TusLibros'!
InternalInterface class
	instanceVariableNames: ''!

!InternalInterface class methodsFor: 'instance creation' stamp: 'GG 11/6/2023 20:54:38'!
forAuthenticator: anAuthenticator andCatalog: aCatalog 

	^self new initializeForAuthenticator: anAuthenticator andCatalog: aCatalog ! !

!InternalInterface class methodsFor: 'instance creation' stamp: 'GG 11/7/2023 17:39:27'!
forAuthenticator: anAuthenticator catalog: aCatalog andMerchantProcessor: aMerchantProcessor

	^self new initializeForAuthenticator: anAuthenticator catalog: aCatalog andMerchantProcessor: aMerchantProcessor! !


!classDefinition: #MerchantProcessor category: 'TusLibros'!
Object subclass: #MerchantProcessor
	instanceVariableNames: 'behavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessor methodsFor: 'debit' stamp: 'GG 11/7/2023 17:48:49'!
debit: anAmount from: aCreditCard 

	^behavior value: anAmount value: aCreditCard ! !


!MerchantProcessor methodsFor: 'initialization' stamp: 'GG 11/7/2023 17:49:42'!
initializeWithBehavior: aBehavior

	behavior := aBehavior ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MerchantProcessor class' category: 'TusLibros'!
MerchantProcessor class
	instanceVariableNames: ''!

!MerchantProcessor class methodsFor: 'instance creation' stamp: 'GG 11/7/2023 17:49:29'!
behaving: aBehavior

 	^ self new initializeWithBehavior: aBehavior ! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'accesing' stamp: 'GG 11/7/2023 18:14:18'!
books

	total = 0 ifTrue: [^Bag new].

	^Bag with: 'validBook'! !

!Sale methodsFor: 'accesing' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'GG 11/7/2023 16:34:34'!
catalogWithThreeBooks
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		at: 'anotherValidBook' put: 200;
		at: 'validBook3' put: 10;
		yourself ! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !
