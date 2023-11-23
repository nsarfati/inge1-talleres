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


!PersistentSet methodsFor: 'adding' stamp: 'NMS 11/22/2023 19:03:19'!
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
	instanceVariableNames: 'customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test01ImportWithValidDataIsDoneCorrectly

	CustomerImporter valueFrom: self validImportData withCustomerSystem: customerSystem.

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test02ImportingFailsWhenCustomerRecordHasLessThanFiveFields
					
	self should: [CustomerImporter valueFrom: (ReadStream on: 'C,Pepe,Sanchez,D') withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidCustomerRecord.
							     self assert: customerSystem numberOfCustomers equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test03ImportingFailsWhenCustomerRecordHasMoreThanFiveFields

	self should: [CustomerImporter valueFrom: (ReadStream on: 'C,Pepe,Sanchez,D,22333444,xyz') withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidCustomerRecord.
							     self assert: customerSystem numberOfCustomers equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test04ImportingFailsWhenAddressRecordHasLessThanSixFields
					
	self should: [CustomerImporter valueFrom: (self customerDataWithLessThanSixFieldsOnAddress) 
								withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidAddressRecord.
							     self assert: customerSystem numberOfCustomers equals: 1]
! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test05ImportingFailsWhenAddressRecordHasMoreThanSixFields
					
	self should: [CustomerImporter valueFrom: (self customerDataWithMoreThanSixFieldsOnAddress) 
								withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidAddressRecord.
							     self assert: customerSystem numberOfCustomers equals: 1]
! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test06CanNotImportAnAddressWithoutACustomer
					
	self should: [CustomerImporter valueFrom: (self addressWithoutCustomerData) 
								withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter addressRecordWithoutCustomerErrorDescription.
							     self assert: customerSystem numberOfCustomers equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test07CanNotImportAnEmptyRecord
					
	self should: [CustomerImporter valueFrom: self emptyRecord withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter emptyRecordErrorDescription.
							     self assert: customerSystem numberOfCustomers equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test08ImportingFailsWhenRecordStartsWithCButHasMoreCharacters
					
	self should: [CustomerImporter valueFrom: self invalidCustomerRecordType withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidRecordTypeErrorDescription.
							     self assert: customerSystem numberOfCustomers equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'NMS 11/22/2023 18:57:00'!
test09ImportingFailsWhenRecordStartsWithAButHasMoreCharacters
					
	self should: [CustomerImporter valueFrom: self invalidAddressRecordType withCustomerSystem: customerSystem]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: CustomerImporter invalidRecordTypeErrorDescription.
							     self assert: customerSystem numberOfCustomers equals: 1].! !


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

!ImportTest methodsFor: 'assertions' stamp: 'NMS 11/22/2023 18:27:07'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer :=  customerSystem findCustomerIdentifiedAs: anIdType withNumber: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'NMS 11/22/2023 18:20:03'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: customerSystem numberOfCustomers! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'NMS 11/22/2023 19:49:16'!
setUp
	
	customerSystem := Environment current createCustomerSystem.
	customerSystem beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'NMS 11/22/2023 19:18:31'!
tearDown
	customerSystem endTransaction! !


!ImportTest methodsFor: 'test data' stamp: 'GG 11/17/2023 00:45:06'!
addressWithoutCustomerData

	^ ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ImportTest methodsFor: 'test data' stamp: 'GG 11/17/2023 02:01:57'!
customerDataWithLessThanSixFieldsOnAddress

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ImportTest methodsFor: 'test data' stamp: 'GG 11/17/2023 02:02:10'!
customerDataWithMoreThanSixFieldsOnAddress

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,Argentina'! !

!ImportTest methodsFor: 'test data' stamp: 'GG 11/17/2023 01:31:32'!
emptyRecord

	^ ReadStream on: '
	'! !

!ImportTest methodsFor: 'test data' stamp: 'GG 11/17/2023 01:59:03'!
invalidAddressRecordType

	^ ReadStream on: 'C,Pepe,Sanchez,D,22333444
Aaaa,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'! !

!ImportTest methodsFor: 'test data' stamp: 'GG 11/17/2023 01:47:26'!
invalidCustomerRecordType

	^ ReadStream on: 'Cx,Pepe,Sanchez,D,22333444' ! !

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


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'readStream customerSystem newCustomer line record'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'NMS 11/22/2023 18:56:28'!
initializeFrom: aReadStream withCustomerSystem: aCustomerSystem 
	readStream := aReadStream.
	customerSystem := aCustomerSystem! !


!CustomerImporter methodsFor: 'importing - aux' stamp: 'NMS 11/22/2023 18:43:38'!
createRecord
	
	record := line findTokens: $,.
	record isEmpty ifTrue: [^self error: self class emptyRecordErrorDescription]! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'NMS 11/22/2023 18:43:28'!
importAddress

	| newAddress |
		
	(record size ~= 6) ifTrue: [^self error: self class invalidAddressRecord].
	newCustomer isNil ifTrue: [^self error: self class addressRecordWithoutCustomerErrorDescription].
	
	newAddress := Address new.
	newCustomer addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'NMS 11/22/2023 19:02:55'!
importCustomer

	(record size ~= 5) ifTrue: [^self error: self class invalidCustomerRecord].
	
	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.

	customerSystem addCustomer: newCustomer! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'NMS 11/22/2023 18:44:11'!
importRecord
	
	self isCustomerRecord ifTrue: [^self importCustomer ].

	self isAddressRecord ifTrue: [ ^self importAddress ].
	
	^self error: self class invalidRecordTypeErrorDescription! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/17/2023 01:57:16'!
isAddressRecord

	^ record first = 'A'! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/17/2023 01:57:09'!
isCustomerRecord

	^ record first = 'C'! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/16/2023 19:47:25'!
isThereALineToImport

	line := readStream nextLine. 
	^line notNil! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'GG 11/17/2023 01:23:48'!
value

	"
	self importCustomers
	"
	 
	[self isThereALineToImport ] whileTrue: [
		self createRecord.
		self importRecord.
	].

	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!


!CustomerImporter class methodsFor: 'importing' stamp: 'NMS 11/22/2023 18:57:00'!
valueFrom: aReadStream withCustomerSystem: aCustomerSystem 
	^(self new initializeFrom: aReadStream withCustomerSystem: aCustomerSystem) value! !


!CustomerImporter class methodsFor: 'error messages' stamp: 'NMS 11/22/2023 18:37:55'!
addressRecordWithoutCustomerErrorDescription

	^'There must be a customer associated with the address!!'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'NMS 11/22/2023 18:42:54'!
emptyRecordErrorDescription

	^'Cannot import an empty record!!'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'NMS 11/22/2023 18:43:01'!
invalidAddressRecord
	
	^'Address record must have six fields!!'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'NMS 11/22/2023 18:38:41'!
invalidCustomerRecord
	
	^'Customer record must have five fields!!'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'NMS 11/22/2023 18:43:08'!
invalidRecordTypeErrorDescription
	
	^'Invalid record type!!'! !


!classDefinition: #CustomerSystem category: 'CustomerImporter'!
Object subclass: #CustomerSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerSystem methodsFor: 'session - handling' stamp: 'NMS 11/22/2023 19:21:50'!
beginTransaction

	self subclassResponsibility! !

!CustomerSystem methodsFor: 'session - handling' stamp: 'NMS 11/22/2023 19:21:54'!
endTransaction

	self subclassResponsibility! !


!CustomerSystem methodsFor: 'storing' stamp: 'NMS 11/22/2023 19:21:46'!
addCustomer: aNewCustomer

	self subclassResponsibility! !


!CustomerSystem methodsFor: 'accessing' stamp: 'NMS 11/22/2023 19:22:02'!
findCustomerIdentifiedAs: anIdType withNumber: anIdNumber

	self subclassResponsibility! !

!CustomerSystem methodsFor: 'accessing' stamp: 'NMS 11/22/2023 19:22:07'!
numberOfCustomers

	self subclassResponsibility! !


!classDefinition: #PersistentCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #PersistentCustomerSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentCustomerSystem methodsFor: 'initialization' stamp: 'NMS 11/22/2023 18:12:34'!
initialize
	session := (DataBaseSession for: (Array with: Address with: Customer))! !


!PersistentCustomerSystem methodsFor: 'session - handling' stamp: 'NMS 11/22/2023 18:13:55'!
beginTransaction
	session beginTransaction! !

!PersistentCustomerSystem methodsFor: 'session - handling' stamp: 'NMS 11/22/2023 19:18:12'!
endTransaction
	session commit.
	session close! !


!PersistentCustomerSystem methodsFor: 'storing' stamp: 'NMS 11/22/2023 19:03:34'!
addCustomer: aNewCustomer
	session persist: aNewCustomer! !


!PersistentCustomerSystem methodsFor: 'accessing' stamp: 'NMS 11/22/2023 18:24:43'!
findCustomerIdentifiedAs: anIdType withNumber: anIdNumber
	^(session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !

!PersistentCustomerSystem methodsFor: 'accessing' stamp: 'NMS 11/22/2023 18:19:40'!
numberOfCustomers
	^(session selectAllOfType: Customer) size! !


!classDefinition: #TransientCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #TransientCustomerSystem
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientCustomerSystem methodsFor: 'initialization' stamp: 'NMS 11/22/2023 19:21:09'!
initialize
	customers := OrderedCollection new! !


!TransientCustomerSystem methodsFor: 'session - handling' stamp: 'NMS 11/22/2023 19:24:44'!
beginTransaction
! !

!TransientCustomerSystem methodsFor: 'session - handling' stamp: 'NMS 11/22/2023 19:24:56'!
endTransaction
! !


!TransientCustomerSystem methodsFor: 'storing' stamp: 'NMS 11/22/2023 19:25:20'!
addCustomer: aNewCustomer

	customers add: aNewCustomer! !


!TransientCustomerSystem methodsFor: 'accessing' stamp: 'NMS 11/22/2023 19:27:48'!
findCustomerIdentifiedAs: anIdType withNumber: anIdNumber
	^customers detect: [:aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ] ]! !

!TransientCustomerSystem methodsFor: 'accessing' stamp: 'NMS 11/22/2023 19:25:33'!
numberOfCustomers

	^customers size! !


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


!classDefinition: #Environment category: 'CustomerImporter'!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Environment methodsFor: 'customer system' stamp: 'NMS 11/22/2023 19:41:49'!
createCustomerSystem

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: 'CustomerImporter'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'instance creation' stamp: 'NMS 11/22/2023 21:10:12'!
current
	^(self subclasses detect: [:anEnvironment | anEnvironment isCurrent]
		ifNone: [self error: self canNotFindValidEnvironmentErrorMessage]) new! !

!Environment class methodsFor: 'instance creation' stamp: 'NMS 11/22/2023 19:40:17'!
isCurrent

	self subclassResponsibility! !


!Environment class methodsFor: 'error messages' stamp: 'NMS 11/22/2023 19:39:01'!
canNotFindValidEnvironmentErrorMessage
	^'No hay ambiente valido definido'! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'NMS 11/22/2023 19:42:19'!
createCustomerSystem
	^PersistentCustomerSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: 'CustomerImporter'!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'instance creation' stamp: 'NMS 11/22/2023 19:48:32'!
isCurrent
	^LocalEnvironment isCurrent not! !


!classDefinition: #LocalEnvironment category: 'CustomerImporter'!
Environment subclass: #LocalEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!LocalEnvironment methodsFor: 'customer system' stamp: 'NMS 11/22/2023 19:42:29'!
createCustomerSystem
	^TransientCustomerSystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LocalEnvironment class' category: 'CustomerImporter'!
LocalEnvironment class
	instanceVariableNames: ''!

!LocalEnvironment class methodsFor: 'instance creation' stamp: 'NMS 11/22/2023 21:36:45'!
isCurrent
	^true! !
