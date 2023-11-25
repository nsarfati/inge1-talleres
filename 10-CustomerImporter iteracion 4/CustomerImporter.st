!classDefinition: #PersistentSet category: 'CustomerImporter'!
Set subclass: #PersistentSet
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSet methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:31'!
initializeOn: aSession from: aNonPersistentSet

	session := aSession.
	self addAll: aNonPersistentSet ! !


!PersistentSet methodsFor: 'adding' stamp: 'HAW 11/14/2023 08:23:40'!
add: newObject

	super add: newObject.
	session persist: newObject.
	
	^newObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSet class' category: 'CustomerImporter'!
PersistentSet class
	instanceVariableNames: ''!

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:24:32'!
on: aSession

	^self on: aSession from: #()! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:25:00'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet
! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:39:51'!
test01SupplierWithNoAddressesOrCustomersIsImportedCorrectly

	|stream |
	
	stream := ReadStream on: 'S,Supplier1,D,123'.
	SupplierImporter valueFrom: stream into: system.

	self assertSupplierWithNoAddressesAndCustomerImportedCorrectly! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'gg 11/23/2023 19:11:01'!
test02CanNotImportSupplierRecordWithMoreThanFourFields

	self
		should: [ 	SupplierImporter valueFrom: (ReadStream on: 'S,Supplier1,D,123,xx') into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter invalidSupplierRecordErrorDescription.
			self assert: system numberOfSuppliers equals: 0]

! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'gg 11/23/2023 19:11:15'!
test03CanNotImportSupplierRecordWithLessThanFourFields

	self
		should: [ 	SupplierImporter valueFrom: (ReadStream on: 'S,Supplier1,D') into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter invalidSupplierRecordErrorDescription.
			self assert: system numberOfSuppliers equals: 0]

! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:42:51'!
test04SupplierWithAddressesIsImportedCorrectly

	SupplierImporter valueFrom: self supplierWithAddresses into: system.
		
	self assertSupplierWithTwoAddressesAndNoCustomersIsImportedCorrectly! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/23/2023 20:32:00'!
test05CannotImportEmptyLine

	self
		should: [ 	SupplierImporter valueFrom: self emptyLine into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter invalidRecordTypeErrorDescription.
			self assert: system numberOfSuppliers equals: 0]	! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/23/2023 20:36:22'!
test06CanNotImportAddressWithoutSupplier

	self
		should: [ SupplierImporter valueFrom: self addressWithoutPartyData into: system. ]
		raise: Error - MessageNotUnderstood
		withMessageText: SupplierImporter canNotImportAddressWithoutPartyErrorDescription! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/23/2023 20:38:38'!
test07DoesNotImportRecordsStartingWithSButMoreCharacters

	self
		should: [ 	SupplierImporter valueFrom: (ReadStream on: 'SS,Supplier1,D,123') into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter invalidRecordTypeErrorDescription.
			self assert: system numberOfSuppliers equals: 0]! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:53:08'!
test08SupplierWithNewCustomerIsImportedCorrectly

	|stream |
	
	stream := ReadStream on:
'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444'.

	SupplierImporter valueFrom: stream into: system.

	self assert: system numberOfCustomers equals: 1.
	self assertSupplierWithNoAddressesAndOneCustomerIsImportedCorrectly! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:47:48'!
test09CanNotImportNewCustomerForSupplierWithMoreThanFiveFields

	|stream |
	
	stream := ReadStream on:
'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444,XX'.

	self
		should: [ 	SupplierImporter valueFrom: stream into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PartyImporter invalidCustomerRecordErrorDescription.
		].

	self assertSupplierWithNoAddressesAndCustomerImportedCorrectly.! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:48:04'!
test10CanNotImportNewCustomerForSupplierWithLessThanFiveFields

	|stream |
	
	stream := ReadStream on:
'S,Supplier1,D,123
NC,Pepe,Sanchez,D,'.

	self
		should: [ 	SupplierImporter valueFrom: stream into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PartyImporter invalidCustomerRecordErrorDescription.
		].

	self assertSupplierWithNoAddressesAndCustomerImportedCorrectly! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:48:37'!
test11DoesNotImportNewCustomerForSupplierWithNCButMoreCharacters

	|stream |
	
	stream := ReadStream on:
'S,Supplier1,D,123
NCC,Pepe,Sanchez,D,'.

	self
		should: [ 	SupplierImporter valueFrom: stream into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PartyImporter invalidRecordTypeErrorDescription .
		].

	self assertSupplierWithNoAddressesAndCustomerImportedCorrectly! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 13:00:20'!
test12CanNotImportANewCustomerWithoutSupplier

	|stream |
	
	stream := ReadStream on:
'NC,Pepe,Sanchez,D,22333444'.

	self
		should: [ 	SupplierImporter valueFrom: stream into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter canNotImportCustomerWithoutPartyErrorDescription.
			self assert: system numberOfSuppliers equals: 0.
			self assert: system numberOfCustomers equals: 0.
		].! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:56:38'!
test13SupplierWithExistingCustomerIsImportedCorrectly

	|stream |
	
	stream := ReadStream on:
