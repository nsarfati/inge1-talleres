!classDefinition: #MarsRoverHistoricalLoggerTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverHistoricalLoggerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:38:28'!
test01PositionHistoryLogIsEmptyOnInitializedMarsRover

	| aMarsRover positionHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	positionHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: positionHistoricalLogger.

	self assert: positionHistoricalLogger log isEmpty
! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:38:35'!
test02PositionHistoryLogHasForwardPosition

	| aMarsRover positionHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.

	positionHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: positionHistoricalLogger.

	aMarsRover process: 'f'.

	self assert: positionHistoricalLogger log first equals: 1@2.
	self assert: positionHistoricalLogger log size equals: 1.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:38:40'!
test03PositionHistoryLogHasBackwardPosition

	| aMarsRover positionHistoricalLogger |

	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.

	positionHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: positionHistoricalLogger.

	aMarsRover process: 'b'.

	self assert: positionHistoricalLogger log first equals: 1@0.
	self assert: positionHistoricalLogger log size equals: 1.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:38:46'!
test04PositionHistoryLogTestExtraGeneralCase

	| aMarsRover positionHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.

	positionHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: positionHistoricalLogger.

	aMarsRover process: 'fflbbrflf'.

	self assert: positionHistoricalLogger log first equals: 1@2.
	self assert: positionHistoricalLogger log second equals: 1@3.
	self assert: positionHistoricalLogger log third equals: 2@3.
	self assert: positionHistoricalLogger log fourth equals: 3@3.
	self assert: positionHistoricalLogger log fifth equals: 3@4.
	self assert: positionHistoricalLogger log sixth equals: 2@4.

	self assert: positionHistoricalLogger log size equals: 6.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:34:53'!
test05HeadingHistoryLogIsEmptyOnInitializedMarsRover

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	self assert: headingHistoricalLogger log isEmpty
! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:34:25'!
test06HeadingHistoryLogHasEastOnRotation

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'r'.

	self assert: headingHistoricalLogger log first equals: 'East'.
	self assert: headingHistoricalLogger log size equals: 1.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:33:25'!
test07HeadingHistoryLogHasWestOnRotation

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'l'.

	self assert: headingHistoricalLogger log first equals: 'West'.
	self assert: headingHistoricalLogger log size equals: 1.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:34:21'!
test08HeadingHistoryLogHasSouthOnRotation

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingWest.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'l'.

	self assert: headingHistoricalLogger log first equals: 'South'.
	self assert: headingHistoricalLogger log size equals: 1.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:34:36'!
test09HeadingHistoryLogHasNorthOnRotation

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingWest.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'r'.

	self assert: headingHistoricalLogger log first equals: 'North'.
	self assert: headingHistoricalLogger log size equals: 1.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:38:11'!
test10HeadingHistoryLogTestExtraGeneralCase

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'rrflbll'.

	self assert: headingHistoricalLogger log first equals: 'East'.
	self assert: headingHistoricalLogger log second equals: 'South'.
	self assert: headingHistoricalLogger log third equals: 'East'.
	self assert: headingHistoricalLogger log fourth equals: 'North'.
	self assert: headingHistoricalLogger log fifth equals: 'West'.
	self assert: headingHistoricalLogger log size equals: 5.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:55:53'!
test11PositionAndHeadingHistoryLogOnlyChangesPosition

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: headingHistoricalLogger.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'ff'.

	self assert: headingHistoricalLogger log first equals: 1@2.
	self assert: headingHistoricalLogger log second equals: 1@3.
	self assert: headingHistoricalLogger log size equals: 2.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:56:04'!
test12PositionAndHeadingHistoryLogOnlyChangesHeading

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: headingHistoricalLogger.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'rr'.

	self assert: headingHistoricalLogger log first equals: 'East'.
	self assert: headingHistoricalLogger log second equals: 'South'.
	self assert: headingHistoricalLogger log size equals: 2.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:56:19'!
