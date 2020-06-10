package main

import (
	"fmt"
	"net"

	maxminddb "github.com/oschwald/maxminddb-golang"
)

func main() {
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
}
