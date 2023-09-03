!classDefinition: #I category: 'NumerosNaturales'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'NumerosNaturales'!
I class
	instanceVariableNames: 'next'!

!I class methodsFor: 'Mensajes de error' stamp: 'N S 8/29/2023 11:55:35'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'! !

!I class methodsFor: 'Mensajes de error' stamp: 'N S 8/29/2023 11:55:46'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	^'No se soportan numeros negativos'! !


!I class methodsFor: 'Mensajes auxiliares' stamp: 'N S 8/24/2023 21:57:18'!
restateA: aNaturalNumber
	^aNaturalNumber previous! !

!I class methodsFor: 'Mensajes auxiliares' stamp: 'N S 9/2/2023 13:11:54'!
vecesADividirte: aNaturalNumber
	^aNaturalNumber! !


!I class methodsFor: 'Axiomas' stamp: 'N S 8/26/2023 12:22:48'!
* aNaturalNumber
	^aNaturalNumber ! !

!I class methodsFor: 'Axiomas' stamp: 'N S 8/24/2023 21:02:31'!
+ aNaturalNumber
	^aNaturalNumber next! !

!I class methodsFor: 'Axiomas' stamp: 'N S 8/29/2023 11:41:19'!
- aNaturalNumber
	^self error: self descripcionDeErrorDeNumerosNegativosNoSoportados ! !

!I class methodsFor: 'Axiomas' stamp: 'N S 8/29/2023 11:41:24'!
/ aNaturalNumber
	aNaturalNumber = I ifTrue: [^I].
	^self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor ! !

!I class methodsFor: 'Axiomas' stamp: 'gg 9/3/2023 15:34:48'!
next
	next ifNotNil: [^next] .
	next := self cloneNamed: self name, 'I' .
	next previous: self .
	^next .! !


!I class methodsFor: '--** private fileout/in **--' stamp: 'gg 9/3/2023 19:26:34'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := II.! !


!classDefinition: #II category: 'NumerosNaturales'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'NumerosNaturales'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'Mensajes de error' stamp: 'N S 8/29/2023 11:56:30'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'! !


!II class methodsFor: 'Mensajes auxiliares' stamp: 'N S 8/24/2023 21:21:46'!
previous: aNaturalNumber
	previous := aNaturalNumber! !

!II class methodsFor: 'Mensajes auxiliares' stamp: 'N S 8/26/2023 13:18:53'!
restateA: aNaturalNumber
	^ aNaturalNumber previous - self previous ! !

!II class methodsFor: 'Mensajes auxiliares' stamp: 'gg 9/3/2023 19:26:10'!
vecesADividirte: aNaturalNumber
	aNaturalNumber = self ifTrue: [^I] .
	^[((aNaturalNumber  - self) / self) + I]
		on: Error
		do: [self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor].! !


!II class methodsFor: 'Axiomas' stamp: 'gg 9/3/2023 19:26:17'!
* aNaturalNumber	
	^ (self previous) * aNaturalNumber + aNaturalNumber! !

!II class methodsFor: 'Axiomas' stamp: 'gg 9/3/2023 15:39:46'!
+ aNaturalNumber
	
	^ self previous + aNaturalNumber next! !

!II class methodsFor: 'Axiomas' stamp: 'gg 9/3/2023 15:40:09'!
- aNaturalNumber
	^ aNaturalNumber restateA: self! !

!II class methodsFor: 'Axiomas' stamp: 'N S 9/2/2023 13:11:39'!
/ aNaturalNumber
	^aNaturalNumber vecesADividirte: self .! !

!II class methodsFor: 'Axiomas' stamp: 'gg 9/3/2023 15:36:51'!
next
	next ifNotNil: [^next] .
	next := II createChildNamed: self name, 'I'.
	next previous: self .
	^next .! !

!II class methodsFor: 'Axiomas' stamp: 'N S 8/24/2023 21:21:26'!
previous
	^previous! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'gg 9/3/2023 19:26:34'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	previous := I.! !


!classDefinition: #III category: 'NumerosNaturales'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'NumerosNaturales'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'gg 9/3/2023 19:26:34'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIII.
	previous := II.! !


!classDefinition: #IIII category: 'NumerosNaturales'!
II subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: 'NumerosNaturales'!
IIII class
	instanceVariableNames: ''!

!IIII class methodsFor: '--** private fileout/in **--' stamp: 'gg 9/3/2023 19:26:34'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := III.! !

I initializeAfterFileIn!
II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!