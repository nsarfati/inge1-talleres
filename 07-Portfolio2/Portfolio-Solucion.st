!classDefinition: #PortfolioStructureTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioStructureTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioStructureTest methodsFor: 'as yet unclassified' stamp: 'gg 10/26/2023 00:13:05'!
test01PortfolioStructureForEmptyPortfolio
 
	| emptyPortfolio portfolioStructureReport |

	emptyPortfolio := Portfolio named: 'Portfolio de la familia'.
	portfolioStructureReport := ((PortfolioStructure for: emptyPortfolio) generatePortfolioStructure).
	
	self assert: portfolioStructureReport first equals: 'Portfolio de la familia'.
	self assert: portfolioStructureReport size equals: 1.! !

!PortfolioStructureTest methodsFor: 'as yet unclassified' stamp: 'gg 10/26/2023 00:16:29'!
test02PortfolioStructureForPortfolioWithTwoAccounts
 
	| portfolioWithOneAccount portfolioStructureReport |

	portfolioWithOneAccount := Portfolio named: 'Portfolio de la familia' with: (ReceptiveAccount named: 'Cuenta de Hernan') with: (ReceptiveAccount named: 'Cuenta de Juan').
	
	portfolioStructureReport := ((PortfolioStructure for: portfolioWithOneAccount) generatePortfolioStructure).
		
	self assert: portfolioStructureReport first equals: 'Portfolio de la familia'.
	self assert: portfolioStructureReport second equals: '    Cuenta de Hernan'.
	self assert: portfolioStructureReport third equals: '    Cuenta de Juan'.
	self assert: portfolioStructureReport size equals: 3

! !

!PortfolioStructureTest methodsFor: 'as yet unclassified' stamp: 'gg 10/26/2023 00:22:01'!
test03PortfolioStructureForPortfolioWithAccountAndEmptyPortfolio
 
	| portfolioWithOneAccount portfolioStructureReport |

	portfolioWithOneAccount := Portfolio named: 'Portfolio de la familia' with: (ReceptiveAccount named: 'Cuenta de Hernan') with: (Portfolio named: 'Portfolio vacio').
	
	portfolioStructureReport := ((PortfolioStructure for: portfolioWithOneAccount) generatePortfolioStructure).

	self assert: portfolioStructureReport first equals: 'Portfolio de la familia'.
	self assert: portfolioStructureReport second equals: '    Cuenta de Hernan'.
	self assert: portfolioStructureReport third equals: '    Portfolio vacio'.
	self assert: portfolioStructureReport size equals: 3! !

!PortfolioStructureTest methodsFor: 'as yet unclassified' stamp: 'gg 10/26/2023 01:05:38'!
test04PortfolioStructureForPortfolioWithPortfoliosWithAccounts
 
	| rootPortfolio portfolioHijos myAccount account1 account2 portfolioStructureReport|
	
	account1 := ReceptiveAccount named: 'Cuenta de Juan'.
	account2 := ReceptiveAccount named: 'Cuenta de Angeles'.
	portfolioHijos := Portfolio named: 'Portfolio de hijos' with: account1 with: account2.
	myAccount := ReceptiveAccount named: 'Cuenta mia'.
	rootPortfolio := Portfolio named: 'Portfolio de la familia' with: myAccount with: portfolioHijos.
	
	portfolioStructureReport := ((PortfolioStructure for: rootPortfolio) generatePortfolioStructure).

	self assert: portfolioStructureReport first equals: 'Portfolio de la familia'.
	self assert: portfolioStructureReport second equals: '    Cuenta mia'.
	self assert: portfolioStructureReport third equals: '    Portfolio de hijos'.
	self assert: portfolioStructureReport fourth equals: '        Cuenta de Juan'.
	self assert: portfolioStructureReport fifth equals: '        Cuenta de Angeles'.
	self assert: portfolioStructureReport size equals: 5! !


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

!PortfolioTest methodsFor: 'tests' stamp: 'NMS 10/25/2023 12:37:04'!
test16PortfolioWithoutNameReturnsDefault

	| portfolio |
	
	portfolio := Portfolio new.
	
	self assert: portfolio accountName equals: 'Portfolio sin nombre'! !

