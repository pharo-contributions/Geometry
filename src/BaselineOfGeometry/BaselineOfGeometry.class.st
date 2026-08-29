"
A baseline for Geometrypackage
"
Class {
	#name : #BaselineOfGeometry,
	#superclass : #BaselineOf,
	#category : #BaselineOfGeometry
}

{ #category : #baseline }
BaselineOfGeometry >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Packages"
			spec
				package: 'Geometry';
				package: 'Geometry-Tests' with: [ spec requires: #('Geometry') ].
				
			"Groups"
			spec
				group: 'Core' with: 'Geometry';
				group: 'Tests' with: #('Geometry-Tests') ]
]