'S,Supplier1,D,123,
EC,D,22333444'.

	self importValidCustomersAndAssertThem.
		
	SupplierImporter valueFrom: stream into: system.

	self assertSupplierWithNoAddressesAndOneCustomerIsImportedCorrectly! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 15:00:46'!
test14DoesNotImportExistingCustomerForSupplierWithECButMoreCharacters

	|stream |
	
	stream := ReadStream on:
'S,Supplier1,D,123,
ECX,D,22333444'.

	self importValidCustomersAndAssertThem.
	
	self
		should: [ 	SupplierImporter valueFrom: stream into: system ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: PartyImporter invalidRecordTypeErrorDescription .
		].	

	self assert: system numberOfSuppliers equals: 1.
	self assert: system numberOfCustomers equals: 2.
	
	self assertSupplierWithNoAddressesAndNoCustomerIsImportedCorrectly! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:23:02'!
test15CanNotImportExistingCustomerForSupplierWithMoreThanThreeFields

	|stream supplier|
	
	stream := ReadStream on:
'S,Supplier1,D,123,
EC,D,22333444,XXXXX'.

	self importValidCustomersAndAssertThem.
	
	self
		should: [ 	SupplierImporter valueFrom: stream into: system ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter invalidExistingCustomerRecordErrorDescription.
		].	

	self assert: system numberOfSuppliers equals: 1.
	self assert: system numberOfCustomers equals: 2.
	
	supplier := system supplierWithIdentificationType: 'D' number: '123'.
	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	self assert: supplier isAddressesEmpty.
	self assert: supplier numberOfCustomers equals: 0.! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:23:07'!
test16CanNotImportExistingCustomerForSupplierWithLessThanThreeFields

	|stream supplier|
	
	stream := ReadStream on:
'S,Supplier1,D,123,
EC,D,'.

	self importValidCustomersAndAssertThem.
	
	self
		should: [ 	SupplierImporter valueFrom: stream into: system ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter invalidExistingCustomerRecordErrorDescription.
		].	

	self assert: system numberOfSuppliers equals: 1.
	self assert: system numberOfCustomers equals: 2.
	
	supplier := system supplierWithIdentificationType: 'D' number: '123'.
	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	self assert: supplier isAddressesEmpty.
	self assert: supplier numberOfCustomers equals: 0.! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:23:10'!
test17CanNotImportANonExistingCustomerAsExistingCustomerForSupplier

	|stream supplier|
	
	stream := ReadStream on:
'S,Supplier1,D,123,
EC,D,666'.

	self importValidCustomersAndAssertThem.
	
	self
		should: [ 	SupplierImporter valueFrom: stream into: system ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter existingCustomerNotFound .
		].	

	self assert: system numberOfSuppliers equals: 1.
	self assert: system numberOfCustomers equals: 2.
	
	supplier := system supplierWithIdentificationType: 'D' number: '123'.
	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	self assert: supplier isAddressesEmpty.
	self assert: supplier numberOfCustomers equals: 0.! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:23:16'!
test18CanNotImportSameExistingCustomerMoreThanOnceForSupplier

	|stream supplier|
	
	stream := ReadStream on:
'S,Supplier1,D,123,
EC,D,22333444
EC,D,22333444'.

	self importValidCustomersAndAssertThem.
	
	self
		should: [ 	SupplierImporter valueFrom: stream into: system ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter customerAlreadyAddedToSupplier .
		].	

	self assert: system numberOfSuppliers equals: 1.
	self assert: system numberOfCustomers equals: 2.
	
	supplier := system supplierWithIdentificationType: 'D' number: '123'.
	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	self assert: supplier isAddressesEmpty.
	self assert: supplier numberOfCustomers equals: 1.

	self assert: (supplier doesAnyCustomerSatisfyFirstNamedAs: 'Pepe' lastNamedAs: 'Sanchez' andIdentifiedAs: 'D' numbered: '22333444').
! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:23:20'!
test19CanNotImportAnExistingCustomerWithoutSupplier

	|stream |
	
	stream := ReadStream on:
'EC,D,22333444'.

	self importValidCustomersAndAssertThem.
	
	self
		should: [ 	SupplierImporter valueFrom: stream into: system]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter canNotImportCustomerWithoutPartyErrorDescription.
			self assert: system numberOfSuppliers equals: 0.
		].! !

!ImportTest methodsFor: 'tests - supplier' stamp: 'NMS 11/25/2023 14:33:38'!
test20CanNotImportSameNewCustomerMoreThanOnceForSupplier

	|stream supplier|
	
	stream := ReadStream on:
'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
NC,Pepe,Sanchez,D,22333444'.

	self
		should: [ 	SupplierImporter valueFrom: stream into: system ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: SupplierImporter customerAlreadyAddedToSupplier .
		].	

	self assert: system numberOfSuppliers equals: 1.
	self assert: system numberOfCustomers equals: 1.
	
	supplier := system supplierWithIdentificationType: 'D' number: '123'.
	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	self assert: supplier isAddressesEmpty.
	self assert: supplier numberOfCustomers equals: 1.
	self assert: (supplier doesAnyCustomerSatisfyFirstNamedAs: 'Pepe' lastNamedAs: 'Sanchez' andIdentifiedAs: 'D' numbered: '22333444')! !


