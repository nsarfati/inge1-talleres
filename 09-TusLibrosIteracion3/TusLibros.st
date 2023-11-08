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


!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:43:10'!
test01CartWithValidCredentialsIsCreatedEmpty

	| interface cartId cartElements |

	interface := self internalInterfaceWithSuccessfullyAuthenticator.

	cartId := interface createCartForClientId: '123' andPassword: 'password'.

	cartElements := interface listCartForId: cartId.

	self assert: cartElements isEmpty! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:52:05'!
test02CantCreateACartWithInvalidCredentials

	| interface |
	
	interface := self internalInterfaceWithInvalidCredentialsAuthenticator.

	self
		should: [interface createCartForClientId: '123' andPassword: 'password']
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | self assert: anError messageText = AuthenticatorSimulator invalidCredentialsErrorMessage]! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:41:22'!
test03AddingAValidBookToEmptyCart

	| interface cartId cartElements |

	interface := self internalInterfaceWithSuccessfullyAuthenticator.

	cartId := interface createCartForClientId: '123' andPassword: 'password'.

	interface addBook: 'validBook' quantity: 1 toCart: cartId.

	cartElements := interface listCartForId: cartId.

	self assert: cartElements size equals: 1.
	self assert: (cartElements occurrencesOf: 'validBook') equals: 1! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:41:17'!
test04CantAddABookNotIncludedInCatalog

	| interface cartId cartElements |
		
	interface := self internalInterfaceWithSuccessfullyAuthenticator.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	
	self should: [	interface addBook: 'invalidBook' quantity: 1 toCart: cartId.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | self assert: anError messageText = Cart invalidItemErrorMessage].
		
	cartElements := interface listCartForId: cartId.
	self assert: cartElements size equals: 0.
	
! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:41:11'!
test05BooksAddedToCartAreListedCorrectly

	| interface cartId cartElements |
		
	interface := self internalInterfaceWithSuccessfullyAuthenticator.

	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	interface addBook: 'validBook' quantity: 3 toCart: cartId.
	interface addBook: 'anotherValidBook' quantity: 2 toCart: cartId.
	interface addBook: 'validBook3' quantity: 1 toCart: cartId.

	cartElements := interface listCartForId: cartId.
	self assert: cartElements size equals: 6.
	self assert: (cartElements occurrencesOf: 'validBook') equals: 3.
	self assert: (cartElements occurrencesOf: 'anotherValidBook') equals: 2.
	self assert: (cartElements occurrencesOf: 'validBook3') equals: 1! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:41:06'!
test06CantCheckoutAnEmptyCart

	| interface cartId purchases |
	
	interface := self internalInterfaceWithSuccessfullyAuthenticator.
	
	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	
	self should: [		interface checkoutCart: cartId
							fromCreditCardNumber: '1234123412341234' 
							withExpirationDate: (storeObjectsFactory nextYear)
							andName: 'Geronimo'
	] raise: Error - MessageNotUnderstood
	  withExceptionDo: [:anError | self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage].
		
	purchases := interface listPurchasesForClientId: '123' andPassword: 'password'.
	self assert: purchases books isEmpty.
	self assert: purchases total equals: 0.! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:28:13'!
test07CantCheckoutWithAnExpiredCard

	| interface cartId purchases |
		
	interface := InternalInterface
			forAuthenticator: (storeObjectsFactory successfullyAuthenticator)
			catalog: (storeObjectsFactory catalogWithThreeBooks)
			andMerchantProcessor: (storeObjectsFactory successDebitMp).

	cartId := interface createCartForClientId: '123' andPassword: 'password'.
	interface addBook: 'validBook' quantity: 1 toCart: cartId.

	self should: [		interface checkoutCart: cartId
					    fromCreditCardNumber: '1234123412341234'
					    withExpirationDate: (storeObjectsFactory pastYear)
					    andName: 'Geronimo'
	]
	raise: Error - MessageNotUnderstood
	withExceptionDo: [:anError | self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage].
		
	purchases := interface listPurchasesForClientId: '123' andPassword: 'password'.
	self assert: purchases books isEmpty.
	self assert: purchases total equals: 0! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:48:52'!
