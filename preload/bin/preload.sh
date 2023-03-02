#!/bin/bash

# Import all files under the "import" directory

COLOR=$'\e[0;32m'

echo "${COLOR}Importing RDFs from import folder to repository ${REPOSITORY_ID}..."

envsubst < /opt/graphdb/repository_template.ttl > /opt/graphdb/repository.ttl

/opt/graphdb/dist/bin/importrdf load --force \
	-c /opt/graphdb/repository.ttl \
	/opt/graphdb/DATASET.ttl \
	/opt/graphdb/home/graphdb-import/*

# Execute queries (e.g. to create indices)

echo "${COLOR}Launching graphdb - using ${REPOSITORY_ID} repository"
/opt/graphdb/dist/bin/graphdb -d -s
sleep 5

for filename in /opt/graphdb/home/graphdb-queries/*.sparql; do
	echo "${COLOR}Executing query: ${filename}"
	PAYLOAD=$(cat $filename)
	curl -X POST \
		-H "Content-type: application/x-www-form-urlencoded" \
		--data-urlencode "update=$PAYLOAD" \
		http://localhost:7200/repositories/${REPOSITORY_ID}/statements
done

exit 0