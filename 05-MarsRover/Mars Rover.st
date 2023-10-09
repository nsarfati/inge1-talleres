!classDefinition: #TestsMarsRover category: 'Mars Rover'!
TestCase subclass: #TestsMarsRover
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:02:48'!
test01StaysInPositionIfCommandIsEmpty

	|marsRover initialCardinalPoint|
	
	initialCardinalPoint := North new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: ''.
	
	self assert: (marsRover isAtPosition: 0@0 pointing: initialCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:03:20'!
test02MovesOnePositionForward

	|marsRover initialCardinalPoint|
	
	initialCardinalPoint := North new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'f'.
	
	self assert: (marsRover isAtPosition: 0@1 pointing: initialCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:03:56'!
test03MovesForwardThreePositions

	|marsRover initialCardinalPoint|
	
	initialCardinalPoint := North new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'fff'.
	
	self assert: (marsRover isAtPosition: 0@3 pointing: initialCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:04:29'!
test04MovesOnePositionBackwards

	|marsRover initialCardinalPoint|
	
	initialCardinalPoint := North new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'b'.
	
	self assert: (marsRover isAtPosition: 0@-1 pointing: initialCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:05:10'!
test05RotateLeftWhenPointingNorth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := North new.
	finalCardinalPoint := West new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 0@0 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:05:38'!
test06RotateLeftWhenPointingSouth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := South new.
	finalCardinalPoint := East new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 0@0 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:05:44'!
test07RotateLeftWhenPointingEast

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := East new.
	finalCardinalPoint := North new.
	marsRover := MarsRover at: 1@1 pointing: initialCardinalPoint.
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 1@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:06:15'!
test08RotateLeftWhenPointingWest

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := West new.
	finalCardinalPoint := South new.
	marsRover := MarsRover at: 1@1 pointing: initialCardinalPoint.
	marsRover process: 'l'.
	
	self assert: (marsRover isAtPosition: 1@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:15:57'!
test09RotateRightWhenPointingNorth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := North new.
	finalCardinalPoint := East new.
	marsRover := MarsRover at: 1@1 pointing: initialCardinalPoint.
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 1@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:16:53'!
test10RotateRightWhenPointingSouth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := South new.
	finalCardinalPoint := West new.
	marsRover := MarsRover at: 1@1 pointing: initialCardinalPoint.
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 1@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:17:23'!
test11RotateRightWhenPointingEast

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := East new.
	finalCardinalPoint := South new.
	marsRover := MarsRover at: 1@1 pointing: initialCardinalPoint.
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 1@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:18:03'!
test12RotateRightWhenPointingWest

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := West new.
	finalCardinalPoint := North new.
	marsRover := MarsRover at: 1@1 pointing: initialCardinalPoint.
	marsRover process: 'r'.
	
	self assert: (marsRover isAtPosition: 1@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:23:17'!
test13RotateLeftAndMoveOnePositionForwardWhenPointingNorth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := North new.
	finalCardinalPoint := West new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'lf'.
	
	self assert: (marsRover isAtPosition: -1@0 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:52:06'!
test14RotateRightAndMoveOnePositionForwardWhenPointingNorth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := North new.
	finalCardinalPoint := East new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'rf'.
	
	self assert: (marsRover isAtPosition: 1@0 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:47:04'!
test15RotateRightAndMoveOnePositionForwardWhenPointingEast

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := East new.
	finalCardinalPoint := South new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'rf'.
	
	self assert: (marsRover isAtPosition: 0@-1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:49:06'!
test16RotateLeftAndMoveOnePositionBackwardWhenPointingNorth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := North new.
	finalCardinalPoint := West new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'lb'.
	
	self assert: (marsRover isAtPosition: 1@0 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 21:00:31'!
test17RotateLeftAndMoveOnePositionBackwardWhenPointingEast

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := West new.
	finalCardinalPoint := South new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'lb'.
	
	self assert: (marsRover isAtPosition: 0@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 21:02:34'!
test18RotateRightAndMoveOnePositionBackwardWhenPointingNorth

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := North new.
	finalCardinalPoint := East new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'rb'.
	
	self assert: (marsRover isAtPosition: -1@0 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 21:10:22'!
test19MarsRoverStaysInLastValidPositionWhenThereIsAnInvalidCommand

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := North new.
	finalCardinalPoint := North new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	
	self 
		should: [marsRover process: 'rbfflfxff']
		raise: Error
		withMessageText: MarsRoverCommand invalidCommandErrorDescription.
	
	self assert: (marsRover isAtPosition: 1@1 pointing: finalCardinalPoint)! !

!TestsMarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 21:13:20'!
test20testExtraToCheckGeneralization

	|marsRover initialCardinalPoint finalCardinalPoint|
	
	initialCardinalPoint := South new.
	finalCardinalPoint := East new.
	marsRover := MarsRover at: 0@0 pointing: initialCardinalPoint.
	marsRover process: 'rbfflffflb'.
	
	self assert: (marsRover isAtPosition: -2@-3 pointing: finalCardinalPoint)! !


!classDefinition: #CardinalPoint category: 'Mars Rover'!
Object subclass: #CardinalPoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!CardinalPoint methodsFor: 'rotation' stamp: 'GG 10/8/2023 19:50:44'!
rotateLeft: aMarsRover

	self subclassResponsibility! !

!CardinalPoint methodsFor: 'rotation' stamp: 'GG 10/8/2023 20:12:00'!
rotateRight: aMarsRover

	self subclassResponsibility! !


!CardinalPoint methodsFor: 'moving' stamp: 'GG 10/8/2023 20:49:24'!
moveBackward: aMarsRover

	self subclassResponsibility! !

!CardinalPoint methodsFor: 'moving' stamp: 'GG 10/8/2023 20:36:11'!
moveForward: aMarsRover

	self subclassResponsibility! !


!CardinalPoint methodsFor: 'comparing' stamp: 'GG 10/8/2023 20:01:49'!
equals: aCardinalPoint

	^ aCardinalPoint class = self class! !


!classDefinition: #East category: 'Mars Rover'!
CardinalPoint subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!East methodsFor: 'rotation' stamp: 'GG 10/8/2023 19:51:38'!
rotateLeft: aMarsRover

	aMarsRover pointNorth! !

!East methodsFor: 'rotation' stamp: 'GG 10/8/2023 20:17:38'!
rotateRight: aMarsRover

	aMarsRover pointSouth ! !


!East methodsFor: 'moving' stamp: 'GG 10/8/2023 21:02:23'!
moveBackward: aMarsRover

	aMarsRover moveTowardsWest ! !

!East methodsFor: 'moving' stamp: 'GG 10/8/2023 20:55:39'!
moveForward: aMarsRover

	aMarsRover moveTowardsEast! !


!classDefinition: #North category: 'Mars Rover'!
CardinalPoint subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!North methodsFor: 'rotation' stamp: 'GG 10/8/2023 19:51:31'!
rotateLeft: aMarsRover

	aMarsRover pointWest! !

!North methodsFor: 'rotation' stamp: 'GG 10/8/2023 20:12:27'!
rotateRight: aMarsRover

	aMarsRover pointEast! !


!North methodsFor: 'moving' stamp: 'GG 10/8/2023 20:59:02'!
moveBackward: aMarsRover

	aMarsRover moveTowardsSouth ! !

!North methodsFor: 'moving' stamp: 'GG 10/8/2023 20:56:22'!
moveForward: aMarsRover

	aMarsRover moveTowardsNorth! !


!classDefinition: #South category: 'Mars Rover'!
CardinalPoint subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!South methodsFor: 'rotation' stamp: 'GG 10/8/2023 19:51:49'!
rotateLeft: aMarsRover

	aMarsRover pointEast! !

!South methodsFor: 'rotation' stamp: 'GG 10/8/2023 20:15:02'!
rotateRight: aMarsRover

	aMarsRover pointWest ! !


!South methodsFor: 'moving' stamp: 'GG 10/8/2023 21:00:47'!
moveBackward: aMarsRover

	aMarsRover moveTowardsNorth ! !

!South methodsFor: 'moving' stamp: 'GG 10/8/2023 20:56:06'!
moveForward: aMarsRover

	aMarsRover moveTowardsSouth! !


!classDefinition: #West category: 'Mars Rover'!
CardinalPoint subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!West methodsFor: 'rotation' stamp: 'GG 10/8/2023 19:52:01'!
rotateLeft: aMarsRover

	aMarsRover pointSouth! !

!West methodsFor: 'rotation' stamp: 'GG 10/8/2023 20:19:04'!
rotateRight: aMarsRover

	aMarsRover pointNorth ! !


!West methodsFor: 'moving' stamp: 'GG 10/8/2023 20:55:39'!
moveBackward: aMarsRover

	aMarsRover moveTowardsEast ! !

!West methodsFor: 'moving' stamp: 'GG 10/8/2023 20:55:52'!
moveForward: aMarsRover

	aMarsRover moveTowardsWest! !


!classDefinition: #MarsRover category: 'Mars Rover'!
Object subclass: #MarsRover
	instanceVariableNames: 'position cardinalPoint'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!MarsRover methodsFor: 'initialization' stamp: 'GG 10/8/2023 18:39:30'!
initializeAt: aStartingPosition pointing: aCardinalPoint 

	position := aStartingPosition.
	cardinalPoint := aCardinalPoint.! !


!MarsRover methodsFor: 'process' stamp: 'GG 10/8/2023 19:36:04'!
process: aSetOfCommands

	aSetOfCommands do: [:command | (MarsRoverCommand with: command) processCommandFrom: self]
! !


!MarsRover methodsFor: 'process - private' stamp: 'GG 10/8/2023 20:58:32'!
moveBackward

	cardinalPoint moveBackward: self! !

!MarsRover methodsFor: 'process - private' stamp: 'GG 10/8/2023 20:58:24'!
moveForward

	cardinalPoint moveForward: self
! !

!MarsRover methodsFor: 'process - private' stamp: 'GG 10/8/2023 20:11:31'!
rotateLeft

	cardinalPoint rotateLeft: self ! !

!MarsRover methodsFor: 'process - private' stamp: 'GG 10/8/2023 20:11:41'!
rotateRight

	cardinalPoint rotateRight: self ! !


!MarsRover methodsFor: 'testing' stamp: 'GG 10/8/2023 20:02:26'!
isAtPosition: aPosition pointing: aCardinalPoint

	^ position = aPosition and: [cardinalPoint equals: aCardinalPoint].! !


!MarsRover methodsFor: 'moving - private' stamp: 'GG 10/8/2023 20:55:39'!
moveTowardsEast
	
	position := position + (1@0)! !

!MarsRover methodsFor: 'moving - private' stamp: 'GG 10/8/2023 20:56:22'!
moveTowardsNorth
	
	position := position + (0@1)! !

!MarsRover methodsFor: 'moving - private' stamp: 'GG 10/8/2023 20:56:06'!
moveTowardsSouth
	
	position := position + (0@-1)! !

!MarsRover methodsFor: 'moving - private' stamp: 'GG 10/8/2023 20:55:52'!
moveTowardsWest
	
	position := position + (-1@0)! !


!MarsRover methodsFor: 'rotation - private' stamp: 'GG 10/8/2023 19:53:07'!
pointEast

	cardinalPoint := East new! !

!MarsRover methodsFor: 'rotation - private' stamp: 'GG 10/8/2023 19:52:38'!
pointNorth

	cardinalPoint := North new! !

!MarsRover methodsFor: 'rotation - private' stamp: 'GG 10/8/2023 19:52:57'!
pointSouth

	cardinalPoint := South new! !

!MarsRover methodsFor: 'rotation - private' stamp: 'GG 10/8/2023 19:53:14'!
pointWest

	cardinalPoint := West new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'Mars Rover'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'GG 10/8/2023 18:30:16'!
at: aStartingPosition pointing: aCardinalPoint

	^self new initializeAt: aStartingPosition pointing: aCardinalPoint ! !


!classDefinition: #MarsRoverCommand category: 'Mars Rover'!
Object subclass: #MarsRoverCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!MarsRoverCommand methodsFor: 'command' stamp: 'GG 10/8/2023 19:31:02'!
processCommandFrom: aMarsRover

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverCommand class' category: 'Mars Rover'!
MarsRoverCommand class
	instanceVariableNames: ''!

!MarsRoverCommand class methodsFor: 'error messages' stamp: 'GG 10/8/2023 21:06:52'!
invalidCommandErrorDescription

	^ 'The command is not valid!!'! !


!MarsRoverCommand class methodsFor: 'instance creation' stamp: 'GG 10/8/2023 21:05:57'!
with: aCommand 

	aCommand = $f ifTrue: [^Forward new].
	aCommand = $b ifTrue: [^Backward new].
	aCommand = $l ifTrue: [^LeftRotation new].
	aCommand = $r ifTrue: [^RightRotation new].
	^ self error: self invalidCommandErrorDescription! !


!classDefinition: #Backward category: 'Mars Rover'!
MarsRoverCommand subclass: #Backward
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!Backward methodsFor: 'command' stamp: 'GG 10/8/2023 19:32:43'!
processCommandFrom: aMarsRover

	aMarsRover moveBackward! !


!classDefinition: #Forward category: 'Mars Rover'!
MarsRoverCommand subclass: #Forward
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!Forward methodsFor: 'command' stamp: 'GG 10/8/2023 19:32:36'!
processCommandFrom: aMarsRover

	aMarsRover moveForward! !


!classDefinition: #LeftRotation category: 'Mars Rover'!
MarsRoverCommand subclass: #LeftRotation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!LeftRotation methodsFor: 'command' stamp: 'GG 10/8/2023 19:32:27'!
processCommandFrom: aMarsRover

	aMarsRover rotateLeft! !


!classDefinition: #RightRotation category: 'Mars Rover'!
MarsRoverCommand subclass: #RightRotation
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!RightRotation methodsFor: 'command' stamp: 'GG 10/8/2023 20:11:08'!
processCommandFrom: aMarsRover

	aMarsRover rotateRight! !