test08CheckOutACartWithOneBook

	| interface cartId purchases |
		
	interface := self internalInterfaceWithSuccessfullyAuthenticator.

	cartId := interface createCartForClientId: '124' andPassword: 'password'.
	interface addBook: 'validBook' quantity: 1 toCart: cartId.
		
	interface checkoutCart: cartId
				    fromCreditCardNumber: '1234123412341234'
				    withExpirationDate: (storeObjectsFactory nextYear)
				    andName: 'Nicolas'.

	purchases := interface listPurchasesForClientId: '124' andPassword: 'password'.

	self assert: (purchases books size) equals: 1.
	self assert: (purchases books occurrencesOf: 'validBook') equals: 1.
	self assert: purchases total equals: 10
	
! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:49:21'!
test09ListPurchasesOfAClientWhoHasntCheckoutIsEmpty

	| interface purchases |
	
	interface := self internalInterfaceWithSuccessfullyAuthenticator.

	purchases := interface listPurchasesForClientId: '123' andPassword: 'password'.
	self assert: purchases books isEmpty.
	self assert: purchases total equals: 0
	
! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:50:09'!
test10ListPurchasesOfCartCheckedOutListTheCartBooks

	| interface cartId purchases |
	
	interface := self internalInterfaceWithSuccessfullyAuthenticator.

	cartId := interface createCartForClientId: '128' andPassword: 'password'.

	interface addBook: 'validBook' quantity: 3 toCart: cartId.
	interface addBook: 'anotherValidBook' quantity: 2 toCart: cartId.
	interface addBook: 'validBook3' quantity: 1 toCart: cartId.

	interface checkoutCart: cartId
			    fromCreditCardNumber: '1234123412341234'
			    withExpirationDate: (storeObjectsFactory nextYear)
			    andName: 'Nicolas'.

	purchases := interface listPurchasesForClientId: '128' andPassword: 'password'.

	self assert: purchases books size equals: 6.
	self assert: (purchases books occurrencesOf: 'validBook') equals: 3.
	self assert: (purchases books occurrencesOf: 'anotherValidBook') equals: 2.
	self assert: (purchases books occurrencesOf: 'validBook3') equals: 1.
	self assert: purchases total equals: 440! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 20:53:06'!
test11CantListPurchasesWithInvalidCredentials

	| interface |
	
	interface := self internalInterfaceWithInvalidCredentialsAuthenticator.	

	self
		should: [	interface listPurchasesForClientId: '128' andPassword: 'password']
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | self assert: anError messageText = AuthenticatorSimulator invalidCredentialsErrorMessage]! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'NMS 11/7/2023 21:17:25'!
test12TestExtraToTestGeneralCase

	| interface firstCartOfClient1 secondCartOfClient1 cartOfClient2 cartOfClient3 |
	
	interface := self internalInterfaceWithSuccessfullyAuthenticator.

	firstCartOfClient1 := interface createCartForClientId: '1' andPassword: 'password'.
	secondCartOfClient1 := interface createCartForClientId: '1' andPassword: 'password'.

	cartOfClient2 := interface createCartForClientId: '2' andPassword: 'password'.
	cartOfClient3 := interface createCartForClientId: '3' andPassword: 'password'.
	
	self checkoutFirstClientWithCartId: firstCartOfClient1 andCartId: secondCartOfClient1 onInternalInterface: interface.
	self checkoutSecondClientWithCartId: cartOfClient2 inInternalInterface: interface.
	self checkoutThirdClientWithCartId: cartOfClient3 inInternalInterface: interface.

	self assertPurchasesOfFirstClientOn: interface.
	self assertPurchasesOfSecondClientOn: interface.
	self assertPurchasesOfThirdClientOn: interface.! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 17:32:25'!
test98CheckoutConTarjetaRobada

	! !

!InternalInterfaceTest methodsFor: 'tests' stamp: 'GG 11/7/2023 17:32:32'!
test99CheckoutConTarjetaSinCredito
! !


