'From Cuis 6.0 [latest update: #5981] on 20 October 2023 at 1:40:21 am'!


!SmalltalkCompleter methodsFor: 'identifier entries - private' stamp: 'MH-NMS 10/16/2023 11:39:40'!
computeMethodNamesFor: aContextClass andMethodPrefix: aMethodStartingWith
	^((aContextClass superclass allSelectors select: [ :aSelector | aSelector beginsWith: aMethodStartingWith ]) collect: [ :aSelector | aContextClass methodHeaderFor: aSelector ]) asOrderedCollection sort.! !


!SHParserST80 methodsFor: 'testing' stamp: 'MH-NMS 10/16/2023 13:39:05'!
isAMethodDefinition: aSymbol
	^#(patternUnary patternBinary patternKeyword) statePointsTo: aSymbol! !


!AutoCompleter methodsFor: 'keyboard - private' stamp: 'MH-NMS 10/20/2023 00:37:34'!
shouldOpenMorphWhenPrefixAt: currentPos and: currentChar 
	
	^ model textSize >= currentPos and: [ currentChar isAlphaNumeric or: [ currentChar isValidInBinarySelectors or: [ currentChar = $: ]]]! !


!SmalltalkCompleter methodsFor: 'entries' stamp: 'MH-NMS 10/20/2023 01:08:09'!
newCursorPosition: anEntry
	(parser isAMethodDefinition: allRanges last rangeType) ifTrue: [^anEntry size - 1].
	^anEntry indexOf: $ ! !

!SmalltalkCompleter methodsFor: 'identifier entries - private' stamp: 'MH-NMS 10/20/2023 01:38:33'!
computeMethodNamesFor: aContextClass
	canShowSelectorDocumentation := false.
	entries := (self computeMethodNamesFor: aContextClass andMethodPrefix: prefix)! !

!SmalltalkCompleter methodsFor: 'entries - private' stamp: 'MH-NMS 10/16/2023 11:48:28'!
computeEntriesOfMessageOrIdentifiersFor: allSource at: range in: contextClass and: specificModel
	prefix := allSource copyFrom: range start to: range end.
	(parser isMessage: range rangeType) ifTrue: [ 
		^self computeMessageEntriesWhenSendinMessageFor: allSource in: contextClass and: specificModel ].	
	(parser isPartialOrFullIdentifier: range rangeType) ifTrue: [ ^self computeIdentifierEntries ].
	(parser isAMethodDefinition: range rangeType) ifTrue: [ ^self computeMethodNamesFor: contextClass ].

	"If we don't know what to do, do nothing"
	entries := #() ! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 11:57:00'!
test045_AutocompletesEntriesFor_patternUnary_containsExactlyTwoMethods

	| completer |
	completer := self createCompleterForBrowsing: 'fl'.
	
	completer computeEntries.

	self assert: completer entries size equals: 2.
	self assert: completer entries includes: 'flag: aSymbol'.
	self assert: completer entries includes: 'flash'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 13:35:15'!
test046_AutocompletesEntriesFor_patternUnary_notContainsAnyMethod

	| completer |
	completer := self createCompleterForBrowsing: 'flagggg'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 13:35:25'!
test047_AutocompletesEntriesFor_patternUnary_doesNotAutocompleteMethodOfSameClass

	| completer |
	completer := self createCompleterForBrowsing: 'm1'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 13:35:37'!
test048_AutocompletesEntriesFor_patternKeyword_containsExactlyOneMethod

	| completer |
	completer := self createCompleterForBrowsing: 'flag:'.
	
	completer computeEntries.

	self assert: completer entries size equals: 1.
	self assert: completer entries includes: 'flag: aSymbol'
! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/14/2023 06:13:52'!
test049_AutocompletesEntriesFor_patternKeyword_notContainsAnyMethod

	| completer |
	completer := self createCompleterForBrowsing: 'flagg:'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 12:00:36'!
test050_AutocompletesEntriesFor_patternKeyword_doesNotAutocompleteMethodOfSameClass

	| completer |
	completer := self createCompleterForBrowsing: 'm1:'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 13:35:57'!
test051_AutocompletesEntriesFor_patternBinary_containsExactlyOneMethod

	| completer |
	completer := self createCompleterForBrowsing: '->'.
	
	completer computeEntries.

	self assert: completer entries size equals: 1.
	self assert: completer entries includes: '-> anObject'! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 13:36:07'!
test052_AutocompletesEntriesFor_patternBinary_notContainsAnyMethod

	| completer |
	completer := self createCompleterForBrowsing: '*'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/16/2023 13:36:03'!
test053_AutocompletesEntriesFor_patternBinary_doestNotAutocompleteMethodOfSameClass

	| completer |
	completer := self createCompleterForBrowsing: '+'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'MH-NMS 10/20/2023 01:40:10'!
+ aNumber! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'MH-NMS 10/14/2023 06:08:26'!
m1: arg1 with: arg2 and: arg3 andLast: arg4! !


!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'MH-NMS 10/14/2023 03:53:39'!
test038_DoesNotAutocompleteEntriesFor_UndefinedIdentifiers

	| completer |
	completer := self createCompleterForBrowsing: 'asddas: kdkk ads'.
	
	completer computeEntries.
	
	self denyHasEntries: completer ! !
