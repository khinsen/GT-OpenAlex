Class {
	#name : #OAEntity,
	#superclass : #Object,
	#instVars : [
		'rawData'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OAEntity class >> entityClassesByLetter [
	^ Dictionary
		with: $A -> OAAuthor
		with: $C -> OAConcept
		with: $I -> OAInstitution
		with: $V -> OAVenue
		with: $W -> OAWork
]

{ #category : #accessing }
OAEntity class >> forId: aString [
	^ self entityClassesByLetter at: aString first
]

{ #category : #accessing }
OAEntity >> gtActionWikiDataFor: anAction [
	<gtAction>
	|  url |
	url := rawData at: 'wikidata'
			ifAbsent: [ ^ anAction noAction ].
	^ anAction explicit stencil: [
		BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			action:  [ WebBrowser openOn: url ];
			icon: OAClient new wikiDataIcon asElement;
			label: 'Wikidata' translated ]
]

{ #category : #inspecting }
OAEntity >> gtConceptsFor: aView [
	<gtView>
	| concepts |
	concepts := rawData at: 'x_concepts'
		ifAbsent: [ ^ aView empty ].
	^ aView list
		title: 'Concepts';
		priority: 4;
		items: [ concepts collect: [ :each |
			OADelayedEntity new
				rawData: each ] ];
		send: #value;
		yourself
]

{ #category : #inspecting }
OAEntity >> gtIdsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'IDs';
		priority: 7;
		items: [ self ids associations ];
		column: 'Name' text: #key;
		column: 'ID' text: #value;
		send: [ :each |
			(each value isString
				and: [ each value beginsWith: 'http' ])
				ifTrue: [ each value asUrl ]
				ifFalse: [ each value ] ];
		yourself
]

{ #category : #inspecting }
OAEntity >> gtJsonDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ rawData ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
OAEntity >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 0;
		items: [ self summary ];
		column: 'Field' text: #key;
		column: 'Value' text: #value;
		send: [ :each | each value value ];
		yourself
]

{ #category : #inspecting }
OAEntity >> ids [
	^ rawData at: 'ids'
]

{ #category : #accessing }
OAEntity >> openAlexId [
	^ OAId fromUrl: (rawData at: #id)
]

{ #category : #printing }
OAEntity >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self openAlexId.
	aStream nextPutAll: ', '.
	aStream nextPutAll: (rawData at: 'display_name').
	aStream nextPut: $)
]

{ #category : #accessing }
OAEntity >> rawData [
	^ rawData
]

{ #category : #accessing }
OAEntity >> rawData: aDictionary [
	rawData := aDictionary
]

{ #category : #accessing }
OAEntity >> summary [
	^ #()
]