!PortfolioTest methodsFor: 'tests' stamp: 'NMS 10/25/2023 12:37:22'!
test17NamedPortfolioReturnsRightOne

	| portfolio |
	
	portfolio := Portfolio named: 'Portfolio de Nico'.
	
	self assert: portfolio accountName equals: 'Portfolio de Nico'! !

!PortfolioTest methodsFor: 'tests' stamp: 'NMS 10/25/2023 12:51:52'!
test18NamedPortfolioWithOneAccount

	| portfolio |
	
	portfolio := Portfolio named: 'Portfolio de Nico' with: (ReceptiveAccount named: 'Cuenta 1').
	
	self assert: portfolio accountName equals: 'Portfolio de Nico'! !

!PortfolioTest methodsFor: 'tests' stamp: 'NMS 10/25/2023 12:54:34'!
test19NamedPortfolioWithTwoAccounts

	| portfolio |
	
	portfolio := Portfolio named: 'Portfolio de Nico' with: (ReceptiveAccount named: 'Cuenta 1') with: (ReceptiveAccount named: 'Cuenta 2').
	
	self assert: portfolio accountName equals: 'Portfolio de Nico'! !


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

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/25/2023 12:24:57'!
test08ReceptiveAccountWithoutNameReturnsDefault

	| account1 |
	
	account1 := ReceptiveAccount new.
		
	self assert: account1 accountName equals: 'Receptive Account sin nombre'! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NMS 10/25/2023 12:37:37'!
test09NamedReceptiveAccountReturnsRightOne

	| account1 |
	
	account1 := ReceptiveAccount named: 'Cuenta de Gero'.
		
	self assert: account1 accountName equals: 'Cuenta de Gero'! !


!classDefinition: #ReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:12:27'!
test01AccountSummaryForAccountWithNoTransactions

	| accountSummary |
	
	accountSummary := (AccountSummary for: ReceptiveAccount new) generateAccountSummary.
	
	self assert: (accountSummary first) equals: 'Balance = 0'.
	self assert: (accountSummary size) equals: 1! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:12:33'!
test02AccountSummaryForAccountWithDeposit

	| accountToVerify accountSummary |

	accountToVerify := ReceptiveAccount new.
	
	Deposit register: 100 on: accountToVerify.

	accountSummary := (AccountSummary for: accountToVerify) generateAccountSummary.
	
	self assert: (accountSummary first) equals: 'Depósito por 100.'.
	self assert: (accountSummary second) equals: 'Balance = 100'.
	self assert: (accountSummary size) equals: 2! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:12:36'!
test03AccountSummaryForAccountWithWithdrawal

	| accountToVerify accountSummary |

	accountToVerify := ReceptiveAccount new.
	
	Withdraw register: 20 on: accountToVerify.

	accountSummary := (AccountSummary for: accountToVerify) generateAccountSummary.
	
	self assert: (accountSummary first) equals: 'Extracción por 20.'.
	self assert: (accountSummary second) equals: 'Balance = -20'.
	self assert: (accountSummary size) equals: 2! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:12:52'!
test04AccountSummaryForAccountWithDepositTransferLeg

	| receptiveAccount senderAccount accountSummaryReceptiveAccount accountSummarySenderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	accountSummaryReceptiveAccount := (AccountSummary for: receptiveAccount) generateAccountSummary.
	accountSummarySenderAccount := (AccountSummary for: senderAccount) generateAccountSummary.
	
	self assert: (accountSummaryReceptiveAccount first) equals: 'Entrada por transferencia de 100.'.
	self assert: (accountSummaryReceptiveAccount second) equals: 'Balance = 100'.
	self assert: (accountSummaryReceptiveAccount size) equals: 2.
	
	self assert: (accountSummarySenderAccount first) equals: 'Salida por transferencia de 100.'.
	self assert: (accountSummarySenderAccount second) equals: 'Balance = -100'.
	self assert: (accountSummarySenderAccount size) equals: 2.

	
! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:12:58'!
test05TestExtraToCheckGeneralization

	| receptiveAccount senderAccount accountSummaryReceptiveAccount accountSummarySenderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Deposit register: 1 on: receptiveAccount.

	Withdraw register: 100 on: senderAccount.
	Deposit register: 200 on: senderAccount.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	
	accountSummaryReceptiveAccount := (AccountSummary for: receptiveAccount) generateAccountSummary.
	accountSummarySenderAccount := (AccountSummary for: senderAccount) generateAccountSummary.

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

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:11:55'!
test06TransferNetForAccountWithNoTransactions

	self assert: (	(TransferNet for: ReceptiveAccount new) generateTransferNet) equals: 0! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:11:55'!