test13PositionAndHeadingHistoryLogChangesPositionAndHeading

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: headingHistoricalLogger.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'fr'.

	self assert: headingHistoricalLogger log first equals: 1@2.
	self assert: headingHistoricalLogger log second equals: 'East'.
	self assert: headingHistoricalLogger log size equals: 2.! !

!MarsRoverHistoricalLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 18:56:34'!
test14PositionAndHeadingHistoryLogTestExtraGeneralCase

	| aMarsRover headingHistoricalLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingHistoricalLogger := MarsRoverHistoricalLogger new.
	aMarsRover subscribeToPosition: headingHistoricalLogger.
	aMarsRover subscribeToHeading: headingHistoricalLogger.

	aMarsRover process: 'frrblbrrrl'.

	self assert: headingHistoricalLogger log first equals: 1@2.
	self assert: headingHistoricalLogger log second equals: 'East'.
	self assert: headingHistoricalLogger log third equals: 'South'.
	self assert: headingHistoricalLogger log fourth equals: 1@3.
	self assert: headingHistoricalLogger log fifth equals: 'East'.
	self assert: headingHistoricalLogger log sixth equals: 0@3.
	self assert: headingHistoricalLogger log seventh equals: 'South'.
	self assert: headingHistoricalLogger log eighth equals: 'West'.
	self assert: headingHistoricalLogger log ninth equals: 'North'.
	self assert: (headingHistoricalLogger log at: 10) equals: 'West'.
	self assert: headingHistoricalLogger log size equals: 10.! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRoverWindowLoggerTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverWindowLoggerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 19:57:07'!
test01PositionWindowLogIsEmptyOnInitializedMarsRover

	| aMarsRover positionWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	positionWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: positionWindowLogger.

	self assert: (positionWindowLogger position) equals: ''.
	self assert: (positionWindowLogger heading) equals: ''! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 19:58:00'!
test02PositionWindowLogHasForwardPosition

	| aMarsRover positionWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.

	positionWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: positionWindowLogger.

	aMarsRover process: 'f'.

	self assert: positionWindowLogger position equals: 1@2.
	self assert: positionWindowLogger heading equals: ''! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:02:44'!
test03PositionWindowLogHasBackwardPosition

	| aMarsRover positionWindowLogger |

	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.

	positionWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: positionWindowLogger.

	aMarsRover process: 'b'.

	self assert: positionWindowLogger position equals: 1@0.
	self assert: positionWindowLogger heading equals: ''! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:03:22'!
test04PositionWindowLogTestExtraGeneralCase

	| aMarsRover positionWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.

	positionWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: positionWindowLogger.

	aMarsRover process: 'fflbbrflf'.

	self assert: positionWindowLogger position equals: 2@4! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:04:53'!
test05HeadingWindowLogIsEmptyOnInitializedMarsRover

	| aMarsRover headingWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToHeading: headingWindowLogger.

	self assert: headingWindowLogger position equals: ''.
	self assert: headingWindowLogger heading equals: ''! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:06:05'!
test06HeadingWindowLogHasEastOnRotation

	| aMarsRover headingWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToHeading: headingWindowLogger.

	aMarsRover process: 'r'.

	self assert: headingWindowLogger heading equals: 'Apuntando al Este'.
	self assert: headingWindowLogger position equals: ''! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:08:12'!
test07HeadingWindowLogHasWestOnRotation

	| aMarsRover headingWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToHeading: headingWindowLogger.

	aMarsRover process: 'l'.

	self assert: headingWindowLogger heading equals: 'Apuntando al Oeste'.
	self assert: headingWindowLogger position equals: ''.
! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:09:09'!
test08HeadingWindowLogHasSouthOnRotation

	| aMarsRover headingWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingWest.
	
	headingWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToHeading: headingWindowLogger.

	aMarsRover process: 'l'.

	self assert: headingWindowLogger heading equals: 'Apuntando al Sur'.
	self assert: headingWindowLogger position equals: ''.! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:10:03'!
