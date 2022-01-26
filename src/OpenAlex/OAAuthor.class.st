Class {
	#name : #OAAuthor,
	#superclass : #OAEntity,
	#instVars : [
		'works'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OAAuthor >> endpoint [
	^ 'https://api.openalex.org/authors/'
]

{ #category : #inspecting }
OAAuthor >> gtWorksFor: aView [
	<gtView>
	self works isEmpty ifTrue: [ ^ aView empty ].
	^ aView columnedList
		title: 'Works';
		priority: 2;
		items: [ self works results ];
		column: 'Year' text: #year width: 50;
		column: 'Name' text: #displayName;
		yourself
]

{ #category : #accessing }
OAAuthor >> summary [
	| summary |
	summary := OrderedCollection new.
	summary add: 'Name' -> rawData display_name.
	rawData last_known_institution ifNotNil: [ :institution |
		summary add: 'Institution' -> 
			([ (OADelayedEntity new rawData: institution ) ]
				onErrorDo:  [ institution display_name ])].
	^ summary.
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