!InternalInterfaceTest methodsFor: 'internal interface' stamp: 'NMS 11/7/2023 20:42:48'!
internalInterfaceWithInvalidCredentialsAuthenticator
	^InternalInterface
		forAuthenticator: (storeObjectsFactory invalidCredentialsAuthenticator)
		catalog: (storeObjectsFactory defaultCatalog)
		andMerchantProcessor: (storeObjectsFactory successDebitMp)! !

!InternalInterfaceTest methodsFor: 'internal interface' stamp: 'NMS 11/7/2023 20:40:30'!
internalInterfaceWithSuccessfullyAuthenticator
	^InternalInterface
		forAuthenticator: (storeObjectsFactory successfullyAuthenticator)
		catalog: (storeObjectsFactory catalogWithThreeBooks)
		andMerchantProcessor: (storeObjectsFactory successDebitMp).
! !


!InternalInterfaceTest methodsFor: 'general test - auxiliars' stamp: 'NMS 11/7/2023 21:15:22'!
assertPurchasesOfFirstClientOn: anInternalinterface 
	| purchasesOfClient1 |
	purchasesOfClient1 := anInternalinterface listPurchasesForClientId: '1' andPassword: 'password'.

	self assert: purchasesOfClient1 books size equals: 9.
	self assert: (purchasesOfClient1 books occurrencesOf: 'validBook') equals: 4.
	self assert: (purchasesOfClient1 books occurrencesOf: 'anotherValidBook') equals: 4.
	self assert: (purchasesOfClient1 books occurrencesOf: 'validBook3') equals: 1.
	self assert: purchasesOfClient1 total equals: 850.
! !

!InternalInterfaceTest methodsFor: 'general test - auxiliars' stamp: 'NMS 11/7/2023 21:16:15'!
assertPurchasesOfSecondClientOn: anInternalinterface 

	| purchasesOfClient2 |
	
	purchasesOfClient2 := anInternalinterface listPurchasesForClientId: '2' andPassword: 'password'.

	self assert: purchasesOfClient2 books size equals: 18.
	self assert: (purchasesOfClient2 books occurrencesOf: 'anotherValidBook') equals: 3.
	self assert: (purchasesOfClient2 books occurrencesOf: 'validBook3') equals: 15.
	self assert: purchasesOfClient2 total equals: 750.
! !

!InternalInterfaceTest methodsFor: 'general test - auxiliars' stamp: 'NMS 11/7/2023 21:16:52'!
assertPurchasesOfThirdClientOn: anInternalinterface 
	
	| purchasesOfClient3 |
	
	purchasesOfClient3 := anInternalinterface listPurchasesForClientId: '3' andPassword: 'password'.
	
	self assert: purchasesOfClient3 books size equals: 8.
	self assert: (purchasesOfClient3 books occurrencesOf: 'anotherValidBook') equals: 3.
	self assert: (purchasesOfClient3 books occurrencesOf: 'validBook3') equals: 5.
	self assert: purchasesOfClient3 total equals: 650! !

!InternalInterfaceTest methodsFor: 'general test - auxiliars' stamp: 'NMS 11/7/2023 21:12:16'!
checkoutFirstClientWithCartId: aCartId1 andCartId: aCartId2 onInternalInterface: anInternalInterface

	anInternalInterface addBook: 'validBook' quantity: 3 toCart: aCartId1.
	anInternalInterface addBook: 'anotherValidBook' quantity: 2 toCart: aCartId1.
	anInternalInterface addBook: 'validBook3' quantity: 1 toCart: aCartId1.

	anInternalInterface addBook: 'validBook' quantity: 1 toCart: aCartId2.
	anInternalInterface addBook: 'anotherValidBook' quantity: 2 toCart: aCartId2.

	anInternalInterface checkoutCart: aCartId1
			    fromCreditCardNumber: '1234123412341234'
			    withExpirationDate: (storeObjectsFactory nextYear)
			    andName: 'Cliente 1'.

	anInternalInterface checkoutCart: aCartId2
			    fromCreditCardNumber: '1234123412341234'
			    withExpirationDate: (storeObjectsFactory nextYear)
			    andName: 'Cliente 1'! !

