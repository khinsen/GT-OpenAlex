Class {
	#name : #OACache,
	#superclass : #Object,
	#instVars : [
		'entitiesById',
		'entitiesByClass'
	],
	#classVars : [
		'uniqueInstance'
	],
	#category : #'OpenAlex-OpenAlex'
}

{ #category : #accessing }
OACache class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #adding }
OACache >> add: anEntity [
	| id type |
	id := anEntity openAlexId.
	entitiesById at: id put: anEntity.
	entitiesByClass at: anEntity class
		ifPresent: [ :list | list add: anEntity ]
		ifAbsentPut: [ OrderedCollection with: anEntity ]
]

{ #category : #inspecting }
OACache >> gtAuthorsFor: aView [
	<gtView>
	^ self
		gtEntityListFor: aView
		class: OAAuthor
		title: 'Authors'
		priority: 1
]

{ #category : #inspecting }
OACache >> gtConceptsFor: aView [
	<gtView>
	^ self
		gtEntityListFor: aView
		class: OAConcept
		title: 'Concepts'
		priority: 2
]

{ #category : #accessing }
OACache >> gtEntityListFor: aView class: aClass title: aString priority: anInteger [
	| items |
	items := entitiesByClass at: aClass ifAbsent: [ ^ aView empty ].
	items ifEmpty: [ ^ aView empty ].
	^ aView columnedList
		items: items;
		title: aString;
		priority: anInteger;
		column: 'Id' text: #openAlexId width: 100;
		column: 'Name' text: #gtDisplayString;
		yourself
]

{ #category : #inspecting }
OACache >> gtInstitutionsFor: aView [
	<gtView>
	^ self
		gtEntityListFor: aView
		class: OAInstitution
		title: 'Institutions'
		priority: 3
]

{ #category : #inspecting }
OACache >> gtVenuesFor: aView [
	<gtView>
	^ self
		gtEntityListFor: aView
		class: OAVenue
		title: 'Venues'
		priority: 4
]

{ #category : #inspecting }
OACache >> gtWorksFor: aView [
	<gtView>
	^ self
		gtEntityListFor: aView
		class: OAWork
		title: 'Works'
		priority: 5
]

{ #category : #intializing }
OACache >> initialize [
	entitiesById := Dictionary new.
	entitiesByClass := Dictionary new.
]

{ #category : #lookup }
OACache >> lookup: anOAId [
	^ entitiesById at: anOAId ifAbsent: [ nil ]
]