test07TransferNetForAccountWithoutTransfers

	| accountToVerify |
	
	accountToVerify := ReceptiveAccount new.

	Deposit register: 100 on: accountToVerify.
	Withdraw register: 20 on: accountToVerify.

	self assert: 	((TransferNet for: accountToVerify) generateTransferNet) equals: 0.
! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:11:55'!
test08TransferNetForAccountWithATransfers

	| receptiveAccount senderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.

	self assert: 	((TransferNet for: receptiveAccount) generateTransferNet) equals: 100.
	self assert: 	((TransferNet for: senderAccount) generateTransferNet) equals: -100! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:11:55'!
test09TestExtraToCheckGeneralization

	| receptiveAccount senderAccount |
	
	receptiveAccount := ReceptiveAccount new.
	senderAccount := ReceptiveAccount new.

	Deposit register: 100 on: receptiveAccount.
	Withdraw register: 50 on: receptiveAccount.

	Deposit register: 42 on: senderAccount.

	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	Transfer from: receptiveAccount to: senderAccount forAmount: 50.

	self assert: ((TransferNet for: receptiveAccount) generateTransferNet) equals: 50.
	self assert: ((TransferNet for: senderAccount) generateTransferNet) equals: -50! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:33:20'!
test10AccountSummaryForEmptyPortfolio

	| portfolio accountSummaryReport|
	
	portfolio := Portfolio new.

	accountSummaryReport := ((AccountSummary for: portfolio) generateAccountSummary).
	
	self assert: (accountSummaryReport first) equals: 'Balance = 0'.
	self assert: (accountSummaryReport size) equals: 1! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 15:44:56'!
test11AccountSummaryForPortfolioWithOneAccount

	| account portfolio accountSummaryReport|
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	portfolio := Portfolio with: account.
	
	accountSummaryReport := ((AccountSummary for: portfolio) generateAccountSummary).
	
	self assert: (accountSummaryReport first) equals: 'Depósito por 100.'.
	self assert: (accountSummaryReport second) equals: 'Extracción por 50.'.
	self assert: (accountSummaryReport third) equals: 'Balance = 50'.
	self assert: (accountSummaryReport size) equals: 3! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 16:39:15'!
test12AccountSummaryForPortfolioWithTwoAccountsAndTransfers

	| senderAccount receptiveAccount portfolio accountSummaryReport|
	
	senderAccount := ReceptiveAccount new.
	Withdraw register: 50 on: senderAccount.
		
	receptiveAccount := ReceptiveAccount new.
	Deposit register: 1000 on: receptiveAccount.
	
	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	portfolio := Portfolio with: senderAccount with: receptiveAccount.
	
	accountSummaryReport := ((AccountSummary for: portfolio) generateAccountSummary).
	
	self assert: (accountSummaryReport first) equals: 'Extracción por 50.'.
	self assert: (accountSummaryReport second) equals: 'Salida por transferencia de 100.'.
	self assert: (accountSummaryReport third) equals: 'Depósito por 1000.'.
	self assert: (accountSummaryReport fourth) equals: 'Entrada por transferencia de 100.'.
	self assert: (accountSummaryReport fifth) equals: 'Balance = 950'.
	
	self assert: (accountSummaryReport size) equals: 5.! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 17:01:57'!
test13AccountSummaryOfPortfolioIsGeneratedRecursively
 
	| simplePortfolioAccount simplePortfolio composedPortfolioAccount1 composedPortfolioAccount2
	composedPortfolio accountSummaryReport |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount1 := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount1.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount1.
	
	Transfer from: simplePortfolioAccount to: composedPortfolioAccount1 forAmount: 100.
	
	composedPortfolioAccount2 := ReceptiveAccount new.
	Deposit register: 101 on: composedPortfolioAccount2.
	composedPortfolio add: composedPortfolioAccount2.
	
	accountSummaryReport := ((AccountSummary for: composedPortfolio) generateAccountSummary).
	
	self assert: (accountSummaryReport first) equals: 'Depósito por 100.'.
	self assert: (accountSummaryReport second) equals: 'Salida por transferencia de 100.'.
	self assert: (accountSummaryReport third) equals: 'Extracción por 50.'.
	self assert: (accountSummaryReport fourth) equals: 'Entrada por transferencia de 100.'.
	self assert: (accountSummaryReport fifth) equals: 'Depósito por 101.'.
	self assert: (accountSummaryReport sixth) equals: 'Balance = 151'.
	
	self assert: (accountSummaryReport size) equals: 6.! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/25/2023 12:04:56'!