test09HeadingWindowLogHasNorthOnRotation

	| aMarsRover headingWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingWest.
	
	headingWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToHeading: headingWindowLogger.

	aMarsRover process: 'r'.

	self assert: headingWindowLogger heading equals: 'Apuntando al Norte'.
	self assert: headingWindowLogger position equals: ''.! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:11:08'!
test10HeadingWindowLogTestExtraGeneralCase

	| aMarsRover headingWindowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	headingWindowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToHeading: headingWindowLogger.

	aMarsRover process: 'rrflbll'.

	self assert: headingWindowLogger heading equals: 'Apuntando al Oeste'.
	self assert: headingWindowLogger position equals: ''.! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:14:32'!
test11PositionAndHeadingWindowLogOnlyChangesPosition

	| aMarsRover windowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	windowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: windowLogger.
	aMarsRover subscribeToHeading: windowLogger.

	aMarsRover process: 'ff'.

	self assert: windowLogger position equals: 1@3.
	self assert: windowLogger heading equals: ''.! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:14:26'!
test12PositionAndHeadingWindowLogOnlyChangesHeading

	| aMarsRover windowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	windowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: windowLogger.
	aMarsRover subscribeToHeading: windowLogger.

	aMarsRover process: 'rr'.

	self assert: windowLogger heading equals: 'Apuntando al Sur'.
	self assert: windowLogger position equals: ''.! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:14:20'!
test13PositionAndHeadingWindowLogChangesPositionAndHeading

	| aMarsRover windowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	windowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: windowLogger.
	aMarsRover subscribeToHeading: windowLogger.

	aMarsRover process: 'fr'.

	self assert: windowLogger position equals: 1@2.
	self assert: windowLogger heading equals: 'Apuntando al Este'.! !

!MarsRoverWindowLoggerTest methodsFor: 'testing' stamp: 'NMS 10/29/2023 20:31:24'!
test14PositionAndHeadingWindowLogTestExtraGeneralCase

	| aMarsRover windowLogger |
	
	aMarsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth.
	
	windowLogger := MarsRoverWindowLogger new.
	aMarsRover subscribeToPosition: windowLogger.
	aMarsRover subscribeToHeading: windowLogger.

	aMarsRover process: 'frrblbrrrl'.

	self assert: windowLogger position equals: 0@3.
	self assert: windowLogger heading equals: 'Apuntando al Oeste'.

	aMarsRover process: 'ff'.

	self assert: windowLogger position equals: -2@3.
	self assert: windowLogger heading equals: 'Apuntando al Oeste'.
! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'NMS 10/29/2023 19:39:59'!
initializeAt: aPosition heading: aHeadingType
	position := MarsRoverCollaboratorProxy for: aPosition.
	head := MarsRoverCollaboratorProxy for: (aHeadingType for: self)
! !


!MarsRover methodsFor: 'heading' stamp: 'NMS 10/29/2023 17:55:57'!
headEast
	
	"head := MarsRoverHeadingEast for: self"
	head changeValue: (MarsRoverHeadingEast for: self)! !

!MarsRover methodsFor: 'heading' stamp: 'NMS 10/29/2023 17:56:07'!
headNorth
	
	"head := MarsRoverHeadingNorth for: self "
	head changeValue: (MarsRoverHeadingNorth for: self)! !

!MarsRover methodsFor: 'heading' stamp: 'NMS 10/29/2023 17:56:24'!
headSouth
	
	"head := MarsRoverHeadingSouth for: self"
	head changeValue: (MarsRoverHeadingSouth for: self)! !

!MarsRover methodsFor: 'heading' stamp: 'NMS 10/29/2023 17:56:31'!
headWest
	
	"head := MarsRoverHeadingWest for: self "
	head changeValue: (MarsRoverHeadingWest for: self)
	! !

