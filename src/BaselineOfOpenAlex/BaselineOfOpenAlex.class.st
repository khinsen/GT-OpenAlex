Class {
	#name : #BaselineOfOpenAlex,
	#superclass : #BaselineOf,
	#category : #BaselineOfOpenAlex
}

{ #category : #accessing }
BaselineOfOpenAlex >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: #'OpenAlex'. ].
]