test14CasoGeneralPENDINGDEHACER
 
	| simplePortfolioAccount simplePortfolio composedPortfolioAccount1 composedPortfolioAccount2
	composedPortfolio accountSummaryReport |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount1 := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount1.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount1.
	
	Transfer from: simplePortfolioAccount to: composedPortfolioAccount1 forAmount: 100.
	
	composedPortfolioAccount2 := ReceptiveAccount new.
	Deposit register: 101 on: composedPortfolioAccount2.
	composedPortfolio add: composedPortfolioAccount2.
	
	accountSummaryReport := ((AccountSummary for: composedPortfolio) generateAccountSummary).
	
	self assert: (accountSummaryReport first) equals: 'Depósito por 100.'.
	self assert: (accountSummaryReport second) equals: 'Salida por transferencia de 100.'.
	self assert: (accountSummaryReport third) equals: 'Extracción por 50.'.
	self assert: (accountSummaryReport fourth) equals: 'Entrada por transferencia de 100.'.
	self assert: (accountSummaryReport fifth) equals: 'Depósito por 101.'.
	self assert: (accountSummaryReport sixth) equals: 'Balance = 151'.
	
	self assert: (accountSummaryReport size) equals: 6.! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 17:04:26'!
test15TransferNetForEmptyPortfolio

	| portfolio transferNetReport|
	
	portfolio := Portfolio new.

	transferNetReport := ((TransferNet for: portfolio) generateTransferNet).
	
	self assert: transferNetReport equals: 0
! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 17:06:16'!
test16TransferNetForPortfolioWithOneAccount

	| account portfolio transferNetReport|
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
	portfolio := Portfolio with: account.
	
	transferNetReport := ((TransferNet for: portfolio) generateTransferNet).
	
	self assert: transferNetReport equals: 0
	! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 17:08:41'!
test17TransferNetForPortfolioWithTwoAccountsAndTransfers

	| senderAccount receptiveAccount portfolio transferNetReport|
	
	senderAccount := ReceptiveAccount new.
	Withdraw register: 50 on: senderAccount.
		
	receptiveAccount := ReceptiveAccount new.
	Deposit register: 1000 on: receptiveAccount.
	
	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	portfolio := Portfolio with: senderAccount with: receptiveAccount.
	
	transferNetReport := ((TransferNet for: portfolio) generateTransferNet).
	
	self assert: transferNetReport equals: 0! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 17:10:09'!
test18TransferNetForPortfolioWithOneAccountAndTransfers

	| senderAccount receptiveAccount portfolio transferNetReport|
	
	senderAccount := ReceptiveAccount new.
	Withdraw register: 50 on: senderAccount.
		
	receptiveAccount := ReceptiveAccount new.
	Deposit register: 1000 on: receptiveAccount.
	
	Transfer from: senderAccount to: receptiveAccount forAmount: 100.
	portfolio := Portfolio with: receptiveAccount.
	
	transferNetReport := ((TransferNet for: portfolio) generateTransferNet).
	
	self assert: transferNetReport equals: 100! !

!ReportTest methodsFor: 'testing' stamp: 'GG 10/24/2023 17:15:40'!
test19TransferNetForPortfolioIsGeneratedRecursively
 
	| simplePortfolioAccount simplePortfolio composedPortfolioAccount1 composedPortfolioAccount2 accountOutsidePortfolio
	composedPortfolio transferNetReport |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount1 := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount1.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount1.
		
	composedPortfolioAccount2 := ReceptiveAccount new.
	Deposit register: 101 on: composedPortfolioAccount2.
	composedPortfolio add: composedPortfolioAccount2.
	
	accountOutsidePortfolio := ReceptiveAccount new.
	
	Transfer from: simplePortfolioAccount to: composedPortfolioAccount1 forAmount: 100.
	Transfer from: simplePortfolioAccount to: accountOutsidePortfolio forAmount: 320.
	
	transferNetReport := ((TransferNet for: composedPortfolio) generateTransferNet).
	
	self assert: transferNetReport equals: -320
	! !

