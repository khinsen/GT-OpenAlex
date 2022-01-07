Class {
	#name : #OADelayedEntity,
	#superclass : #Object,
	#instVars : [
		'openAlexId',
		'displayName'
	],
	#category : #'OpenAlex-OpenAlex'
}

{ #category : #accessing }
OADelayedEntity >> displayName: aString [
	displayName := aString
]

{ #category : #printing }
OADelayedEntity >> gtDisplayOn: aStream [
	aStream nextPutAll: displayName
]

{ #category : #accessing }
OADelayedEntity >> openAlexId: aString [
	openAlexId := aString
]

{ #category : #printing }
OADelayedEntity >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: displayName.
	aStream nextPut: $)
]

{ #category : #inspecting }
OADelayedEntity >> rawData: aDictionary [
	self displayName: (aDictionary at: 'display_name').
	self openAlexId: (OAId fromUrl: (aDictionary at: 'id'))
]

{ #category : #accessing }
OADelayedEntity >> value [
	^ OAClient new openAlexId:  openAlexId
]
