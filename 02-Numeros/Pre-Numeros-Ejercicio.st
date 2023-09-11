!classDefinition: #NumeroTest category: 'Numero-Exercise'!
TestCase subclass: #NumeroTest
	instanceVariableNames: 'zero one two four oneFifth oneHalf five twoFifth twoTwentyfifth fiveHalfs three eight negativeOne negativeTwo negativeOneHalf'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:08:06'!
test01isCeroReturnsTrueWhenAskToZero

	self assert: zero isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:09:48'!
test02isCeroReturnsFalseWhenAskToOthersButZero

	self deny: one isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:09:55'!
test03isOneReturnsTrueWhenAskToOne

	self assert: one isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:10:04'!
test04isOneReturnsFalseWhenAskToOtherThanOne

	self deny: zero isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:10:14'!
test05EnteroAddsWithEnteroCorrectly

	self assert: one + one equals: two! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:10:25'!
test06EnteroMultipliesWithEnteroCorrectly

	self assert: two * two equals: four! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:15:37'!
test07FraccionAddsWithFraccionCorrectly
"
    La suma de fracciones es:
	 
	a/b + c/d = (a.d + c.b) / (b.d)
	 
	SI ESTAN PENSANDO EN LA REDUCCION DE FRACCIONES NO SE PREOCUPEN!!
	TODAVIA NO SE ESTA TESTEANDO ESE CASO
"
	| sevenTenths |

	sevenTenths := Numero with: (Numero with: 7) over: (Numero with: 10).

	self assert: oneFifth + oneHalf equals: sevenTenths! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:11:26'!
test08FraccionMultipliesWithFraccionCorrectly
"
    La multiplicacion de fracciones es:
	 
	(a/b) * (c/d) = (a.c) / (b.d)
"

	self assert: oneFifth * twoFifth equals: twoTwentyfifth! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:16:19'!
test09AparentFraccionesAreEqual

	self assert: oneHalf equals: (Numero with: two over: four)! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:12:46'!
test10AddingFraccionesCanReturnAnEntero

	self assert: oneHalf + oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:26:23'!
test11MultiplyingFraccionesCanReturnAnEntero

	self assert: (twoFifth) * (fiveHalfs) equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:13:21'!
test12AFraccionCanNotBeZero

	self deny: oneHalf isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:13:30'!
test13AFraccionCanNotBeOne

	self deny: oneHalf isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:14:16'!
test14NegationOfEnteroIsCorrect

	self assert: two negated equals: negativeTwo.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/24/2020 02:23:47'!
test15NegationOfFraccionIsCorrect

	self assert: oneHalf negated equals: negativeOneHalf! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:29:45'!
test16SignIsCorrectlyAssignedToFractionWithTwoNegatives

	self assert: oneHalf equals: (Numero with: negativeOne over: negativeTwo)! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/8/2019 21:30:07'!
test17SignIsCorrectlyAssignedToFractionWithNegativeDivisor

	self assert: oneHalf negated equals: (Numero with: one over: negativeTwo)! !


!NumeroTest methodsFor: 'setup' stamp: 'NR 9/24/2020 02:23:22'!
setUp

	zero := Numero with: 0.
	one := Numero with: 1.
	two := Numero with: 2.
	three:= Numero with: 3.
	four := Numero with: 4.
	five := Numero with: 5.
	eight := Numero with: 8.
	negativeOne := Numero with: -1.
	negativeTwo := Numero with: -2.
	
	oneHalf := Numero with: one over: two.
	oneFifth := Numero with: one over: five.
	twoFifth := Numero with: two over: five.
	twoTwentyfifth := Numero with: two over: (Numero with: 25).
	fiveHalfs := Numero with: five over: two.
	negativeOneHalf := Numero with: negativeOne over: two
	! !


!classDefinition: #Numero category: 'Numero-Exercise'!
Object subclass: #Numero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Numero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:32:39'!
* aMultiplier 
	^self subclassResponsibility! !

