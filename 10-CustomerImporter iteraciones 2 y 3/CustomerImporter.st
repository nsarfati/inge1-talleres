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
	instanceVariableNames: 'session customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'GG 11/16/2023 19:53:04'!
test01ImportWithValidDataIsDoneCorrectly

	CustomerImporter valueFrom: self validImportData into: session.

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/16/2023 20:11:04'!
test02ImportingFailsWhenCustomerRecordHasLessThanFiveFields

	|importer|
	
	importer := CustomerImporter from: (ReadStream on: 'C,Pepe,Sanchez,D') into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer invalidCustomerRecord.
							     self assert: importer numberOfCustomersImported equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/16/2023 20:11:09'!
test03ImportingFailsWhenCustomerRecordHasMoreThanFiveFields

	|importer|
	
	importer := CustomerImporter from: (ReadStream on: 'C,Pepe,Sanchez,D,22333444,xyz') into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer invalidCustomerRecord.
							     self assert: importer numberOfCustomersImported equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/17/2023 02:02:26'!
test04ImportingFailsWhenAddressRecordHasLessThanSixFields

	|importer|
	
	importer := CustomerImporter from: (self customerDataWithLessThanSixFieldsOnAddress) 
								into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer invalidAddressRecord.
							     self assert: importer numberOfCustomersImported equals: 1]
! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/17/2023 02:02:31'!
test05ImportingFailsWhenAddressRecordHasMoreThanSixFields

	|importer|
	
	importer := CustomerImporter from: (self customerDataWithMoreThanSixFieldsOnAddress) 
								into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer invalidAddressRecord.
							     self assert: importer numberOfCustomersImported equals: 1]
! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/17/2023 00:57:34'!
test06CanNotImportAnAddressWithoutACustomer

	|importer|
	
	importer := CustomerImporter from: (self addressWithoutCustomerData) 
								into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer addressRecordWithoutCustomerErrorDescription.
							     self assert: importer numberOfCustomersImported equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/17/2023 01:30:05'!
test07CanNotImportAnEmptyRecord

	|importer|
	
	importer := CustomerImporter from: self emptyRecord into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer emptyRecordErrorDescription.
							     self assert: importer numberOfCustomersImported equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/17/2023 01:39:25'!
test08ImportingFailsWhenRecordStartsWithCButHasMoreCharacters

	|importer|
	
	importer := CustomerImporter from: self invalidCustomerRecordType into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer invalidRecordTypeErrorDescription.
							     self assert: importer numberOfCustomersImported equals: 0]
! !

!ImportTest methodsFor: 'tests' stamp: 'GG 11/17/2023 01:59:48'!
test09ImportingFailsWhenRecordStartsWithAButHasMoreCharacters

	|importer|
	
	importer := CustomerImporter from: self invalidAddressRecordType into: session.
					
	self should: [importer value]
	       raise: Error
	       withExceptionDo: [:anError | self assert: anError messageText equals: importer invalidRecordTypeErrorDescription.
							     self assert: importer numberOfCustomersImported equals: 1].! !


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

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:12:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (session selectAllOfType: Customer) size! !

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


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'GG 11/16/2023 21:29:12'!
setUp
	
	"customerSystem := PersistentCustomerSystem new.
	
	customerSystem := Environment current createSystem.
	
	
	current --> self subclasses detect: [:anEnvironment | anEnvironment isCurrent]] new
	"
	
	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber

	^ (session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


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
	instanceVariableNames: 'session readStream newCustomer line record'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'HAW 5/22/2022 18:06:47'!
initializeFrom: aReadStream into: aSession
	session := aSession.
	readStream := aReadStream.! !


!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/17/2023 02:06:38'!
createRecord
	
	record := line findTokens: $,.
	record isEmpty ifTrue: [^self error: self emptyRecordErrorDescription]! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/17/2023 00:57:34'!
importAddress

	| newAddress |
		
	(record size ~= 6) ifTrue: [^self error: self invalidAddressRecord].
	newCustomer isNil ifTrue: [^self error: self addressRecordWithoutCustomerErrorDescription].
	
	newAddress := Address new.
	newCustomer addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/16/2023 20:08:11'!
importCustomer

	(record size ~= 5) ifTrue: [^self error: self invalidCustomerRecord].
	
	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.
	session persist: newCustomer! !

!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/17/2023 01:57:51'!
importRecord
	
	self isCustomerRecord ifTrue: [^self importCustomer ].

	self isAddressRecord ifTrue: [ ^self importAddress ].
	
	^self error: self invalidRecordTypeErrorDescription! !

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

!CustomerImporter methodsFor: 'importing - aux' stamp: 'GG 11/16/2023 20:26:25'!
numberOfCustomersImported
	
	^(session selectAllOfType: Customer) size! !


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


!CustomerImporter methodsFor: 'error messages' stamp: 'GG 11/17/2023 02:07:31'!
addressRecordWithoutCustomerErrorDescription

	^'There must be a customer associated with the address!!'! !

!CustomerImporter methodsFor: 'error messages' stamp: 'GG 11/17/2023 01:05:35'!
emptyRecordErrorDescription

	^'Cannot import an empty record!!'! !

!CustomerImporter methodsFor: 'error messages' stamp: 'GG 11/16/2023 20:15:53'!
invalidAddressRecord
	
	^'Address record must have six fields!!'! !

!CustomerImporter methodsFor: 'error messages' stamp: 'GG 11/16/2023 20:02:02'!
invalidCustomerRecord
	
	^'Customer record must have five fields!!'! !

!CustomerImporter methodsFor: 'error messages' stamp: 'GG 11/17/2023 01:36:48'!
invalidRecordTypeErrorDescription
	
	^'Invalid record type!!'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


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
