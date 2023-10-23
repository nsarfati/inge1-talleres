!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 5/27/2021 17:36:04'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:23:25'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:11'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:06'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'NR 6/22/2020 07:31:19'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:54'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:02'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:21:24'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #ReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/21/2023 13:21:59'!
test01AccountSummaryForAccountWithNoTransactions

	| accountSummary |

	accountSummary := ReceptiveAccount new accountSummary.
	
	
	self assert: (accountSummary first) equals: 'Balance = 0'.
	self assert: (accountSummary size) equals: 1! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/21/2023 13:22:05'!
test02AccountSummaryForAccountWithDeposit

	| accountToVerify accountSummary |

	accountToVerify := ReceptiveAccount new.
	
	Deposit register: 100 on: accountToVerify.

	accountSummary := accountToVerify accountSummary.
	
	self assert: (accountSummary first) equals: 'Depósito por 100.'.
	self assert: (accountSummary second) equals: 'Balance = 100'.
	self assert: (accountSummary size) equals: 2! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/21/2023 13:22:19'!
test03AccountSummaryForAccountWithWithdrawal

	| accountToVerify accountSummary |

	accountToVerify := ReceptiveAccount new.
	
	Withdraw register: 20 on: accountToVerify.

	accountSummary := accountToVerify accountSummary.
	
	self assert: (accountSummary first) equals: 'Extracción por 20.'.
	self assert: (accountSummary second) equals: 'Balance = -20'.
	self assert: (accountSummary size) equals: 2! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/21/2023 13:26:48'!
test04AccountSummaryForAccountWithDepositTransferLeg

	| receptiveAccount senderAccount accountSummaryReceptiveAccount accountSummarySenderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	accountSummaryReceptiveAccount := receptiveAccount accountSummary.
	accountSummarySenderAccount := senderAccount accountSummary.
	
	self assert: (accountSummaryReceptiveAccount first) equals: 'Entrada por transferencia de 100.'.
	self assert: (accountSummaryReceptiveAccount second) equals: 'Balance = 100'.
	self assert: (accountSummaryReceptiveAccount size) equals: 2.
	
	self assert: (accountSummarySenderAccount first) equals: 'Salida por transferencia de 100.'.
	self assert: (accountSummarySenderAccount second) equals: 'Balance = -100'.
	self assert: (accountSummarySenderAccount size) equals: 2.

	
! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/23/2023 10:48:13'!
test05TestExtraToCheckGeneralization

	| receptiveAccount senderAccount accountSummaryReceptiveAccount accountSummarySenderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Deposit register: 1 on: receptiveAccount.

	Withdraw register: 100 on: senderAccount.
	Deposit register: 200 on: senderAccount.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	accountSummaryReceptiveAccount := receptiveAccount accountSummary.
	accountSummarySenderAccount := senderAccount accountSummary.

	self assert: (accountSummaryReceptiveAccount first) equals: 'Depósito por 1.'.
	self assert: (accountSummaryReceptiveAccount second) equals: 'Entrada por transferencia de 100.'.
	self assert: (accountSummaryReceptiveAccount third) equals: 'Balance = 101'.
	self assert: (accountSummaryReceptiveAccount size) equals: 3.
	
	self assert: (accountSummarySenderAccount first) equals: 'Extracción por 100.'.
	self assert: (accountSummarySenderAccount second) equals: 'Depósito por 200.'.
	self assert: (accountSummarySenderAccount third) equals: 'Salida por transferencia de 100.'.
	self assert: (accountSummarySenderAccount fourth) equals: 'Balance = 0'.
	self assert: (accountSummarySenderAccount size) equals: 4.
! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/23/2023 11:23:54'!
test06TransferNetForAccountWithNoTransactions

	self assert: (ReceptiveAccount new transferNet) equals: 0! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/23/2023 11:24:07'!
test07TransferNetForAccountWithoutTransfers

	| accountToVerify |
	
	accountToVerify := ReceptiveAccount new.

	Deposit register: 100 on: accountToVerify.
	Withdraw register: 20 on: accountToVerify.

	self assert: (accountToVerify transferNet) equals: 0.
! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/23/2023 11:24:24'!
test08TransferNetForAccountWithATransfers

	| receptiveAccount senderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.

	self assert: (receptiveAccount transferNet) equals: 100.
	self assert: (senderAccount transferNet) equals: -100! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/23/2023 11:26:20'!