!ReportTest methodsFor: 'testing' stamp: 'NMS 10/25/2023 12:05:03'!
test20CasoGeneralPENDINGDEHACER
 
	| simplePortfolioAccount simplePortfolio composedPortfolioAccount1 composedPortfolioAccount2 accountOutsidePortfolio
	composedPortfolio transferNetReport |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount1 := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount1.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount1.
		
	composedPortfolioAccount2 := ReceptiveAccount new.
	Deposit register: 101 on: composedPortfolioAccount2.
	composedPortfolio add: composedPortfolioAccount2.
	
	accountOutsidePortfolio := ReceptiveAccount new.
	
	Transfer from: simplePortfolioAccount to: composedPortfolioAccount1 forAmount: 100.
	Transfer from: simplePortfolioAccount to: accountOutsidePortfolio forAmount: 320.
	
	transferNetReport := ((TransferNet for: composedPortfolio) generateTransferNet).
	
	self assert: transferNetReport equals: -320
	! !


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
	instanceVariableNames: 'accountName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'NMS 10/25/2023 13:55:21'!
treeDepth

	self subclassResponsibility! !


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


!Account methodsFor: 'reporting' stamp: 'GG 10/24/2023 15:36:00'!
generateReport: aReport

	self subclassResponsibility! !


!Account methodsFor: 'accessing' stamp: 'NMS 10/25/2023 12:31:38'!
accountName
	^accountName! !


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


!Portfolio methodsFor: 'initialization' stamp: 'NMS 10/25/2023 12:35:20'!
initialize
	self initializeNamed: 'Portfolio sin nombre'! !

!Portfolio methodsFor: 'initialization' stamp: 'NMS 10/25/2023 12:35:07'!
initializeNamed: anAccountName
	accounts := OrderedCollection new.
	parents := OrderedCollection new.
	accountName := anAccountName! !


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


!Portfolio methodsFor: 'reporting' stamp: 'gg 10/26/2023 00:28:58'!
generateIndentatedReport: aReport

	aReport addPortfolioToReport: self! !

!Portfolio methodsFor: 'reporting' stamp: 'gg 10/26/2023 00:09:33'!
generateReport: aReport

	accounts do: [:anAccount |
		anAccount generateReport: aReport
	]! !

!Portfolio methodsFor: 'reporting' stamp: 'gg 10/26/2023 00:37:17'!
loopAccountContentForReport: aReport

	accounts do: [:anAccount | anAccount generateIndentatedReport: aReport].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'NMS 10/25/2023 12:26:11'!
named: anAccountName
	^self new initializeNamed: anAccountName! !

!Portfolio class methodsFor: 'instance creation' stamp: 'NMS 10/25/2023 12:53:19'!
named: anAccountName with: anAccount

	^self new initializeNamed: anAccountName;
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'instance creation' stamp: 'NMS 10/25/2023 12:54:24'!
named: anAccountName with: anAccount with: anotherAccount

	^self new initializeNamed: anAccountName;
		add: anAccount;
		add: anotherAccount;
		yourself! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'instance creation' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!Portfolio class methodsFor: 'error messages' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NMS 10/25/2023 12:36:08'!
initialize
	super initialize.
	self initializeNamed: 'Receptive Account sin nombre'! !

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NMS 10/25/2023 12:34:45'!
initializeNamed: anAccountName
	accountName := anAccountName.
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


!ReceptiveAccount methodsFor: 'reporting' stamp: 'gg 10/26/2023 00:41:09'!
generateIndentatedReport: aReport

	aReport addReceptiveAccountToReport: self.! !

!ReceptiveAccount methodsFor: 'reporting' stamp: 'gg 10/26/2023 00:09:38'!
generateReport: aReport

	transactions do: [:aTransaction |
		aTransaction doOperationFor: aReport
	]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ReceptiveAccount class' category: 'Portfolio-Solucion'!
ReceptiveAccount class
	instanceVariableNames: ''!

!ReceptiveAccount class methodsFor: 'instance creation' stamp: 'NMS 10/25/2023 12:19:22'!
named: anAccountName
	^self new initializeNamed: anAccountName! !


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


