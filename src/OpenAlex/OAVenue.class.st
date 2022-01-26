Class {
	#name : #OAVenue,
	#superclass : #OAEntity,
	#category : #OpenAlex
}

{ #category : #accessing }
OAVenue >> endpoint [
	^ 'https://api.openalex.org/venues/'
]