test09TestExtraToCheckGeneralization

	| receptiveAccount senderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Deposit register: 100 on: receptiveAccount.
	Withdraw register: 50 on: receptiveAccount.

	Deposit register: 42 on: senderAccount.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	Transfer from: receptiveAccount to: senderAccount forAmount: 50.

	self assert: (receptiveAccount transferNet) equals: 50.
	self assert: (senderAccount transferNet) equals: -50! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'tests' stamp: 'NMS 10/21/2023 12:34:29'!
test01BalanceIsAffectedByTransfer
	
	| receptiveAccount senderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.
	
	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	self assert: receptiveAccount balance equals: 100.
	self assert: senderAccount balance equals: -100! !

!TransferTest methodsFor: 'tests' stamp: 'NMS 10/21/2023 12:35:00'!
test02AccountRegisterTransactionOnTransfer
	
	| receptiveAccount senderAccount transfer |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.
	
	transfer := Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	self assert: (senderAccount hasRegistered: (transfer withdrawLeg)).
	self assert: (receptiveAccount hasRegistered: (transfer depositLeg))! !

!TransferTest methodsFor: 'tests' stamp: 'NMS 10/21/2023 12:36:12'!
test03TransferKnowsLegsAndLegsKnowsTransfer
	
	| receptiveAccount senderAccount transfer |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	transfer := Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	self assert: transfer equals: (transfer depositLeg transfer).
	self assert: transfer equals: (transfer withdrawLeg transfer).
! !

!TransferTest methodsFor: 'tests' stamp: 'NMS 10/21/2023 12:37:20'!
test04CanSurfTransferFromOneLegToAnother
	
	| receptiveAccount senderAccount transfer |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	transfer := Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	self assert: (transfer withdrawLeg) equals: (transfer depositLeg transfer withdrawLeg).
	self assert: (transfer depositLeg) equals: (transfer withdrawLeg transfer depositLeg).
! !

!TransferTest methodsFor: 'tests' stamp: 'NMS 10/21/2023 12:38:58'!
test05TransferKnowsItsValue
	
	| receptiveAccount senderAccount transfer |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	transfer := Transfer from: senderAccount to: receptiveAccount forAmount: 100.

	self assert: (transfer value) equals: 100! !

!TransferTest methodsFor: 'tests' stamp: 'NMS 10/21/2023 12:46:23'!
test06CanNotMakeZeroTransfer
	
	| receptiveAccount senderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	self 
		should: [ Transfer from: senderAccount to: receptiveAccount forAmount: 0 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Transfer canNotTransferZeroOrLess equals: anError messageText.
		]! !

!TransferTest methodsFor: 'tests' stamp: 'NMS 10/21/2023 12:46:30'!
test07CanNotMakeNegativeTransfer
	
	| receptiveAccount senderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	self 
		should: [ Transfer from: senderAccount to: receptiveAccount forAmount: -10 ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Transfer canNotTransferZeroOrLess equals: anError messageText.
		]! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !


!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !


!ReceptiveAccount methodsFor: 'reporting' stamp: 'NMS 10/21/2023 13:27:46'!
accountSummary	
	| report |
	report := OrderedCollection new.
	
	transactions do: [ :aTransaction |
		(aTransaction isKindOf: Deposit) ifTrue: [
			report add: (('Depósito por ' append: (aTransaction value asString)) append: '.').
		].

		(aTransaction isKindOf: Withdraw) ifTrue: [
			report add: (('Extracción por ' append: (aTransaction value asString)) append: '.').
		].
	
		(aTransaction isKindOf: DepositLeg) ifTrue: [
			report add: (('Entrada por transferencia de ' append: (aTransaction value asString)) append: '.').
		].

		(aTransaction isKindOf: WithdrawLeg ) ifTrue: [
			report add: (('Salida por transferencia de ' append: (aTransaction value asString)) append: '.').
		].
	].

	report add: ('Balance = ' append: self balance asString).
	
	^report
	! !

!ReceptiveAccount methodsFor: 'reporting' stamp: 'NMS 10/23/2023 11:30:02'!
transferNet
	^transactions 
		inject: 0
		into: [ :currentBalance :transaction |
				(transaction isKindOf: DepositLeg)
					ifTrue: [
						currentBalance + transaction value
					]
					ifFalse: [
						(transaction isKindOf: WithdrawLeg)
							ifTrue: [
								currentBalance	 - transaction value
							]
							ifFalse: [currentBalance]
					]
		]! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!classDefinition: #TT category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TT class' category: 'Portfolio-Solucion'!
