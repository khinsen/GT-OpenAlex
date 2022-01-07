Class {
	#name : #OAWork,
	#superclass : #OAEntity,
	#category : #OpenAlex
}

{ #category : #accessing }
OAWork >> summary [
	| summary |
	summary := OrderedCollection new.
	(rawData at: 'is_retracted') ifTrue:
		[ summary add:
			'Status' ->
				('retracted' asRopedText foreground: Color red) ].
	summary add: 'Type' -> (rawData at: 'type').
	summary add: 'Title' ->(rawData at: 'display_name').
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
					(OADelayedEntity new rawData: venue ) ].
	^ summary
]