!InternalInterfaceTest methodsFor: 'general test - auxiliars' stamp: 'NMS 11/7/2023 21:10:46'!
checkoutSecondClientWithCartId: aCartId inInternalInterface: anInternalInterface 
	
	anInternalInterface addBook: 'anotherValidBook' quantity: 3 toCart: aCartId.
	anInternalInterface addBook: 'validBook3' quantity: 15 toCart: aCartId.

	anInternalInterface checkoutCart: aCartId
			    fromCreditCardNumber: '1234123412341234'
			    withExpirationDate: (storeObjectsFactory nextYear)
			    andName: 'Cliente 2'.
! !

!InternalInterfaceTest methodsFor: 'general test - auxiliars' stamp: 'NMS 11/7/2023 21:13:26'!
checkoutThirdClientWithCartId: aCartId inInternalInterface: anInternalInterface 
	
	anInternalInterface addBook: 'anotherValidBook' quantity: 3 toCart: aCartId.
	anInternalInterface addBook: 'validBook3' quantity: 5 toCart: aCartId.

	anInternalInterface checkoutCart: aCartId
			    fromCreditCardNumber: '1234123412341234'
			    withExpirationDate: (storeObjectsFactory nextYear)
			    andName: 'Cliente 3'.! !


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

!Cashier methodsFor: 'checkout - private' stamp: 'NMS 11/7/2023 20:05:48'!
createSale

	^ Sale of: total withBooks: cart items
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
	instanceVariableNames: 'authenticator catalog carts nextAvailableCartId merchantProcessor salesByClientId clientIdByCart'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!InternalInterface methodsFor: 'initialization' stamp: 'NMS 11/7/2023 20:00:14'!
initializeForAuthenticator: anAuthenticator catalog: aCatalog andMerchantProcessor: aMerchantProcessor

	authenticator := anAuthenticator.
	catalog := aCatalog.
	carts := Dictionary new.
	clientIdByCart := Dictionary new.
	salesByClientId := Dictionary new.
	merchantProcessor := aMerchantProcessor.
	nextAvailableCartId := 1! !


!InternalInterface methodsFor: 'cart management' stamp: 'GG 11/6/2023 21:21:00'!
addBook: aBook quantity: aQuantity toCart: aCartId 

	(carts at: aCartId) add: aQuantity of: aBook! !

!InternalInterface methodsFor: 'cart management' stamp: 'NMS 11/7/2023 19:56:34'!
createCartForClientId: aClientId andPassword: aPassword 

	| cartId |

	authenticator authenticateClientId: aClientId forPassword: aPassword.
	carts at: nextAvailableCartId put: (Cart acceptingItemsOf: catalog).

	cartId := nextAvailableCartId.
	nextAvailableCartId := nextAvailableCartId + 1.

	clientIdByCart at: cartId put: aClientId.

	^cartId! !

!InternalInterface methodsFor: 'cart management' stamp: 'GG 11/6/2023 21:36:50'!
listCartForId: aCartId 
	
	^ (carts at: aCartId) items! !


!InternalInterface methodsFor: 'checkout' stamp: 'NMS 11/7/2023 20:00:43'!
checkoutCart: aCartId fromCreditCardNumber: aCreditCardNumber withExpirationDate: anExpirationDate andName: aClientName 

	| creditCard cart cashier salesBook |
	creditCard := CreditCard expiringOn: anExpirationDate. 
	cart := carts at: aCartId.

	salesBook := salesByClientId at: (clientIdByCart at: aCartId) ifAbsentPut: [OrderedCollection new].

	cashier := Cashier toCheckout: cart charging: creditCard throught: merchantProcessor 
				on: (Date today) registeringOn: salesBook.

	^cashier checkOut! !


!InternalInterface methodsFor: 'purchase listing' stamp: 'NMS 11/7/2023 20:46:33'!
calculateSalesOfAClientId: aClientId 
	| total aBag |
	
	total := 0.
	aBag := Bag new.
	
	
	(salesByClientId at: aClientId) do: [:aSale |
		total := total + aSale total.
		aBag addAll: aSale books
	].

	^Sale of: total withBooks: aBag! !

!InternalInterface methodsFor: 'purchase listing' stamp: 'NMS 11/7/2023 20:52:41'!
listPurchasesForClientId: aClientId andPassword: aPassword

	authenticator authenticateClientId: aClientId forPassword: aPassword.

	(salesByClientId includesKey: aClientId) ifFalse: [^Sale of: 0 withBooks: Bag new].
	
	^self calculateSalesOfAClientId: aClientId! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InternalInterface class' category: 'TusLibros'!
