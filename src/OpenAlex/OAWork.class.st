Class {
	#name : #OAWork,
	#superclass : #OAEntity,
	#instVars : [
		'citing'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OAWork >> citing [
	^ citing ifNil: [
		citing := OAClient new
					url: rawData cited_by_api_url;
					getOAEntity.
		citing loadAll.
		citing ]
]

{ #category : #accessing }
OAWork >> date [
	^ rawData at: 'publication_date'
		ifPresent: [ :date | date asDate ]
		ifAbsent: [ rawData at: 'publication_year'
						ifPresent: [ :year |
							 Year year: year asNumber ] ]
]

{ #category : #accessing }
OAWork >> doiUrl [
	^ rawData ids doi ifNotNil: [ :url | url asZnUrl ]
]

{ #category : #accessing }
OAWork >> endpoint [
	^ 'https://api.openalex.org/works/'
]

{ #category : #accessing }
OAWork >> gtCitingFor: aView [
	<gtView>
	self citing isEmpty ifTrue: [ ^ aView empty ].
	^ aView list
		title: 'Citing';
		priority: 5;
		items: [ self citing results ];
		updateWhen: OAMoreResultsEvent in: [ self citing announcer ]
		yourself
]

{ #category : #accessing }
OAWork >> gtConceptsFor: aView [
	<gtView>
	^ rawData at: 'concepts'
		ifPresent: [ :data |
			aView columnedList
				title: 'Concepts';
				priority: 6;
				items: [ data ];
				column: 'Score' text: #score weight: 0.2;
				column: 'Name' text: #display_name weight: 0.8;
				send: [ :each |
					OAClient new openAlexId:
						(OAId fromUrl: each id) ];
				yourself ]
		ifAbsent: [ aView empty ]
]

{ #category : #accessing }
OAWork >> gtReferencedWorksFor: aView [
	<gtView>
	^ rawData at: 'referenced_works'
		ifPresent: [ :data |
			aView list
				title: 'Referenced';
				priority: 4;
				items: [ data collect: [ :each |
					| id |
					id := OAId fromUrl: each.
					(OACache uniqueInstance lookup: id)
						ifNil: [
							OADelayedEntity new
								openAlexId: id;
								displayName: id ]
						ifNotNil: [ :entity | entity ] ] ];
				send: #value;
				yourself ]
		ifAbsent: [ aView empty ]
]

{ #category : #accessing }
OAWork >> gtRelatedWorksFor: aView [
	<gtView>
	^ rawData at: 'related_works'
		ifPresent: [ :data |
			aView list
				title: 'Related';
				priority: 3;
				items: [ data collect: [ :each |
					| id |
					id := OAId fromUrl: each.
					(OACache uniqueInstance lookup: id)
						ifNil: [
							OADelayedEntity new
								openAlexId: id;
								displayName: id ]
						ifNotNil: [ :entity | entity ] ] ];
				send: #value;
				yourself ]
		ifAbsent: [ aView empty ]
]

{ #category : #accessing }
OAWork >> summary [
	| summary authorNumber |
	summary := OrderedCollection new.
	rawData is_retracted ifTrue:
		[ summary add:
			'Status' ->
				('retracted' asRopedText foreground: Color red) ].
	summary add: 'Type' -> rawData type.
	summary add: 'Title' ->
		(rawData at: 'title'
			ifAbsent: [ rawData display_name ]).
	rawData at: 'publication_date'
		ifPresent: [ :date |
			summary add: 'Date' -> date asDate ]
		ifAbsent: [ rawData at: 'publication_year'
						ifPresent: [ :year |
							summary add: 'Year' -> Year year: year asNumber ] ].
	rawData at: 'host_venue'
		ifPresent: [ :venue |
			summary add:
				'Venue' ->
					([ (OADelayedEntity new rawData: venue ) ]
					onErrorDo:  [ venue display_name ]) ].
	rawData at: 'biblio'
		ifPresent: [ :biblio |
			| volumeAndIssue |
			biblio volume ifNotNil: [ :vol |
				volumeAndIssue := vol asString.
				biblio issue ifNotNil: [ :issue |
					volumeAndIssue := volumeAndIssue,
						' (',  issue asString, ')'].
				summary add: 'Volume' -> volumeAndIssue ] ].
	rawData open_access is_oa ifTrue: [
		summary add:
			'Open access' ->
				(rawData open_access oa_status
					ifNil: [ 'yes' ]).
		rawData open_access oa_url
			ifNotNil: [ :url |
				summary add: 'URL' -> url asZnUrl ] ].
	authorNumber := 1.
	rawData authorships do: [ :each |
		summary add:
			'Author ', authorNumber asString ->
				(OADelayedEntity new rawData: each author).
		authorNumber := authorNumber + 1 ].
	^ summary
]

{ #category : #accessing }
OAWork >> year [
	^ self date year
]
