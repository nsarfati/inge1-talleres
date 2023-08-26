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

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 12:22:48'!
* aNaturalNumber
	^aNaturalNumber ! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:02:31'!
+ aNaturalNumber
	^aNaturalNumber next! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 16:48:33'!
/ aNaturalNumber
	^self! !

!I class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 16:24:33'!
dividir: dividendo and: divisor
	^self! !

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


!I class methodsFor: '--** private fileout/in **--' stamp: 'N S 8/26/2023 16:56:14'!
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

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 16:48:25'!
/ aNaturalNumber
	aNaturalNumber = self ifTrue: [^I] .
	^(self - aNaturalNumber + I) dividir: self and: aNaturalNumber! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 16:40:13'!
dividir: dividendo and: divisor
	^[((dividendo - divisor) / divisor) + I] on: Error do: [I]! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/26/2023 13:15:06'!
multiplicateA: aNaturalNumber
	^ (aNaturalNumber + aNaturalNumber) * self previous! !

!II class methodsFor: 'PeanoAxiomas' stamp: 'N S 8/24/2023 21:20:34'!
next
	next ifNotNil: [^next] .
	next := self cloneNamed: self name, 'I' .
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


!II class methodsFor: '--** private fileout/in **--' stamp: 'N S 8/26/2023 16:56:14'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := AnObsoleteIII.
	previous := I.! !

I initializeAfterFileIn!
II initializeAfterFileIn!