TT class
	instanceVariableNames: ''!

!TT class methodsFor: 'instance creation' stamp: 'NMS 10/23/2023 10:55:29'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
TT subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
TT subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #TransferLeg category: 'Portfolio-Solucion'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!classDefinition: #DepositLeg category: 'Portfolio-Solucion'!
TransferLeg subclass: #DepositLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositLeg methodsFor: 'initilization' stamp: 'NMS 10/21/2023 12:17:42'!
initializeWith: aTransfer on: aReceptiveAccount
	transfer := aTransfer.
	aReceptiveAccount 	register: self.
! !


!DepositLeg methodsFor: 'accessing' stamp: 'NMS 10/21/2023 12:21:52'!
affectBalance: aBalance
	^aBalance + transfer value ! !

!DepositLeg methodsFor: 'accessing' stamp: 'NMS 10/21/2023 12:09:00'!
transfer
	^transfer! !

!DepositLeg methodsFor: 'accessing' stamp: 'NMS 10/21/2023 12:26:45'!
value
	^transfer value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DepositLeg class' category: 'Portfolio-Solucion'!
DepositLeg class
	instanceVariableNames: ''!

!DepositLeg class methodsFor: 'instance creation' stamp: 'NMS 10/21/2023 12:16:21'!
on: aReceptiveAccount with: aTransfer
	^self new initializeWith: aTransfer on: aReceptiveAccount ! !


!classDefinition: #WithdrawLeg category: 'Portfolio-Solucion'!
TransferLeg subclass: #WithdrawLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!WithdrawLeg methodsFor: 'initilization' stamp: 'NMS 10/21/2023 12:22:48'!
affectBalance: aBalance
	^aBalance - transfer value ! !

!WithdrawLeg methodsFor: 'initilization' stamp: 'NMS 10/21/2023 12:22:11'!
initializeWith: aTransfer on: aReceptiveAccount
	transfer := aTransfer.
	aReceptiveAccount 	register: self.
! !


!WithdrawLeg methodsFor: 'accessing' stamp: 'NMS 10/21/2023 12:09:21'!
transfer
	^transfer! !

!WithdrawLeg methodsFor: 'accessing' stamp: 'NMS 10/21/2023 12:26:54'!
value
	^transfer value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WithdrawLeg class' category: 'Portfolio-Solucion'!
WithdrawLeg class
	instanceVariableNames: ''!

!WithdrawLeg class methodsFor: 'instance creation' stamp: 'NMS 10/21/2023 12:22:24'!
on: aReceptiveAccount with: aTransfer
	^self new initializeWith: aTransfer on: aReceptiveAccount ! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'depositLeg withdrawLeg amountToTransfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'initialize' stamp: 'NMS 10/21/2023 12:24:10'!
initializeWith: aSenderAccount and: aReceptiveAccount forAmount: anAmountToTransfer 
	amountToTransfer := anAmountToTransfer.
	depositLeg := DepositLeg on: aReceptiveAccount with: self.
	withdrawLeg := WithdrawLeg on: aSenderAccount with: self.! !


!Transfer methodsFor: 'accesing' stamp: 'NMS 10/21/2023 12:05:59'!
depositLeg
	^depositLeg.! !

!Transfer methodsFor: 'accesing' stamp: 'NMS 10/21/2023 12:23:32'!
value
	^amountToTransfer! !

!Transfer methodsFor: 'accesing' stamp: 'NMS 10/21/2023 12:06:08'!
withdrawLeg
	^withdrawLeg ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'NMS 10/21/2023 12:47:21'!
assertTransferPositive: anAmountToTransfer
	^ (anAmountToTransfer <= 0) ifTrue: [ self error: self canNotTransferZeroOrLess ]! !

!Transfer class methodsFor: 'instance creation' stamp: 'NMS 10/21/2023 12:42:56'!
canNotTransferZeroOrLess
	^'Las transferencias deben ser mayores a 0'! !

!Transfer class methodsFor: 'instance creation' stamp: 'NMS 10/21/2023 12:47:21'!
from: aSenderAccount to: aReceptiveAccount forAmount: anAmountToTransfer
	self assertTransferPositive: anAmountToTransfer.
	^self new initializeWith: aSenderAccount and: aReceptiveAccount forAmount: anAmountToTransfer ! !