!Numero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:31:41'!
+ anAdder
	^self subclassResponsibility! !

!Numero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:28:38'!
// aDivisor 
	^self subclassResponsibility! !

!Numero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:27:31'!
greatestCommonDivisorWith: anEntero 
	^self subclassResponsibility! !

!Numero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:25:24'!
negated
	^self subclassResponsibility! !

!Numero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:16:07'!
printOn: aStream
	^self subclassResponsibility! !


!Numero methodsFor: 'testing' stamp: 'N S 9/11/2023 13:05:11'!
isNegative
	^self subclassResponsibility! !

!Numero methodsFor: 'testing' stamp: 'N S 9/11/2023 13:05:16'!
isOne
	^self subclassResponsibility! !

!Numero methodsFor: 'testing' stamp: 'N S 9/11/2023 13:05:20'!
isZero
	^self subclassResponsibility! !


!Numero methodsFor: 'initialization' stamp: 'NR 9/8/2019 20:40:23'!
initializeWith: aNumerator over: aDenominator

	"Estas precondiciones estan por si se comenten errores en la implementacion - Hernan"
	aNumerator isZero ifTrue: [ self error: 'una fraccion no puede ser cero' ].
	aDenominator isOne ifTrue: [ self error: 'una fraccion no puede tener denominador 1 porque sino es un entero' ].
	
	type:=#Fraccion.
	numerator := aNumerator.
	denominator := aDenominator ! !


!Numero methodsFor: 'accessing' stamp: 'NR 9/8/2019 20:59:46'!
denominator

	^denominator! !

!Numero methodsFor: 'accessing' stamp: 'NR 9/8/2019 20:59:52'!
numerator

	^numerator! !


!Numero methodsFor: 'comparing' stamp: 'N S 9/11/2023 13:37:18'!
= anObject
	^self subclassResponsibility! !

!Numero methodsFor: 'comparing' stamp: 'N S 9/11/2023 13:05:26'!
hash
	^self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Numero class' category: 'Numero-Exercise'!
Numero class
	instanceVariableNames: ''!

!Numero class methodsFor: 'error descriptions' stamp: 'NR 4/15/2021 16:49:48'!
canNotDivideByZeroErrorDescription

	^'No se puede dividir por cero!!!!!!'! !


!Numero class methodsFor: 'instance creation' stamp: 'N S 9/11/2023 12:41:23'!
with: aValue 
	
	"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
	aValue isInteger ifFalse: [  self error: 'aValue debe ser anInteger' ].
	
	^Entero new initializeWith: aValue! !

!Numero class methodsFor: 'instance creation' stamp: 'N S 9/11/2023 12:42:33'!
with: aDividend over: aDivisor

	| greatestCommonDivisor numerator denominator |
	
	aDivisor isZero ifTrue: [ self error: self canNotDivideByZeroErrorDescription ].
	aDividend isZero ifTrue: [ ^aDividend ].
	
	aDivisor isNegative ifTrue: [ ^self with: aDividend negated over: aDivisor negated].
	
	greatestCommonDivisor := aDividend greatestCommonDivisorWith: aDivisor. 
	numerator := aDividend // greatestCommonDivisor.
	denominator := aDivisor // greatestCommonDivisor.
	
	denominator isOne ifTrue: [ ^numerator ].

	^Fraccion new initializeWith: numerator over: denominator! !


!classDefinition: #Entero category: 'Numero-Exercise'!
Numero subclass: #Entero
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Entero methodsFor: 'testing' stamp: 'N S 9/11/2023 12:54:02'!
isNegative
	^value < 0! !

!Entero methodsFor: 'testing' stamp: 'N S 9/11/2023 12:55:17'!
isOne
	^value = 1! !

!Entero methodsFor: 'testing' stamp: 'N S 9/11/2023 12:53:27'!
isZero
	^self integerValue = 0! !