!ImportTest methodsFor: 'tests - customer' stamp: 'NMS 11/25/2023 14:22:47'!
test01ValidDataIsImportedCorrectly

	self importValidCustomersAndAssertThem ! !

!ImportTest methodsFor: 'tests - customer' stamp: 'NMS 11/23/2023 20:35:36'!
test02CanNotImportAddressWithoutCustomer

	self
		should: [ CustomerImporter valueFrom: self addressWithoutPartyData into: system. ]
		raise: Error - MessageNotUnderstood
		withMessageText: CustomerImporter canNotImportAddressWithoutPartyErrorDescription

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:56:58'!
test03DoesNotImportRecordsStartingWithCButMoreCharacters

	self
		shouldFailImporting: self invalidCustomerRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:49:03'!
test04DoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:49:36'!
test05CanNotImportAddressRecordWithLessThanSixFields

	self
		shouldFailImporting: self addressRecordWithLessThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:51:14'!
test06CanNotImportAddressRecordWithMoreThanSixFields

	self
		shouldFailImporting: self addressRecordWithMoreThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:56:58'!
test07CanNotImportCustomerRecordWithLessThanFiveFields

	self
		shouldFailImporting: self customerRecordWithLessThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 19:56:58'!
test08CanNotImportCustomerRecordWithMoreThanFiveFields

	self
		shouldFailImporting: self customerRecordWithMoreThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'HAW 5/22/2022 20:01:43'!
test09CannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ImportTest methodsFor: 'tests - customer' stamp: 'NMS 11/25/2023 13:24:26'!
test10CanNotImportSameCustomerMoreThanOnce

	self
		should: [ 	CustomerImporter valueFrom: self invalidImportData into: system ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: CustomerImporter customerAlreadyAddedErrorDescription .
		].	

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'NMS 11/25/2023 13:54:21'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := system customerWithIdentificationType: anIdType number: anIdNumber withNotFoundBlock: [self fail].

	self assert: (importedCustomer isNamedAs: aFirstName andLastNamedAs: aLastName).
	self assert: (importedCustomer isIdentifiedAs: anIdType numbered: anIdNumber).

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'NMS 11/25/2023 13:54:47'!
assertImportedOneCustomerWithoutAddress

	| importedCustomer |

	self assert: 1 equals: system numberOfCustomers.
	importedCustomer := system customerWithIdentificationType: 'D' number: '22333444' withNotFoundBlock: [self fail].
	self assert: importedCustomer isAddressesEmpty
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:24'!
assertNoCustomerWasImported

	^ self assert: 0 equals: system numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!ImportTest methodsFor: 'assertions' stamp: 'NMS 11/25/2023 14:22:47'!
importValidCustomersAndAssertThem

	CustomerImporter valueFrom: self validImportData into: system.

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:15:52'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ CustomerImporter valueFrom: aReadStream into: system. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]

	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 21:36:16'!
setUp

	system := Environment current createCustomerSystem.
	system start.
	system beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 20:12:16'!
tearDown

	system commit.
	system stop
	! !


!ImportTest methodsFor: 'assertions - supplier' stamp: 'NMS 11/25/2023 15:01:41'!
assertSupplierWithNoAddressesAndCustomerImportedCorrectly

	self assert: system numberOfCustomers equals: 0.
	self assert: system numberOfSuppliers equals: 1.

	self assertSupplierWithNoAddressesAndNoCustomerIsImportedCorrectly! !

!ImportTest methodsFor: 'assertions - supplier' stamp: 'NMS 11/25/2023 15:01:06'!
assertSupplierWithNoAddressesAndNoCustomerIsImportedCorrectly

	| supplier |

	supplier := system supplierWithIdentificationType: 'D' number: '123'.

	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	self assert: supplier isAddressesEmpty.
	self assert: supplier isCustomersEmpty! !

!ImportTest methodsFor: 'assertions - supplier' stamp: 'NMS 11/25/2023 14:54:26'!
assertSupplierWithNoAddressesAndOneCustomerIsImportedCorrectly

	| supplier |

	supplier := system supplierWithIdentificationType: 'D' number: '123'.

	self assert: system numberOfSuppliers equals: 1.

	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	self assert: supplier isAddressesEmpty.
	self assert: supplier numberOfCustomers equals: 1.
	
	self assert: (supplier doesAnyCustomerSatisfyFirstNamedAs: 'Pepe' lastNamedAs: 'Sanchez' andIdentifiedAs: 'D' numbered: '22333444')! !

!ImportTest methodsFor: 'assertions - supplier' stamp: 'NMS 11/25/2023 14:42:13'!
assertSupplierWithTwoAddressesAndNoCustomersIsImportedCorrectly

	| supplier |

	supplier := system supplierWithIdentificationType: 'D' number: '123'.

	self assert: system numberOfSuppliers equals: 1.
	self assert: (supplier isNamedAs: 'Supplier1').
	self assert: (supplier isIdentifiedAs: 'D' numbered: '123').
	
	self assertAddressOf: supplier at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: supplier at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'! !


