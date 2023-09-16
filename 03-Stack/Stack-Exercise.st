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
	instanceVariableNames: 'size stackPointer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 16:17:54'!
initialize 
	
	|stackBase|
	stackBase := 	StackBase new.
	stackPointer := PointerToStackTop new pointsTo: stackBase.
	size := 0.! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 18:07:14'!
isEmpty

	^ stackPointer accessPointedElement stackIsEmpty ! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 18:07:24'!
pop

	 ^ stackPointer accessPointedElement popElementFromStack: self! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 18:09:57'!
push: anElementValue 
	
	|elementToPush|
	elementToPush := StackElement new initializeElementWith: anElementValue.
	elementToPush pushTo: self.! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/14/2023 21:51:13'!
size 

	^size! !

!OOStack methodsFor: 'stack messages' stamp: 'gg 9/16/2023 18:07:46'!
top
	
	^stackPointer accessPointedElement topElementOfStack: self.! !


!OOStack methodsFor: 'private messages' stamp: 'gg 9/16/2023 16:37:14'!
decrementSize

	size := size - 1! !

!OOStack methodsFor: 'private messages' stamp: 'gg 9/16/2023 16:37:06'!
incrementSize

	size := size + 1! !

!OOStack methodsFor: 'private messages' stamp: 'gg 9/16/2023 16:33:56'!
stackPointer

	^stackPointer ! !

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

!OOStackElements methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 17:58:26'!
popElementFromStack: anOOStack
	
	self subclassResponsibility 
	! !

!OOStackElements methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 16:21:42'!
stackIsEmpty

	self subclassResponsibility ! !

!OOStackElements methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 17:58:46'!
topElementOfStack: anOOStack
	
	self subclassResponsibility ! !


!classDefinition: #StackBase category: 'Stack-Exercise'!
OOStackElements subclass: #StackBase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackBase methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 18:10:58'!
popElementFromStack: anOOStack

	self error: OOStack stackEmptyErrorDescription! !

!StackBase methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 16:21:29'!
stackIsEmpty

	^ true! !

!StackBase methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 18:11:06'!
topElementOfStack: anOOStack
	
	self error: OOStack stackEmptyErrorDescription! !


!classDefinition: #StackElement category: 'Stack-Exercise'!
OOStackElements subclass: #StackElement
	instanceVariableNames: 'elementValue pointerToPreviousElement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 18:02:14'!
initializeElementWith: aValue

	elementValue := aValue ! !

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 18:08:10'!
popElementFromStack: anOOStack
	
	|newTop|
	newTop := 	pointerToPreviousElement accessPointedElement.
	anOOStack stackPointer pointsTo: newTop.
	anOOStack decrementSize.
	^ elementValue
	! !

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 18:08:50'!
pushTo: anOOStack

	pointerToPreviousElement := ElementPointer new pointsTo: 
									anOOStack stackPointer accessPointedElement .
	anOOStack stackPointer pointsTo: self.
	anOOStack incrementSize.! !

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 16:21:11'!
stackIsEmpty

	^false! !

!StackElement methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 17:58:56'!
topElementOfStack: anOOStack

	^ elementValue! !


!classDefinition: #OOStackPointers category: 'Stack-Exercise'!
Object subclass: #OOStackPointers
	instanceVariableNames: 'elementPointed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackPointers methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 18:07:02'!
accessPointedElement 

	^ elementPointed

	! !

!OOStackPointers methodsFor: 'as yet unclassified' stamp: 'gg 9/16/2023 18:03:08'!
pointsTo: aStackElement

	elementPointed := aStackElement! !


!classDefinition: #ElementPointer category: 'Stack-Exercise'!
OOStackPointers subclass: #ElementPointer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!


!classDefinition: #PointerToStackTop category: 'Stack-Exercise'!
OOStackPointers subclass: #PointerToStackTop
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!
