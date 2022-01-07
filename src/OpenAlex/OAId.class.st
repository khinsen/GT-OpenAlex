Class {
	#name : #OAId,
	#superclass : #String,
	#category : #'OpenAlex-OpenAlex'
}

{ #category : #accessing }
OAId class >> fromUrl: aString [
	^ ($/ split: aString) last
]
