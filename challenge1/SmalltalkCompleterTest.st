'From Cuis 6.0 [latest update: #5981] on 16 October 2023 at 12:04:13 pm'!
Transcript show: 'poolDictionaryForTesting'; newLine!
Smalltalk at: #poolDictionaryForTesting put: Dictionary new!
poolDictionaryForTesting at: #'X' put:  1!

!classDefinition: #SmalltalkCompleterTest category: 'BaseImageTests-Tools-Autocompletion'!
TestCase subclass: #SmalltalkCompleterTest
	instanceVariableNames: 'instanceVariable1 classToBrowse selectorToBrowse'
	classVariableNames: 'ClassVariableForTesting'
	poolDictionaries: 'poolDictionaryForTesting'
	category: 'BaseImageTests-Tools-Autocompletion'!

!SmalltalkCompleterTest methodsFor: 'testing' stamp: 'jmv 7/5/2022 23:08:14'!
testMessages
	"
	SmalltalkCompleterTest new testMessages
	"
	| fromSmalltalk fromUCompleter |
	fromSmalltalk _ Smalltalk allImplementedMessages.
	fromUCompleter _ Symbol allSymbols select: [ :s |
		SmalltalkCompleter isThereAnImplementorOf: s].
	self assert: fromSmalltalk = fromUCompleter asSet! !


!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 20:56:42'!
test000_AutocompletesMessagesFor_GlobalVariables_WithSelectorsFromTheirClasses
	
	self
		assertEntriesWhenBrowsing: 'm1 SmalltalkCompleterTest '
		areSelectorsOf: SmalltalkCompleterTest class.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < SmalltalkCompleterTest '
		areUnaryAndBinarySelectorsOf: SmalltalkCompleterTest class.
	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:01:49'!
test001_AutocompletesMessagesFor_Self_WithSelectorsFromTheBrowsedClass
	
	self
		assertEntriesWhenBrowsing: 'm1 self '
		areSelectorsOf: SmalltalkCompleterTest.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < self '
		areUnaryAndBinarySelectorsOf: SmalltalkCompleterTest.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:02:19'!
test002_AutocompletesMessagesFor_Super_WithSelectorsFromTheBrowsedClass
	
	self
		assertEntriesWhenBrowsing: 'm1 super '
		areSelectorsOf: TestCase.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < super '
		areUnaryAndBinarySelectorsOf: TestCase.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:02:43'!
test003_AutocompletesMessagesFor_Super_WithSelectorsForUnknownClassesWhenTheBrowsedClassDoesNotHaveASuperclass
	
	self browseClass: ProtoObject.
	
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 super '.
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 1 < super '.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:11:29'!
test004_AutocompletesMessagesFor_True_WithSelectorsFromTrue
	
	self
		assertEntriesWhenBrowsing: 'm1 true '
		areSelectorsOf: True.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < true '
		areUnaryAndBinarySelectorsOf: True.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:12:17'!
test005_AutocompletesMessagesFor_False_WithSelectorsFromFalse
	
	self
		assertEntriesWhenBrowsing: 'm1 false '
		areSelectorsOf: False.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < false '
		areUnaryAndBinarySelectorsOf: False.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:12:12'!
test006_AutocompletesMessagesFor_Nil_WithSelectorsFromUndefinedObject
	
	self
		assertEntriesWhenBrowsing: 'm1 nil '
		areSelectorsOf: UndefinedObject.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < nil '
		areUnaryAndBinarySelectorsOf: UndefinedObject.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'jmv 7/5/2022 16:26:48'!
test007_AutocompletesMessagesFor_Characters_WithSelectorsFromCharacter
	
	self
		assertEntriesWhenBrowsing: 'm1 $a '
		areSelectorsOf: $m class.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < $a '
		areUnaryAndBinarySelectorsOf: $m class.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:15:01'!
test008_AutocompletesMessagesFor_Numbers_WithSelectorsFromTheirClass
	
	self
		assertEntriesWhenBrowsing: 'm1 1 '
		areSelectorsOf: SmallInteger.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < 1 '
		areUnaryAndBinarySelectorsOf: SmallInteger.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'jmv 7/5/2022 16:27:59'!
