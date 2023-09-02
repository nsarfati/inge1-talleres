!classDefinition: #I category: '4.24-08.NumerosNaturales'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '4.24-08.NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: '4.24-08.NumerosNaturales'!
I class
	instanceVariableNames: 'next'!

!I class methodsFor: 'ErrorMessages' stamp: 'N S 8/29/2023 11:55:35'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'! !

!I class methodsFor: 'ErrorMessages' stamp: 'N S 8/29/2023 11:55:46'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	^'No se soportan numeros negativos'! !


!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 12:22:48'!
* aNaturalNumber
	^aNaturalNumber ! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:02:31'!
+ aNaturalNumber
	^aNaturalNumber next! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/29/2023 11:41:19'!
- aNaturalNumber
	^self error: self descripcionDeErrorDeNumerosNegativosNoSoportados ! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/29/2023 11:41:24'!
/ aNaturalNumber
	aNaturalNumber = I ifTrue: [^I].
	^self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor ! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 12:36:24'!
multiplicateA: aNaturalNumber
	^aNaturalNumber! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:22:59'!
next
	next ifNotNil: [^next] .
	next := self cloneNamed: self name, 'I' .
	"Le envia al objeto next el mensaje previous, diciendo quien es"
	"Ejemplo: II next -> Le manda III previous II"
	next previous: self .
	^next .! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:57:18'!
restateA: aNaturalNumber
	^aNaturalNumber previous! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 9/2/2023 13:11:54'!
vecesADividirte: aNaturalNumber
	^aNaturalNumber! !


!I class methodsFor: '--** private fileout/in **--' stamp: 'N S 9/2/2023 13:17:22'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := II.! !


!classDefinition: #II category: '4.24-08.NumerosNaturales'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '4.24-08.NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: '4.24-08.NumerosNaturales'!
II class
	instanceVariableNames: 'next previous'!

!II class methodsFor: 'ErrorMessages' stamp: 'N S 8/29/2023 11:56:30'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un numero mayor'! !


!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 13:15:06'!
* aNaturalNumber
	^ aNaturalNumber multiplicateA: self! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:26:00'!
+ aNaturalNumber
	"Hace un llamado recursivo al usar el +"
	^ self previous + aNaturalNumber next! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 13:18:53'!
- aNaturalNumber
	^ aNaturalNumber  restateA: self! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 9/2/2023 13:11:39'!
/ aNaturalNumber
	^aNaturalNumber vecesADividirte: self .! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 13:15:06'!
multiplicateA: aNaturalNumber
	^ (aNaturalNumber + aNaturalNumber) * self previous! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/28/2023 21:13:14'!
next
	next ifNotNil: [^next] .
	"next := self cloneNamed: self name, 'I' . << Asi era para clonarlo asi nomas"
	"Asi para que los siguientes sean childOf del II, es decir que tengan al II como prototipo"
	next := II createChildNamed: self name, 'I'.
	"Le envia al objeto next el mensaje previous, diciendo quien es"
	"Ejemplo: II next -> Le manda III previous II"
	next previous: self .
	^next .! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:21:26'!
previous
	^previous! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:21:46'!
previous: aNaturalNumber
	previous := aNaturalNumber! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 13:18:53'!
restateA: aNaturalNumber
	^ aNaturalNumber previous - self previous ! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 9/2/2023 13:17:13'!
vecesADividirte: aNaturalNumber
	|resultadoResta|
	aNaturalNumber = self ifTrue: [^I] .

	resultadoResta := [^(aNaturalNumber  - self)]
		on: Error
		do: [self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor ] .

	^((resultadoResta / self) + I)! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'N S 9/2/2023 13:17:22'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	previous := I.! !


!classDefinition: #III category: '4.24-08.NumerosNaturales'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '4.24-08.NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: '4.24-08.NumerosNaturales'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'N S 9/2/2023 13:17:22'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIII.
	previous := II.! !


!classDefinition: #IIII category: '4.24-08.NumerosNaturales'!
II subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '4.24-08.NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: '4.24-08.NumerosNaturales'!
IIII class
	instanceVariableNames: ''!

!IIII class methodsFor: '--** private fileout/in **--' stamp: 'N S 9/2/2023 13:17:22'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIII.
	previous := III.! !


!classDefinition: #IIIII category: '4.24-08.NumerosNaturales'!
II subclass: #IIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: '4.24-08.NumerosNaturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIII class' category: '4.24-08.NumerosNaturales'!
IIIII class
	instanceVariableNames: ''!

!IIIII class methodsFor: '--** private fileout/in **--' stamp: 'N S 9/2/2023 13:17:22'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	previous := IIII.! !

I initializeAfterFileIn!
II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!
IIIII initializeAfterFileIn!