!Entero methodsFor: 'accessing' stamp: 'N S 9/11/2023 12:59:55'!
integerValue
	"Usamos integerValue en vez de value para que no haya problemas con el mensaje value implementado en Object - Hernan"
	^value! !


!Entero methodsFor: 'comparing' stamp: 'N S 9/11/2023 13:36:07'!
= anObject
	^(anObject isKindOf: self class) and: [ self integerValue = anObject integerValue ]! !

!Entero methodsFor: 'comparing' stamp: 'N S 9/11/2023 13:02:29'!
hash
	^self integerValue hash! !


!Entero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:33:56'!
* aMultiplier 
	^self class
		with: value * aMultiplier integerValue	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:29:18'!
+ anAdder 
	^self class with: self integerValue + anAdder integerValue! !

!Entero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:28:06'!
// aDivisor 
	^self class with: value // aDivisor integerValue! !

!Entero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:26:36'!
greatestCommonDivisorWith: anEntero
	^self class with: (self integerValue gcd: anEntero integerValue)! !

!Entero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:23:31'!
negated
	^self * (self class with: -1)! !

!Entero methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:14:31'!
printOn: aStream
	aStream print: value! !


!Entero methodsFor: 'initialization' stamp: 'N S 9/11/2023 13:43:38'!
initializeWith: aValue
	value := aValue! !


!classDefinition: #Fraccion category: 'Numero-Exercise'!
Numero subclass: #Fraccion
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Fraccion methodsFor: 'testing' stamp: 'N S 9/11/2023 12:54:25'!
isNegative
	^denominator < 0! !

!Fraccion methodsFor: 'testing' stamp: 'N S 9/11/2023 12:55:51'!
isOne
	^false! !

!Fraccion methodsFor: 'testing' stamp: 'N S 9/11/2023 12:49:47'!
isZero
	^false! !


!Fraccion methodsFor: 'accessing' stamp: 'N S 9/11/2023 12:59:39'!
denominator
	^denominator! !

!Fraccion methodsFor: 'accessing' stamp: 'N S 9/11/2023 12:59:22'!
numerator
	^numerator! !


!Fraccion methodsFor: 'comparing' stamp: 'N S 9/11/2023 13:36:55'!
= anObject
	^(anObject isKindOf: self class)
		and: [ (numerator * anObject denominator) = (denominator * anObject numerator) ]! !

!Fraccion methodsFor: 'comparing' stamp: 'N S 9/11/2023 13:03:13'!
hash
	^(self numerator hash / self denominator hash) hash! !


!Fraccion methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:33:48'!
* aMultiplier 
	^self class
		with: (self numerator * aMultiplier numerator)
		over: (self denominator * aMultiplier denominator)! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:31:24'!
+ anAdder 
	| newNumerator newDenominator |

	newNumerator := (numerator * anAdder denominator) + (denominator * anAdder numerator).
	newDenominator := denominator * anAdder denominator.

	^ self class with: newNumerator over: newDenominator! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:28:21'!
// aDivisor 
	self error: 'Tipo de número no soportado'! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:27:13'!
greatestCommonDivisorWith: anEntero		
	self error: 'Tipo de número no soportado'! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:24:26'!
negated
	^self class with: self numerator * (self class with: -1) over: self denominator! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'N S 9/11/2023 13:15:13'!
printOn: aStream
	aStream 
		print: numerator;
		nextPut: $/;
		print: denominator! !


!Fraccion methodsFor: 'initialization' stamp: 'N S 9/11/2023 13:44:27'!
initializeWith: aNumerator over: aDenominator

	"Estas precondiciones estan por si se comenten errores en la implementacion - Hernan"
	aNumerator isZero ifTrue: [ self error: 'una fraccion no puede ser cero' ].
	aDenominator isOne ifTrue: [ self error: 'una fraccion no puede tener denominador 1 porque sino es un entero' ].
	
	numerator := aNumerator.
	denominator := aDenominator ! !