!AccountTransaction methodsFor: 'reporting - private' stamp: 'NMS 10/25/2023 11:52:54'!
doOperationFor: aReport

	self subclassResponsibility! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
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


!Deposit methodsFor: 'reporting - private' stamp: 'NMS 10/25/2023 11:53:30'!
doOperationFor: aReport
	aReport doOperationForADeposit: self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !

!Deposit class methodsFor: 'instance creation' stamp: 'NMS 10/23/2023 21:33:44'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #DepositLeg category: 'Portfolio-Solucion'!
AccountTransaction subclass: #DepositLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!DepositLeg methodsFor: 'initilization' stamp: 'NMS 10/21/2023 12:17:42'!
initializeWith: aTransfer on: aReceptiveAccount
	transfer := aTransfer.
	aReceptiveAccount 	register: self.
! !


!DepositLeg methodsFor: 'accessing' stamp: 'NMS 10/21/2023 12:09:00'!
transfer
	^transfer! !

!DepositLeg methodsFor: 'accessing' stamp: 'NMS 10/21/2023 12:26:45'!
value
	^transfer value! !


!DepositLeg methodsFor: 'reporting - private' stamp: 'NMS 10/25/2023 11:53:26'!
doOperationFor: aReport
	aReport doOperationForADepositLeg: self! !


!DepositLeg methodsFor: 'balance' stamp: 'NMS 10/21/2023 12:21:52'!
affectBalance: aBalance
	^aBalance + transfer value ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DepositLeg class' category: 'Portfolio-Solucion'!
DepositLeg class
	instanceVariableNames: ''!

!DepositLeg class methodsFor: 'instance creation' stamp: 'NMS 10/21/2023 12:16:21'!
on: aReceptiveAccount with: aTransfer
	^self new initializeWith: aTransfer on: aReceptiveAccount ! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
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


!Withdraw methodsFor: 'reporting - private' stamp: 'NMS 10/25/2023 11:53:45'!
doOperationFor: aReport
	aReport doOperationForAWithdraw: self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !

!Withdraw class methodsFor: 'instance creation' stamp: 'NMS 10/23/2023 21:33:44'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #WithdrawLeg category: 'Portfolio-Solucion'!
AccountTransaction subclass: #WithdrawLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

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


!WithdrawLeg methodsFor: 'reporting - private' stamp: 'NMS 10/25/2023 11:53:55'!
doOperationFor: aReport
	aReport doOperationForAWithdrawLeg: self! !


!WithdrawLeg methodsFor: 'balance' stamp: 'NMS 10/21/2023 12:22:48'!
affectBalance: aBalance
	^aBalance - transfer value ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'WithdrawLeg class' category: 'Portfolio-Solucion'!
WithdrawLeg class
	instanceVariableNames: ''!

!WithdrawLeg class methodsFor: 'instance creation' stamp: 'NMS 10/21/2023 12:22:24'!
on: aReceptiveAccount with: aTransfer
	^self new initializeWith: aTransfer on: aReceptiveAccount ! !


!classDefinition: #PortfolioStructure category: 'Portfolio-Solucion'!
Object subclass: #PortfolioStructure
	instanceVariableNames: 'report portfolio indentation'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioStructure methodsFor: 'initialization' stamp: 'gg 10/25/2023 23:55:40'!
initializeWith: aPortfolio

	portfolio := aPortfolio.
	report := OrderedCollection new.
	indentation := ''! !


!PortfolioStructure methodsFor: 'report generation' stamp: 'gg 10/26/2023 00:26:18'!
generatePortfolioStructure

	portfolio generateIndentatedReport: self.
	^report
"	report add: portfolio accountName.
	portfolio accountsIsEmpty ifFalse: [	report add: '    Cuenta de Hernan'; add: '    Cuenta de Juan'].
	^report"! !


!PortfolioStructure methodsFor: 'report generation - private' stamp: 'gg 10/26/2023 00:55:51'!
addPortfolioToReport: aPortfolio
	
	report add: indentation, aPortfolio accountName.
	indentation := indentation, '    '.

	aPortfolio loopAccountContentForReport: self.
	
	indentation copyReplaceFrom: (indentation size + 1 - 4) to: (indentation size) with: ''.! !

