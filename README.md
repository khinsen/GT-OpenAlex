# An [OpenAlex](https://openalex.org) client for [Glamorous Toolkit](https://gtoolkit.com/)

## Installation

1. Launch Glamorous Toolkit and open a Playground.
2. Paste the following lines into the playground and run them
```
Metacello new
    baseline: 'OpenAlex';
    repository: 'github://khinsen/GT-OpenAlex:main/src';
    load.
```

## Functionality

Limited but rapidly evolving.

The following examples (to be run from a playground) show how to access individual entities:

Author record by ORCID:
```
OAClient new
	orcid: '0000-0003-0330-9428'
```

Journal record by ISSN:
```
OAClient new
	issn: '1521-9615'
```

Paper record by DOI:
```
OAClient new
	doi: '10.7717/peerj-cs.142'
```

Institution record by ROR:
```
OAClient new
	ror: '02feahw73'
```

Concept record:
```
OAClient new
	concept: 'wikidata:Q14565201'
```

Any entity by its OpenAlex ID:
```
OAClient new
	openAlexId: 'A306386534'
```

All entities have a view labelled "JSON data" that shows the raw data as obtained from OpenAlex. There are additional views to make the data more accessible.
