!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/11/2023 21:18:59'!
test08EmptyPortfolioHasZeroBalance

	| portfolio |
	
	portfolio := Portfolio new.

	self assert: portfolio balance equals: 0! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/13/2023 20:16:55'!
test09AddTwoAccountsInPortfolio

	| portfolio anAccount1 anAccount2 |

	anAccount1 := ReceptiveAccount new.
	anAccount2 := ReceptiveAccount new.

	Deposit register: 100 on: anAccount1.
	Withdraw register: 50 on: anAccount2.

	portfolio := Portfolio new.

	portfolio addAccount: anAccount1.
	portfolio addAccount: anAccount2.

	self assert: portfolio balance equals: 50
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/13/2023 20:17:02'!
test10AddEmptyPortfolioIntoEmptyPortfolio

	| portfolioToCheck portfolioBase |

	portfolioBase := Portfolio new.
	portfolioToCheck := Portfolio new.

	portfolioToCheck addPortfolio: portfolioBase.

	self assert: portfolioToCheck balance equals: 0
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/13/2023 20:17:08'!
test11AddPortfolioWithAccountsIntoEmptyPortfolio

	| portfolioWithAccounts portfolioToVerify anAccount1 anAccount2 |

	anAccount1 := ReceptiveAccount new.
	anAccount2 := ReceptiveAccount new.

	Deposit register: 100 on: anAccount1.
	Withdraw register: 50 on: anAccount2.

	portfolioWithAccounts := Portfolio new.
	portfolioToVerify := Portfolio new.

	portfolioWithAccounts addAccount: anAccount1.
	portfolioWithAccounts addAccount: anAccount2.

	portfolioToVerify addPortfolio: portfolioWithAccounts.

	self assert: portfolioToVerify balance equals: 50
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/13/2023 20:17:14'!
test12CantAddSameAccountTwiceInAPortfolio

	| portfolioToVerify anAccount |

	anAccount := ReceptiveAccount new.

	Deposit register: 100 on: anAccount.

	portfolioToVerify := Portfolio new.

	portfolioToVerify addAccount: anAccount.

	self 
		should: [ portfolioToVerify addAccount: anAccount ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/13/2023 20:17:23'!
test13CantAddPortfolioIntoSamePortfolio

	| portfolioToVerify portfolioToAdd |

	portfolioToVerify := Portfolio new.
	portfolioToAdd := Portfolio new.
	
	portfolioToVerify addPortfolio: portfolioToAdd.

	self 
		should: [ portfolioToVerify addPortfolio: portfolioToAdd ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/13/2023 20:47:01'!
test14CantAddAnAccountToAPorfolioWhichAlreadyHasAPortfolioWithSameAccount

	| portfolioToVerify portfolioToAdd aRepeatedAccount |

	aRepeatedAccount := ReceptiveAccount new.

	Deposit register: 100 on: aRepeatedAccount.

	portfolioToVerify := Portfolio new.
	portfolioToAdd := Portfolio new.
	
	portfolioToAdd addAccount: aRepeatedAccount.
	portfolioToVerify addPortfolio: portfolioToAdd.

	self 
		should: [ portfolioToVerify addAccount: aRepeatedAccount ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/13/2023 20:47:30'!
test15CantAddPortfolioIntoSamePortfolio

	| portfolioToVerify anAccount |

	anAccount := ReceptiveAccount new.

	Deposit register: 100 on: anAccount.

	portfolioToVerify := Portfolio new.
	
	portfolioToVerify addAccount: anAccount.

	self 
		should: [ 	portfolioToVerify addPortfolio: portfolioToVerify ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'gg 10/13/2023 21:46:14'!
test16

	| portfolioToVerify portfolio1 portfolio2|

	portfolioToVerify := Portfolio new.
	portfolio1 := Portfolio new.
	portfolio2 := Portfolio new.

	portfolio1 addPortfolio: portfolio2 .
	portfolioToVerify addPortfolio: portfolio1.

	self 
		should: [portfolioToVerify addPortfolio: portfolio2]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
	! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'gg 10/13/2023 21:28:27'!
test900

	| portfolioToVerify portfolio1 portfolio2 portfolio3 account1 account2 account3 account4 account5 |

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

	portfolioToVerify addAccount: account1.
	portfolioToVerify addAccount: account2.

	portfolio1 addAccount: account3.
	portfolio1 addAccount: account4.

	portfolio2 addAccount: account5.

	portfolio3 addAccount: account4.

	portfolioToVerify addPortfolio: portfolio1.
	portfolioToVerify addPortfolio: portfolio2.

	self 
		should: [ 	portfolioToVerify addPortfolio: portfolio3 ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: Portfolio canNotAddAnAssetAlreadyAdded ]
	! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'NMS 10/11/2023 21:16:47'!
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


!Deposit methodsFor: 'value' stamp: 'NMS 10/11/2023 21:16:31'!
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


!Withdraw methodsFor: 'value' stamp: 'NMS 10/11/2023 21:18:12'!
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

!FinancialAsset methodsFor: 'as yet unclassified' stamp: 'NMS 10/13/2023 19:44:22'!
balance
	^self subclassResponsibility! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
FinancialAsset subclass: #Portfolio
	instanceVariableNames: 'assets'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'balance' stamp: 'NMS 10/11/2023 21:56:11'!
balance
	^(assets inject: 0 into: [:balanceAccumulated :anAsset | balanceAccumulated + anAsset balance])! !


!Portfolio methodsFor: 'portfolio managment' stamp: 'NMS 10/13/2023 20:34:51'!
addAccount: anAccountToAdd
	(assets anySatisfy: [:anAsset | anAsset xxxx: anAccountToAdd]) ifTrue: [^self error: self class canNotAddAnAssetAlreadyAdded].

	assets add: anAccountToAdd! !

!Portfolio methodsFor: 'portfolio managment' stamp: 'gg 10/13/2023 21:35:32'!
addPortfolio: aPortfolioToAdd

	((self = aPortfolioToAdd) or: [assets anySatisfy: [:anAsset | anAsset yyy: aPortfolioToAdd]]) 
		ifTrue: [^self error: self class canNotAddAnAssetAlreadyAdded].
	
	assets add: aPortfolioToAdd! !

!Portfolio methodsFor: 'portfolio managment' stamp: 'NMS 10/11/2023 21:55:26'!
initialize
	assets := Set new! !

!Portfolio methodsFor: 'portfolio managment' stamp: 'NMS 10/13/2023 20:32:42'!
xxxx: anAssetToVerify
	^(assets includes: anAssetToVerify)! !

!Portfolio methodsFor: 'portfolio managment' stamp: 'gg 10/13/2023 21:45:43'!
yyy: aPortfolio
	
	
	^ (assets anySatisfy: [:anAsset | anAsset = aPortfolio]) or: [self = aPortfolio ]

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


!ReceptiveAccount methodsFor: 'transactions' stamp: 'NMS 10/11/2023 21:37:06'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'NMS 10/11/2023 21:17:41'!
balance
	^transactions inject: 0 into: [:currentBalance :aTransaction | aTransaction affectBalance: currentBalance]! !

!ReceptiveAccount methodsFor: 'balance' stamp: 'NMS 10/13/2023 20:32:09'!
xxxx: anAssetToVerify
	^self = anAssetToVerify! !

!ReceptiveAccount methodsFor: 'balance' stamp: 'gg 10/13/2023 21:55:30'!
yyy: aPortfolioToAdd

	^aPortfolioToAdd xxxx:self! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !
