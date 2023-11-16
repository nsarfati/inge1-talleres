!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'assertions' stamp: 'GG 11/13/2023 21:14:26'!
assertCustomer: aCustomer hasFirstName: aFirstName lastName: aLastName identificationType: anIdentificationType andIdentificationNumber: anIdentificationNumber    

	self assert: aCustomer firstName equals: aFirstName.
	self assert: aCustomer lastName equals: aLastName.
	self assert: aCustomer identificationType equals: anIdentificationType.
	self assert: aCustomer identificationNumber equals: anIdentificationNumber ! !

!ImportTest methodsFor: 'assertions' stamp: 'GG 11/13/2023 21:23:14'!
assertCustomerAddress: aCustomerAddress hasStreetName: aStreetName streetNumber: aStreetNumber town: aTown zipCode: aZipCode andProvince: aProvince     

	self assert: aCustomerAddress streetName equals: aStreetName.
	self assert: aCustomerAddress streetNumber equals: aStreetNumber.
	self assert: aCustomerAddress town equals: aTown.
	self assert: aCustomerAddress zipCode equals: aZipCode.
	self assert: aCustomerAddress province equals: aProvince! !

!ImportTest methodsFor: 'assertions' stamp: 'GG 11/13/2023 21:50:06'!
assertDataBaseSizeIsCorrect

	|numberOfCustomers| 
	numberOfCustomers:= (session selectAllOfType: Customer) size.
	
	self assert: numberOfCustomers equals: 2! !

!ImportTest methodsFor: 'assertions' stamp: 'GG 11/16/2023 00:52:22'!
assertFirstCustomerIsImportedCorrectly

	|customers firstCustomer|
	
	customers := self selectCustomerWithIdType: 'D' andIdNumber: '22333444'.
	self assertThereIsOnlyOneCustomerFound: customers.
	
	firstCustomer := customers anyOne.
	
	self assertCustomer: firstCustomer hasFirstName: 'Pepe' lastName: 'Sanchez' identificationType: 'D' andIdentificationNumber: '22333444'.
	
	self assert: firstCustomer addresses size equals: 2.
	self assertCustomerAddress: (firstCustomer addresses first) hasStreetName: 'San Martin' streetNumber: 3322 town: 'Olivos' zipCode: 1636 andProvince: 'BsAs'.
self assertCustomerAddress: (firstCustomer addresses second) hasStreetName: 'Maipu' streetNumber: 888 town: 'Florida' zipCode: 1122 andProvince: 'Buenos Aires'! !

!ImportTest methodsFor: 'assertions' stamp: 'GG 11/16/2023 00:55:56'!
assertSecondCustomerIsImportedCorrectly

	|customers secondCustomer|
	
	customers := self selectCustomerWithIdType: 'C' andIdNumber: '23-25666777-9'.				
	self assertThereIsOnlyOneCustomerFound: customers.
	
	secondCustomer := customers anyOne.
	
	self assertCustomer: secondCustomer hasFirstName: 'Juan' lastName: 'Perez' identificationType: 'C' andIdentificationNumber: '23-25666777-9'.
	
	self assert: secondCustomer addresses size equals: 1.
self assertCustomerAddress: (secondCustomer addresses first) hasStreetName: 'Alem' streetNumber: 1122 town: 'CABA' zipCode: 1001 andProvince: 'CABA'! !

!ImportTest methodsFor: 'assertions' stamp: 'GG 11/16/2023 00:40:19'!
assertThereIsOnlyOneCustomerFound: customers

	^ self assert: customers size equals: 1! !


!ImportTest methodsFor: 'setUp + tearDown' stamp: 'GG 11/13/2023 20:30:44'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction! !

!ImportTest methodsFor: 'setUp + tearDown' stamp: 'GG 11/13/2023 20:33:11'!
tearDown

	session commit.
	session close! !


!ImportTest methodsFor: 'test data' stamp: 'GG 11/16/2023 01:20:03'!
dataToImport

	"^ UniFileStream new open: 'input.txt' forWrite: false"
	
	^ReadStream on: 
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'.! !


!ImportTest methodsFor: 'selects' stamp: 'GG 11/16/2023 00:32:12'!
selectCustomerWithIdType: anIdType andIdNumber: anIdNumber 

	^ session select: [:aCustomer | (aCustomer identificationType= anIdType) and: [aCustomer identificationNumber = anIdNumber]]
					ofType: Customer! !


!ImportTest methodsFor: 'tests' stamp: 'GG 11/16/2023 01:21:16'!
test01Import

	|  inputStream |
	
	inputStream := self dataToImport.
	(CustomerImporter fromStream: inputStream onSession: session) import.
	
	self assertDataBaseSizeIsCorrect.
	self assertFirstCustomerIsImportedCorrectly.
	self assertSecondCustomerIsImportedCorrectly.

	

	! !


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

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'importing' stamp: 'GG 11/13/2023 20:27:33'!
importCustomers

	"
	self importCustomers --borrar
	"
	| inputStream session newCustomer line |

	inputStream := UniFileStream new open: 'input.txt' forWrite: false.
	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.

	line := inputStream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fourth.
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData fourth ].

		line := inputStream nextLine. ].

	session commit.
	session close.

	inputStream close.
	! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'session inputStream'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'GG 11/15/2023 21:37:11'!
initializeWithStream: aStream andSession: aSession

	session := aSession.
	inputStream := aStream! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'GG 11/15/2023 00:57:21'!
import

	"
	self importCustomers
	"
	|   newCustomer line |

	line := inputStream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth ].

		line := inputStream nextLine. ].

	inputStream close.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'GG 11/15/2023 21:37:03'!
fromStream: anInputStream onSession: aSession

	^self new initializeWithStream: anInputStream andSession: aSession ! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close

	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |

	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].

	self defineIdOf: anObject.
	table add: anObject.

	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !
