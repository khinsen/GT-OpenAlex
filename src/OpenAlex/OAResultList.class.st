Class {
	#name : #OAResultList,
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
OAResultList >> addResults: aCollection [
	aCollection do: [ :each |
		| entity |
		entity := (OAEntity forId: (OAId fromUrl: each id)) new
			rawData: each.
		OACache uniqueInstance add: entity.
		results add: entity ]
]

{ #category : #announcer }
OAResultList >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
OAResultList >> count [
	^ rawData meta count
]

{ #category : #accessing }
OAResultList >> currentPage [
	^ rawData
		ifNil: [ 0 ]
		ifNotNil: [ rawData meta page ]
]

{ #category : #inspecting }
OAResultList >> gtJsonDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ rawData ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
OAResultList >> gtResultsFor: aView [
	<gtView>
	| view |
	self results ifEmpty: [ ^ aView empty ].
	view := aView list
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
OAResultList >> initialize [
	results := OrderedCollection new
]

{ #category : #inspecting }
OAResultList >> isComplete [
	^ self size = self totalSize
]

{ #category : #inspecting }
OAResultList >> loadAll [
	[ self isComplete ] whileFalse: [ self loadMore ]
]

{ #category : #inspecting }
OAResultList >> loadMore [
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
OAResultList >> originUrl [
	^ originUrl
]

{ #category : #accessing }
OAResultList >> originUrl: aZnUrl [
	originUrl := aZnUrl
]

{ #category : #printing }
OAResultList >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self size printOn: aStream.
	aStream nextPutAll: ' / '.
	self totalSize printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
OAResultList >> rawData: aDictionary [
	| page |
	page := self currentPage.
	rawData := aDictionary.
	self assert: self currentPage equals: page + 1.
	self addResults: rawData results
]

{ #category : #accessing }
OAResultList >> results [
	^ results
]

{ #category : #accessing }
OAResultList >> size [
	^ results size
]

{ #category : #accessing }
OAResultList >> totalSize [
	^ rawData meta count
]
