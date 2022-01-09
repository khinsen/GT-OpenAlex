Class {
	#name : #OAWork,
	#superclass : #OAEntity,
	#category : #OpenAlex
}

{ #category : #accessing }
OAWork >> gtConceptsFor: aView [
	<gtView>
	^ rawData at: 'concepts'
		ifPresent: [ :data |
			aView columnedList
				title: 'Concepts';
				priority: 4;
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
	| summary |
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
		ifPresent: [ :venue | [
			summary add:
				'Venue' ->
					(OADelayedEntity new rawData: venue )
			] onErrorDo:  [] ].
	rawData open_access is_oa ifTrue: [
		summary add:
			'Open access' ->rawData open_access oa_status.
		rawData open_access oa_url
			ifNotNil: [ :url |
				summary add: 'URL' -> url asZnUrl ] ].
	^ summary
]