test009_AutocompletesMessagesFor_Strings_WithSelectorsFromString
	
	self
		assertEntriesWhenBrowsing: 'm1 ''a'' '
		areSelectorsOf: 'm' class.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < ''a'' '
		areUnaryAndBinarySelectorsOf: 'm' class	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 23:37:45'!
test010_AutocompletesMessagesFor_Symbols_WithSelectorsFromSymbol
	
	self
		assertEntriesWhenBrowsing: 'm1 #a '
		areSelectorsOf: Symbol.
		
	self
		assertEntriesWhenBrowsing: 'm1 1 < #a '
		areUnaryAndBinarySelectorsOf: Symbol.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 23:38:21'!
test011_AutocompletesMessagesFor_StringSymbol_WithSelectorsFromSymbol
	
	self
		assertEntriesWhenBrowsing: 'm1 #''a'' '
		areSelectorsOf: Symbol.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < #''a'' '
		areUnaryAndBinarySelectorsOf: Symbol.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/6/2020 23:42:33'!
test012_AutocompletesMessagesFor_InstanceVariables
	
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 instanceVariable1 '.
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 1 + instanceVariable1 '.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 16:42:09'!
test013_AutocompletesMessagesFor_MethodArguments_WithSelectorsForUnknownClasses
	
	"I reference to SmalltalkCompleterTest directly and not thru 'self class' becuase this test has subclasses
	the #m1: and #m2: are defined in SmalltalkCompleterTest - Hernan"
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsingMethodWith: SmalltalkCompleterTest >> #m1:.
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsingMethodWith: SmalltalkCompleterTest >> #m2: ! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:22:39'!
test014_AutocompletesMessagesFor_TemporaryVariables_WithSelectorsForUnknownClasses
	
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 |a| a '.
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 |a| 1 + a '.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:25:42'!
test015_AutocompletesMessagesFor_BlockArguments_WithSelectorsForUnknownClasses
	
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 [ :a | a '.
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 [ :a | 1 + a '.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 22:04:54'!
test016_AutocompletesMessagesFor_BlockTemporaryVariables_WithSelectorsForUnknownClasses
	
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 [ | a | a '.
	
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 [ | a | 1 + a '.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NPM 3/18/2020 18:34:08'!
test017_AutocompletesMessagesFor_NilWorkspaceVariables_WithSelectorsForUnknownClasses
	
	self
		assertEntriesAreSelectorsForUnknownClassesForWorkspaceWith: 'x '
		binding: 'x'
		to: nil.
	
	self
		assertEntriesAreSelectorsForUnknownClassesForWorkspaceWith: '1 + x '
		binding: 'x'
		to: nil.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 22:05:36'!
test017_AutocompletesMessagesFor_NonNilWorkspaceVariables_WithSelectorsFromTheirClasses
	
	self
		assertEntriesForWorkspaceWith: 'x '
		binding: 'x'
		to: 1
		areSelectorsOf: SmallInteger.
		
	self
		assertEntriesForWorkspaceWith: '1 < x '
		binding: 'x'
		to: 1
		areUnaryAndBinarySelectorsOf: SmallInteger.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 23:27:14'!
test018_AutocompletesMessagesFor_ThisContext_WithSelectorsFromMethodContext
	
	self
		assertEntriesWhenBrowsing: 'm1 thisContext '
		areSelectorsOf: MethodContext.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < thisContext '
		areUnaryAndBinarySelectorsOf: MethodContext.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 23:27:39'!
test019_AutocompletesMessagesFor_ClassVariables_WithSelectorsFromTheirClasses
	
	ClassVariableForTesting _ 1.
		
	self
		assertEntriesWhenBrowsing: 'm1 ClassVariableForTesting '
		areSelectorsOf: SmallInteger.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < ClassVariableForTesting '
		areUnaryAndBinarySelectorsOf: SmallInteger.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 23:28:01'!
test020_AutocompletesMessagesFor_PoolConstants_WithSelectorsFromTheirClasses
	
	poolDictionaryForTesting at: #X put: 1.
	
	self
		assertEntriesWhenBrowsing: 'm1 X '
		areSelectorsOf: SmallInteger.
	
	self
		assertEntriesWhenBrowsing: 'm1 1 < X '
		areUnaryAndBinarySelectorsOf: SmallInteger.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 23:39:25'!
test021_AutocompletesMessagesFor_BlockEndings_WithSelectorsFromBlockClosure
	
	self
		assertEntriesWhenBrowsing: 'm1 [] '
		areSelectorsOf: BlockClosure.
		
	self
		assertEntriesWhenBrowsing: 'm1 1 < [] '
		areUnaryAndBinarySelectorsOf: BlockClosure.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 23:39:55'!
test022_AutocompletesMessagesFor_ArrayEnds_WithSelectorsFromArray
	
	self
		assertEntriesWhenBrowsing: 'm1 #() '
		areSelectorsOf: Array.
		
	self
		assertEntriesWhenBrowsing: 'm1 1 < #() '
		areUnaryAndBinarySelectorsOf: Array.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:04:04'!
test023_AutocompletesMessagesFor_RightBraces_WithSelectorsFromArray
	
	self
		assertEntriesWhenBrowsing: 'm1 {} '
		areSelectorsOf: Array.
		
	self
		assertEntriesWhenBrowsing: 'm1 1 < {} '
		areUnaryAndBinarySelectorsOf: Array.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/6/2020 23:43:31'!
test023_AutocompletingMessagesFor_UnaryMessages
	
	self denyComputingEntriesIsSupportedWhenBrowsing: 'm1 self class '.
		
	self denyComputingEntriesIsSupportedWhenBrowsing: 'm1 1 < self class '.	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/6/2020 23:44:50'!
test024_AutocompletingMessagesFor_RightParenthesis
	
	self denyComputingEntriesIsSupportedWhenBrowsing: 'm1 (1) '.
		
	self denyComputingEntriesIsSupportedWhenBrowsing: 'm1 1 < (1) '.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 02:08:24'!
test025_AutocompletesMessagesFor_UnknownIdentifiers_WithSelectorsForUnknownClasses
	
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 Foo1234 '.
	self assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: 'm1 foo1234 '.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/6/2020 23:45:10'!
test026_AutocompletingMessagesFor_Cascade
	
	self denyComputingEntriesIsSupportedWhenBrowsing: 'm1 self class; '.
	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:13:19'!
test027_AutocompletesEntriesFor_GlobalVariables_WithIdentifiersBegginingWithThem
	
	self
		assertEntriesWhenBrowsing: 'm1 SmalltalkCompleterTes'
		areIdentifiersBeginningWith: 'SmalltalkCompleterTest'.
	! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:14:50'!
test028_AutocompletesEntriesFor_PoolConstants_WithIdentifiersBegginingWithThem
	
	poolDictionaryForTesting at: #X put: 1.
	
	self
		assertEntriesWhenBrowsing: 'm1 X'
		areIdentifiersBeginningWith: 'X'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NPM 3/18/2020 19:56:46'!
test029_AutocompletesEntriesFor_WorkspaceVariables_WithIdentifiersBegginingWithThem
	
	| completer |
	completer := self
		autocompleteEntriesForWorkspaceWith: 'x'
		binding: 'x'
		to: 1. 
		
	self
		assertEntriesOf: completer
		areIdentifiersBeginningWith: 'x'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:15:11'!
test030_AutocompletesEntriesFor_ClassVariables_WithIdentifiersBegginingWithThem
	
	ClassVariableForTesting _ 1.
	
	self
		assertEntriesWhenBrowsing: 'm1 ClassVariableForTestin'
		areIdentifiersBeginningWith: 'ClassVariableForTesting'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:15:28'!
test031_AutocompletesEntriesFor_InstanceVariables_WithIdentifiersBegginingWithThem
	
	self
		assertEntriesWhenBrowsing: 'm1 instanceVariable'
		areIdentifiersBeginningWith: 'instanceVariable1'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/2/2020 21:36:46'!
test032_AutocompletesEntriesFor_MethodArguments_WithIdentifiersBegginingWithThem
	
	| completer |
	
	completer := self autocompleteEntriesBrowsingMethod: SmalltalkCompleterTest >> #m3:.
	
	self
		assert: completer
		analizedSelectorsFrom: nil
		canShowDocumentation: false
		detectedPossibleInvalidSelector: #()
		suggested: (completer computeIdentifierEntriesBeginningWith: 'arg1').! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:15:54'!
test033_AutocompletesEntriesFor_TemporaryVariables_WithIdentifiersBegginingWithThem
	
	self
		assertEntriesWhenBrowsing: 'm1 |xx| x'
		areIdentifiersBeginningWith: 'xx'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:16:11'!
test034_AutocompletesEntriesFor_BlockArguments_WithIdentifiersBegginingWithThem
	
	self
		assertEntriesWhenBrowsing: 'm1 [ :xx | x'
		areIdentifiersBeginningWith: 'xx'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:16:27'!
test035_AutocompletesEntriesFor_BlockTemporaryVariables_WithIdentifiersBegginingWithThem
	
	self
		assertEntriesWhenBrowsing: 'm1 [ | xx | x'
		areIdentifiersBeginningWith: 'xx'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:16:43'!
test036_AutocompletesEntriesFor_IncompleteIdentifiers_WithIdentifiersBegginingWithThem

	self
		assertEntriesWhenBrowsing: 'm1 Obj'
		areIdentifiersBeginningWith: 'Obj'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:17:34'!
test037_AutocompletesEntriesFor_ReservedNames_WithIdentifiersBegginingWithThem

	self assertEntriesWhenBrowsing: 'm1 self' areIdentifiersBeginningWith: 'self'.
	self assertEntriesWhenBrowsing: 'm1 supe' areIdentifiersBeginningWith: 'super'.
	self assertEntriesWhenBrowsing: 'm1 tru' areIdentifiersBeginningWith: 'true'.
	self assertEntriesWhenBrowsing: 'm1 fals' areIdentifiersBeginningWith: 'false'.
	self assertEntriesWhenBrowsing: 'm1 ni' areIdentifiersBeginningWith: 'nil'.
	self assertEntriesWhenBrowsing: 'm1 thisContex' areIdentifiersBeginningWith: 'thisContext'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/14/2023 03:53:39'!
test038_DoesNotAutocompleteEntriesFor_UndefinedIdentifiers

	| completer |
	completer := self createCompleterForBrowsing: 'asddas: kdkk ads'.
	
	completer computeEntries.
	
	self denyHasEntries: completer ! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:18:55'!
test039_AutocompletesEntriesFor_BinaryMessages_WithIdentifiersBegginingWithThem

	self
		assertEntriesWhenBrowsing: 'm1 1 ~='
		areSelectorsOf: SmallInteger
		beginningWith: '~='! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:19:17'!
test040_AutocompletesEntriesFor_IncompleteBinaryMessages_WithIdentifiersBegginingWithThem

	self
		assertEntriesWhenBrowsing: 'm1 1 ~'
		areSelectorsOf: SmallInteger
		beginningWith: '~'! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:19:42'!
test041_AutocompletesEntriesFor_UnaryMessages_WithIdentifiersBegginingWithThem

	self
		assertEntriesWhenBrowsing: 'm1 1 not'
		areSelectorsOf: SmallInteger
		beginningWith: 'not'! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:19:53'!
test042_AutocompletesEntriesFor_IncompleteUnaryMessages_WithIdentifiersBegginingWithThem

	self
		assertEntriesWhenBrowsing: 'm1 1 no'
		areSelectorsOf: SmallInteger
		beginningWith: 'no'! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:20:03'!
test043_AutocompletesEntriesFor_KeywordMessages_WithIdentifiersBegginingWithThem

	self
		assertEntriesWhenBrowsing: 'm1 1 at:'
		areSelectorsOf: SmallInteger
		beginningWith: 'at:'! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'HAW 5/3/2020 01:18:26'!
test044_AutocompletesEntriesFor_IncompleteKeywordMessages_WithIdentifiersBegginingWithThem

	self
		assertEntriesWhenBrowsing: 'm1 self firstKeyword:'
		areSelectorsOf: SmalltalkCompleterTest
		beginningWith: 'firstKeyword:'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 11:57:00'!
test045_AutocompletesEntriesFor_patternUnary_containsExactlyTwoMethods

	| completer |
	completer := self createCompleterForBrowsing: 'fl'.
	
	completer computeEntries.

	self assert: completer entries size equals: 2.
	self assert: completer entries includes: 'flag: aSymbol'.
	self assert: completer entries includes: 'flash'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 12:00:25'!
test046_AutocompletesEntriesFor_patternUnary_doesNotAutocompleteMethodOfSameClass

	| completer |
	completer := self createCompleterForBrowsing: 'm1'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 11:56:32'!
test047_AutocompletesEntriesFor_patternKeyword_containsExactlyOneMethod

	| completer |
	completer := self createCompleterForBrowsing: 'flag:'.
	
	completer computeEntries.

	self assert: completer entries size equals: 1.
	self assert: completer entries includes: 'flag: aSymbol'
! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/14/2023 06:14:44'!
test048_AutocompletesEntriesFor_patternUnary_notContainsAnyMethod

	| completer |
	completer := self createCompleterForBrowsing: 'flagggg'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/14/2023 06:13:52'!
test049_AutocompletesEntriesFor_patternKeyword_notContainsAnyMethod

	| completer |
	completer := self createCompleterForBrowsing: 'flagg:'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 12:00:36'!
test050_AutocompletesEntriesFor_patternKeyword_doesNotAutocompleteMethodOfSameClass

	| completer |
	completer := self createCompleterForBrowsing: 'm1:'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 11:56:01'!
test051_AutocompletesEntriesFor_patternArg_containsExactlyFourMethods

	| completer |
	completer := self createCompleterForBrowsing: 'when: zzz'.
	
	completer computeEntries.

	self assert: completer entries size equals: 4.
	self assert: completer entries includes: 'when: anEventSelector evaluate: anAction'.
	self assert: completer entries includes: 'when: anEventSelector
send: aMessageSelector
to: anObject'.
	self assert: completer entries includes: 'when: anEventSelector
send: aMessageSelector
to: anObject
with: anArg'.
	self assert: completer entries includes: 'when: anEventSelector
send: aMessageSelector
to: anObject
withArguments: anArgArray'.! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/14/2023 06:14:06'!
test052_AutocompletesEntriesFor_patternArg_notContainsAnyMethod

	| completer |
	completer := self createCompleterForBrowsing: 'whevn: ff sendc: ddd to: qqq withArgumeccnts: rr and: oo'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 12:00:45'!
test053_AutocompletesEntriesFor_patternArg_doesNotAutocompleteMethodOfSameClass

	| completer |
	completer := self createCompleterForBrowsing: 'm1: arg1 with: arg2 and: arg3 andLast: arg4'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 11:57:36'!
test054_AutocompletesEntriesFor_patternBinary_containsExactlyOneMethod

	| completer |
	completer := self createCompleterForBrowsing: '->'.
	
	completer computeEntries.

	self assert: completer entries size equals: 1.
	self assert: completer entries includes: '-> anObject'! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 11:59:55'!
test055_AutocompletesEntriesFor_patternBinary_notContainsAnyMethod


	| completer |
	completer := self createCompleterForBrowsing: '*'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !

!SmalltalkCompleterTest methodsFor: 'tests' stamp: 'NMS 10/16/2023 11:59:33'!
test056_AutocompletesEntriesFor_patternBinary_doestNotAutocompleteMethodOfSameClass

	| completer |
	completer := self createCompleterForBrowsing: '+'.
	
	completer computeEntries.

	self assert: completer entries size equals: 0! !


!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'NMS 10/16/2023 11:46:07'!
+ aNumber! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'HAW 1/27/2022 19:32:18'!
createCompleterForBrowsing: sourceCode 
	
	| browser model |
	browser := Browser new.
	browser setSelectedSystemCategoryTreeItem: (SystemCategoryWrapper with: classToBrowse category name: classToBrowse category model: browser).
	browser classListIndex: (browser classList indexOf: classToBrowse name).
	
	model := (PluggableTextModel on: browser) actualContents: sourceCode.
	browser editSelection: #newMethod.

	^ self createCompleterWith: model.! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'NPM 3/18/2020 19:17:59'!
createCompleterForWorkspaceWith: sourceCode binding: aVariableName to: aValue
	
	| model |
	model := Workspace withText: sourceCode.
	(model bindingOf: aVariableName) value: aValue.
	
	^ self createCompleterWith: model! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'HAW 5/2/2020 13:14:11'!
createCompleterWith: aModel
	
	^ (SmalltalkCompleter withModel: aModel)
		changePositionTo: aModel actualContents size;
		yourself! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'HAW 5/2/2020 16:37:44'!
firstKeyword: a secondKeyword: b! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'HAW 5/2/2020 16:55:18'!
m1: arg1 arg1 ! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'NMS 10/14/2023 06:08:26'!
m1: arg1 with: arg2 and: arg3 andLast: arg4! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'HAW 5/2/2020 16:37:29'!
m2: arg1 1 + arg1 ! !

!SmalltalkCompleterTest methodsFor: 'test objects' stamp: 'HAW 5/2/2020 16:56:16'!
m3: arg1 arg1! !


!SmalltalkCompleterTest methodsFor: 'test support' stamp: 'NPM 3/18/2020 19:13:43'!
autocompleteEntriesBrowsing: sourceCode
	
	| completer |
	completer := self createCompleterForBrowsing: sourceCode.
	
	completer computeEntries.
	
	^ completer! !

!SmalltalkCompleterTest methodsFor: 'test support' stamp: 'HAW 5/2/2020 21:51:30'!
autocompleteEntriesBrowsingMethod: aCompiledMethod 
	
	| completer selector |
	
	selector := aCompiledMethod selector.
	completer := self createCompleterForBrowsing: aCompiledMethod sourceCode.
	"Not nice, but does it work - Hernan"
	completer textProviderOrModel instVarNamed: 'currentCompiledMethod' put: aCompiledMethod.
	completer textProviderOrModel selectedMessageName: selector.
	
	completer computeEntries.
	
	^ completer! !

!SmalltalkCompleterTest methodsFor: 'test support' stamp: 'NPM 3/18/2020 19:07:19'!
autocompleteEntriesForWorkspaceWith: sourceCode binding: aVariableName to: aValue 
	
	| completer |
	completer := self
		createCompleterForWorkspaceWith: sourceCode
		binding: aVariableName
		to: aValue.
		
	completer computeEntries.
	
	^ completer! !

!SmalltalkCompleterTest methodsFor: 'test support' stamp: 'NPM 3/18/2020 18:32:34'!
browseClass: aClass 
	
	classToBrowse _ aClass.! !


!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 20:21:58'!
assert: aCompleter analizedSelectorsFrom: classes canShowDocumentation: aBoolean detectedPossibleInvalidSelector: selectors suggested: entries 
	
	classes 
		ifNil: [ self assert: aCompleter selectorsClasses isNil ]
		ifNotNil: [ self assert: aCompleter selectorsClasses asSet = classes asSet ].
	self assert: aCompleter canShowSelectorDocumentation equals: aBoolean.
	self assert: aCompleter possibleInvalidSelectors asSet = selectors asSet.
	entries 
		ifNil: [ self assert: aCompleter entries isNil ]
		ifNotNil: [ self assert: (self entriesToCompareFrom: aCompleter entries) = (self entriesToCompareFrom: entries) ]
		
		! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 20:25:15'!
assertEntriesAreSelectorsForUnknownClasses: aCompleter 
	
	| expectedEntries expectedPossibleInvalidSelectors |
	expectedPossibleInvalidSelectors _ Set new.
	expectedEntries _ aCompleter computeMessageEntriesForUnknowClassAddingPossibleInvalidSelectorsTo: expectedPossibleInvalidSelectors.
	
	self
		assert: aCompleter
		analizedSelectorsFrom: #()
		canShowDocumentation: true
		detectedPossibleInvalidSelector: expectedPossibleInvalidSelectors
		suggested: expectedEntries! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 19:06:02'!
assertEntriesAreSelectorsForUnknownClassesForWorkspaceWith: sourceCode binding: aVariableName to: aValue
	
	| completer |
	completer := self
		autocompleteEntriesForWorkspaceWith: sourceCode
		binding: aVariableName
		to: aValue.
	
	self assertEntriesAreSelectorsForUnknownClasses: completer.! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 19:07:53'!
assertEntriesAreSelectorsOfUnknownClassesWhenBrowsing: sourceCode 
	
	| completer |
	completer := self autocompleteEntriesBrowsing: sourceCode.
	
	self assertEntriesAreSelectorsForUnknownClasses: completer.! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 21:36:46'!
assertEntriesAreSelectorsOfUnknownClassesWhenBrowsingMethodWith: aCompiledMethod 
	
	| completer |
	
	completer := self autocompleteEntriesBrowsingMethod: aCompiledMethod.
	
	self assertEntriesAreSelectorsForUnknownClasses: completer.
	
	! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 19:08:09'!
assertEntriesForWorkspaceWith: sourceCode binding: aVariableName to: aValue areSelectorsOf: aClass
	
	| completer |
	completer := self
		autocompleteEntriesForWorkspaceWith: sourceCode
		binding: aVariableName
		to: aValue.
	
	self
		assertEntriesOf: completer
		areAllSelectorsOf: aClass.! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 19:19:49'!
assertEntriesForWorkspaceWith: sourceCode binding: aVariableName to: aValue areUnaryAndBinarySelectorsOf: aClass 
	
	| completer |
	completer := self
		autocompleteEntriesForWorkspaceWith: sourceCode
		binding: aVariableName
		to: aValue.
	
	self
		assertEntriesOf: completer
		areUnaryAndBinarySelectorsOf: aClass.! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/17/2020 18:27:01'!
assertEntriesOf: aCompleter areAllSelectorsOf: aClass

	self
		assertEntriesOf: aCompleter
		areAllSelectorsOf: aClass
		beginningWith: ''! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 17:38:48'!
assertEntriesOf: aCompleter areAllSelectorsOf: aClass beginningWith: aPrefix

	self assertEntriesOf: aCompleter areAllSelectorsOfAll: { aClass } beginningWith: aPrefix
! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 18:42:55'!
assertEntriesOf: aCompleter areAllSelectorsOfAll: classes beginningWith: aPrefix

	| suggested |

	suggested := classes inject: Set new into: [ :suggestedCollector :aClass |
		suggestedCollector 
			addAll: (aCompleter selectorsOf: aClass beginningWith: aPrefix);
			yourself ].
	
	self
		assert: aCompleter
		analizedSelectorsFrom: classes
		canShowDocumentation: true
		detectedPossibleInvalidSelector: #()
		suggested: suggested.! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 20:25:15'!
assertEntriesOf: aCompleter areIdentifiersBeginningWith: aPrefix

	self
		assert: aCompleter
		analizedSelectorsFrom: nil
		canShowDocumentation: false
		detectedPossibleInvalidSelector: #()
		suggested: (aCompleter computeIdentifierEntriesBeginningWith: aPrefix)! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 20:10:35'!
assertEntriesOf: aCompleter areUnaryAndBinarySelectorsOf: aClass

	self
		assert: aCompleter
		analizedSelectorsFrom: {aClass}
		canShowDocumentation: true
		detectedPossibleInvalidSelector: #()
		suggested: (self using: aCompleter addUnaryAndBinarySelectorsOf: aClass).
	! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 19:58:16'!
assertEntriesWhenBrowsing: sourceCode areIdentifiersBeginningWith: aPrefix
	
	| completer |
	completer := self autocompleteEntriesBrowsing: sourceCode.
	
	self
		assertEntriesOf: completer
		areIdentifiersBeginningWith: aPrefix.! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 18:55:09'!
assertEntriesWhenBrowsing: sourceCode areSelectorsOf: aClass
	
	self
		assertEntriesWhenBrowsing: sourceCode
		areSelectorsOf: aClass
		beginningWith: ''! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 18:58:41'!
assertEntriesWhenBrowsing: sourceCode areSelectorsOf: aClass beginningWith: aPrefix
	
	self
		assertEntriesOf: (self autocompleteEntriesBrowsing: sourceCode)
		areAllSelectorsOf: aClass
		beginningWith: aPrefix 
	! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 17:40:10'!
assertEntriesWhenBrowsing: sourceCode areSelectorsOfAll: classes
	
	self
		assertEntriesWhenBrowsing: sourceCode
		areSelectorsOfAll: classes
		beginningWith: ''! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 17:41:09'!
assertEntriesWhenBrowsing: sourceCode areSelectorsOfAll: classes beginningWith: aPrefix
	
	self
		assertEntriesOf: (self autocompleteEntriesBrowsing: sourceCode)
		areAllSelectorsOfAll: classes
		beginningWith: aPrefix 
	! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 18:59:22'!
assertEntriesWhenBrowsing: sourceCode areUnaryAndBinarySelectorsOf: aClass
	
	self
		assertEntriesOf: (self autocompleteEntriesBrowsing: sourceCode)
		areUnaryAndBinarySelectorsOf: aClass.
	
	! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 21:33:48'!
assertEntriesWhenBrowsingMethod: aMethod areSelectorsOf: aClass
	
	self
		assertEntriesWhenBrowsingMethod: aMethod
		areSelectorsOf: aClass
		beginningWith: ''! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 21:36:46'!
assertEntriesWhenBrowsingMethod: aMethod areSelectorsOf: aClass beginningWith: aPrefix
	
	self
		assertEntriesOf: (self autocompleteEntriesBrowsingMethod: aMethod)
		areAllSelectorsOf: aClass
		beginningWith: aPrefix 
	! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 21:36:46'!
assertEntriesWhenBrowsingMethod: aMethod areUnaryAndBinarySelectorsOf: aClass
	
	self
		assertEntriesOf: (self autocompleteEntriesBrowsingMethod: aMethod)
		areUnaryAndBinarySelectorsOf: aClass.
	
	! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 20:25:15'!
denyComputingEntriesIsSupportedWhenBrowsing: sourceCode 
	
	| completer |
	completer := self createCompleterForBrowsing: sourceCode.
	
	self
		should: [ completer computeEntries ]
		raise: Error.
	self
		assert: completer
		analizedSelectorsFrom: nil
		canShowDocumentation: true
		detectedPossibleInvalidSelector: #()
		suggested: nil.! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'NPM 3/18/2020 20:25:15'!
denyHasEntries: aCompleter  

	self
		assert: aCompleter
		analizedSelectorsFrom: nil
		canShowDocumentation: nil
		detectedPossibleInvalidSelector: #()
		suggested: #()! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 20:24:54'!
entriesToCompareFrom: aCollectionOfEntries

	^(aCollectionOfEntries reject: [ :anEntry | 
		anEntry beginsWith: AutoCompleterSelectorsCollector categoryEntryHeader ]) asSet! !

!SmalltalkCompleterTest methodsFor: 'assertions' stamp: 'HAW 5/2/2020 20:10:35'!
using: aCompleter addUnaryAndBinarySelectorsOf: aClass

	^ aCompleter unaryAndBinarySelectorsOf: aClass beginningWith: ''! !


!SmalltalkCompleterTest methodsFor: 'setUp/tearDown' stamp: 'NPM 3/18/2020 18:32:49'!
setUp

	super setUp.
	
	self browseClass: SmalltalkCompleterTest.
	
! !


!SmalltalkCompleterTest methodsFor: 'running' stamp: 'HAW 5/2/2020 20:49:50'!
performTest

	^SmalltalkCompleter changeEntriesLimitTo: SmallInteger maxVal during: [ super performTest ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SmalltalkCompleterTest class' category: 'BaseImageTests-Tools-Autocompletion'!
SmalltalkCompleterTest class
	instanceVariableNames: ''!

!SmalltalkCompleterTest class methodsFor: 'testing' stamp: 'HAW 5/2/2020 13:21:14'!
isAbstract

	^true! !
