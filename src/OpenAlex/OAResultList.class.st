Class {
	#name : #OAResultList,
	#superclass : #Object,
	#instVars : [
		'results',
		'rawData'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OAResultList >> count [
	^ rawData meta count
]

{ #category : #inspecting }
OAResultList >> gtJsonDataFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON Data';
		priority: 10;
		object: [ rawData ];
		view: #gtTreeFor:;
		yourself
]

{ #category : #inspecting }
OAResultList >> gtResultsFor: aView [
	<gtView>
	self results ifEmpty: [ ^ aView empty ].
	^ aView forward
		title: 'Results';
		priority: 0;
		object: [ self results ];
		view: #gtItemsFor:;
		yourself
]

{ #category : #printing }
OAResultList >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self results size printOn: aStream.
	aStream nextPutAll: ' / '.
	rawData meta count printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
OAResultList >> rawData: aDictionary [
	rawData := aDictionary
]

{ #category : #accessing }
OAResultList >> results [
	^ results ifNil: [
		results := rawData results collect: [ :each |
			| entity |
			entity := (OAEntity forId: (OAId fromUrl: each id)) new
				rawData: each.
			OACache uniqueInstance add: entity.
			entity ] ]
]