InternalInterface class
	instanceVariableNames: ''!

!InternalInterface class methodsFor: 'instance creation' stamp: 'GG 11/7/2023 17:39:27'!
forAuthenticator: anAuthenticator catalog: aCatalog andMerchantProcessor: aMerchantProcessor

	^self new initializeForAuthenticator: anAuthenticator catalog: aCatalog andMerchantProcessor: aMerchantProcessor! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'accesing' stamp: 'NMS 11/7/2023 20:15:33'!
books
	^books! !

!Sale methodsFor: 'accesing' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

!Sale methodsFor: 'initialization' stamp: 'NMS 11/7/2023 20:02:40'!
initializeWithTotal: aTotal andSoldBooks: aBagOfBooks

	total := aTotal.
	books := aBagOfBooks! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !

!Sale class methodsFor: 'instance creation' stamp: 'NMS 11/7/2023 20:03:23'!
of: aTotal withBooks: aBagOfBooks

	"should assert total is not negative or 0!!"
	^self new initializeWithTotal: aTotal andSoldBooks: aBagOfBooks! !


!classDefinition: #Simulator category: 'TusLibros'!
Object subclass: #Simulator
	instanceVariableNames: 'behavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Simulator methodsFor: 'initialization' stamp: 'NMS 11/7/2023 20:36:43'!
initializeBehaving: aBehaviorClosure 
	
	behavior := aBehaviorClosure.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Simulator class' category: 'TusLibros'!
Simulator class
	instanceVariableNames: ''!

!Simulator class methodsFor: 'instance creation' stamp: 'NMS 11/7/2023 20:37:15'!
behaving: aBehaviorClosure

	^self new initializeBehaving: aBehaviorClosure ! !


!classDefinition: #AuthenticatorSimulator category: 'TusLibros'!
Simulator subclass: #AuthenticatorSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!AuthenticatorSimulator methodsFor: 'authenticate' stamp: 'GG 11/6/2023 20:33:54'!
authenticateClientId: aClientId forPassword: aPassword

	^ behavior value: aClientId value: aPassword! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AuthenticatorSimulator class' category: 'TusLibros'!
AuthenticatorSimulator class
	instanceVariableNames: ''!

!AuthenticatorSimulator class methodsFor: 'instance creation' stamp: 'GG 11/6/2023 20:36:50'!
invalidCredentialsErrorMessage

	^ 'Incorrect client ID or password !!'! !


!classDefinition: #MerchantProcessorSimulator category: 'TusLibros'!
Simulator subclass: #MerchantProcessorSimulator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MerchantProcessorSimulator methodsFor: 'debit' stamp: 'GG 11/7/2023 17:48:49'!
debit: anAmount from: aCreditCard 

	^behavior value: anAmount value: aCreditCard ! !


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


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'NMS 11/7/2023 20:26:12'!
nextYear
	^(Month month: Date today monthIndex year: Date today yearNumber + 1)! !

!StoreTestObjectsFactory methodsFor: 'date' stamp: 'NMS 11/7/2023 20:28:40'!
pastYear
	^(Month month: Date today monthIndex year: Date today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!StoreTestObjectsFactory methodsFor: 'authenticator - simulator' stamp: 'NMS 11/7/2023 20:35:22'!
invalidCredentialsAuthenticator
	^AuthenticatorSimulator behaving: [:aClientId :aPassword | self error: AuthenticatorSimulator invalidCredentialsErrorMessage]! !

!StoreTestObjectsFactory methodsFor: 'authenticator - simulator' stamp: 'NMS 11/7/2023 20:35:22'!
successfullyAuthenticator
	^AuthenticatorSimulator behaving: [:aClientId :aPassword | ].
! !


!StoreTestObjectsFactory methodsFor: 'merchant processor - simulator' stamp: 'NMS 11/7/2023 20:35:33'!
successDebitMp
	^MerchantProcessorSimulator behaving: [:anAmount :aCreditCard | ]! !
