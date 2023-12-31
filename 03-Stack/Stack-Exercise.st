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

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 22:36:09'!
test01StackWithOneSentenceThatMatchesThePrefix
	| stack sentenceFinderByPrefix sentences |

	stack := OOStack new.
	stack push: 'winter'.

	sentenceFinderByPrefix := SentenceFinderByPrefix initializeFinderWithPrefix: 'wint' on: stack.
	sentences := sentenceFinderByPrefix find.

	self assert: sentences size equals: 1.
	self assert: sentences includes: 'winter'! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 22:36:35'!
test02StackWithFiveSentencesOnlyOneMatch
	| stack sentenceFinderByPrefix sentences |

	stack := OOStack new.
	stack push: 'winter'.
	stack push: 'summer'.
	stack push: 'autumn'.
	stack push: 'Winter is coming'.
	stack push: 'Winter'.

	sentenceFinderByPrefix := SentenceFinderByPrefix initializeFinderWithPrefix: 'wint' on: stack.
	sentences := sentenceFinderByPrefix find.

	self assert: sentences size equals: 1.
	self assert: sentences includes: 'winter'! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 22:40:19'!
test03StackWithFiveSentencesAndThreeMatches
	| stack sentenceFinderByPrefix sentences |

	stack := OOStack new.
	stack push: 'winter'.
	stack push: 'summer'.
	stack push: 'autumn'.
	stack push: 'winter is coming'.
	stack push: 'win the lottery'.
	stack push: 'autumn'.

	sentenceFinderByPrefix := SentenceFinderByPrefix initializeFinderWithPrefix: 'win' on: stack.
	sentences := sentenceFinderByPrefix find.

	self assert: sentences size equals: 3.
	self assert: sentences includes: 'winter'.
	self assert: sentences includes: 'winter is coming'.
	self assert: sentences includes: 'win the lottery'! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 22:41:29'!
test04StackWithFiveSentencesAndNoMatches
	| stack sentenceFinderByPrefix sentences |

	stack := OOStack new.
	stack push: 'winter'.
	stack push: 'summer'.
	stack push: 'autumn'.
	stack push: 'winter is coming'.
	stack push: 'win the lottery'.
	stack push: 'autumn'.

	sentenceFinderByPrefix := SentenceFinderByPrefix initializeFinderWithPrefix: 'impossible' on: stack.
	sentences := sentenceFinderByPrefix find.

	self assert: sentences isEmpty! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 22:44:55'!
test05StackWithFiveSentencesRemainsTheSame
	| stack sentenceFinderByPrefix |

	stack := OOStack new.
	stack push: 'winter'.
	stack push: 'summer'.
	stack push: 'autumn'.
	stack push: 'winter is coming'.

	sentenceFinderByPrefix := SentenceFinderByPrefix initializeFinderWithPrefix: 'impossible' on: stack.
	sentenceFinderByPrefix find.

	self assert: stack size equals: 4.
	self assert: stack pop equals: 'winter is coming'.
	self assert: stack pop equals: 'autumn'.
	self assert: stack pop equals: 'summer'.
	self assert: stack pop equals: 'winter'! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 22:49:41'!
test06StackEmptyRemainsEmptyAndNoSentencesAreFound
	| stack sentenceFinderByPrefix sentences |

	stack := OOStack new.

	sentenceFinderByPrefix := SentenceFinderByPrefix initializeFinderWithPrefix: 'impossible' on: stack.
	sentences := sentenceFinderByPrefix find.

	self assert: stack size equals: 0.
	self assert: sentences isEmpty! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 23:02:08'!
test07CanNotCreateSentenceFinderWithEmptyPrefix

	self
		should: [ SentenceFinderByPrefix initializeFinderWithPrefix: '' on: OOStack new ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix errorEmptyPrefix ]
! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'N S 9/17/2023 23:02:48'!
test08CanNotCreateSentenceFinderWithSpacedPrefix

	self
		should: [ SentenceFinderByPrefix initializeFinderWithPrefix: 'winter is coming' on: OOStack new ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix errorEmptySpacesInPrefix ]
! !


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

!OOStackElements methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 22:15:15'!
accessValue

	self subclassResponsibility ! !

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
	instanceVariableNames: 'stack prefix sentencesWithPrefix checkedSentences'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'initializing' stamp: 'gg 9/17/2023 21:07:22'!
initializeWithPrefix: aPrefix on: anOOStack

	stack := anOOStack .
	prefix := aPrefix.! !


!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'N S 9/17/2023 22:25:15'!
find

	sentencesWithPrefix := OrderedCollection new.
	checkedSentences := OrderedCollection new.
	self findSentencesWithGivenPrefix.
	self reconstructStack.
	^sentencesWithPrefix! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 21:06:26'!
findSentencesWithGivenPrefix

	stack size timesRepeat: [ self verifyTopSentenceStartsWithPrefix ].! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 22:12:10'!
reconstructStack

	checkedSentences size timesRepeat: [
		stack push: checkedSentences first.
		checkedSentences removeFirst ].! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'gg 9/17/2023 22:12:10'!
verifyTopSentenceStartsWithPrefix

	| topSentence |
	topSentence := stack top.
	(topSentence beginsWith: prefix) ifTrue: [ sentencesWithPrefix addFirst: topSentence ].
	checkedSentences addFirst: topSentence .
	stack pop.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'prefix verifications' stamp: 'N S 9/17/2023 23:01:17'!
verifyNotEmpty: aPrefix

	aPrefix ='' ifTrue: [self error: self errorEmptyPrefix]! !

!SentenceFinderByPrefix class methodsFor: 'prefix verifications' stamp: 'gg 9/17/2023 21:45:26'!
verifyNotEmptySpaces: aPrefix

	(aPrefix includesSubString: ' ') ifTrue: [self error: self errorEmptySpacesInPrefix]! !


!SentenceFinderByPrefix class methodsFor: 'instance creation' stamp: 'N S 9/17/2023 22:27:57'!
initializeFinderWithPrefix: aPrefix on: anOOStack

	self verifyNotEmpty: aPrefix.
	self verifyNotEmptySpaces: aPrefix.

	^SentenceFinderByPrefix new initializeWithPrefix: aPrefix on: anOOStack. ! !


!SentenceFinderByPrefix class methodsFor: 'error messages' stamp: 'gg 9/17/2023 21:12:39'!
errorEmptyPrefix

	^ 'Empty prefix!!'! !

!SentenceFinderByPrefix class methodsFor: 'error messages' stamp: 'gg 9/17/2023 21:12:57'!
errorEmptySpacesInPrefix

	^ 'Prefix has spaces!!'! !
