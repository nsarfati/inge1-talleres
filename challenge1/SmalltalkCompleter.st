'From Cuis 6.0 [latest update: #5981] on 14 October 2023 at 5:04:35 am'!
!classDefinition: #SmalltalkCompleter category: #'Tools-Autocompletion'!
AutoCompleter subclass: #SmalltalkCompleter
	instanceVariableNames: 'parser selectorsClasses possibleInvalidSelectors canShowSelectorDocumentation possibleBinarySendRange allRanges'
	classVariableNames: 'AccessLock EntriesLimit Selectors'
	poolDictionaries: ''
	category: 'Tools-Autocompletion'!
!SmalltalkCompleter commentStamp: 'jmv 7/14/2011 14:25' prior: 0!
An autocompleter specialized in Smalltalk code!


!SmalltalkCompleter methodsFor: 'entries' stamp: 'NMS 10/14/2023 03:54:17'!
computeEntries

	| allSource source contextClass specificModel range
	separator fragmentStart fragmentEnd done |

	specificModel := self textProviderOrModel.
	contextClass := self selectedClassOrMetaClassIn: specificModel.

	allSource := self allSource.
	(specificModel is: #CodeProvider)
		ifTrue: [source := allSource copyFrom: 1 to: position]
		ifFalse: [
			separator := String newLineString, String newLineString.
			fragmentStart := 1.
			done := false.
			[done] whileFalse: [
				fragmentEnd := allSource
					indexOfSubCollection: separator
					startingAt: fragmentStart
					ifAbsent: [allSource size].
				fragmentEnd >= position ifTrue: [
					source := allSource copyFrom: fragmentStart to: position.
					done := true ].
				fragmentStart := fragmentEnd+separator size ]].

	allRanges := self parse: source in: contextClass and: specificModel.
	range := allRanges lastIfEmpty: [ ^entries := #() ].
	possibleInvalidSelectors := #().

	range end = source size
		ifTrue: [ self computeEntriesOfMessageOrIdentifiersFor: source at: range in: contextClass and: specificModel ]
	 	ifFalse: [ self computeMessageEntriesWithEmptyPrefixFor: source at: range in: contextClass and: specificModel ].

	! !

!SmalltalkCompleter methodsFor: 'entries' stamp: 'HAW 9/23/2018 19:23:35'!
newCursorPosition: anEntry

	^anEntry indexOf: $ ! !

!SmalltalkCompleter methodsFor: 'entries' stamp: 'HAW 1/19/2019 23:55:29'!
selectedEntryFormatted

	^(self entries at: menuMorph selected) separateKeywords! !


!SmalltalkCompleter methodsFor: 'entries - private ' stamp: 'HAW 5/3/2020 01:09:40'!
canComputeMessageEntriesFor: prevRange 

	^ prevRange rangeType notNil ! !

!SmalltalkCompleter methodsFor: 'entries - private ' stamp: 'jmv 5/24/2020 20:25:23'!
selectedClassOrMetaClassIn: specificModel

	(specificModel is: #CodeProvider) ifTrue: [ ^ specificModel selectedClassOrMetaClass ].
	
	"I can not use #selectedClassOrMetaClass becuase it changes with the selection but when compiling to evaluate it assumes object as receiver - Hernan"
	^ (specificModel isKindOf: Inspector) ifTrue: [ specificModel objectClass ] ! !

!SmalltalkCompleter methodsFor: 'entries - private ' stamp: 'HAW 2/8/2019 17:09:54'!
selectorsClasses

	^selectorsClasses ! !

!SmalltalkCompleter methodsFor: 'entries - private ' stamp: 'HAW 9/23/2018 19:30:43'!
textProviderOrModel

	^ (model is: #hasTextProvider) ifTrue: [ model textProvider ] ifFalse: [ model ].! !


!SmalltalkCompleter methodsFor: 'testing' stamp: 'HAW 2/8/2019 17:29:12'!
canSelect: anEntry

	^ (self isCategoryEntry: anEntry) not! !

!SmalltalkCompleter methodsFor: 'testing' stamp: 'HAW 2/21/2019 16:06:32'!
canShowSelectorDocumentation

	^canShowSelectorDocumentation ! !

!SmalltalkCompleter methodsFor: 'testing' stamp: 'HAW 2/8/2019 17:29:29'!
isCategoryEntry: anEntry

	^anEntry beginsWith: AutoCompleterSelectorsCollector categoryEntryHeader! !

!SmalltalkCompleter methodsFor: 'testing' stamp: 'HAW 2/10/2019 21:35:32'!
isPossibleInvalidEntry: anEntry

	^possibleInvalidSelectors includes: anEntry ! !

!SmalltalkCompleter methodsFor: 'testing' stamp: 'HAW 2/21/2019 15:55:07'!
opensWithTab

	^true! !


!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 9/23/2018 16:52:20'!
classOfLiteral: aLiteral in: aClass 
	
	| compilerClass |
	
	compilerClass := aClass ifNil: [ Compiler ] ifNotNil: [ aClass compilerClass ].
	
	^ (compilerClass evaluate: aLiteral) class ! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 9/23/2018 16:52:36'!
classOfLocalBindingNamed: aName in: aClass 
	
	^  (aClass localBindingOf: aName) ifNotNil: [ :aBinding | aBinding value class ]! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 12/4/2019 15:18:56'!
computeEntriesOfUnaryMessageReturnNamed: aSelector at: aRange   
	
	self subclassResponsibility ! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'jmv 1/20/2023 20:07:32'!
computeMessageEntriesFor: allSource at: range in: contextClass and: specificModel  
	
	| id rangeType |

	canShowSelectorDocumentation _ true.
	id _ allSource copyFrom: range start to: range end.
	rangeType _ range rangeType.

	rangeType == #globalVar
		ifTrue: [ ^self computeMessageEntriesForClass: (Smalltalk at: id asSymbol) class ].
	rangeType == #self
		ifTrue: [ ^self computeMessageEntriesForClass: contextClass ].
	rangeType == #super
		ifTrue: [ ^self computeMessageEntriesForClass: contextClass superclass ].
	rangeType == #true 
		ifTrue: [ ^self computeMessageEntriesForClass: True ].
	rangeType == #false
		ifTrue: [ ^self computeMessageEntriesForClass: False ].
	rangeType == #nil
		ifTrue: [ ^self computeMessageEntriesForClass: UndefinedObject ].
	rangeType == #character
		ifTrue: [ ^self computeMessageEntriesForClass: (id first asciiValue ifNotNil: [Character] ifNil: [UnicodeCodePoint]) ].
	rangeType == #number
		ifTrue: [ ^self computeMessageEntriesForClass: (self classOfLiteral: id in: contextClass) ].
	rangeType == #string
		ifTrue: [ ^self computeMessageEntriesForClass: (self classOfLiteral: id in: contextClass) ].
	rangeType == #symbol
		ifTrue: [ ^self computeMessageEntriesForClass: (self classOfLiteral: id in: contextClass) ].
	rangeType == #stringSymbol
		ifTrue: [ ^self computeMessageEntriesForClass: (self classOfLiteral: id in: contextClass) ].
	rangeType == #instVar
		ifTrue: [ ^specificModel computeMessageEntriesIn: self ofInstVarNamed: id ].
	rangeType == #methodArg
		ifTrue: [ ^specificModel computeMessageEntriesIn: self ofTempVarNamed: id ].
	rangeType == #tempVar
		ifTrue: [ ^specificModel computeMessageEntriesIn: self ofTempVarNamed: id ].
	rangeType == #blockArg
		ifTrue: [ ^specificModel computeMessageEntriesIn: self ofBlockArgNamed: id ].
	rangeType == #blockTempVar
		ifTrue: [ ^specificModel computeMessageEntriesIn: self ofBlockTempVarNamed: id ].
	rangeType == #workspaceVar
		ifTrue: [ ^self computeMessageEntriesForClassOrNil: (specificModel classOfWorkspaceVarNamed: id) ].
	rangeType == #thisContext
		ifTrue: [ ^self computeMessageEntriesForClass: (specificModel classOfThisContext) ]. 
	rangeType == #classVar
		ifTrue: [ ^self computeMessageEntriesForClassOrNil: (self classOfLocalBindingNamed: id in: contextClass) ].
	rangeType == #poolConstant
		ifTrue: [ ^self computeMessageEntriesForClassOrNil: (self classOfLocalBindingNamed: id in: contextClass) ].
	(rangeType beginsWith: #blockEnd)
		ifTrue: [ ^self computeMessageEntriesForClass: BlockClosure ].
	rangeType == #arrayEnd
		ifTrue: [ ^self computeMessageEntriesForClass: Array ].
	(rangeType beginsWith: #rightBrace)
		ifTrue: [ ^self computeMessageEntriesForClass: Array ].
	rangeType == #unary
		ifTrue: [ ^self computeEntriesOfUnaryMessageReturnNamed: id at: range ].
	(rangeType beginsWith: #rightParenthesis)
		ifTrue: [ ^self computeMessageEntriesOfEnclosedExpressionReturnAt: range ].
	rangeType == #cascadeSeparator
		ifTrue: [ ^self computeMessageEntriesOfCascadeReceiverAt: range ]. 

	self computeMessageEntriesForUnknowClass 
	
	! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 12/4/2019 15:37:54'!
computeMessageEntriesForClass: aClass  

	self isPreviousMessageSendBinary
		ifTrue: [ self computeMessageEntriesWithBinaryMessageForClass: aClass ]
		ifFalse: [ self computeMessageEntriesWithoutBinaryMessageForClass: aClass ].
		
	self ifEmptyEntriesShowAllPrefixedSelectors! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 12/4/2019 15:37:55'!
computeMessageEntriesForClassOrNil: aClassOrNil  

	aClassOrNil 
		ifNil: [ self computeMessageEntriesForUnknowClass ]
		ifNotNil: [ self computeMessageEntriesForClass: aClassOrNil ].
	
! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 12/4/2019 15:20:04'!
computeMessageEntriesOfCascadeReceiverAt: aRange   
	
	self subclassResponsibility ! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 12/4/2019 15:19:35'!
computeMessageEntriesOfEnclosedExpressionReturnAt: aRange   

	self subclassResponsibility ! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 5/4/2020 15:42:32'!
computeMessageEntriesWhenSendinMessageFor: allSource in: contextClass and: specificModel 
	
	| lastRange |
	
	allRanges removeLast.
	lastRange _ allRanges lastIfEmpty: [ SHRange nilObject ].
	possibleBinarySendRange _ self lookForBinarySendRange.
	
	^ (self canComputeMessageEntriesFor: lastRange) 
		ifTrue: [ self computeMessageEntriesFor: allSource at: lastRange in: contextClass and: specificModel ]
		ifFalse: [ self computeMessageEntriesForUnknowClass ]
! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'NPM 3/18/2020 19:50:06'!
computeMessageEntriesWithBinaryMessageForClass: aClass 

	selectorsClasses := Array with: aClass.
	
	entries := self unaryAndBinarySelectorsOf: aClass beginningWith: prefix.
		! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 5/4/2020 15:42:32'!
computeMessageEntriesWithEmptyPrefixFor: allSource at: range in: contextClass and: specificModel 
	
	possibleBinarySendRange _ self lookForBinarySendRange.
	prefix _ ''.

	self computeMessageEntriesFor: allSource at: range in: contextClass and: specificModel .! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'NPM 3/18/2020 19:51:12'!
computeMessageEntriesWithoutBinaryMessageForClass: aClass

	selectorsClasses := Array with: aClass.
	
	entries := self selectorsOf: aClass beginningWith: prefix.! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 2/21/2019 22:00:30'!
ifEmptyEntriesShowAllPrefixedSelectors

	entries isEmpty ifTrue: [ self computeMessageEntriesForUnknowClass ] ! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 12/4/2019 15:26:55'!
isPreviousMessageSendBinary

	^possibleBinarySendRange notNil and: [ possibleBinarySendRange rangeType = #binary ].

	! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 5/4/2020 15:49:19'!
lookForBinarySelectorAfter: aStopToken startingAt: anIndex with: aCandidate

	| currentRange currentIndex |
	
	currentIndex := anIndex.
	[ currentRange := allRanges at: currentIndex.
	currentRange rangeType ~= aStopToken and: [ currentIndex > 1 ]] whileTrue: [ currentIndex := currentIndex - 1 ].

	^currentIndex > 1
		ifTrue: [ allRanges at: currentIndex - 1 ]
		ifFalse: [ aCandidate ].
! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 5/4/2020 15:43:49'!
lookForBinarySelectorAfterArrayStartStartingAt: anIndex with: aCandidate
 
	| foundRange foundRangeIndex |
	
	foundRange := self lookForBinarySelectorAfter: #arrayStart startingAt: anIndex with: aCandidate.
	
	^foundRange rangeType = #symbol
		ifTrue: [ 
			foundRangeIndex := allRanges indexOf: foundRange.
			allRanges at: foundRangeIndex - 1 ifAbsent: [ aCandidate ]]
		ifFalse: [ aCandidate ]! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 5/4/2020 15:45:27'!
lookForBinarySendRange

	| penultimate currentIndex currentRangeType |

	currentIndex := self lookForNoUnaryMessageSend.
	penultimate := allRanges at: currentIndex - 1 ifAbsent: [ SHRange nilObject ].

	currentRangeType := (allRanges at: currentIndex) rangeType.
	currentRangeType = #rightParenthesis ifTrue: [ 
		^self lookForBinarySelectorAfter: #leftParenthesis startingAt: currentIndex with: penultimate ].	
	currentRangeType = #rightBrace ifTrue: [
		^self lookForBinarySelectorAfter: #leftBrace startingAt: currentIndex with: penultimate ].	
	currentRangeType = #blockEnd ifTrue: [
		^self lookForBinarySelectorAfter: #blockStart startingAt: currentIndex with: penultimate ].	
	currentRangeType = #arrayEnd ifTrue: [
		^self lookForBinarySelectorAfterArrayStartStartingAt: currentIndex with: penultimate ].	

	^({#'$'. #symbol} includes: penultimate rangeType)
		ifTrue: [ allRanges at: currentIndex - 2 ifAbsent: [ SHRange nilObject ] ]
		ifFalse: [ penultimate ]! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'HAW 5/4/2020 15:46:02'!
lookForNoUnaryMessageSend
		
	| currentIndex currentRangeType |
	
	currentIndex := allRanges size.
	[ currentRangeType := (allRanges at: currentIndex) rangeType.
	currentRangeType = #unary and: [ currentIndex > 1 ]] whileTrue: [ currentIndex := currentIndex - 1 ].

	^currentIndex! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'NPM 3/18/2020 19:50:30'!
selectorsOf: aClass beginningWith: aPrefix

	^ (AutoCompleterSelectorsCollector for: aPrefix) 
		addSelectorsOf: aClass;
		entriesToShow! !

!SmalltalkCompleter methodsFor: 'message entries - private' stamp: 'NPM 3/18/2020 19:50:06'!
unaryAndBinarySelectorsOf: aClass beginningWith: aPrefix 

	^ (AutoCompleterSelectorsCollector for: aPrefix) 
		addUnaryAndBinarySelectorsOf: aClass;
		entriesToShow! !


!SmalltalkCompleter methodsFor: 'identifier entries - private' stamp: 'NPM 3/18/2020 20:44:01'!
computeIdentifierEntries
	
	canShowSelectorDocumentation _ false.
	entries _ self computeIdentifierEntriesBeginningWith: prefix.! !

!SmalltalkCompleter methodsFor: 'identifier entries - private' stamp: 'NPM 3/17/2020 17:53:08'!
computeIdentifierEntriesBeginningWith: aPrefix
	"Use an aux Set to avoid duplicates, but keep the order given."

	| entriesSet lastTitle candidates |
	entriesSet _ Set new.
	lastTitle _ nil.
	
	candidates _ Array streamContents: [ :strm |
		parser namesBeginningWith: aPrefix do: [ :identifier :kindOfIdentifierTitle |
			(entriesSet includes: identifier) ifFalse: [
				kindOfIdentifierTitle = lastTitle ifFalse: [
					strm nextPut: kindOfIdentifierTitle.
					lastTitle _ kindOfIdentifierTitle ].
				entriesSet  add: identifier.
				strm nextPut: identifier ]]].
	entriesSet size = 1 ifTrue: [
		^ Array with: entriesSet anyOne ]
		ifFalse: [ ^ candidates ]! !

!SmalltalkCompleter methodsFor: 'identifier entries - private' stamp: 'NMS 10/14/2023 04:28:02'!
computeMethodNamesFor: aClassName
	canShowSelectorDocumentation := false.
	entries := (self computeMethodNamesFor: aClassName andMethodPrefix: ((parser source substrings) at: 1))! !

!SmalltalkCompleter methodsFor: 'identifier entries - private' stamp: 'NMS 10/14/2023 04:14:19'!
computeMethodNamesFor: aClassName andMethodPrefix: aMethodStartingWith
	^(aClassName allSelectors select: [ :aSelector | aSelector beginsWith: aMethodStartingWith ]) asOrderedCollection sort.! !


!SmalltalkCompleter methodsFor: 'message entries for unknown class - private' stamp: 'HAW 12/20/2018 14:43:28'!
add: selector and: lastUsedTime to: selectorsToShow

	^ selectorsToShow size < EntriesLimit
		ifTrue: [ self add: selector and: lastUsedTime whenNotFullTo: selectorsToShow ]
		ifFalse: [ self add: selector and: lastUsedTime whenFullTo: selectorsToShow ]	! !

!SmalltalkCompleter methodsFor: 'message entries for unknown class - private' stamp: 'HAW 12/20/2018 14:44:54'!
add: selector and: lastUsedTime whenFullTo: selectorsToShow

	selectorsToShow
		findBinaryIndex: [ :selectorAndTime | selectorAndTime second < lastUsedTime ifTrue: [ -1 ] ifFalse: [ 1 ]]
		do: [ :found | ]
		ifNone: [ :leftBound :rightBound | self insert: selector and: lastUsedTime at: rightBound to: selectorsToShow ].
		
	^selectorsToShow 
! !

!SmalltalkCompleter methodsFor: 'message entries for unknown class - private' stamp: 'HAW 12/20/2018 14:49:34'!
add: selector and: lastUsedTime whenNotFullTo: selectorsToShow
			
	selectorsToShow add: { selector . lastUsedTime }.
	
	^selectorsToShow size = EntriesLimit 
		ifTrue: [ self sortByLastUsedTime: selectorsToShow ]
		ifFalse: [ selectorsToShow ]
	! !

!SmalltalkCompleter methodsFor: 'message entries for unknown class - private' stamp: 'NPM 3/18/2020 20:47:56'!
computeMessageEntriesForUnknowClass

	selectorsClasses _ #().
	possibleInvalidSelectors _ IdentitySet new.
	canShowSelectorDocumentation _ true.
	entries _ self computeMessageEntriesForUnknowClassAddingPossibleInvalidSelectorsTo: possibleInvalidSelectors.! !

!SmalltalkCompleter methodsFor: 'message entries for unknown class - private' stamp: 'NPM 3/16/2020 23:09:03'!
computeMessageEntriesForUnknowClassAddingPossibleInvalidSelectorsTo: aCollection

	| selectorsToShow |
	selectorsToShow _ OrderedCollection new.
	
	self class protected: [
		Selectors forPrefix: prefix keysAndValuesDo: [ :selector :lastUsedTime |
				selectorsToShow := self add: selector and: lastUsedTime to: selectorsToShow.
				(Object canUnderstand: selector) ifFalse: [ aCollection add: selector ]]].
				
	selectorsToShow size < EntriesLimit ifTrue: [ selectorsToShow _  self sortByLastUsedTime: selectorsToShow ].
	
	" To see the timestamps in the menu (need to tweak #insertCompletion: to activate. Right now, just for debugging)
	entries _ selectorsToShow collect: [ :ary | ary first, '(', ((DateAndTime fromString: '01/01/1996 00:00') + ary second minutes) printString,')' ]
	"
	^ selectorsToShow collect: [ :selectorAndTime | selectorAndTime first ]
	
! !

!SmalltalkCompleter methodsFor: 'message entries for unknown class - private' stamp: 'HAW 12/20/2018 14:45:44'!
insert: selector and: lastUsedTime at: insertionIndex to: selectorsToShow

	insertionIndex <= EntriesLimit ifTrue: [ selectorsToShow insert: { selector . lastUsedTime } shiftingRightAt: insertionIndex ].
	
	^selectorsToShow ! !

!SmalltalkCompleter methodsFor: 'message entries for unknown class - private' stamp: 'HAW 12/20/2018 14:44:13'!
sortByLastUsedTime: selectorsToShow

	^selectorsToShow asArray sort: [ :leftSelectorAndTime :rightSelectorAndTime | leftSelectorAndTime second > rightSelectorAndTime second ]! !


!SmalltalkCompleter methodsFor: 'selector documentation' stamp: 'HAW 2/8/2019 18:12:00'!
documentationOf: aMethod

	self subclassResponsibility ! !


!SmalltalkCompleter methodsFor: 'accessing' stamp: 'jmv 4/26/2021 19:28:15'!
allSource
	^model actualContents string! !

!SmalltalkCompleter methodsFor: 'accessing' stamp: 'NPM 3/17/2020 17:30:02'!
possibleInvalidSelectors
	
	^ possibleInvalidSelectors! !


!SmalltalkCompleter methodsFor: 'menu morph' stamp: 'jmv 7/6/2020 09:23:50'!
morphClass
	^SmalltalkCompleterMorph! !


!SmalltalkCompleter methodsFor: 'keyboard' stamp: 'jmv 7/6/2020 10:06:22'!
handleLeftArrowKeystrokeBefore: kbEvent
	canShowSelectorDocumentation ifTrue: [
		menuMorph hideSelectorDocumentation ].
	^ true! !

!SmalltalkCompleter methodsFor: 'keyboard' stamp: 'jmv 7/6/2020 10:06:11'!
handleRightArrowKeystrokeBefore: kbEvent
	canShowSelectorDocumentation ifTrue: [
		menuMorph showSelectorDocumentation ].
	^ true! !


!SmalltalkCompleter methodsFor: 'entries - private' stamp: 'NMS 10/14/2023 04:46:23'!
computeEntriesOfMessageOrIdentifiersFor: allSource at: range in: contextClass and: specificModel
	prefix := allSource copyFrom: range start to: range end.
	(parser isMessage: range rangeType) ifTrue: [ 
		^self computeMessageEntriesWhenSendinMessageFor: allSource in: contextClass and: specificModel ].	
	(parser isPartialOrFullIdentifier: range rangeType) ifTrue: [ ^self computeIdentifierEntries ].
	(parser isAMethodDefinition: range rangeType) ifTrue: [ ^self computeMethodNamesFor: contextClass ].

	"If we don't know what to do, do nothing"
	entries := #() ! !

!SmalltalkCompleter methodsFor: 'entries - private' stamp: 'jmv 4/26/2021 19:32:47'!
parse: source in: contextClass and: specificModel
	
	| isMethod |
	parser _ SHParserST80 new.
	parser
		workspace: ((specificModel is: #providesBindings) ifTrue: [specificModel]);
		classOrMetaClass: contextClass;
		source: source.

	isMethod := (specificModel is: #Browser)
		ifTrue: [ specificModel isEditingClass not ]
		ifFalse: [ specificModel is: #CodeProvider ].
	parser parse: isMethod.

	^ parser rangesWithoutExcessCode.! !


!SmalltalkCompleter methodsFor: '*BaseImageTests' stamp: 'NPM 3/17/2020 03:12:11'!
changePositionTo: newPosition 
	
	position _ newPosition! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SmalltalkCompleter class' category: #'Tools-Autocompletion'!
SmalltalkCompleter class
	instanceVariableNames: ''!

!SmalltalkCompleter class methodsFor: 'class initialization' stamp: 'jmv 4/8/2022 16:05:32'!
addSelector: aSymbol

	self protected: [
		Selectors at: aSymbol ifAbsentPut: 0 ].! !

!SmalltalkCompleter class methodsFor: 'class initialization' stamp: 'jmv 12/21/2018 17:33:20'!
addSelector: aSymbol method: aCompiledMethod allImplemented: implemented

	| sentValue value |
	self protected: [
		value _ (ChangeSet notInstallOrTestRun or: [Smalltalk platformName ~= 'Win32'])
			ifTrue: [
				"Expensive and not worth doing in Windows with antivirus active, when installing large packages"
				aCompiledMethod dateSortingValue ]
			ifFalse: [ 0 ].
		Selectors at: aSymbol put: (value  max: (Selectors at: aSymbol ifAbsent: [0])).
		aCompiledMethod messages do: [ :sentMsg |
			((Selectors includesKey: sentMsg) or: [ 
				implemented
					ifNotNil: [ implemented includes: sentMsg ]
					ifNil: [ Smalltalk isThereAnImplementorOf: sentMsg ]])
						ifTrue: [
							sentValue _ value max: (Selectors at: sentMsg ifAbsent: [0]).
							Selectors at: sentMsg put: sentValue ]]]! !

!SmalltalkCompleter class methodsFor: 'class initialization' stamp: 'jmv 1/29/2020 08:49:30'!
initialize
	"
	It takes about 6 seconds, mostly because of the time to fetch method stamps from source files...
	[ SmalltalkCompleter initialize ]timeToRun
	Selectors inspect
	"
	| maxSortValue allImplemented |
	
	EntriesLimit _ 100.
	
	SystemChangeNotifier uniqueInstance
		removeActionsWithReceiver: self.	 "avoid double registration"

	SystemChangeNotifier uniqueInstance
		when: #classRemoved send: #classRemoved:fromCategory: to: self;
		when: #methodAddedInProtocol send: #methodAdded:selector:inProtocol:class:requestor: to: self;
		when: #methodRemoved send: #methodRemoved:selector:inProtocol:class: to: self.
	
	self protected: [
		allImplemented _ Smalltalk allImplementedMessages.
		Selectors _ Trie new.
		"
		Smalltalk allBehaviorsDo: [:class |
			class selectorsAndMethodsDo: [ :sel :method |
				Selectors at: sel ifAbsentPut: [ 0 ].
				method messages do: [ :sentMsg |
					Selectors at: sentMsg put: (Selectors at: sentMsg ifAbsent: [ 0 ]) + 1 ]]].
		"
		Smalltalk allBehaviorsDo: [:class |
			class selectorsAndMethodsDo: [ :sel :method |
				self addSelector: sel method: method allImplemented: allImplemented]].
		""
	
		"The following might not be found in #messages. Give them maximum priority."
		maxSortValue _ SmallInteger maxVal.
		"From MessageNode>>#initialize"
		#(	ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue:
			and: or:
			whileFalse: whileTrue: whileFalse whileTrue
			to:do: to:by:do:
			caseOf: caseOf:otherwise:
			ifNil: ifNotNil:  ifNil:ifNotNil: ifNotNil:ifNil:) do: [ :sel |
				Selectors at: sel put: maxSortValue ].
	
		maxSortValue _ SmallInteger maxVal-1.
		"From SystemDictionary >>#recreateSpecialObjectsArray"
		(1 to: Smalltalk specialSelectorSize) do:  [ :i | | sym |
			sym _ Smalltalk specialSelectorAt: i.
			(Selectors includesKey: sym)
				ifTrue: [ Selectors at: sym put: maxSortValue ]]]! !


!SmalltalkCompleter class methodsFor: 'services' stamp: 'jmv 7/14/2011 13:58'!
isThereAnImplementorOf: aSymbol
	| answer |
	self protected: [
		answer _ Selectors includesKey: aSymbol ].
	^answer! !

!SmalltalkCompleter class methodsFor: 'services' stamp: 'jmv 7/14/2011 13:58'!
thatStartsCaseSensitive: prefix
	self protected: [
		Selectors forPrefix: prefix keysAndValuesDo: [ :key :value | ^key ] ].
	^nil! !


!SmalltalkCompleter class methodsFor: 'synchronization' stamp: 'jmv 7/14/2011 13:58'!
protected: aBlock

	^(AccessLock ifNil: [ AccessLock := Mutex new ]) critical: aBlock! !


!SmalltalkCompleter class methodsFor: 'system change notifications' stamp: 'jmv 4/19/2014 18:38'!
classRemoved: aClass fromCategory: aCategoryName

	self protected: [
		aClass selectorsDo: [ :selector |
			(Smalltalk isThereAnImplementorOf: selector exceptFor: { aClass . aClass class }) ifFalse: [
				Selectors removeKey: selector ifAbsent: nil ]].
		aClass class selectorsDo: [ :selector |
			(Smalltalk isThereAnImplementorOf: selector exceptFor: { aClass . aClass class }) ifFalse: [
				Selectors removeKey: selector ifAbsent: nil ]]]! !

!SmalltalkCompleter class methodsFor: 'system change notifications' stamp: 'jmv 3/19/2012 08:01'!
methodAdded: aMethod selector: aSymbol inProtocol: aCategoryName class: aClass requestor: requestor

	self protected: [
		 self addSelector: aSymbol method: aMethod allImplemented: nil ]! !

!SmalltalkCompleter class methodsFor: 'system change notifications' stamp: 'jmv 3/19/2012 07:59'!
methodRemoved: aMethod selector: aSymbol inProtocol: protocol class: aClass

	self protected: [
		(Smalltalk isThereAnImplementorOf: aSymbol) not ifTrue: [
			Selectors removeKey: aSymbol ifAbsent: nil ]]! !


!SmalltalkCompleter class methodsFor: 'instance creation' stamp: 'HAW 2/10/2019 17:44:10'!
withModel: aStringHolder

	"Looks it its subclasses the right autocompleter depending on the Type System. If you do not have
	Live Typing installed you will see only one subclass but if Live Typing is intalled LiveTypeingSmalltalkCompleter
	subclass is added - Hernan"
	
	| smalltalkCompleterClass |
	
	smalltalkCompleterClass := self subclasses detect: [ :aSubclass | aSubclass isForCurrentTypeSystem ].
	
	^smalltalkCompleterClass new setModel: aStringHolder! !


!SmalltalkCompleter class methodsFor: 'testing' stamp: 'HAW 2/8/2019 15:57:29'!
isForCurrentTypeSystem

	self subclassResponsibility ! !


!SmalltalkCompleter class methodsFor: 'accessing' stamp: 'HAW 5/2/2020 20:47:22'!
changeEntriesLimitTo: aNewLimit during: aBlock

	| previousLimit |
	
	previousLimit := EntriesLimit.
	EntriesLimit := aNewLimit.
	
	^aBlock ensure: [ EntriesLimit := previousLimit ]! !

!SmalltalkCompleter class methodsFor: 'accessing' stamp: 'HAW 2/15/2019 15:27:22'!
entriesLimit
	
	^EntriesLimit ! !


SmalltalkCompleter initialize!
