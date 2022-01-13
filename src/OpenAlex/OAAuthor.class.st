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
	| view |
	self works isEmpty ifTrue: [ ^ aView empty ].
	view := aView list
		title: 'Works';
		priority: 2;
		items: [ self works results ];
		updateWhen: OAMoreResultsEvent in: [ self works announcer ]
		yourself.
	self works isComplete ifFalse: [
		view
			actionButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'More'
			action: [ self works loadMore ].
		 view
			actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'All'
			action: [ self works loadAll ] ].
	^ view
]

{ #category : #accessing }
OAAuthor >> works [
	^ works ifNil: [
		works := OAClient new
					url: rawData works_api_url;
					getOAEntity ]
]
