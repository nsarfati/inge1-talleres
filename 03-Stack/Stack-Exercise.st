!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'size topOfStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/17/2023 21:49:22'!
initialize 
	
	topOfStack := 	StackBase new.
	size := 0.! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 19:54:39'!
isEmpty

	^ topOfStack stackIsEmpty ! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/17/2023 16:31:53'!
pop

	| poppedElement |
	poppedElement := self top.
	topOfStack := topOfStack previousElement.
	self decrementSize.
	^ poppedElement .! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 20:12:49'!
push: anElementValue 
	
	topOfStack := StackElement new pushAfter: topOfStack withValue: anElementValue on: self.
	! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/14/2023 21:51:13'!
size 

	^size! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 20:15:28'!
top
	
	^topOfStack accessValue! !


!OOStack methodsFor: 'private messages' stamp: 'gg 9/16/2023 16:37:14'!
decrementSize

	size := size - 1! !

!OOStack methodsFor: 'private messages' stamp: 'gg 9/16/2023 16:37:06'!
incrementSize

	size := size + 1! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'NR 9/14/2023 08:12:21'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #OOStackElements category: 'Stack-Exercise'!
Object subclass: #OOStackElements
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackElements methodsFor: 'as yet unclassified'!
! !

!OOStackElements methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 16:21:42'!
stackIsEmpty

	self subclassResponsibility ! !


!classDefinition: #StackBase category: 'Stack-Exercise'!
OOStackElements subclass: #StackBase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackBase methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 20:14:51'!
accessValue

	self error: OOStack stackEmptyErrorDescription! !

!StackBase methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 16:21:29'!
stackIsEmpty

	^ true! !


!classDefinition: #StackElement category: 'Stack-Exercise'!
OOStackElements subclass: #StackElement
	instanceVariableNames: 'elementValue previousElement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 20:14:42'!
accessValue

	^ elementValue! !

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 20:24:09'!
previousElement

	^previousElement ! !

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 20:12:36'!
pushAfter: anElement withValue: aValue on: anOOStack
	
	elementValue := aValue.
	previousElement := anElement.
	anOOStack incrementSize.! !

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 16:21:11'!
stackIsEmpty

	^false! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'stack prefix sentencesWithPrefix stackAux'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'initializing' stamp: 'gg 9/17/2023 21:07:22'!
initializeWithPrefix: aPrefix on: anOOStack

	stack := anOOStack .
	prefix := aPrefix.! !


!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 21:06:21'!
find

	sentencesWithPrefix := OrderedCollection new.
	stackAux := OrderedCollection new.
	self findSentencesWithGivenPrefix.
	self reconstructStack.! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 21:06:26'!
findSentencesWithGivenPrefix

	stack size timesRepeat: [ self verifyTopSentenceStartsWithPrefix ].! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 21:06:29'!
reconstructStack

	stackAux size timesRepeat: [
		stack push: stackAux first.
		stackAux removeFirst ].! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 21:06:32'!
sentences

	^ sentencesWithPrefix.! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 21:33:23'!
verifyTopSentenceStartsWithPrefix

	| topSentence | 
	topSentence := stack top.
	(topSentence beginsWith: prefix) ifTrue: [ sentencesWithPrefix addFirst: topSentence ].
	stackAux addFirst: topSentence .
	stack pop.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'prefix verifications' stamp: 'gg 9/17/2023 21:46:31'!
verifyNotEmpty: aPrefix

	aPrefix ='' ifTrue: [self error: self errorEmptyPrefix]! !

!SentenceFinderByPrefix class methodsFor: 'prefix verifications' stamp: 'gg 9/17/2023 21:45:26'!
verifyNotEmptySpaces: aPrefix

	(aPrefix includesSubString: ' ') ifTrue: [self error: self errorEmptySpacesInPrefix]! !


!SentenceFinderByPrefix class methodsFor: 'instance creation' stamp: 'gg 9/17/2023 21:10:09'!
initializeFinderWithPrefix: aPrefix on: anOOStack

	self verifyNotEmpty: aPrefix.
	self verifyNotEmptySpaces: aPrefix.
	
	SentenceFinderByPrefix new initializeWithPrefix: aPrefix on: anOOStack. ! !


!SentenceFinderByPrefix class methodsFor: 'error messages' stamp: 'gg 9/17/2023 21:12:39'!
errorEmptyPrefix

	^ 'Empty prefix!!'! !

!SentenceFinderByPrefix class methodsFor: 'error messages' stamp: 'gg 9/17/2023 21:12:57'!
errorEmptySpacesInPrefix

	^ 'Prefix has spaces!!'! !