!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:41:20'!
addressRecordWithLessThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:51:35'!
addressRecordWithMoreThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,x'! !

!ImportTest methodsFor: 'test data' stamp: 'NMS 11/23/2023 20:34:39'!
addressWithoutPartyData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:53:41'!
customerRecordWithLessThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:55:59'!
customerRecordWithMoreThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444,x'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 20:02:57'!
emptyLine

	^ReadStream on: '
'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:34:25'!
invalidAddressRecordStartData

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:22:55'!
invalidCustomerRecordStartData

	^ReadStream on: 'CC,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'NMS 11/25/2023 13:18:37'!
invalidImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA
C,Pepe,Sanchez,D,22333444'! !

!ImportTest methodsFor: 'test data' stamp: 'gg 11/23/2023 19:20:09'!
supplierWithAddresses

	^ ReadStream on: 
'S,Supplier1,D,123
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #CSVImporter category: 'CustomerImporter'!
Object subclass: #CSVImporter
	instanceVariableNames: 'line readStream record system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVImporter methodsFor: 'evaluating' stamp: 'gg 11/23/2023 18:48:34'!
value

	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord ].

	! !


!CSVImporter methodsFor: 'initialization' stamp: 'gg 11/23/2023 18:48:44'!
initializeFrom: aReadStream into: aCustomerSystem

	readStream := aReadStream.
	system := aCustomerSystem ! !


!CSVImporter methodsFor: 'evaluating - private' stamp: 'gg 11/23/2023 18:49:07'!
assertRecordNotEmpty

	record isEmpty ifTrue: [ self error: self class invalidRecordTypeErrorDescription ]! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'gg 11/23/2023 18:49:20'!
createRecord

	^ record := line findTokens: $,! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'gg 11/23/2023 18:49:14'!
hasLineToImport

	line := readStream nextLine.
	^line notNil! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'gg 11/23/2023 18:49:30'!
importRecord

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CSVImporter class' category: 'CustomerImporter'!
CSVImporter class
	instanceVariableNames: ''!

!CSVImporter class methodsFor: 'error messages' stamp: 'gg 11/23/2023 18:49:48'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !


!CSVImporter class methodsFor: 'importing' stamp: 'gg 11/23/2023 18:49:53'!
valueFrom: aReadStream into: aCustomerSystem

	^(self from: aReadStream into: aCustomerSystem) value! !


!CSVImporter class methodsFor: 'instance creation' stamp: 'gg 11/23/2023 18:50:00'!
from: aReadStream into: aCustomerSystem

	^self new initializeFrom: aReadStream into: aCustomerSystem! !


!classDefinition: #PartyImporter category: 'CustomerImporter'!
CSVImporter subclass: #PartyImporter
	instanceVariableNames: 'newParty'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartyImporter methodsFor: 'address' stamp: 'NMS 11/23/2023 21:21:04'!
assertPartyWasImportedForAddress

	^ newParty ifNil: [ self error: self class canNotImportAddressWithoutPartyErrorDescription ]! !

!PartyImporter methodsFor: 'address' stamp: 'gg 11/23/2023 18:51:38'!
assertValidAddressRecord

	^ record size ~= 6 ifTrue: [ self error: self class invalidAddressRecordErrorDescription ]! !

!PartyImporter methodsFor: 'address' stamp: 'NMS 11/23/2023 21:21:04'!
importAddress

	| newAddress |

	self assertPartyWasImportedForAddress.
	self assertValidAddressRecord.

	newAddress := Address new.
	newParty addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth! !

!PartyImporter methodsFor: 'address' stamp: 'gg 11/23/2023 18:51:53'!
isAddressRecord

	^ record first = 'A'! !


!PartyImporter methodsFor: 'evaluating - private' stamp: 'NMS 11/23/2023 20:21:55'!
importRecord

	self subclassResponsibility ! !


!PartyImporter methodsFor: 'customer' stamp: 'NMS 11/25/2023 13:35:18'!
addCustomerToSystem

	| newCustomer |
	
	newCustomer := Customer firstNamedAs: record second lastNamedAs: record third withIdentificationType: record fourth numbered: record fifth.
	system add: newCustomer.
	
	^newCustomer! !