!MarsRover methodsFor: 'heading' stamp: 'NMS 10/29/2023 17:56:39'!
rotateLeft
	
	head value rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'NMS 10/29/2023 17:56:42'!
rotateRight
	
	head value rotateRight! !


!MarsRover methodsFor: 'observer - subscription' stamp: 'NMS 10/29/2023 19:31:29'!
subscribeToHeading: aMarsRoverObserver
	head attach: [ :aNewHeading | aMarsRoverObserver logHeadingChange: aNewHeading]! !

!MarsRover methodsFor: 'observer - subscription' stamp: 'NMS 10/29/2023 19:31:32'!
subscribeToPosition: aMarsRoverObserver
	position attach: [ :aNewPosition | aMarsRoverObserver logPositionChange: aNewPosition]! !


!MarsRover methodsFor: 'testing' stamp: 'NMS 10/29/2023 19:31:08'!
isAt: aPosition heading: aHeadingType
	^position value = aPosition and: [ head value isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'NMS 10/29/2023 17:59:06'!
moveBackward
	head value moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'NMS 10/29/2023 19:30:57'!
moveEast
	position changeValue: position value + (1@0)! !

!MarsRover methodsFor: 'moving' stamp: 'NMS 10/29/2023 17:59:02'!
moveForward
	head value moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'NMS 10/29/2023 19:30:52'!
moveNorth
	position changeValue: position value + (0@1)! !

!MarsRover methodsFor: 'moving' stamp: 'NMS 10/29/2023 19:30:49'!
moveSouth
	position changeValue: position value + (0@-1)! !

!MarsRover methodsFor: 'moving' stamp: 'NMS 10/29/2023 19:31:03'!
moveWest
	position changeValue: position value + (-1@0)! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverCollaboratorProxy category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverCollaboratorProxy
	instanceVariableNames: 'value observers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverCollaboratorProxy methodsFor: 'observer' stamp: 'NMS 10/29/2023 17:50:56'!
attach: anObserver
	observers add: anObserver! !


!MarsRoverCollaboratorProxy methodsFor: 'initialize' stamp: 'NMS 10/29/2023 17:51:18'!
initializeWith: aValue
	value := aValue.
	observers := OrderedCollection new.! !


!MarsRoverCollaboratorProxy methodsFor: 'accessing' stamp: 'NMS 10/29/2023 19:17:20'!
changeValue: aNewValue
	value := aNewValue. 
	
	"observers do: [:anObserver | anObserver updateChange: self]"
	observers do: [:anObserver | anObserver value: aNewValue]! !

!MarsRoverCollaboratorProxy methodsFor: 'accessing' stamp: 'NMS 10/29/2023 17:53:13'!
value
	^value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverCollaboratorProxy class' category: 'MarsRover-WithHeading'!
MarsRoverCollaboratorProxy class
	instanceVariableNames: ''!

!MarsRoverCollaboratorProxy class methodsFor: 'instance creation' stamp: 'NMS 10/29/2023 17:51:38'!
for: aValue
	^self new initializeWith: aValue! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'logging' stamp: 'NMS 10/29/2023 19:24:25'!
logChange: aHeadingObserver

	self subclassResponsibility! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!MarsRoverHeadingEast methodsFor: 'logging' stamp: 'NMS 10/29/2023 19:25:05'!
logChange: aHeadingObserver

	aHeadingObserver logHeadingChangeToEast! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!MarsRoverHeadingNorth methodsFor: 'logging' stamp: 'NMS 10/29/2023 19:25:17'!
logChange: aHeadingObserver

	aHeadingObserver logHeadingChangeToNorth! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!MarsRoverHeadingSouth methodsFor: 'logging' stamp: 'NMS 10/29/2023 19:25:26'!
logChange: aHeadingObserver

	aHeadingObserver logHeadingChangeToSouth! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!MarsRoverHeadingWest methodsFor: 'logging' stamp: 'NMS 10/29/2023 19:25:32'!
logChange: aHeadingObserver

	aHeadingObserver logHeadingChangeToWest! !


!classDefinition: #MarsRoverLogger category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverLogger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLogger methodsFor: 'logging' stamp: 'NMS 10/29/2023 20:27:00'!
logHeadingChange: aNewHeading
	self subclassResponsibility ! !

!MarsRoverLogger methodsFor: 'logging' stamp: 'NMS 10/29/2023 20:27:21'!
logPositionChange: aNewPosition
	self subclassResponsibility! !


!MarsRoverLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:27:34'!
logHeadingChangeToEast

	self subclassResponsibility! !

!MarsRoverLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:27:38'!
logHeadingChangeToNorth

	self subclassResponsibility! !

!MarsRoverLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:27:42'!
logHeadingChangeToSouth

	self subclassResponsibility! !

!MarsRoverLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:27:45'!
logHeadingChangeToWest

	self subclassResponsibility! !


!classDefinition: #MarsRoverHistoricalLogger category: 'MarsRover-WithHeading'!
MarsRoverLogger subclass: #MarsRoverHistoricalLogger
	instanceVariableNames: 'log'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHistoricalLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 19:26:17'!
logHeadingChangeToEast
	log add: 'East'! !

!MarsRoverHistoricalLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 19:26:22'!
logHeadingChangeToNorth
	log add: 'North'! !

!MarsRoverHistoricalLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 19:29:02'!
logHeadingChangeToSouth
	log add: 'South'! !

!MarsRoverHistoricalLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 19:26:12'!
logHeadingChangeToWest
	log add: 'West'! !


!MarsRoverHistoricalLogger methodsFor: 'logging' stamp: 'NMS 10/29/2023 20:26:25'!
logHeadingChange: aNewHeading
	aNewHeading logChange: self! !

!MarsRoverHistoricalLogger methodsFor: 'logging' stamp: 'NMS 10/29/2023 19:16:22'!
logPositionChange: aNewPosition
	log add: aNewPosition! !


!MarsRoverHistoricalLogger methodsFor: 'accessing' stamp: 'NMS 10/28/2023 16:53:34'!
log
	^log! !


!MarsRoverHistoricalLogger methodsFor: 'initialization' stamp: 'NMS 10/28/2023 16:57:34'!
initialize
	log := OrderedCollection new! !


!classDefinition: #MarsRoverWindowLogger category: 'MarsRover-WithHeading'!
MarsRoverLogger subclass: #MarsRoverWindowLogger
	instanceVariableNames: 'heading position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindowLogger methodsFor: 'accesing' stamp: 'NMS 10/29/2023 19:58:47'!
heading
	^heading! !

!MarsRoverWindowLogger methodsFor: 'accesing' stamp: 'NMS 10/29/2023 19:58:49'!
position
	^position! !


!MarsRoverWindowLogger methodsFor: 'logging' stamp: 'NMS 10/29/2023 20:06:34'!
logHeadingChange: aNewHeading
	aNewHeading logChange: self! !

!MarsRoverWindowLogger methodsFor: 'logging' stamp: 'NMS 10/29/2023 20:00:06'!
logPositionChange: aNewPosition
	position := aNewPosition! !


!MarsRoverWindowLogger methodsFor: 'initialization' stamp: 'NMS 10/29/2023 19:59:23'!
initialize
	heading := ''.
	position := ''! !


!MarsRoverWindowLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:07:26'!
logHeadingChangeToEast
	heading := 'Apuntando al Este'! !

!MarsRoverWindowLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:10:22'!
logHeadingChangeToNorth
	heading := 'Apuntando al Norte'! !

!MarsRoverWindowLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:09:23'!
logHeadingChangeToSouth
	heading := 'Apuntando al Sur'! !

!MarsRoverWindowLogger methodsFor: 'logging heading - private' stamp: 'NMS 10/29/2023 20:08:27'!
logHeadingChangeToWest
	heading := 'Apuntando al Oeste'! !
