!classDefinition: #FinancialAssetTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #FinancialAssetTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!FinancialAssetTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'NMS 10/11/2023 21:18:59'!
test08EmptyPortfolioHasZeroBalance

	| portfolio |
	
	portfolio := Portfolio new.

	self assert: portfolio balance equals: 0! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:18:09'!
test09AddTwoAccountsInPortfolio

	| portfolio anAccount1 anAccount2 |

	anAccount1 := ReceptiveAccount new.
	anAccount2 := ReceptiveAccount new.

	Deposit register: 100 on: anAccount1.
	Withdraw register: 50 on: anAccount2.

	portfolio := Portfolio new.

	portfolio add: anAccount1.
	portfolio add: anAccount2.

	self assert: portfolio balance equals: 50
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:10:40'!
test10AddEmptyPortfolioIntoEmptyPortfolio

	| portfolioToCheck portfolioBase |

	portfolioBase := Portfolio new.
	portfolioToCheck := Portfolio new.

	portfolioToCheck add: portfolioBase.

	self assert: portfolioToCheck balance equals: 0
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:18:23'!
test11AddPortfolioWithAccountsIntoEmptyPortfolio

	| portfolioWithAccounts portfolioToVerify anAccount1 anAccount2 |

	anAccount1 := ReceptiveAccount new.
	anAccount2 := ReceptiveAccount new.

	Deposit register: 100 on: anAccount1.
	Withdraw register: 50 on: anAccount2.

	portfolioWithAccounts := Portfolio new.
	portfolioToVerify := Portfolio new.

	portfolioWithAccounts add: anAccount1.
	portfolioWithAccounts add: anAccount2.

	portfolioToVerify add: portfolioWithAccounts.

	self assert: portfolioToVerify balance equals: 50
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:18:30'!
test12CantAddSameAccountTwiceInAPortfolio

	| portfolioToVerify anAccount |

	anAccount := ReceptiveAccount new.

	Deposit register: 100 on: anAccount.

	portfolioToVerify := Portfolio new.

	portfolioToVerify add: anAccount.

	self 
		should: [ portfolioToVerify add: anAccount ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:10:40'!
test13CantAddPortfolioTwiceInPortfolio

	| portfolioToVerify portfolioToAdd |

	portfolioToVerify := Portfolio new.
	portfolioToAdd := Portfolio new.
	
	portfolioToVerify add: portfolioToAdd.

	self 
		should: [ portfolioToVerify add: portfolioToAdd ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:19:02'!
test14CantAddAnAccountToAPorfolioThatHasAnotherPortfolioWithSameAccount

	| portfolioToVerify portfolioToAdd aRepeatedAccount |

	aRepeatedAccount := ReceptiveAccount new.

	Deposit register: 100 on: aRepeatedAccount.

	portfolioToVerify := Portfolio new.
	portfolioToAdd := Portfolio new.
	
	portfolioToAdd add: aRepeatedAccount.
	portfolioToVerify add: portfolioToAdd.

	self 
		should: [ portfolioToVerify add: aRepeatedAccount ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:19:08'!
test15CantAddPortfolioIntoSamePortfolio

	| portfolioToVerify anAccount |

	anAccount := ReceptiveAccount new.

	Deposit register: 100 on: anAccount.

	portfolioToVerify := Portfolio new.
	
	portfolioToVerify add: anAccount.

	self 
		should: [ 	portfolioToVerify add: portfolioToVerify ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:19:24'!
test16CantAddAnAccountThatIsAlreadyAddedSomewhereInsidePortfolio

	"caso general de agregar cuenta - chequeo que se revise todo el grafo por esa cuenta"

	| portfolioToVerify anAccountToAdd portfolio1 portfolio2 portfolio3 account1 account2 |

	anAccountToAdd := ReceptiveAccount new.
	Deposit register: 100 on: anAccountToAdd.
	
	account1 := ReceptiveAccount new.
	Withdraw register: 50 on: account1.
	
	account2 := ReceptiveAccount new.
	Deposit register: 25  on: account2.

	portfolioToVerify := Portfolio new.
	
	portfolio1 := Portfolio new.
	portfolio1 add: anAccountToAdd.
	
	portfolio2 := Portfolio new.
	portfolio2 add: portfolio1.
	portfolio2 add: account1.
	
	portfolio3 := Portfolio new.
	portfolio3 add: account2.
	
	portfolioToVerify add: portfolio2.
	portfolioToVerify add: portfolio3.

	self 
		should: [ 	portfolioToVerify add: anAccountToAdd ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:10:40'!
test17CantAddPortfolioThatIsAlreadyAddedSomewhereInsidePortfolio

	| portfolioToVerify portfolio1 portfolio2|

	portfolioToVerify := Portfolio new.
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.

	portfolio1 add: portfolio2 .
	portfolioToVerify add: portfolio1.

	self 
		should: [portfolioToVerify add: portfolio2]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/15/2023 18:43:52'!
test18CantAddPortfolioWithAccountAlreadyContainedInAnotherPortfolioAdded

	| portfolioToVerify portfolio1 portfolio2 account1 account2|

	portfolioToVerify := Portfolio new.
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	
	account1 := ReceptiveAccount new.
	Deposit register: 100 on: account1.
	
	account2 := ReceptiveAccount new.
	Withdraw register: 10 on: account2.
	
	portfolio1 add: account1 .
	portfolio2 add: account1.
	portfolio2 add: account2.
	
	portfolioToVerify add: portfolio2.

	self 
		should: [portfolioToVerify add: portfolio1]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/16/2023 18:12:02'!
test19TestExtraToCheckGeneralization

	| portfolioToVerify portfolio1 portfolio2 portfolio3 account1 account2 account3 account4 account5|

	account1 := ReceptiveAccount new.
	account2 := ReceptiveAccount new.
	account3 := ReceptiveAccount new.
	account4 := ReceptiveAccount new.
	account5 := ReceptiveAccount new.

	Deposit register: 100 on: account1.
	Withdraw register: 300 on: account2.
	Deposit register: 400 on: account3.
	Withdraw register: 150 on: account4.
	Deposit register: 170 on: account5.

	portfolioToVerify := Portfolio new.
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.
	portfolio3 := Portfolio new.

	portfolioToVerify add: account1.
	portfolioToVerify add: account2.

	portfolio1 add: account3.
	portfolio1 add: account4.

	portfolio2 add: account5.

	portfolio3 add: account4.

	portfolioToVerify add: portfolio1.
	portfolioToVerify add: portfolio2.

	self 
		should: [ 	portfolioToVerify add: portfolio3 ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
	! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/16/2023 18:11:26'!
test20NoTransactionsRegisteredInPortfolio

	| portfolio aTransaction|

	portfolio := Portfolio new.
	
	aTransaction := Deposit for: 100.
	
	self deny: (portfolio hasRegistered: aTransaction)
	
	
	

	! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/16/2023 18:11:36'!
test21PortfolioKnowsTwoRegisteredTransactionsInAccounts

	| portfolio account account2 aTransaction anotherTransaction|

	account := ReceptiveAccount new.
	aTransaction := Deposit register: 100 on: account.
	
	account2 := ReceptiveAccount new.
	anotherTransaction := Withdraw register: 50 on: account2.

	portfolio := Portfolio new.
	portfolio add: account.
	portfolio add: account2.
	
	self assert: (portfolio hasRegistered: aTransaction).
	self assert: (portfolio hasRegistered: anotherTransaction)
	
	
	

	! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/16/2023 18:24:24'!
test22PortfolioKnowsRegisteredTransactionsWhenItHasAccountsAndPortfolios

	| portfolioToVerify portfolio1 account1 account2 transaction1 transaction2 transaction3 |

	account1:= ReceptiveAccount new.
	transaction1 := Deposit register: 100 on: account1.
	
	account2 := ReceptiveAccount new.
	transaction2 := Withdraw register: 50 on: account2.
	transaction3 := Deposit register: 80 on: account2. 	

	portfolioToVerify := Portfolio new.
	portfolio1 := Portfolio new.
	portfolio1 add: account2.
	
	portfolioToVerify add: portfolio1.
	portfolioToVerify add: account1.
	
	self assert: (portfolioToVerify hasRegistered: transaction1 ).
	self assert: (portfolioToVerify hasRegistered: transaction2 ).
	self assert: (portfolioToVerify hasRegistered: transaction3 ).
	
	
	

	! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/16/2023 18:34:10'!
test23EmptyPortfolioReturnEmptyCollectionOfTransactions

	self assert: (Portfolio new transactions isEmpty)
	

	! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/16/2023 18:48:20'!
test24PortfolioWithTwoAccountsWithTransactionsKnowsItsTransactions
	
	|portfolioToVerify account1 account2 transaction1 transaction2 transaction3 transactionsCollection|
	
	portfolioToVerify := Portfolio new.
	account1 := ReceptiveAccount new.
	transaction1 := Deposit register: 100 on: account1.
	transaction2 := Withdraw register: 50 on: account1.
	portfolioToVerify add: account1.
	
	account2 := ReceptiveAccount new.
	transaction3 := Deposit register: 20 on: account2.
	portfolioToVerify add: account2.
	
	transactionsCollection := portfolioToVerify transactions.
	
	self assert: (transactionsCollection size) equals: 3.
	self assert: (transactionsCollection includes: transaction1).
	self assert: (transactionsCollection includes: transaction2).
	self assert: (transactionsCollection includes: transaction3)


	

	! !

!FinancialAssetTest methodsFor: 'tests' stamp: 'gg 10/16/2023 18:55:50'!
test25PortfolioWithPortfoliosAndAccountsKnowsItsTransactions

	|portfolioToVerify portfolio1 portfolio2 account1 account2 account3 transaction1 transaction2 transaction3 transactionsCollection|
		
	account1 := ReceptiveAccount new.
	transaction1 := Deposit register: 100 on: account1.
	
	account2 := ReceptiveAccount new.
	transaction2 := Withdraw register: 50 on: account2.
	
	account3 := ReceptiveAccount new.
	transaction3 := Deposit register: 20 on: account3.
	
	portfolio1 := Portfolio new.
	portfolio1 add: account1.
	portfolio1 add: account2.
	
	portfolio2 := Portfolio new.
	portfolio2 add: account3.
	
	portfolioToVerify := Portfolio new.
	portfolioToVerify add: portfolio1.
	portfolioToVerify add: portfolio2.

	transactionsCollection := portfolioToVerify transactions.
	
	self assert: (transactionsCollection size) equals: 3.
	self assert: (transactionsCollection includes: transaction1).
	self assert: (transactionsCollection includes: transaction2).
	self assert: (transactionsCollection includes: transaction3)


	

	! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'gg 10/15/2023 18:41:32'!
affectBalance: aBalance

	self subclassResponsibility! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'gg 10/15/2023 18:41:40'!
affectBalance: aBalance

	^aBalance + value! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'gg 10/15/2023 18:41:45'!
affectBalance: aBalance

	^aBalance - value! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #FinancialAsset category: 'Portfolio-Ejercicio'!
Object subclass: #FinancialAsset
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!FinancialAsset methodsFor: 'balance' stamp: 'gg 10/15/2023 18:29:14'!
balance

	self subclassResponsibility! !


!FinancialAsset methodsFor: 'asset management - private' stamp: 'gg 10/15/2023 18:28:50'!
elementsAlreadyAdded: anAssetToVerify

	self subclassResponsibility! !


!FinancialAsset methodsFor: 'testing' stamp: 'gg 10/15/2023 20:27:05'!
hasRegistered: aTransaction

	self subclassResponsibility! !


!FinancialAsset methodsFor: 'transactions' stamp: 'gg 10/16/2023 19:08:12'!
addTransactionsInto: transactionsList

	self subclassResponsibility! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
FinancialAsset subclass: #Portfolio
	instanceVariableNames: 'assets'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'balance' stamp: 'gg 10/15/2023 18:41:23'!
balance

	^assets inject: 0 into: [:accumulatedBalance :anAsset | accumulatedBalance + anAsset balance]! !


!Portfolio methodsFor: 'asset management' stamp: 'gg 10/15/2023 18:40:12'!
add: anAssetToAdd
	
	self verifyIsPossibleToAddAsset: anAssetToAdd.
		
	assets add: anAssetToAdd! !


!Portfolio methodsFor: 'initialization' stamp: 'NMS 10/11/2023 21:55:26'!
initialize
	assets := Set new! !


!Portfolio methodsFor: 'assertions' stamp: 'gg 10/15/2023 18:40:12'!
verifyIsPossibleToAddAsset: anAssetToAdd

	(self elementsAlreadyAdded: anAssetToAdd) ifTrue: [^self error: self class canNotAddAnAssetAlreadyAdded]! !


!Portfolio methodsFor: 'asset management - private' stamp: 'gg 10/16/2023 18:00:56'!
elementsAlreadyAdded: anAssetToVerify

	^ (self = anAssetToVerify) or: [assets anySatisfy: 
		[:anAsset | (anAsset elementsAlreadyAdded: anAssetToVerify) or: [anAssetToVerify elementsAlreadyAdded: anAsset]]]! !


!Portfolio methodsFor: 'testing' stamp: 'gg 10/15/2023 20:13:22'!
hasRegistered: aTransaction 
	
	^ assets anySatisfy: [:anAsset | anAsset hasRegistered: aTransaction]! !


!Portfolio methodsFor: 'transactions' stamp: 'gg 10/16/2023 19:21:35'!
addTransactionsInto: aTransactionsList 
	
	assets do: [:anAsset | anAsset addTransactionsInto: aTransactionsList]
! !

!Portfolio methodsFor: 'transactions' stamp: 'gg 10/16/2023 19:18:52'!
transactions
	
	|transactionList|
	transactionList := OrderedCollection new.
	
	self addTransactionsInto: transactionList.
	^transactionList 
	
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error messages' stamp: 'NMS 10/13/2023 19:49:32'!
canNotAddAnAssetAlreadyAdded
	^'No se pueden agregar activos repetidos'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
FinancialAsset subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'gg 10/16/2023 19:20:15'!
addTransactionsInto: aTransactionsList 

	aTransactionsList addAll: transactions! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'NMS 10/11/2023 21:37:06'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'gg 10/15/2023 18:41:59'!
balance

	^transactions inject: 0 into: [:currentBalance :aTransaction | aTransaction affectBalance: currentBalance]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'asset management - private' stamp: 'gg 10/15/2023 18:17:05'!
elementsAlreadyAdded: anAssetToVerify

	^ self = anAssetToVerify ! !
