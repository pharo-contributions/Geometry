"
Description
--------------------

I am a geometric segment. I am defined by two points which are my limits.

As a goemetric segment, I have no direction, so the order of the two points during the creation has no importance.

Examples
--------------------

	GSegment with: 1 , 2 with: 3 , 4.
	
	(GSegment with: 1 , 3 with: 3 , 0) includes: 1 , 3.
	
	(GSegment with: -1 , -1 with: 1 , 1) intersectionsWith: (GSegment with: -3 , 3 with: -1 , 1).
	
	(GSegment with: 0 , 0 with: 3 , 4) length.
	
	(GSegment with: -1 , 2 with: 2 , 1) midPoint.
	
	(GSegment with: -1 , -4 with: 1 , -2) translateBy: #(1 -2) asGVector.
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	v1:		<aGPoint>		One of the two limit of the segment.
	v2:		<aGPoint>		Second limit of the segment. 

"
Class {
	#name : #GSegment,
	#superclass : #G1DElement,
	#instVars : [
		'v1',
		'v2'
	],
	#category : #'Geometry-Elements'
}

{ #category : #'instance creation' }
GSegment class >> with: aPoint1 with: aPoint2 [
	^ self new
		v1: aPoint1;
		v2: aPoint2;
		yourself
]

{ #category : #comparing }
GSegment >> = aSegment [
	self == aSegment ifTrue: [ ^ true ].
	self class = aSegment class ifFalse: [ ^ false ].
	
	^ (v1 =~ aSegment v1 and: [ v2 =~ aSegment v2 ])
		or: [ v1 =~ aSegment v2 and: [ v2 =~ aSegment v1 ] ]
]

{ #category : #arithmetic }
GSegment >> angleWith: aSegment [
	^ self v1 - self v2 angleWith: aSegment v1 - aSegment v2
]

{ #category : #properties }
GSegment >> asGLine [
	^ GLine through: v1 and: v2
]

{ #category : #properties }
GSegment >> distanceTo: aGPoint [

	| vectSegment vectPoint t distance closestPoint|

	"See:https://paulbourke.net/geometry/pointlineplane/
	and: https://gist.github.com/mattdesl/47412d930dcd8cd765c871a65532ffac"

	distance := SmallInteger maxVal.
	
	"Vector from v1 to v2"
	vectSegment := (v2 asPoint) - (v1 asPoint).
	vectSegment isZero ifTrue:[ ^distance ].
	"Vector from v1 to P"
	vectPoint := (aGPoint asPoint) - (v1 asPoint).
	t := (vectSegment dotProduct: vectPoint) / (vectSegment dotProduct: vectSegment).
	"Clamp t to [0, 1] to restrict to the segment"
	t := (t max: 0) min: 1.
	
	"Closest point on segment to P"
	closestPoint := (v1 asPoint) + (vectSegment * t).
	distance := (aGPoint asPoint) distanceTo: closestPoint.
	
	^distance
	
	
	
]

{ #category : #comparing }
GSegment >> hash [
	^ v1 hash bitXor: v2 hash
]

{ #category : #properties }
GSegment >> includes: aGPoint [
	"The point is on the segment if the sum of the distance from v1 to aGPoint and the distance of a GPoint to v2 is my length"

	^ (v2 distanceTo: aGPoint) + (aGPoint distanceTo: v1) =~ self length
]

{ #category : #intersections }
GSegment >> intersectionsWith: anElement [
	^ anElement intersectionsWithSegment: self
]

{ #category : #intersections }
GSegment >> intersectionsWithEllipse: aGEllipse [ 
	^ aGEllipse intersectionsWithSegment: self
]

{ #category : #intersections }
GSegment >> intersectionsWithLine: aLine [
	^ aLine intersectionsWithSegment: self
]

{ #category : #properties }
GSegment >> length [
	"The distance between two points is the length of the vector transposing v1 into v2"

	^ (v2 - v1) length
]

{ #category : #properties }
GSegment >> midPoint [
	^ ((v1 coordinates + v2 coordinates) / 2) asGPoint
]

{ #category : #properties }
GSegment >> perpendicularBisector [
	self flag: #todo.	"This is only for 2D. We should rely on GPoints to be able to do it for n-dimensions."

	^ GLine a: v2 x - v1 x b: v2 y - v1 y c: (v1 x * v1 x - (v2 x * v2 x) + (v1 y * v1 y) - (v2 y * v2 y)) / 2
]

{ #category : #printing }
GSegment >> printOn: aStream [
	v1 coordinates printOn: aStream.
	aStream nextPutAll: '>-<'.
	v2 coordinates printOn: aStream
]

{ #category : #transforming }
GSegment >> translateBy: aGVector [ 
	v1 := v1 + aGVector.
	v2 := v2 + aGVector
]

{ #category : #accessing }
GSegment >> v1 [
	^ v1
]

{ #category : #accessing }
GSegment >> v1: aGPoint [
	v1 := aGPoint asGPoint
]

{ #category : #accessing }
GSegment >> v2 [
	^ v2
]

{ #category : #accessing }
GSegment >> v2: aGPoint [
	v2 := aGPoint asGPoint
]

{ #category : #initialization }
GSegment >> vertices [
	^ { v1 . v2 }
]
