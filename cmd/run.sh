#!/bin/bash

# As an SRE I would like to know when a Common Vulnerabilities and Exposures (CVE) is published that may affect important Software I use. 
# runs thorugh list from National Vulnerability Database (NVD) list of CVEs and matches key components in each CVE description

set -eu

cleanup() {
    rm nvdcve-1.0-recent.json.zip
    rm nvdcve-1.0-recent.json 
}
file_name=nvdcve-1.0-recent.json
# download the zipped json cve list
curl https://nvd.nist.gov/feeds/json/cve/1.0/$file_name.zip -o $file_name.zip
# unzip the zipped json cve list
unzip $file_name.zip
trap cleanup EXIT
#loop through items
for key in $(jq '.CVE_Items | keys | .[]' $file_name); do
    description=$(jq -r ".CVE_Items[$key].cve.description.description_data[0].value" $file_name);
    cve_id=$(jq -r ".CVE_Items[$key].cve.CVE_data_meta.ID" $file_name);
    #check if description contains component
    if [[ $description == *$COMPONENT* ]]; then
        echo "CVE $cve_id triggered by component \"$COMPONENT\""
        #alert slack
    else 
        echo "Skipping CVE $cve_id..."
    fi
done