!PartyImporter methodsFor: 'customer' stamp: 'NMS 11/23/2023 20:57:35'!
assertValidCustomerRecord

	^ record size ~= 5 ifTrue: [ self error: self class invalidCustomerRecordErrorDescription ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PartyImporter class' category: 'CustomerImporter'!
PartyImporter class
	instanceVariableNames: ''!

!PartyImporter class methodsFor: 'error messages' stamp: 'NMS 11/23/2023 20:36:00'!
canNotImportAddressWithoutPartyErrorDescription

	^'Cannot import address without party'! !

!PartyImporter class methodsFor: 'error messages' stamp: 'NMS 11/23/2023 21:12:40'!
invalidCustomerRecordErrorDescription

	^'Invalid Customer record'! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
PartyImporter subclass: #CustomerImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'customer' stamp: 'NMS 11/25/2023 13:23:46'!
importCustomer
	self assertValidCustomerRecord.
	
	system customerWithIdentificationType: record fourth number: record fifth withNotFoundBlock: [
		^newParty := self addCustomerToSystem
	].

	self error: self class customerAlreadyAddedErrorDescription! !

!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:23:55'!
isCustomerRecord

	^ record first = 'C'! !


!CustomerImporter methodsFor: 'evaluating - private' stamp: 'NMS 11/23/2023 21:36:54'!
importRecord

	self assertRecordNotEmpty.

	self isCustomerRecord ifTrue: [ ^self importCustomer ].
	self isAddressRecord ifTrue: [ ^self importAddress ].

	self error: self class invalidRecordTypeErrorDescription! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!



!CustomerImporter class methodsFor: 'error messages' stamp: 'NMS 11/25/2023 13:19:19'!
customerAlreadyAddedErrorDescription
	^'Customer already added'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'HAW 5/22/2022 19:41:39'!
invalidAddressRecordErrorDescription

	^'Address record has to have six fields'! !


!classDefinition: #SupplierImporter category: 'CustomerImporter'!
PartyImporter subclass: #SupplierImporter
	instanceVariableNames: 'newSupplier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImporter methodsFor: 'evaluating - private' stamp: 'NMS 11/25/2023 12:05:34'!
importRecord
	
	self assertRecordNotEmpty.
	
	self isSupplierRecord ifTrue: [^self importSupplier].

	self isAddressRecord ifTrue: [ ^self importAddress ].

	self isNewCustomerRecord ifTrue: [ ^self importNewCustomer ].
	
	self isExistingCustomerRecord ifTrue: [ ^self importExistingCustomer ].

	self error: self class invalidRecordTypeErrorDescription! !


!SupplierImporter methodsFor: 'supplier' stamp: 'gg 11/23/2023 19:07:14'!
assertValidSupplierRecord
	
	^ record size ~= 4 ifTrue: [ self error: self class  invalidSupplierRecordErrorDescription]! !

!SupplierImporter methodsFor: 'supplier' stamp: 'NMS 11/23/2023 20:15:12'!
importSupplier

	self assertValidSupplierRecord.
	newParty := Supplier named: record second identificationType: record third numbered: record fourth.
	system addSupplier: newParty! !

!SupplierImporter methodsFor: 'supplier' stamp: 'gg 11/23/2023 19:27:11'!
isSupplierRecord

	^ record first = 'S'! !


!SupplierImporter methodsFor: 'customer - new' stamp: 'NMS 11/25/2023 13:27:16'!
importNewCustomer
	| newCustomer |
	
	self assertSupplierWasImportedForCustomer.
	self assertValidCustomerRecord.

	self assertCustomerNotAddedIdentifiedAs: record fourth numbered: record fifth.
	newCustomer := super addCustomerToSystem .

	newParty addCustomer: newCustomer.! !

!SupplierImporter methodsFor: 'customer - new' stamp: 'NMS 11/23/2023 20:59:33'!
isNewCustomerRecord
	^ record first = 'NC'! !


!SupplierImporter methodsFor: 'customer - assertions' stamp: 'NMS 11/25/2023 13:49:03'!
assertCustomerNotAddedIdentifiedAs: anIdentificationType numbered: anIdentificationNumber

	^ (newParty doesAnyCustomerSatisfyIdentifiedAs: anIdentificationType numbered: anIdentificationNumber) ifTrue:[
		self error: self class customerAlreadyAddedToSupplier 
	]! !

!SupplierImporter methodsFor: 'customer - assertions' stamp: 'NMS 11/25/2023 13:27:16'!
assertSupplierWasImportedForCustomer

	^ newParty ifNil: [ self error: self class canNotImportCustomerWithoutPartyErrorDescription ]! !


!SupplierImporter methodsFor: 'customer - existing' stamp: 'NMS 11/25/2023 12:20:14'!
assertValidExistingCustomerRecord
	
	^ record size ~= 3 ifTrue: [ self error: self class invalidExistingCustomerRecordErrorDescription ]! !

!SupplierImporter methodsFor: 'customer - existing' stamp: 'NMS 11/25/2023 13:27:16'!
importExistingCustomer
	| existingCustomer |
	
	self assertSupplierWasImportedForCustomer.
	self assertValidExistingCustomerRecord.

	self assertCustomerNotAddedIdentifiedAs: record second numbered: record third.

	existingCustomer := system customerWithIdentificationType: record second number: record third withNotFoundBlock: [self error: self class existingCustomerNotFound ].

	newParty addCustomer: existingCustomer.! !

!SupplierImporter methodsFor: 'customer - existing' stamp: 'NMS 11/25/2023 12:06:27'!
isExistingCustomerRecord
	^ record first = 'EC'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SupplierImporter class' category: 'CustomerImporter'!
SupplierImporter class
	instanceVariableNames: ''!

!SupplierImporter class methodsFor: 'error messages' stamp: 'NMS 11/25/2023 12:59:37'!
canNotImportCustomerWithoutPartyErrorDescription
	
	^'Cannot import existing customer without party'! !

!SupplierImporter class methodsFor: 'error messages' stamp: 'NMS 11/25/2023 12:39:47'!
customerAlreadyAddedToSupplier

	^ 'Customer already added to supplier'! !

!SupplierImporter class methodsFor: 'error messages' stamp: 'NMS 11/25/2023 12:24:28'!
existingCustomerNotFound
	^ 'Customer not found in system'! !

!SupplierImporter class methodsFor: 'error messages' stamp: 'NMS 11/25/2023 12:19:16'!
invalidExistingCustomerRecordErrorDescription

	^ 'Existing Customer record must have three fields'! !

!SupplierImporter class methodsFor: 'error messages' stamp: 'gg 11/23/2023 19:07:38'!
invalidSupplierRecordErrorDescription

	^ 'Supplier record must have four fields'! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction closed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:25'!
beginTransaction

	inTransaction := true.! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:18'!
commit

	inTransaction := false.! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 11/14/2023 08:52:30'!
close

	closed := true.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:49:30'!
assertCanUseDatabase

	self assertIsOpen.
	self assertInTransaction ! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:43'!
assertInTransaction

	inTransaction ifFalse: [ self error: 'Not in transaction' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:16'!
assertIsOpen

	closed ifTrue: [ self error: 'Connection with database closed' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:09:07'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType name, ' are not configured to be persisted' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
isRelationToPersist: possibleRelation

	^ possibleRelation class = Set! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
persistPossibleRelationOf: anObject at: anInstVarOffset

	| possibleRelation |
		
	possibleRelation := anObject instVarAt: anInstVarOffset.
	(self isRelationToPersist: possibleRelation) ifTrue: [ self persistRelationOf: anObject at: anInstVarOffset with: possibleRelation ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:03'!
persistRelationOf: anObject at: anInstVarOffset with: aRelation

	| persistentRelation |
	
	persistentRelation := PersistentSet on: self from: aRelation.
	anObject instVarAt: anInstVarOffset put: persistentRelation! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:34'!
persistRelationsOf: anObject

	anObject class instVarNamesAndOffsetsDo: [ :anInstVarName :anInstVarOffset | self persistPossibleRelationOf: anObject at: anInstVarOffset]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:06:24'!
tableOfType: aType

	^ tables at: aType ifAbsentPut: [ Set new ]! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:44:19'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	closed := false.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 11/14/2023 09:06:24'!
persist: anObject

	| table |

	self assertCanUseDatabase.
	self assertTypeIsPersisted: anObject class.
	self delay.
	
	table := self tableOfType: anObject class.
	self defineIdOf: anObject.
	table add: anObject.
	self persistRelationsOf: anObject.
! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:06:56'!
select: aCondition ofType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:07:12'!
selectAllOfType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #ERPSystem category: 'CustomerImporter'!
Object subclass: #ERPSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ERPSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:17:57'!
add: aCustomer

	self subclassResponsibility ! !

!ERPSystem methodsFor: 'customers' stamp: 'NMS 11/25/2023 13:55:18'!
customerWithIdentificationType: anIdType number: anIdNumber withNotFoundBlock: aNotFoundBlock

	self subclassResponsibility! !

!ERPSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:51'!
numberOfCustomers

	self subclassResponsibility ! !


!ERPSystem methodsFor: 'suppliers' stamp: 'NMS 11/25/2023 14:04:14'!
addSupplier: aNewSupplier

	self subclassResponsibility! !

!ERPSystem methodsFor: 'suppliers' stamp: 'NMS 11/25/2023 14:04:19'!
numberOfSuppliers

	self subclassResponsibility! !

!ERPSystem methodsFor: 'suppliers' stamp: 'NMS 11/25/2023 14:04:23'!
supplierWithIdentificationType: anIdentificationType number: anIdentificationNumber

	self subclassResponsibility! !


!ERPSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:10'!
start

	self subclassResponsibility ! !

!ERPSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:13'!
stop

	self subclassResponsibility ! !


!ERPSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:04'!
beginTransaction

	self subclassResponsibility ! !

!ERPSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:16'!
commit

	self subclassResponsibility ! !


!classDefinition: #PersistentERPSystem category: 'CustomerImporter'!
ERPSystem subclass: #PersistentERPSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentERPSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:14:14'!
add: aCustomer

	^session persist: aCustomer ! !

!PersistentERPSystem methodsFor: 'customers' stamp: 'NMS 11/25/2023 14:19:22'!
customerWithIdentificationType: anIdType number: anIdNumber withNotFoundBlock: aNotFoundBlock
	
	| resultSet |

	resultSet := (session
		select: [ :aCustomer | aCustomer isIdentifiedAs: anIdType numbered: anIdNumber]
		ofType: Customer).

	(resultSet isEmpty)
		ifTrue: [aNotFoundBlock value]
		ifFalse: [^resultSet anyOne]
! !

!PersistentERPSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:08:47'!
numberOfCustomers

	^(session selectAllOfType: Customer) size! !


!PersistentERPSystem methodsFor: 'suppliers' stamp: 'NMS 11/25/2023 14:07:11'!
addSupplier: aNewSupplier

	^session persist: aNewSupplier! !

!PersistentERPSystem methodsFor: 'suppliers' stamp: 'NMS 11/25/2023 14:09:34'!
numberOfSuppliers

	^(session selectAllOfType: Supplier) size! !

!PersistentERPSystem methodsFor: 'suppliers' stamp: 'NMS 11/25/2023 14:10:49'!
supplierWithIdentificationType: anIdentificationType number: anIdentificationNumber

	^(session
		select: [ :aSupplier | aSupplier isIdentifiedAs: anIdentificationType numbered: anIdentificationNumber]
		ofType: Supplier) anyOne! !


!PersistentERPSystem methodsFor: 'system lifecycle' stamp: 'NMS 11/25/2023 14:06:54'!
start

	session := DataBaseSession for: (Array with: Address with: Customer with: Supplier).
	! !

!PersistentERPSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 20:13:10'!
stop

	session close! !


!PersistentERPSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:12:39'!
beginTransaction

	session beginTransaction.
! !

!PersistentERPSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:13:00'!
commit

	session commit ! !


!classDefinition: #TransientERPSystem category: 'CustomerImporter'!
ERPSystem subclass: #TransientERPSystem
	instanceVariableNames: 'customers suppliers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientERPSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:32'!
add: aCustomer

	customers add: aCustomer ! !

!TransientERPSystem methodsFor: 'customers' stamp: 'NMS 11/25/2023 13:40:34'!
customerWithIdentificationType: anIdType number: anIdNumber withNotFoundBlock: aNotFoundBlock

	^ customers detect: [ :aCustomer | aCustomer isIdentifiedAs: anIdType numbered: anIdNumber] ifNone: aNotFoundBlock! !

!TransientERPSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:43'!
numberOfCustomers

	^customers size! !


!TransientERPSystem methodsFor: 'suppliers' stamp: 'gg 11/23/2023 18:33:23'!
addSupplier: aNewSupplier

	suppliers add: aNewSupplier ! !

!TransientERPSystem methodsFor: 'suppliers' stamp: 'gg 11/23/2023 18:27:25'!
numberOfSuppliers

	^ suppliers size! !

!TransientERPSystem methodsFor: 'suppliers' stamp: 'gg 11/23/2023 18:39:36'!
supplierWithIdentificationType: anIdentificationType number: anIdentificationNumber

	^suppliers detect: [ :aSupplier | aSupplier isIdentifiedAs: anIdentificationType numbered: anIdentificationNumber]! !


!TransientERPSystem methodsFor: 'system lifecycle' stamp: 'gg 11/23/2023 18:28:12'!
start

	customers := OrderedCollection new.
	suppliers := OrderedCollection new.! !

!TransientERPSystem methodsFor: 'system lifecycle' stamp: 'gg 11/23/2023 18:28:21'!
stop

	customers := nil.
	suppliers := nil! !


!TransientERPSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:21:20'!
beginTransaction

	! !

!TransientERPSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:23:01'!
commit

	! !


!classDefinition: #Environment category: 'CustomerImporter'!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Environment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:41:06'!
createCustomerSystem

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: 'CustomerImporter'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:37:10'!
current

	^(self subclasses detect: [ :anEnvironmentClass | anEnvironmentClass isCurrent ]) new! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentKey

	^ #ENV! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentVariable

	^ Smalltalk at: self environmentKey! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:09'!
identifier

	self subclassResponsibility! !

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:41:36'!
isCurrent

	self subclassResponsibility ! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:46:01'!
makeCurrent

	"
	Tener en cuenta que en Smalltalk se podría poner directamente la clase de environment,
	esto es DevelopmentEnvironment o IntegrationEnvironmet o hasta una instancia de ellas,
	pero se está simulando el hecho de que esto esté definido por fuera del sistema, como una
	variable del sistema operativo - Hernan"
	
	Smalltalk at: self environmentKey put: self identifier! !


!classDefinition: #DevelopmentEnvironment category: 'CustomerImporter'!
Environment subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'gg 11/23/2023 18:47:09'!
createCustomerSystem

	^TransientERPSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: 'CustomerImporter'!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:42:50'!
identifier

	^ #DEV! !

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'NMS 11/25/2023 14:20:21'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'gg 11/23/2023 18:46:56'!
createCustomerSystem

	^PersistentERPSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: 'CustomerImporter'!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:07'!
identifier

	^ #INT! !

!IntegrationEnvironment class methodsFor: 'current' stamp: 'NMS 11/25/2023 13:51:40'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #Identification category: 'CustomerImporter'!
Object subclass: #Identification
	instanceVariableNames: 'identificationType identificationNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Identification methodsFor: 'testing' stamp: 'NMS 11/25/2023 14:25:37'!
isIdentifiedAs: anIdentificationType numbered: anIdentificationNumber

	^ identificationType = anIdentificationType and: [identificationNumber = anIdentificationNumber ]! !


!Identification methodsFor: 'initialization' stamp: 'NMS 11/25/2023 14:27:42'!
initializeWithIdentificationType: anIdentificationType numbered: anIdentificationNumber
	identificationType := anIdentificationType.
	identificationNumber := anIdentificationNumber! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Identification class' category: 'CustomerImporter'!
Identification class
	instanceVariableNames: ''!

!Identification class methodsFor: 'instance creation' stamp: 'NMS 11/25/2023 14:26:52'!
withType: anIdentificationType numbered: anIdentificationNumber
	^self new initializeWithIdentificationType: anIdentificationType numbered: anIdentificationNumber! !


!classDefinition: #Party category: 'CustomerImporter'!
Object subclass: #Party
	instanceVariableNames: 'id identification addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Party methodsFor: 'addresses' stamp: 'gg 11/23/2023 18:56:35'!
addAddress: anAddress

	addresses add: anAddress ! !

!Party methodsFor: 'addresses' stamp: 'gg 11/23/2023 18:56:42'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Party methodsFor: 'addresses' stamp: 'gg 11/23/2023 18:57:35'!
isAddressesEmpty

	^addresses isEmpty ! !


!Party methodsFor: 'identification' stamp: 'NMS 11/25/2023 14:32:20'!
isIdentifiedAs: anIdentificationType numbered: anIdentificationNumber

	^ identification isIdentifiedAs: anIdentificationType numbered: anIdentificationNumber ! !


!Party methodsFor: 'initialization' stamp: 'NMS 11/25/2023 14:32:04'!
initializePartyWith: anIdentificationType numbered: anIdentificationNumber 

	identification := Identification withType: anIdentificationType numbered: anIdentificationNumber.
	addresses := OrderedCollection new.! !


!classDefinition: #Customer category: 'CustomerImporter'!
Party subclass: #Customer
	instanceVariableNames: 'firstName lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'initialization' stamp: 'NMS 11/25/2023 13:37:50'!
initializeFirstName: aFirstName lastName: aLastName withIdentificationType: anIdentificationType numbered: anIdentificationNumber
	super initializePartyWith: anIdentificationType numbered: anIdentificationNumber.
	firstName := aFirstName.
	lastName := aLastName	! !


!Customer methodsFor: 'name' stamp: 'NMS 11/23/2023 20:48:41'!
isNamedAs: aFirstName andLastNamedAs: aLastName
	^firstName = aFirstName and: [lastName = aLastName]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'instance creation' stamp: 'NMS 11/25/2023 13:33:14'!
firstNamedAs: aFirstName lastNamedAs: aLastName withIdentificationType: anIdentificationType numbered: anIdentificationNumber

	^self new initializeFirstName: aFirstName lastName: aLastName withIdentificationType: anIdentificationType numbered: anIdentificationNumber ! !


!classDefinition: #Supplier category: 'CustomerImporter'!
Party subclass: #Supplier
	instanceVariableNames: 'name customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'initialization' stamp: 'NMS 11/25/2023 13:38:16'!
initializeNamed: aName identificationType: anIdentificationType numbered: anIdentificationNumber 
	super initializePartyWith: anIdentificationType numbered: anIdentificationNumber.
	name := aName.
	customers := OrderedCollection new.! !


!Supplier methodsFor: 'identification' stamp: 'NMS 11/25/2023 13:50:38'!
isNamedAs: aName
	 
	^name = aName! !


!Supplier methodsFor: 'customers' stamp: 'NMS 11/25/2023 13:50:21'!
addCustomer: newCustomer

	customers add: newCustomer! !

!Supplier methodsFor: 'customers' stamp: 'NMS 11/25/2023 13:46:15'!
doesAnyCustomerSatisfyFirstNamedAs: firstName lastNamedAs: lastName andIdentifiedAs: anIdentificationType numbered: anIdentificationNumber

	^ (customers anySatisfy: [:customer |
		(customer isNamedAs: firstName andLastNamedAs: lastName) and: [
			customer isIdentifiedAs: anIdentificationType numbered: anIdentificationNumber
		]
	])! !

!Supplier methodsFor: 'customers' stamp: 'NMS 11/25/2023 13:48:29'!
doesAnyCustomerSatisfyIdentifiedAs: anIdentificationType numbered: anIdentificationNumber

	^ (customers anySatisfy: [:customer |
		customer isIdentifiedAs: anIdentificationType numbered: anIdentificationNumber
	])! !

!Supplier methodsFor: 'customers' stamp: 'NMS 11/23/2023 21:13:51'!
isCustomersEmpty
	
	^customers isEmpty! !

!Supplier methodsFor: 'customers' stamp: 'NMS 11/25/2023 13:50:14'!
numberOfCustomers

	^customers size! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Supplier class' category: 'CustomerImporter'!
Supplier class
	instanceVariableNames: ''!

!Supplier class methodsFor: 'instance creation' stamp: 'gg 11/23/2023 18:32:43'!
named: aName identificationType: anIdentificationType numbered: anIdentificationNumber

	^self new initializeNamed: aName identificationType: anIdentificationType numbered: anIdentificationNumber ! !
