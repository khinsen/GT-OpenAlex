Class {
	#name : #OAClient,
	#superclass : #ZnClient,
	#instVars : [
		'oaIcon',
		'wikiDataIcon',
		'mail'
	],
	#classInstVars : [
		'defaultMail'
	],
	#category : #OpenAlex
}

{ #category : #accessing }
OAClient class >> mail [
	^ defaultMail
]

{ #category : #accessing }
OAClient class >> mail: aString [
	defaultMail := aString
]

{ #category : #accessing }
OAClient >> author: aString [
	self url: self oaBaseUrl, 'authors/', aString.
	^ self getOAEntity
]

{ #category : #accessing }
OAClient >> concept: aString [
	self url: self oaBaseUrl, 'concepts/', aString.
	^ self getOAEntity
]

{ #category : #accessing }
OAClient >> doi: aString [
	^ self work: 'doi:', aString
]

{ #category : #accessing }
OAClient >> get [
	self mail ifNotNil: [
		| headers |
		headers := self request headers.
		headers at: 'User-Agent' put:
			(headers at: 'User-Agent'), ' mailto:', self mail ].
	^ super get
]

{ #category : #accessing }
OAClient >> getOAEntity [
	| json |
	json := self get.
	(json includesKey: 'meta') ifTrue: [
		^ OASearchResults new
			rawData: json;
			originUrl: self request url ].
	(json includesKey: 'id') ifTrue: [
		| entity |
		entity := (OAEntity forId: (OAId fromUrl: json id)) new
					rawData: json;
					originUrl: self request url.
		OACache uniqueInstance add: entity.
		^ entity ].
	^ json
]

{ #category : #accessing }
OAClient >> initialize [
	super initialize.
	self contentReader: [ :entity |
		self response isError ifTrue: [
			self error: (String streamContents: [ :out |
				self response statusLine writeOn: out ]) ].
		NeoJSONObject fromString: entity contents ]
]

{ #category : #accessing }
OAClient >> institution: aString [
	self url: self oaBaseUrl, 'institutions/', aString.
	^ self getOAEntity
]

{ #category : #accessing }
OAClient >> issn: aString [
	^ self venue: 'issn:', aString
]

{ #category : #accessing }
OAClient >> mail [
	mail ifNotNil: [ :aString | ^ aString ].
	self class mail ifNotNil: [ :aString | ^ aString ].
	^ nil
]

{ #category : #accessing }
OAClient >> mail: aString [
	mail := aString
]

{ #category : #accessing }
OAClient >> oaBaseUrl [
	^ 'https://api.openalex.org/'
]

{ #category : #accessing }
OAClient >> oaIcon [
^ oaIcon ifNil: [ oaIcon := (Form
	extent: (16@16)
	depth: 32
	fromArray: #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1056964608 2305847408 50331648 0 0 0 0 0 0 0 0 0 0 0 805306368 3209382731 4293519849 4294967295 4290295992 1997936150 0 0 0 0 0 0 0 0 0 2436841279 4290756543 4294967295 4291743438 4287927444 4293059298 4294967295 3548348287 1056964608 0 0 0 0 0 0 4101667450 4290756543 4291217094 4288782753 4288387995 4286282619 4291677645 4290427578 4294967295 4288059030 1712986650 0 0 0 0 0 4068441983 4293980400 4288453788 4287006342 3173591337 1711276032 4203909778 4293454056 4291611852 4288453788 1696209434 0 0 0 0 0 1141179653 3682302843 3259648586 1056964608 0 0 251658240 4293914607 4291414473 4288453788 1696209434 0 0 0 0 0 0 0 0 0 2621390655 4034887551 1493172224 4293914607 4291414473 4288453788 1696209434 0 0 0 0 0 0 0 1879969294 4289901234 4294967295 4294967295 4293980400 4293454056 4291414473 4288453788 1696209434 0 0 0 0 0 1056964608 3414130559 4294967295 4293914607 4288848546 4282992969 4292072403 4293454056 4291414473 4288453788 1696209434 0 0 0 0 0 4064691782 4291217094 4294967295 4294967295 4289374890 4285295724 4292269782 4291875024 4287532686 4288453788 1696209434 0 0 0 0 0 4085219199 4293454056 4292335575 4292598747 4294967295 4294967295 4294835709 4287861651 4288585374 4288453788 1696209434 0 0 0 0 0 1056964608 3278860143 4293651435 4293454056 4290295992 4289901234 4285887861 4288453788 4286019447 2132482843 0 0 0 0 0 0 0 0 1610744322 4237266831 4293454056 4284637794 4287401100 3190302760 452984832 0 0 0 0 0 0 0 0 0 0 0 2218145334 3543348019 1056964608 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	offset: (0@0)) ]
]

{ #category : #accessing }
OAClient >> oaLogo [
	^ (ZnEasy getPng:'https://openalex.org/img/OpenAlex-logo-5.2de7053c.png')
		contentsOfArea: (56@36 corner: 184@164)
]

{ #category : #accessing }
OAClient >> openAlexId: aString [
	| entity |
	entity := OACache uniqueInstance lookup: aString.
	entity ifNil: [
		entity := (OAEntity forId: aString) new rawData:
			(self
				url: (self oaBaseUrl, aString);
				get).
	OACache uniqueInstance add: entity ].
	^ entity
]

{ #category : #accessing }
OAClient >> orcid: aString [
	^ self author: 'orcid:', aString
]

{ #category : #accessing }
OAClient >> ror: aString [
	^ self institution: 'ror:', aString
]

{ #category : #accessing }
OAClient >> venue: aString [
	self url: self oaBaseUrl, 'venues/', aString.
	^ self getOAEntity
]

{ #category : #accessing }
OAClient >> wikiDataIcon [
	^ wikiDataIcon ifNil: [ wikiDataIcon := (Form
	extent: (16@16)
	depth: 32
	fromArray: #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 654443010 1074202375 2669353755 1325860615 2671064373 1661668107 1577716234 1325860615 1863192078 2585401882 1325860615 1293161492 2672840784 1158417420 1325860615 872678404 1057293573 1712394513 4282664004 2131824913 4287137928 2669353755 2535004441 2131824913 2988647203 4148314690 2131824913 2066887218 4291611852 1847467550 2131824913 1393101065 1057293573 1712394513 4282664004 2131824913 4287137928 2669353755 2535004441 2131824913 2988647203 4148314690 2131824913 2066887218 4291611852 1847467550 2131824913 1393101065 1057293573 1712394513 4282664004 2131824913 4287137928 2669353755 2535004441 2131824913 2988647203 4148314690 2131824913 2066887218 4291611852 1847467550 2131824913 1393101065 1057293573 1712394513 4282664004 2131824913 4287137928 2669353755 2535004441 2131824913 2988647203 4148314690 2131824913 2066887218 4291611852 1847467550 2131824913 1393101065 1057293573 1712394513 4282664004 2131824913 4287137928 2669353755 2535004441 2131824913 2988647203 4148314690 2131824913 2066887218 4291611852 1847467550 2131824913 1393101065 1057293573 1712394513 4282664004 2131824913 4287137928 2669353755 2535004441 2131824913 2988647203 4148314690 2131824913 2066887218 4291611852 1847467550 2131824913 1393101065 1057293573 1712394513 4282664004 2131824913 4287137928 2669353755 2535004441 2131824913 2988647203 4148314690 2131824913 2066887218 4291611852 1847467550 2131824913 1393101065 788726531 1275726346 3207014183 1594493450 3209514317 1997475599 1896746510 1594493450 2249462804 3106219301 1594493450 1545346076 3212014451 1393627409 1594493450 1040516357 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
	offset: (0@0)) ]
]

{ #category : #accessing }
OAClient >> wikiDataLogo [
	^ ZnEasy getPng:  'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Wikidata_oversight.svg/320px-Wikidata_oversight.svg.png'
]

{ #category : #accessing }
OAClient >> work: aString [
	self url: self oaBaseUrl, 'works/', aString.
	^ self getOAEntity
]
