'From Cuis 6.0 [latest update: #5981] on 14 October 2023 at 5:05:09 am'!
!classDefinition: #SHParserST80 category: #'Tools-Syntax Highlighting'!
Object subclass: #SHParserST80
	instanceVariableNames: 'classOrMetaClass source workspace arguments sourcePosition currentToken currentTokenFirst temporaries instanceVariables errorBlock currentTokenSourcePosition blockDepth bracketDepth ranges blockDepths blockDepthsStartIndexes braceDepth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tools-Syntax Highlighting'!
!SHParserST80 commentStamp: '<historical>' prior: 0!
I am a Smalltalk method / expression parser.

Rather than creating an Abstract Syntax Tree, I create a sequence of SHRanges (in my 'ranges' instance variable), which represent the tokens within the String I am parsing.

I am used by a SHTextStylerST80 to parse method source strings.
I am able to parse incomplete / incorrect methods, and so can be used to parse methods that are being edited.

My 'source' instance variable should be set to the string to be parsed.

My 'classOrMetaClass' instance var must be set to the class or metaClass for the method source so that I can correctly resolve identifiers within the source. If this is nil , I parse the source as an expression (i.e. a doIt expression).

My 'workspace' instance variable can be set to a Workspace, so that I can resolve workspace variables.

Example 1.
	ranges := SHParserST80 new
		classOrMetaClass: Object;
		source: 'testMethod ^self';
		parse;
		ranges
!


!SHParserST80 methodsFor: 'accessing' stamp: 'jmv 9/13/2017 22:00:57'!
blockDepths
	^blockDepths! !

!SHParserST80 methodsFor: 'accessing' stamp: 'jmv 9/13/2017 22:01:05'!
blockDepthsStartIndexes
	^blockDepthsStartIndexes! !

!SHParserST80 methodsFor: 'accessing' stamp: 'HAW 12/19/2018 16:10:09'!
classOrMetaClass
	
	^classOrMetaClass! !

!SHParserST80 methodsFor: 'accessing' stamp: 'tween 4/13/2004 20:20'!
classOrMetaClass: aClass
    classOrMetaClass := aClass! !

