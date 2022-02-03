Class {
	#name : #OAConcept,
	#superclass : #OAEntity,
	#instVars : [
		'works'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OAConcept >> endpoint [
	^ 'https://api.openalex.org/concepts/'
]

{ #category : #inspecting }
OAConcept >> gtAncestorsFor: aView [
	<gtView>
	^ rawData at: 'ancestors'
		ifPresent: [ :data |
			aView columnedList
				title: 'Ancestors';
				priority: 4;
				items: [ data ];
				column: 'Level' text: #level weight: 1;
				column: 'Name' text: #display_name weight: 5;
				send: [ :each |
					OAClient new
						openAlexId:(OAId fromUrl: each id) ];
				yourself ]
		ifAbsent: [ aView empty ]
]

{ #category : #inspecting }
OAConcept >> gtRelatedConceptsFor: aView [
	<gtView>
	^ rawData at: 'related_concepts'
		ifPresent: [ :data |
			aView columnedList
				title: 'Related';
				priority: 3;
				items: [ data ];
				column: 'Level' text: #level weight: 1;
				column: 'Score' text: #score weight: 2;
				column: 'Name' text: #display_name weight: 5;
				send: [ :each |
					OAClient new
						openAlexId:(OAId fromUrl: each id) ];
				yourself ]
		ifAbsent: [ aView empty ]
]

{ #category : #inspecting }
OAConcept >> gtWorksFor: aView [
	<gtView>
	self works isEmpty ifTrue: [ ^ aView empty ].
	^ aView list
		title: 'Works';
		priority: 5;
		items: [ self works results ];
		updateWhen: OAMoreResultsEvent in: [ self works announcer ]
		yourself
]

{ #category : #accessing }
OAConcept >> summary [
	| summary |
	summary := OrderedCollection new.
	summary add: 'Name' -> rawData display_name.
	summary add: 'Level' -> rawData level.
	summary add: 'Description' -> rawData description.
	summary add: 'Number of works' -> rawData works_count.
	^ summary.
]

{ #category : #accessing }
OAConcept >> works [
	^ works ifNil: [
		works := OAClient new
					url: rawData works_api_url;
					getOAEntity ]
]
