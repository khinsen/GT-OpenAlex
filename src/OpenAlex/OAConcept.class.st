Class {
	#name : #OAConcept,
	#superclass : #OAEntity,
	#category : #OpenAlex
}

{ #category : #accessing }
OAConcept >> gtRelatedConceptsFor: aView [
	<gtView>
	^ rawData at: 'related_concepts'
		ifPresent: [ :data |
			aView list
				title: 'Related';
				priority: 3;
				items: [ data collect: [ :each |
					OADelayedEntity new rawData: each ] ];
				yourself ]
		ifAbsent: [ aView empty ]
]
