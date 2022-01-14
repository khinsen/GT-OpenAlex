Class {
	#name : #OASearchResults,
	#superclass : #Object,
	#instVars : [
		'results',
		'rawData',
		'originUrl',
		'announcer'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OASearchResults >> addResults: aCollection [
	aCollection do: [ :each |
		| entity |
		entity := (OAEntity forId: (OAId fromUrl: each id)) new
			rawData: each.
		OACache uniqueInstance add: entity.
		results add: entity ]
]

{ #category : #announcer }
OASearchResults >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #inspecting }
OASearchResults >> containsWorks [
	self isEmpty ifTrue: [ ^ false ].
	^ self results first isKindOf: OAWork.
]

{ #category : #accessing }
OASearchResults >> count [
	^ rawData meta count
]

{ #category : #accessing }
OASearchResults >> currentPage [
	^ rawData
		ifNil: [ 0 ]
		ifNotNil: [ rawData meta page ]
]

{ #category : #inspecting }
OASearchResults >> gtJsonDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ rawData ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
OASearchResults >> gtResultsFor: aView [
	<gtView>
	| view |
	self results isEmpty ifTrue: [ ^ aView empty ].
	view := self containsWorks
		ifTrue: [ aView columnedList
					column: 'Year' text: #year width: 50;
					column: 'Name' text: #displayName ]
		ifFalse: [ aView list ].
	view
		title: 'Results';
		priority: 0;
		items: [ self results ];
		updateWhen: OAMoreResultsEvent in: [ self announcer ]
		yourself.
	self isComplete ifFalse: [
		view
			actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'More'
			action: [ self loadMore ].
		 view
			actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'All'
			action: [ self loadAll ] ].
	^ view
]

{ #category : #initializing }
OASearchResults >> initialize [
	results := OrderedCollection new
]

{ #category : #inspecting }
OASearchResults >> isComplete [
	^ self size = self totalSize
]

{ #category : #testing }
OASearchResults >> isEmpty [
	^ self size = 0
]

{ #category : #inspecting }
OASearchResults >> loadAll [
	[ self isComplete ] whileFalse: [ self loadMore ]
]

{ #category : #inspecting }
OASearchResults >> loadMore [
	| data |
	self size = self totalSize ifTrue: [ ^ nil ].
	data := OAClient new
				url: originUrl;
				queryAt: #page put: self currentPage + 1;
				get.
	self rawData: data.
	self announcer announce: OAMoreResultsEvent new
]

{ #category : #accessing }
OASearchResults >> originUrl [
	^ originUrl
]

{ #category : #accessing }
OASearchResults >> originUrl: aZnUrl [
	originUrl := aZnUrl
]

{ #category : #printing }
OASearchResults >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self size printOn: aStream.
	aStream nextPutAll: ' / '.
	self totalSize printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
OASearchResults >> rawData: aDictionary [
	| page |
	page := self currentPage.
	rawData := aDictionary.
	self assert: self currentPage equals: page + 1.
	self addResults: rawData results
]

{ #category : #accessing }
OASearchResults >> results [
	^ results
]

{ #category : #accessing }
OASearchResults >> size [
	^ results size
]

{ #category : #accessing }
OASearchResults >> totalSize [
	^ rawData meta count
]
