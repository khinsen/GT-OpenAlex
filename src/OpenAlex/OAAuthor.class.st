Class {
	#name : #OAAuthor,
	#superclass : #OAEntity,
	#instVars : [
		'works'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OAAuthor >> gtWorksFor: aView [
	<gtView>
	self works isEmpty ifTrue: [ ^ aView empty ].
	^ aView list
		title: 'Works';
		priority: 2;
		items: [ self works results ];
		updateWhen: OAMoreResultsEvent in: [ self works announcer ]
		yourself
]

{ #category : #accessing }
OAAuthor >> works [
	^ works ifNil: [
		works := OAClient new
					url: rawData works_api_url;
					getOAEntity.
		works loadAll.
		works ]
]