!SHParserST80 methodsFor: 'accessing' stamp: 'jmv 4/18/2016 15:22'!
last3Ranges
	| r s lastI |
	s _ ranges size.
	s = 0 ifTrue: [ ^ #(nil nil nil) ].
	r _ ranges last.
	lastI _ r rangeType = #excessCode
		ifTrue: [ s - 1 ]
		ifFalse: [ s].
	^{ 
		(lastI > 2 ifTrue: [ranges at: lastI-2]).
		(lastI > 1 ifTrue: [ranges at: lastI-1]).
		(lastI > 0 ifTrue: [ranges at: lastI])
	}! !

!SHParserST80 methodsFor: 'accessing' stamp: 'jmv 1/31/2013 22:42'!
lastRange
	| r i s |
	s _ ranges size.
	s = 0 ifTrue: [ ^nil ].
	r _ ranges last.
	^r rangeType = #excessCode
		ifFalse: [ r ]
		ifTrue: [
			i _ s-1.
			i > 0 ifTrue: [ ranges at: i ]]! !

!SHParserST80 methodsFor: 'accessing' stamp: 'jmv 9/13/2017 20:51:24'!
ranges
	^ ranges! !

!SHParserST80 methodsFor: 'accessing' stamp: 'HAW 5/3/2020 00:14:19'!
rangesWithoutExcessCode
	
	^ranges 
		ifEmpty: [ ranges ]
		ifNotEmpty: [ 
			ranges last rangeType = #excessCode
				ifTrue: [ ranges allButLast ]
				ifFalse: [ ranges ]]! !

!SHParserST80 methodsFor: 'accessing' stamp: 'tween 4/17/2004 22:21'!
source
	^source! !

!SHParserST80 methodsFor: 'accessing' stamp: 'tween 4/27/2004 18:59'!
source: aString
    source := aString! !

!SHParserST80 methodsFor: 'accessing' stamp: 'tween 4/15/2004 13:18'!
workspace: aWorkspace
    workspace := aWorkspace! !


!SHParserST80 methodsFor: 'scan' stamp: 'jmv 3/2/2010 10:05'!
currentChar
	^source at: sourcePosition ifAbsent: nil! !

!SHParserST80 methodsFor: 'scan' stamp: 'tween 4/28/2004 09:42'!
nextChar
	sourcePosition := sourcePosition + 1.
	^source at: sourcePosition ifAbsent: [$ ]! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 12/1/2022 11:51:31'!
peekChar
	^source at: sourcePosition + 1 ifAbsent: [ $  ]! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 5/24/2022 11:20:42'!
scanBinary
	| c d |
	c := self currentChar.
	currentTokenSourcePosition := sourcePosition.
	currentToken := source class with: c.
	d := self nextChar.
	((self isBinarySelectorCharacter: c) or: [c = $:]) ifFalse: [^currentToken].
	(c = $: and: [d = $=]) 
		ifTrue: [" := assignment"
			currentToken := currentToken , (source class with: d).
			self nextChar.
			^currentToken].
	"|| empty temp declaration"
	"This makes || colorize as an invalid method definition.
	It is better to allow #|| as valid selector, and mark an empty temp declaration as invalid instead!!"
	"(c = $| and: [d = $|])
		ifTrue: [^currentToken]."
	c _ d.
	[
		d _ self peekChar.
		c = $-
			ifTrue: [ d isDigit not ]
			ifFalse: [ self isBinarySelectorCharacter: c ]
	]
		whileTrue: [
			currentToken _ currentToken copyWith: c.
			c _ self nextChar ].
	^currentToken! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 5/21/2022 22:45:35'!
scanComment
	| c s e |
	s := sourcePosition.
	
	[sourcePosition := sourcePosition + 1.
	(c := self currentChar) 
		ifNil: [
			self rangeType: #unfinishedComment start: s end: source size.
			^self error	": 'unfinished comment'"].
	c = $"] 
		whileFalse: [].
	e := sourcePosition.
	s < e ifTrue: [self rangeType: #comment start: s end: e].
	self nextChar.
	self scanWhitespace! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 5/21/2022 22:45:41'!
scanIdentifier
	| c start |
	start _ sourcePosition.
	[ (c _ self nextChar) isValidInIdentifiers ] whileTrue: [].
	(c = $: and: [(self isBinarySelectorCharacter: self peekChar) not]) 
		ifTrue: [self nextChar].
	currentToken _ source copyFrom: start to: sourcePosition - 1.
	currentTokenSourcePosition _ start! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 11/16/2015 14:57'!
scanNext
	self scanWhitespace.
	currentTokenFirst _ self currentChar.
	currentTokenFirst 
		ifNil: [" end of input "
			currentTokenFirst _ $ .
			currentTokenSourcePosition _ nil.
			currentToken _ nil.
			^nil].
	currentTokenFirst isDigit ifTrue: [^self scanNumber].
	currentTokenFirst isValidStartOfIdentifiers ifTrue: [^self scanIdentifier].
	^self scanBinary! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 5/23/2022 12:46:55'!
scanNumber
	| start c nc base |
	start := sourcePosition.
	self skipDigits.
	c := self currentChar.
	('rx' includes: c)
		ifTrue: [
			base := Integer readFrom: ((source copyFrom: start to: sourcePosition - 1) readStream).
			self peekChar = $- ifTrue: [self nextChar].
			self skipBigDigits: base.
			c := self currentChar.
			c = $. 
				ifTrue: [
					(self isBigDigit: self nextChar base: base) 
						ifFalse: [sourcePosition := sourcePosition - 1]
						ifTrue: [self skipBigDigits: base]].
			c := self currentChar.
			('deqp'includes: c)
				ifTrue: [
					((nc := self nextChar) isDigit or: [nc = $- and:[self peekChar isDigit]]) 
						ifFalse: [sourcePosition := sourcePosition - 1]
						ifTrue: [self skipDigits]].
			c = $s 
				ifTrue: [
					self nextChar isDigit 
						ifFalse: [sourcePosition := sourcePosition - 1]
						ifTrue: [self skipDigits]].
			currentToken := source copyFrom: start to: sourcePosition - 1.
			^currentTokenSourcePosition := start].
	c = $s 
		ifTrue: [
			self nextChar isDigit 
				ifFalse: [sourcePosition := sourcePosition - 1]
				ifTrue: [self skipDigits.].
			currentToken := source copyFrom: start to: sourcePosition - 1.
			^currentTokenSourcePosition := start].
	c = $. 
		ifTrue: [
			self nextChar isDigit 
				ifFalse: [
					sourcePosition := sourcePosition - 1.
					currentToken := source copyFrom: start to: sourcePosition - 1.
					^currentTokenSourcePosition := start]
				ifTrue: [self skipDigits]].
	c := self currentChar.
	('deqp' includes: c)
		ifTrue: [
			((nc := self nextChar) isDigit or: [nc = $-  and:[self peekChar isDigit]]) 
				ifFalse: [sourcePosition := sourcePosition - 1]
				ifTrue: [self skipDigits]].
	c = $s 
		ifTrue: [
			self nextChar isDigit 
				ifFalse: [sourcePosition := sourcePosition - 1]
				ifTrue: [self skipDigits]].
	currentToken := source copyFrom: start to: sourcePosition - 1.
	^currentTokenSourcePosition := start! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 12/28/2011 19:01'!
scanPast: rangeType 
	"record rangeType for current token .
	record argument and temp declarations.
	scan and answer the next token"
	rangeType == #blockPatternArg ifTrue: [self pushArgument: currentToken].
	rangeType == #blockPatternTempVar ifTrue: [self pushTemporary: currentToken].
	rangeType == #patternArg ifTrue: [self pushArgument: currentToken].
	rangeType == #patternTempVar ifTrue: [self pushTemporary: currentToken].
	^self
		rangeType: rangeType;
		scanNext! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 4/21/2022 12:42:11'!
scanPast: rangeType level: level
	"first level adds no suffix to the rangeType.
	Suffix from 1 to 7 added in cycles , ((level-2) mod(7) + 1)"
	| cycle typePlusCycle |
	
	cycle := level <= 1 
		ifTrue: [0]
		ifFalse:[ ((level - 2) \\ 7) + 1].
	typePlusCycle := cycle = 0 
		ifTrue:[rangeType]
		ifFalse:[(rangeType, cycle printString) asSymbol].
	^self scanPast: typePlusCycle
! !

!SHParserST80 methodsFor: 'scan' stamp: 'tween 4/28/2004 09:56'!
scanPast: rangeType start: startInteger end: endInteger
	"record rangeType for current token from startInteger to endInteger,
	 and scanNext token"

	^self 
		rangeType: rangeType start: startInteger end: endInteger;
		scanNext
	
! !

!SHParserST80 methodsFor: 'scan' stamp: 'jmv 5/21/2022 22:45:45'!
scanWhitespace
	| c |
	
	[c := self currentChar.
	c notNil and: [c isSeparator]] 
		whileTrue: [sourcePosition := sourcePosition + 1].
	c = $" ifTrue: [self scanComment]! !

!SHParserST80 methodsFor: 'scan' stamp: 'tween 8/6/2005 13:20'!
skipBigDigits: baseInteger
	[self isBigDigit: self nextChar base: baseInteger] 
		whileTrue: []
! !

!SHParserST80 methodsFor: 'scan' stamp: 'tween 4/28/2004 14:57'!
skipDigits
	[self nextChar isDigit] 
		whileTrue: []! !


!SHParserST80 methodsFor: 'parse support' stamp: 'tween 4/28/2004 09:48'!
enterBlock
	blockDepth := blockDepth + 1.
	bracketDepth := bracketDepth + 1! !

!SHParserST80 methodsFor: 'parse support' stamp: 'jmv 3/2/2010 17:13'!
initializeInstanceVariables
	instanceVariables := classOrMetaClass 
		ifNotNil: [classOrMetaClass allInstVarNames asArray]
		ifNil: [Set new]! !

!SHParserST80 methodsFor: 'parse support' stamp: 'jmv 3/2/2010 10:06'!
leaveBlock
	arguments removeKey: blockDepth ifAbsent: nil.
	temporaries removeKey: blockDepth ifAbsent: nil.
	blockDepth := blockDepth - 1.
	bracketDepth := bracketDepth - 1! !

!SHParserST80 methodsFor: 'parse support' stamp: 'tween 4/28/2004 10:03'!
pushArgument: aString 
	(arguments at: blockDepth ifAbsentPut: [OrderedCollection new: 10]) 
		add: aString! !

!SHParserST80 methodsFor: 'parse support' stamp: 'tween 4/28/2004 10:05'!
pushTemporary: aString 
	(temporaries at: blockDepth ifAbsentPut: [OrderedCollection new: 10]) 
		add: aString! !


!SHParserST80 methodsFor: 'error handling' stamp: 'tween 4/28/2004 10:16'!
error
	self 
		rangeType: #excessCode
		start: (ranges isEmpty ifTrue: [1] ifFalse: [ranges last end + 1])
		end: source size.
	errorBlock value! !

!SHParserST80 methodsFor: 'error handling' stamp: 'tween 8/7/2005 14:31'!
failUnless: aBoolean
	aBoolean ifFalse:[self error]
! !

!SHParserST80 methodsFor: 'error handling' stamp: 'tween 8/7/2005 14:31'!
failWhen: aBoolean
	aBoolean ifTrue:[self error]! !


!SHParserST80 methodsFor: 'token testing' stamp: 'tween 4/28/2004 09:43'!
isAnsiAssignment
	^currentToken = ':='! !

!SHParserST80 methodsFor: 'token testing' stamp: 'jmv 10/28/2022 12:19:57'!
isAssignment

	^ currentToken = ':=' or: [ currentToken = '_' or: [ currentToken = Character smalltalkLeftArrow asString ]]! !

!SHParserST80 methodsFor: 'token testing' stamp: 'jmv 5/21/2022 22:35:28'!
isBinary
	| c |
	(currentToken isNil or: [self isName or: [self isKeyword]]) 
		ifTrue: [^false].
	"Special case: '::' is not a binary selector but the Chain operator"
	(sourcePosition - currentTokenSourcePosition = 1 and: [
		(source at: currentTokenSourcePosition ifAbsent: nil) = $: and: [		
			(source at: sourcePosition ifAbsent: nil) = $: ]])
				ifTrue: [^ false ].
	1 to: currentToken size do: [ :i |
		c := currentToken at: i.
		((self isBinarySelectorCharacter: c) or: [c = $:])
			ifFalse: [^false]].
	^true! !

!SHParserST80 methodsFor: 'token testing' stamp: 'jmv 5/21/2022 22:35:32'!
isKeyword
	^ currentTokenFirst isValidStartOfIdentifiers and: [ currentToken last = $: ]! !

!SHParserST80 methodsFor: 'token testing' stamp: 'jmv 11/16/2015 14:57'!
isName
	^ currentTokenFirst isValidStartOfIdentifiers and: [ currentToken last isValidInIdentifiers ]! !

!SHParserST80 methodsFor: 'token testing' stamp: 'jmv 3/2/2010 10:06'!
isTokenExternalFunctionCallingConvention
	| descriptorClass |
	descriptorClass := Smalltalk at: #ExternalFunction ifAbsent: nil.
	descriptorClass ifNil: [^false].
	^(descriptorClass callingConventionFor: currentToken) notNil! !


!SHParserST80 methodsFor: 'character testing' stamp: 'jmv 2/12/2010 14:44'!
isBigDigit: aCharacter base: anInteger
    "Answer true if aCharacter is a digit or a capital
    letter appropriate for base anInteger"
	| digitValue |
	
	digitValue := aCharacter digitValue.
	anInteger = 1 ifTrue: [
		^digitValue = 1 ].
	^digitValue >= 0 and:[digitValue < anInteger]! !

!SHParserST80 methodsFor: 'character testing' stamp: 'jmv 12/14/2018 15:39:18'!
isBinarySelectorCharacter: aCharacter
	aCharacter = $: ifTrue: [^ false].
	^aCharacter isValidInBinarySelectors! !


!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:09:28'!
isBlockArgName: aString 
	"Answer true if aString is the name of a block argument, false otherwise"

	self blockArgNamesDo: [ :arg :dummy | arg = aString ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:09:18'!
isBlockTempName: aString 
	"Answer true if aString is the name of a block temporary. false otherwise"

	self blockTempNamesDo: [ :arg :dummy | arg = aString ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 6/27/2011 17:49'!
isClassVarName: aSymbol 
	"Answer true if aString is the name of a class variable, false otherwise"

	classOrMetaClass isBehavior 
		ifTrue: [
			classOrMetaClass theNonMetaClass withAllSuperclasses do: [ :c | 
				(c classPool bindingOf: aSymbol) ifNotNil: [^true]]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 6/27/2011 17:48'!
isGlobal: aSymbol
	"Answer true if aString is the name of a global variable, false otherwise"

	(Smalltalk bindingOf: aSymbol) ifNotNil: [^true].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:09:31'!
isIncompleteBlockArgName: aString 
	"Answer true if aString is the start of the name of a block argument, false otherwise"

	self blockArgNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:09:21'!
isIncompleteBlockTempName: aString 
	"Answer true if aString is the start of the name of a block temporary. false otherwise"

	self blockTempNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:09:05'!
isIncompleteClassVarName: aString 
	"Answer true if aString is the start of the name of a class variable, false otherwise"

	self classVarNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 6/27/2011 17:44'!
isIncompleteGlobal: aString
	"Answer true if aString is the start of the name of a global variable, false otherwise"

	^Smalltalk hasBindingThatBeginsWith: aString! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:08:54'!
isIncompleteInstVarName: aString 
	"Answer true if aString is the start of the name of an instance variable, false otherwise"

	self instVarNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:08:42'!
isIncompleteMethodArgName: aString 
	"Answer true if aString is the start of the name of a method argument, false otherwise.
    Does not check whether aString is also a blockArgName"

	self methodArgNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:08:34'!
isIncompleteMethodTempName: aString 
	"Answer true if aString is the start of the name of a method temporary, false otherwise."

	self methodTempNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:07:49'!
isIncompletePoolConstantName: aString 
	"Answer true if aString is the start of the name of a pool constant, false otherwise"

	self poolConstantNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 8/28/2017 16:51:25'!
isIncompleteReservedName: aString 
	"Answer true if aString is the start of a reserved name, false otherwise"

	self reservedNames do: [ :arg | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:07:38'!
isIncompleteWorkspaceVarName: aString 
	"Answer true if aString is the  start of the name of an workspace variable, false otherwise"

	self workspaceNamesDo: [ :arg :dummy | (arg beginsWith: aString) ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:08:58'!
isInstVarName: aString 
	"Answer true if aString is the name of an instance variable, false otherwise"

	self instVarNamesDo: [ :arg :dummy | arg = aString ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:08:45'!
isMethodArgName: aString 
	"Answer true if aString is the name of a method argument, false otherwise.
    Does not check whether aString is also a blockArgName"

	self methodArgNamesDo: [ :arg :dummy | arg = aString ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 2/19/2019 12:08:28'!
isMethodTempName: aString 
	"Answer true if aString is the name of a method temporary, false otherwise.
    Does not check whether aString is also a block temporary
    or argument"

	self methodTempNamesDo: [ :arg :dummy | arg = aString ifTrue: [ ^true ]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 6/27/2011 17:48'!
isPoolConstantName: aSymbol 
	"Answer true if aString is the name of a pool constant, false otherwise"

	classOrMetaClass isBehavior 
		ifTrue: [
			classOrMetaClass theNonMetaClass withAllSuperclasses do: [ :c |
				c sharedPools do: [:p | (p bindingOf: aSymbol) ifNotNil: [ ^true ]]]].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 6/27/2011 17:44'!
isWorkspaceVarName: aString 
	"Answer true if aString is the name of an workspace variable, false otherwise"
	workspace
		ifNotNil: [ ^(workspace hasBindingOf: aString) ].
	^false! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 8/28/2017 16:53:14'!
resolve: aString

	self reservedNames do: [ :symbol | aString = symbol ifTrue: [^symbol]].
	(self isBlockTempName: aString) ifTrue: [^#blockTempVar].
	(self isBlockArgName: aString) ifTrue: [^#blockArg].
	(self isMethodTempName: aString) ifTrue: [^#tempVar].
	(self isMethodArgName: aString) ifTrue: [^#methodArg].
	(self isInstVarName: aString) ifTrue: [^#instVar].
	(self isWorkspaceVarName: aString) ifTrue: [^#workspaceVar].
	Symbol hasInterned: aString ifTrue: [ :symbol |
		(self isClassVarName: symbol) ifTrue: [ ^#classVar ].
		(self isPoolConstantName: symbol) ifTrue: [ ^#poolConstant].
		(self isGlobal: symbol) ifTrue: [^#globalVar]].
	^self resolvePartial: aString! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 6/27/2011 17:43'!
resolvePartial: aString 
	"check if any identifier begins with aString"
	
	(self isIncompleteReservedName: aString) ifTrue: [^#incompleteIdentifier].
	(self isIncompleteBlockTempName: aString) ifTrue: [^#incompleteIdentifier].
	(self isIncompleteBlockArgName: aString) ifTrue: [^#incompleteIdentifier].
	(self isIncompleteMethodTempName: aString) ifTrue: [^#incompleteIdentifier].
	(self isIncompleteMethodArgName: aString) ifTrue: [^#incompleteIdentifier].
	(self isIncompleteInstVarName: aString) ifTrue: [^#incompleteIdentifier].
	(self isIncompleteWorkspaceVarName: aString) ifTrue: [^#incompleteIdentifier].
	(self isIncompleteClassVarName: aString) ifTrue: [ ^#incompleteIdentifier ].
	(self isIncompletePoolConstantName: aString) ifTrue: [ ^#incompleteIdentifier ].
	(self isIncompleteGlobal: aString) ifTrue: [^#incompleteIdentifier].
	^#undefinedIdentifier! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 4/11/2010 22:06'!
resolvePartialPragmaArgument: aString 
	"check if any valid pragma argument begins with aString"
	
	(#('true' 'false' 'nil') anySatisfy: [:each | each beginsWith: aString]) 
		ifTrue: [^#incompleteIdentifier].
	"should really check that a matching binding is for a Class?"
	classOrMetaClass isBehavior 
		ifTrue: [
			classOrMetaClass theNonMetaClass withAllSuperclasses do: [:c | 
				(Smalltalk hasBindingThatBeginsWith: aString) ifTrue: [^#incompleteIdentifier]]]
		ifFalse: [(Smalltalk hasBindingThatBeginsWith: aString) ifTrue: [^#incompleteIdentifier]].
	^#undefinedIdentifier! !

!SHParserST80 methodsFor: 'identifier testing' stamp: 'jmv 8/18/2009 23:09'!
resolvePragmaArgument: aString 
	(#('true' 'false' 'nil') includes: aString) ifTrue: [^aString asSymbol].
	"should really check that global is a class?"
	Symbol hasInterned: aString ifTrue: [:sym | 
		classOrMetaClass isBehavior 
			ifTrue: [
				classOrMetaClass theNonMetaClass withAllSuperclasses do: [:c | 
					(Smalltalk bindingOf: sym) ifNotNil: [^#globalVar]]]
			ifFalse: [(Smalltalk bindingOf: sym) ifNotNil: [^#globalVar]]].
	^self resolvePartialPragmaArgument: aString! !


!SHParserST80 methodsFor: 'parse' stamp: 'jmv 7/8/2014 22:12'!
parse
    "Parse the receiver's text as a Smalltalk method"

    self parse: (classOrMetaClass notNil)! !

!SHParserST80 methodsFor: 'parse' stamp: 'HAW 5/3/2020 21:54:53'!
parse: isAMethod 
	"Parse the receiver's text. If isAMethod is true
    then treat text as a method, if false as an
    expression with no message pattern"

	| continue prevSourcePosition |
	self initializeInstanceVariables.
	sourcePosition _ 1.
	arguments _ Dictionary new.
	temporaries _ Dictionary new.
	blockDepth _ bracketDepth _ braceDepth _ 0.
	blockDepths _ OrderedCollection with: blockDepth.
	blockDepthsStartIndexes _ OrderedCollection with: sourcePosition.
	ranges ifNil: [ ranges := OrderedCollection new: 100] ifNotNil: [ ranges reset].
	errorBlock _ [^false].
	[
		self scanNext.
		isAMethod 
			ifTrue: [
				self parseMessagePattern.
				self parsePragmaSequence].
		self parseMethodTemporaries.
		isAMethod ifTrue: [self parsePragmaSequence].
		"Iterate once for methods, but pontentially several times for workspaces
		(to recover after errors, for possible good next lines or chunks)"
		continue _ true.
		[ continue ] whileTrue: [
			prevSourcePosition _ sourcePosition.
			self parseStatementList.
			continue _ sourcePosition > prevSourcePosition.
			isAMethod
				ifTrue: [
					"Only if we are parsing a method, consider everything after this point as error."
					currentToken ifNotNil: [ self error ].
					continue _ false]
				ifFalse: [
					sourcePosition > source size ifTrue: [continue _ false]]].
	] ensure: [errorBlock _ nil].
	^true! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:35:36'!
parseArray
	[currentTokenFirst = $)] whileFalse: [self parseLiteralArrayElement].
	self scanPast: #arrayEnd! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:35:41'!
parseBacktick
	self enterBlock.
	self scanPast: #backtick.
	currentTokenFirst = $| ifTrue: [self parseBlockTemporaries].
	self parseStatementList.
	self failUnless: currentTokenFirst = $`.
	self scanPast: #backtick.
	self leaveBlock! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 6/14/2011 15:16'!
parseBinary 
	| binary type |
	self parseUnary.
	[ self isBinary ]
		whileTrue: [
			binary _ currentToken.
			type _ #binary.
			(binary isEmpty or: [ Symbol hasInternedAndImplemented: binary ])
				ifFalse: [
					type _ (Symbol thatStartsCaseSensitive: binary)
						ifNil: [ #undefinedBinary]
						ifNotNil: [ #incompleteBinary]].	
			self scanPast: type. 	
			self parseTerm.
            	self parseUnary ]! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 8/7/2005 14:26'!
parseBinaryMessagePattern   

   	self scanPast:  #patternBinary. 
	self failUnless: self isName.
	self scanPast: #patternArg.

! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:35:49'!
parseBlock

	"Just read $["
	blockDepths add: blockDepth+1.
	blockDepthsStartIndexes add: sourcePosition-1.

	self enterBlock.
	self scanPast: #blockStart level: bracketDepth.
	currentTokenFirst = $: ifTrue: [self parseBlockArguments].
	currentTokenFirst = $| ifTrue: [self parseBlockTemporaries].
	self parseStatementList.
	self failUnless: currentTokenFirst = $].

	"Just read $]"
	blockDepths add: blockDepth-1.
	blockDepthsStartIndexes add: sourcePosition.

	self scanPast: #blockEnd level: bracketDepth.
	self leaveBlock! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:35:55'!
parseBlockArguments
	[ currentTokenFirst = $: ]
		whileTrue: [
			self scanPast: #blockArgColon.
			self failUnless: self isName.
			self scanPast: #blockPatternArg ].
	currentTokenFirst = $| 
		ifTrue: [ self scanPast: #blockArgsBar ]! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:35:59'!
parseBlockTemporaries
	currentTokenFirst = $| 
		ifTrue: [
			self scanPast: #blockTempBar.
			[self isName] 
				whileTrue: [self scanPast: #blockPatternTempVar].
			self failUnless: currentToken = '|'.
			self scanPast: #blockTempBar]! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:36:05'!
parseBraceArray
	self parseStatementListForBraceArray.
	self failUnless: currentTokenFirst = $}.
	self scanPast: #rightBrace level: braceDepth.
	braceDepth := braceDepth - 1! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:36:12'!
parseByteArray
	"Literal ByteArray or literal FloatArray"
	[currentTokenFirst = $]] whileFalse: [
		currentTokenFirst isDigit | (currentTokenFirst = $-)
			ifTrue: [
				"do not parse the number, can be time consuming"
				self scanPast: #number]
			ifFalse: [
				self failWhen: currentTokenFirst = $. .
				self error]].
	self scanPast: #arrayEnd! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:36:15'!
parseCascadeAndChain

	self parseKeyword.
	currentTokenFirst = $; ifTrue:
		[
			self scanPast: #cascadeSeparator.
			^self parseCascadeAndChain
		].
	currentTokenFirst = $: ifTrue:
		[
			self scanPast: #chainSeparator.

			"These lines implement double colon chains"
			currentTokenFirst = $: ifFalse: [^self].
			self scanPast: #chainSeparator.
			
			^self parseCascadeAndChain
		]! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 4/28/2004 14:28'!
parseCharSymbol
	| s e |
	s := sourcePosition - 1.
	e := sourcePosition.
	self nextChar.
	self scanPast: #symbol start: s end: e! !

!SHParserST80 methodsFor: 'parse' stamp: 'SqR 8/24/2014 23:10'!
parseExpression
	| assignType |
	self isName 
		ifTrue: [
			self scanPast: (self resolve: currentToken).
			self isAssignment 
				ifTrue: [
					assignType := self isAnsiAssignment 
						ifTrue: [#ansiAssignment]
						ifFalse: [#assignment].
					self scanPast: assignType.
					self parseExpression]
				ifFalse: [self parseCascadeAndChain]]
		ifFalse: [
			self parseTerm.
			self parseCascadeAndChain]! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:36:25'!
parseExternalCall
	self scanNext.
	self failWhen: currentToken isNil.
	self scanPast: #externalCallType.
	currentToken = '*' 
		ifTrue: [self scanPast: #externalCallTypePointerIndicator].
	currentTokenFirst isDigit 
		ifTrue: [self scanPast: #integer]
		ifFalse: 	[
			self failUnless: currentTokenFirst = $'.
			self parseString].
	self failUnless: currentTokenFirst = $(.
	self scanPast: #leftParenthesis.
	[currentTokenFirst ~= $)] 
		whileTrue: [
			self failWhen: currentToken isNil.
			self scanPast: #externalCallType.
			currentToken = '*' 
				ifTrue: [self scanPast: #externalCallTypePointerIndicator]].
	self scanPast: #rightParenthesis.
	currentToken = 'module:' 
		ifTrue: [
			self scanPast: #module.
			self failUnless: currentTokenFirst = $'.
			self parseString].
	self failUnless: currentToken = '>'.
	self scanPast: #primitiveOrExternalCallEnd! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 6/14/2011 15:20'!
parseKeyword 
    | keyword rangeIndices |
	self parseBinary.
	keyword _ ''.
	rangeIndices _ #().
	[
    		[ self isKeyword ]
        		whileTrue: [
				keyword _ keyword, currentToken. 
				self rangeType: #keyword.
				"remember where this keyword token is in ranges"
				rangeIndices _ rangeIndices copyWith: ranges size.
				self scanNext.
				self parseTerm.
				self parseBinary ]
	] ensure: [ | type |
		"do this in an ensure so that it happens even if the errorBlock evaluates before getting here"
		"patch up the keyword tokens, so that incomplete and undefined ones look different"
		(keyword isEmpty or: [ Symbol hasInternedAndImplemented: keyword ])
			ifFalse: [
				type _ (Symbol thatStartsCaseSensitive: keyword)
					ifNil: [ #undefinedKeyword]
					ifNotNil: [ #incompleteKeyword ].
				rangeIndices do: [ :i | (ranges at: i) type: type ]]]! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 8/7/2005 14:27'!
parseKeywordMessagePattern   

	[self isKeyword]
		whileTrue: [ 
			self scanPast:  #patternKeyword. 
			self failUnless: self isName.
			self scanPast: #patternArg]

! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:44:55'!
parseLiteral: inArray 
	currentTokenFirst = $$ 
		ifTrue: [
			| pos |
			self failWhen: self currentChar isNil.
			self rangeType: #'$'.
			pos := currentTokenSourcePosition + 1.
			self nextChar.
			self scanPast: #character start: pos end: pos.
			^self ].
	currentTokenFirst isDigit 
		ifTrue: [
			"do not parse the number, can be time consuming"
			self scanPast: #number.
			^self ].
	currentToken = '-' 
		ifTrue: [
			| c |
			c := self currentChar.
			(inArray and: [c isNil or: [c isDigit not]]) 
				ifTrue: [
					"single - can be a symbol in an Array"
					self scanPast: #symbol.
					^self ].
			self scanPast: #-.
			self failWhen: currentToken isNil.
			"token isNil ifTrue: [self error: 'Unexpected End Of Input']."
			"do not parse the number, can be time consuming"
			self scanPast: #number.
			^self ].
	currentTokenFirst = $' ifTrue: [
		self parseString.
		^self ].
	currentTokenFirst = $# ifTrue: [
		self parseSymbol.
		^self ].
	(inArray and: [currentToken notNil]) ifTrue: [
		self scanPast: #symbol.
		^self ].
	self failWhen: currentTokenFirst = $. .
	self error	": 'argument missing'"! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:36:39'!
parseLiteralArrayElement
	 currentTokenFirst isValidStartOfIdentifiers ifTrue: [
		#true = currentToken ifTrue: [
			self scanPast: #true.
			^ self ].
		#false = currentToken ifTrue: [
			self scanPast: #false.
			^ self ].
		#nil = currentToken ifTrue: [
			self scanPast: #nil.
			^ self ].
		self scanPast: #symbol.
		^ self ].
	currentTokenFirst = $( ifTrue: [
		self scanPast: #arrayStart.
		self parseArray.
		^ self ].
	self parseLiteral: true! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 8/7/2005 14:28'!
parseMessagePattern   

	self isName 
		ifTrue: [self parseUnaryMessagePattern]
		ifFalse: [
			self isBinary
				ifTrue:[self parseBinaryMessagePattern]
				ifFalse:[
					self failUnless: self isKeyword.
					self parseKeywordMessagePattern]]! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:36:42'!
parseMethodTemporaries
	currentTokenFirst = $| 
		ifTrue: [
			self scanPast: #methodTempBar.
			[self isName] 
				whileTrue: [self scanPast: #patternTempVar].
			self failUnless: currentToken = '|'.
			self scanPast: #methodTempBar]! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 12/29/2006 11:13'!
parsePragmaBinary

	self scanPast: #pragmaBinary.
	self isName
		ifTrue:[self scanPast: (self resolvePragmaArgument: currentToken)] 
		ifFalse:[	self parseLiteral: false].
	self failUnless: currentToken = '>'.
	self scanPast: #primitiveOrExternalCallEnd! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 7/2/2006 12:59'!
parsePragmaKeyword

	[self isKeyword]
		whileTrue:[
			self scanPast: #pragmaKeyword.
			self isName
				ifTrue:[self scanPast: (self resolvePragmaArgument: currentToken)] 
				ifFalse:[	self parseLiteral: false]].
	self failUnless: currentToken = '>'.
	self scanPast: #primitiveOrExternalCallEnd! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 12/29/2006 11:11'!
parsePragmaSequence
	[currentToken = '<' ]
		whileTrue:[
			self scanPast: #primitiveOrExternalCallStart.
			currentToken = 'primitive:' 
				ifTrue: [
					self rangeType: #primitive.
					self parsePrimitive]
				ifFalse:[
					self isTokenExternalFunctionCallingConvention 
						ifTrue: [
							self rangeType: #externalFunctionCallingConvention.
							self parseExternalCall]
						ifFalse:[
							self isName
								ifTrue:[
									self scanPast: #pragmaUnary.
									self failUnless: currentToken = '>'.
									self scanPast: #primitiveOrExternalCallEnd]
								ifFalse:[
									self isKeyword
										ifTrue:[
											self parsePragmaKeyword]
										ifFalse:[
											self isBinary
												ifTrue:[self parsePragmaBinary]
												ifFalse:[	self error	": 'Invalid External Function Calling convention'" ]]]]]]! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:36:49'!
parsePrimitive
	self scanNext.
	currentTokenFirst isDigit 
		ifTrue: [self scanPast: #integer]
		ifFalse: [
			self failUnless: currentTokenFirst = $'.
			self parseString.
			currentToken = 'module:' 
				ifTrue: [
					self scanPast: #module.
					self failUnless: currentTokenFirst = $'.
					self parseString]].
	currentToken = 'error:' ifTrue: [
		self scanPast: #primitive. "there's no rangeType for error"
		self isName
			ifTrue: [ self scanPast: #patternTempVar ]
			ifFalse: [ self parseStringOrSymbol ] ].
	self failUnless: currentToken = '>'.
	self scanPast: #primitiveOrExternalCallEnd! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 6/30/2023 17:55:30'!
parseStatement
	(currentToken isNil or: [	currentToken size = 1]) ifTrue: [
		currentTokenFirst = $^ ifTrue: [self scanPast: #return].
		currentTokenFirst = Character smalltalkUpArrow ifTrue: [self scanPast: #return]].
	self parseExpression! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:37:00'!
parseStatementList
	
	[[currentTokenFirst = $.] whileTrue: [self scanPast: #statementSeparator].
	(currentToken notNil and: [currentTokenFirst ~= $]]) 
		ifTrue: [self parseStatement].
	currentTokenFirst = $.] 
			whileTrue: [self scanPast: #statementSeparator]! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:37:03'!
parseStatementListForBraceArray
	"same as parseStatementList, but does not allow empty statements e.g {...$a...}.
	A single terminating . IS allowed e.g. {$a.} "

	
	[currentTokenFirst ~= $} ifTrue: [self parseStatement].
	currentTokenFirst = $.] 
		whileTrue: [self scanPast: #statementSeparator]! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:37:09'!
parseString
	| first c last |
	first _ sourcePosition.
	[
		(c _ self currentChar) ifNil: [
			self
				rangeType: #unfinishedString
				start: first - 1
				end: source size.
			self error": 'unfinished string'" ].
		c ~= $' or: [
			self peekChar = $' and: [
				sourcePosition _ sourcePosition + 1.
				true ]]] whileTrue: [ sourcePosition _ sourcePosition + 1 ].
	last _ sourcePosition.
	self nextChar.
	self
		scanPast: #string
		start: first - 1
		end: last! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:37:15'!
parseStringOrSymbol

	currentTokenFirst = $' ifTrue: [ ^self parseString ].
	currentTokenFirst = $# ifTrue: [ ^self parseSymbol ].
	self error! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:45:04'!
parseSymbol
	| c |
	currentToken = '#' 
		ifTrue: [
			"if token is just the #, then scan whitespace and comments
			and then process the next character.
			Allows space between the # and the start of the symbol 
			e.g. # (),  #  a, #  'sym' "
			self rangeType: #symbol.
			self scanWhitespace].
	c _ self currentChar.
	self failWhen: (c isNil or: [c isSeparator]).
	c = $( 
		ifTrue: [
			self nextChar.
			self scanPast: #arrayStart start: currentTokenSourcePosition end: currentTokenSourcePosition + 1.
			^self parseArray].
	c = $' ifTrue: [
		self parseSymbolString.
		^self ].
	c = $[ ifTrue: [
			self nextChar.
			self scanPast: #arrayStart start: currentTokenSourcePosition end: currentTokenSourcePosition + 1.
			^self parseByteArray].
	(self isBinarySelectorCharacter: c) ifTrue: [
		self parseSymbolSelector.
		^self ].
	( c isValidStartOfIdentifiers or: [c = $:]) ifTrue: [
		self parseSymbolIdentifier.
		^self].
	self parseCharSymbol! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:37:29'!
parseSymbolIdentifier
	| c start end |
	c _ self currentChar.
	self failUnless: ( c isValidStartOfIdentifiers or: [ c = $: ]).
	start _ sourcePosition.
	[
		c _ self nextChar.
		c isValidInIdentifiers or: [ c = $: ]
	] whileTrue: [].
	end _ sourcePosition - 1.
	self scanPast: #symbol start: start - 1 end: end! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 9/4/2016 22:48:51'!
parseSymbolSelector
	| start end |
	start := sourcePosition - 1.
	end := sourcePosition.
	[self isBinarySelectorCharacter: self nextChar] 
		whileTrue: [end := sourcePosition].
	self scanPast: #symbol start: start end: end! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:37:34'!
parseSymbolString
	| first c last |
	first := sourcePosition.
	self nextChar.
	[
		(c := self currentChar) 
			ifNil: [
				self rangeType: #unfinishedString start: first end: source size.
				self error	": 'unfinished string'"].
		c ~= $' or: [
			self peekChar = $' 
				ifTrue: [sourcePosition := sourcePosition + 1. true] 
				ifFalse: [false]]
	] whileTrue: [sourcePosition := sourcePosition + 1].
	last := sourcePosition.
	self nextChar.
	self scanPast: #stringSymbol start: first - 1 end: last! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 5/21/2022 22:45:14'!
parseTerm
	self failWhen: currentToken isNil.
	currentTokenFirst = $( 
		ifTrue: [
			bracketDepth := bracketDepth + 1.
			self scanPast: #leftParenthesis level: bracketDepth.
			self parseExpression.
			self failUnless: currentTokenFirst = $).
			self scanPast: #rightParenthesis level: bracketDepth.
			bracketDepth := bracketDepth - 1.
			^self ].
	currentTokenFirst = $[ ifTrue: [^self parseBlock].
	currentTokenFirst = $` ifTrue: [^self parseBacktick].
	currentTokenFirst = ${ 
		ifTrue: [
			braceDepth := braceDepth + 1.
			self scanPast: #leftBrace level: braceDepth.
			self parseBraceArray.
			^self ].
	self isName ifTrue: [^self scanPast: (self resolve: currentToken)].
	self parseLiteral: false! !

!SHParserST80 methodsFor: 'parse' stamp: 'jmv 6/14/2011 15:20'!
parseUnary
	| unary type |
	[ self isName ]
		whileTrue: [
			unary _ currentToken.
			type _ #unary.
			(unary isEmpty or: [ Symbol hasInternedAndImplemented: unary ])
				ifFalse:[
					type _ (Symbol thatStartsCaseSensitive: unary)
						ifNil: [ #undefinedUnary]
						ifNotNil: [ #incompleteUnary ]].
			self scanPast: type ]! !

!SHParserST80 methodsFor: 'parse' stamp: 'tween 4/17/2004 22:17'!
parseUnaryMessagePattern
	
	 self scanPast: #patternUnary
! !


!SHParserST80 methodsFor: 'recording ranges' stamp: 'tween 4/28/2004 09:54'!
rangeType: aSymbol 
	^self 
		rangeType: aSymbol
		start: currentTokenSourcePosition
		end: currentTokenSourcePosition + currentToken size - 1! !

!SHParserST80 methodsFor: 'recording ranges' stamp: 'tween 4/28/2004 10:20'!
rangeType: aSymbol start: s end: e 
	^ranges add: (SHRange start: s end: e type: aSymbol)! !


!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:41:34'!
blockArgNamesDo: aBlock
	"Iterate over block argument names valid at current blockDepth"

	| title |
	title _ '-- block arguments'.
	blockDepth to: 1 by: -1 do: [ :level |
		arguments at: level ifPresent: [ :args | args do: [ :name | aBlock value: name value: title ] ]]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:41:41'!
blockTempNamesDo: aBlock
	"Iterate over block temp names valid at current blockDepth"

	| title |
	title _ '-- block variables'.
	blockDepth to: 1 by: -1 do: [ :level |
		temporaries at: level ifPresent: [ :args | args do: [ :name | aBlock value: name value: title ] ]]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:41:48'!
classVarNamesDo: aBlock

	| title |
	title _ '-- class variables'.
	classOrMetaClass isBehavior 
		ifTrue: [
			classOrMetaClass theNonMetaClass withAllSuperclasses do: [ :c |
				c classPool keysDo: [ :name | aBlock value: name value: title ] ]]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:42:08'!
instVarNamesDo: aBlock

	| title |
	title _ '-- instance variables'.
	instanceVariables do: [ :name | aBlock value: name value: title ]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:42:17'!
methodArgNamesDo: aBlock
	"Iterate over method argument names"

	| title |
	title _ '-- method arguments'.
	^arguments at: 0  ifPresent: [ :args | args do: [ :name | aBlock value: name value: title ] ]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:42:24'!
methodTempNamesDo: aBlock
	"Iterate over method temporary names"

	| title |
	title _ '-- method variables'.
	^temporaries at: 0 ifPresent: [ :args | args do: [ :name | aBlock value: name value: title ] ]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:42:33'!
namesBeginningWith: aString do: aBlock
	"Evaluate aBlock for all available names that start with aString"

	self nonGlobalNamesDo: [ :name :kindOfIdentifierTitle |
		(name beginsWith: aString) ifTrue: [ aBlock value: name value: kindOfIdentifierTitle ]].
	self namesBeginningWith: aString do: [ :name | aBlock value: name value: '-- classes' ] in: Smalltalk classNames.
	self namesBeginningWith: aString do: [ :name | aBlock value: name value: '-- globals' ] in: Smalltalk nonClassNames! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:43:00'!
nonGlobalNamesDo: aBlock
	"Evaluate aBlock over all available names, except for globals"

	self
		blockArgNamesDo: aBlock;
		blockTempNamesDo: aBlock;
		methodArgNamesDo: aBlock;
		methodTempNamesDo: aBlock;
		instVarNamesDo: aBlock;
		classVarNamesDo: aBlock;
		poolConstantNamesDo: aBlock;
		workspaceNamesDo: aBlock.
	self
		reservedNames do: [ :name |
			aBlock value: name value: '-- pseudovariables'  ]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:43:31'!
poolConstantNamesDo: aBlock

	| title |
	title _ '-- pool variables'.
	classOrMetaClass isBehavior 
		ifTrue: [
			classOrMetaClass theNonMetaClass withAllSuperclasses do: [ :c |
				c sharedPools do: [ :pool |
					pool bindingsDo: [ :assoc | aBlock value: assoc key value: title ]]]]! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 8/28/2017 17:06:34'!
reservedNames

	^Theme current pseudoVariables! !

!SHParserST80 methodsFor: 'indentifier iteration' stamp: 'jmv 2/22/2019 16:43:38'!
workspaceNamesDo: aBlock

	| title |
	title _ '-- workspace variables'.
	workspace ifNotNil: [
		workspace bindingNamesDo: [ :name | aBlock value: name value: title ] ]! !


!SHParserST80 methodsFor: 'testing' stamp: 'NMS 10/14/2023 04:36:53'!
isAMethodDefinition: aSymbol
	^#(patternUnary patternKeyword patternArg) statePointsTo: aSymbol! !

!SHParserST80 methodsFor: 'testing' stamp: 'HAW 5/3/2020 00:27:29'!
isIdentifier: aSymbol

	^ #(#incompleteIdentifier
		#blockTempVar #blockArg #tempVar #methodArg
		#instVar #classVar 
		#workspaceVar #poolConstant #globalVar ) statePointsTo:aSymbol! !

!SHParserST80 methodsFor: 'testing' stamp: 'jmv 6/29/2012 16:49'!
isMessage: aSymbol

	^#(binary incompleteBinary keyword incompleteKeyword unary incompleteUnary) statePointsTo: aSymbol! !

!SHParserST80 methodsFor: 'testing' stamp: 'HAW 5/3/2020 00:28:13'!
isPartialOrFullIdentifier: aSymbol

	^(self isIdentifier: aSymbol) or: [ self isReservedName: aSymbol ]! !

!SHParserST80 methodsFor: 'testing' stamp: 'HAW 5/3/2020 00:27:56'!
isReservedName: aSymbol

	^ self reservedNames statePointsTo: aSymbol! !


!SHParserST80 methodsFor: 'aux' stamp: 'jmv 2/19/2019 11:49:22'!
namesBeginningWith: aString do: aBlock in: aCollection
	"aCollection is sorted"
	"
	self new namesBeginningWith: 'O' do: [ :each | each print ] in: Smalltalk classNames
	self new namesBeginningWith: 'ObjectExplorer' do: [ :each | each print ] in: Smalltalk classNames
	self new namesBeginningWith: 'ObjectExplorerWrapper' do: [ :each | each print ] in: Smalltalk classNames
	"
	| count |

	"Find the first element  starting with aString"
	count _ aCollection size.
	aCollection
		findBinaryIndex: [ :element |
			element < aString
				ifFalse: [ -1 ]
				ifTrue: [ 1 ] ]
		do: [ :found | "Will never find any" ]
		ifNone: [ :a :b | | i n |
			i _ b.
			[ i <= count and: [ 
				n _ aCollection at: i.
				aString isEmpty or: [
					n beginsWith: aString ]]] whileTrue: [
				aBlock value: n.
				i _ i + 1 ]]! !
