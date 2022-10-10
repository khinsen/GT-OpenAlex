Class {
	#name : #OAEntity,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'originUrl'
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
OAEntity >> displayName [
	^ rawData display_name
]

{ #category : #accessing }
OAEntity >> endpoint [
	self subclassResponsibility
]

{ #category : #inspecting }
OAEntity >> gtActionHomePageFor: anAction [
	<gtAction>
	|  url |
	url := rawData homepage_url
			ifNil: [ ^ anAction noAction ].
	^ anAction explicit stencil: [
		BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			action:  [ WebBrowser openOn: url ];
			icon:BrGlamorousIcons go asElement;
			label: 'Open home page' translated ]
]

{ #category : #inspecting }
OAEntity >> gtActionRefreshFor: anAction [
	<gtAction>
	^ anAction explicit stencil: [
		BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude;
			action:  [
				| json |
				json := OAClient new
					url: self originUrl;
					get.
				self rawData: json ];
			icon: BrGlamorousVectorIcons refresh asElement;
			label: 'Refresh' translated ]
]

{ #category : #inspecting }
OAEntity >> gtActionWikiDataFor: anAction [
	<gtAction>
	|  url |
	url := rawData at: 'wikidata'
			ifAbsent: [ rawData ids wikidata
						ifNil: [ ^ anAction noAction ] ].
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
	^ aView columnedList
		title: 'Concepts';
		priority: 4;
		items: [ concepts ];
		column: 'Score' text: #score weight:0.2;
		column: 'Name' text: #'display_name' weight: 0.8;
		send: [ :each |
			OAClient new openAlexId:
				(OAId fromUrl: each id) ];
		yourself
]

{ #category : #printing }
OAEntity >> gtDisplayOn: aStream [
	aStream nextPutAll: (rawData display_name)
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
		column: 'Field' text: #key weight: 0.2;
		column: 'Value' text: #value weight: 0.8;
		send: [ :each | each value value ];
		yourself
]

{ #category : #inspecting }
OAEntity >> ids [
	^ rawData ids
]

{ #category : #accessing }
OAEntity >> openAlexId [
	^ OAId fromUrl: rawData id
]

{ #category : #accessing }
OAEntity >> originUrl [
	^ originUrl ifNil: [
		| id |
		id := OAId fromUrl: rawData id.
		self endpoint, id ]
]

{ #category : #accessing }
OAEntity >> originUrl: aZnUrl [
	originUrl := aZnUrl
]

{ #category : #printing }
OAEntity >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self openAlexId.
	aStream nextPutAll: ', '.
	rawData display_name ifNotNil: [ :s |
		aStream nextPutAll: s ].
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

{ #category : #accessing }
OAEntity >> value [
	^ self
]
