Class {
	#name : #OAConcept,
	#superclass : #OAEntity,
	#category : #OpenAlex
}

{ #category : #accessing }
OAConcept >> endpoint [
	^ 'https://api.openalex.org/concepts/'
]

{ #category : #accessing }
OAConcept >> gtRelatedConceptsFor: aView [
	<gtView>
	^ rawData at: 'related_concepts'
		ifPresent: [ :data |
			aView columnedList
				title: 'Related';
				priority: 3;
				items: [ data ];
				column: 'Score' text: #score weight: 0.2;
				column: 'Name' text: #display_name weight: 0.8;
				send: [ :each |
					OADelayedEntity new rawData: each ];
				yourself ]
		ifAbsent: [ aView empty ]
]
