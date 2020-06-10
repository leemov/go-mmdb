# Intro
This is note on how I implement example of how to lookup IP on ASN dictionary using .mmdb format
what is mmdb you can read on the official page https://maxmind.github.io/MaxMind-DB/

On my local setup, 
loading ~400k mmdb data (6mb) with ASN resulting ~50µs duration
lookup to new range entry resulting ~1ms duration
lookup to cached range entry resulting ~50µs duration

# Getting started
- Clone the repo
```sh
$ git clone git@github.com:leemov/go-mmdb.git
```

# Write mmdb tree file
- We will be using perl to write tree into .mmdb file. visit official perl site for installation
-- https://learn.perl.org/installing/ 
- We also need this 2 library, Maxmind as writter API and CSV
-- How to install perl module : https://www.ostechnix.com/how-to-install-perl-modules-on-linux/
```sh
Text::CSV_XS
MaxMind::DB::Writer::Tree;
```
- After you install those perl modules, then you can build from csv file into mmdb
```sh
$ perl build.pl
```

# Read mmdb in golang
we will be using this awesome package to open mmdb file
https://github.com/oschwald/maxminddb-golang

- Run dep ensure to fetch dependencies
```sh
$ dep ensure -v
```
- run example in main.go file to test
```sh
// open mmdb files
	db, err := maxminddb.Open("my-ip-data.mmdb")
	if err != nil {
		fmt.Println(err)
	}
	defer db.Close()

	// parse ip v4 string into net.IP
	ip := net.ParseIP("207.101.8.2")
	var record struct {
		ASNumber       string `maxminddb:"autonomous_system_number"`
		ASOrganization string `maxminddb:"autonomous_system_organization"`
	}

	// lookup net.IP inside .mmdb
	err = db.Lookup(ip, &record)
	if err != nil {
		fmt.Println(err)
	}
```

```sh
$ go run main.go
```

