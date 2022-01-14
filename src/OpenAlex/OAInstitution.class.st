Class {
	#name : #OAInstitution,
	#superclass : #OAEntity,
	#instVars : [
		'works'
	],
	#category : #OpenAlex
}

{ #category : #inspecting }
OAInstitution >> gtWorksFor: aView [
	<gtView>
	| view |
	self works isEmpty ifTrue: [ ^ aView empty ].
	view := aView columnedList
		title: 'Works';
		priority: 2;
		items: [ self works results ];
		column: 'Year' text: #year width: 50;
		column: 'Name' text: #displayName;
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
OAInstitution >> summary [
	| summary |
	summary := OrderedCollection new.
	summary add: 'Name' -> rawData display_name.
	rawData display_name_alternatives ifNotNil: [ :alt |
		alt do: [ :each |
			summary add: 'Other name' -> each ] ].
	^ summary.
]

{ #category : #accessing }
OAInstitution >> works [
	^ works ifNil: [
		works := OAClient new
					url: rawData works_api_url;
					getOAEntity ]
]