!PortfolioStructure methodsFor: 'report generation - private' stamp: 'gg 10/26/2023 00:39:44'!
addReceptiveAccountToReport: aReceptiveAccount
	
	report add: indentation, aReceptiveAccount accountName.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PortfolioStructure class' category: 'Portfolio-Solucion'!
PortfolioStructure class
	instanceVariableNames: ''!

!PortfolioStructure class methodsFor: 'instance creation' stamp: 'gg 10/26/2023 00:15:16'!
for: aPortfolio

	^self new initializeWith: aPortfolio ! !


!classDefinition: #Report category: 'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Report methodsFor: 'initialization' stamp: 'NMS 10/25/2023 12:12:46'!
initializeWith: anAccount
	account := anAccount! !


!Report methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 13:19:11'!
doOperationForADeposit: aTransaction

	self subclassResponsibility! !

!Report methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 13:19:17'!
doOperationForADepositLeg: aTransaction

	self subclassResponsibility! !

!Report methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 13:19:39'!
doOperationForAWithdraw: aTransaction

	self subclassResponsibility! !

!Report methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 13:19:45'!
doOperationForAWithdrawLeg: aTransaction

	self subclassResponsibility! !

!Report methodsFor: 'report generation - private' stamp: 'GG 10/24/2023 15:21:38'!
processForTransaction: aTransaction

	self subclassResponsibility! !


!Report methodsFor: 'report generation' stamp: 'NMS 10/25/2023 13:18:29'!
doOperationForAPortfolio: aPortfolio

	self subclassResponsibility! !

!Report methodsFor: 'report generation' stamp: 'NMS 10/25/2023 13:18:36'!
doOperationForAReceptiveAccount: aReceptiveAccount

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Report class' category: 'Portfolio-Solucion'!
Report class
	instanceVariableNames: ''!

!Report class methodsFor: 'instance creation' stamp: 'GG 10/24/2023 17:00:13'!
for: anAccount

	^self new initializeWith: anAccount ! !


!classDefinition: #AccountSummary category: 'Portfolio-Solucion'!
Report subclass: #AccountSummary
	instanceVariableNames: 'report'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummary methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 11:58:22'!
doOperationForADeposit: aTransaction
	report add: 'Depósito por ', (aTransaction value asString), '.'! !

!AccountSummary methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 12:01:22'!
doOperationForADepositLeg: aTransaction
	report add: 'Entrada por transferencia de ', (aTransaction value asString), '.'! !

!AccountSummary methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 12:00:57'!
doOperationForAWithdraw: aTransaction
	report add: 'Extracción por ', (aTransaction value asString), '.'
	! !

!AccountSummary methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 12:01:50'!
doOperationForAWithdrawLeg: aTransaction
	report add: 'Salida por transferencia de ', (aTransaction value asString), '.'
! !


!AccountSummary methodsFor: 'report generation' stamp: 'GG 10/24/2023 16:58:41'!
generateAccountSummary

	account generateReport: self.
	report add: ('Balance = ', account balance asString).
	
	^report! !


!AccountSummary methodsFor: 'initialization' stamp: 'GG 10/24/2023 16:59:37'!
initializeWith: anAccount

	super initializeWith: anAccount.
	report := OrderedCollection new.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummary class' category: 'Portfolio-Solucion'!
AccountSummary class
	instanceVariableNames: 'receptiveAccount'!


!classDefinition: #TransferNet category: 'Portfolio-Solucion'!
Report subclass: #TransferNet
	instanceVariableNames: 'transferNet'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNet methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 12:03:20'!
doOperationForADeposit: aTransaction
! !

!TransferNet methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 12:03:34'!
doOperationForADepositLeg: aTransaction
	transferNet := transferNet + aTransaction value! !

!TransferNet methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 11:54:48'!
doOperationForAWithdraw: aTransaction! !

!TransferNet methodsFor: 'report generation - private' stamp: 'NMS 10/25/2023 12:03:43'!
doOperationForAWithdrawLeg: aTransaction
	transferNet := transferNet - aTransaction value! !


!TransferNet methodsFor: 'report generation' stamp: 'GG 10/24/2023 16:58:41'!
generateTransferNet

	account generateReport: self.

	^ transferNet ! !


!TransferNet methodsFor: 'initialization' stamp: 'GG 10/24/2023 16:59:50'!
initializeWith: anAccount

	super initializeWith: anAccount.	
	transferNet := 0.! !


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
