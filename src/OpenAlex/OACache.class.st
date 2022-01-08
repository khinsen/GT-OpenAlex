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
	^ aView columnedList
		title: 'Authors';
		priority: 1;
		items: [ entitiesByClass at: OAAuthor ];
		column: 'Id' text: #openAlexId;
		column: 'Name' text: #displayName;
		yourself
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
