#!/bin/bash

component=java
file_name=test.json
# # download the zipped json cve list
# curl https://nvd.nist.gov/feeds/json/cve/1.0/nvdcve-1.0-recent.json.zip -o ./nvdcve-1.0-recent.json.zip
# # unzip the zipped json cve list
# unzip nvdcve-1.0-recent.json.zip
# # get items
# cve_items=$(cat nvdcve-1.0-recent.json | jq .CVE_Items | jq -r '.[0]')
#loop through items
for key in $(jq '.CVE_Items | keys | .[]' $file_name); do
    # echo "CVE DATA:"
    description=$(jq -r ".CVE_Items[$key].cve.description.description_data[0].value" $file_name);
    cve_id=$(jq -r ".CVE_Items[$key].cve.CVE_data_meta.ID" $file_name);
    # echo $description
    # echo $cve_id
    #check if description contains component
    if [[ $description == *$component* ]]; then
        echo "CVE $cve_id triggered by component $component"
    fi
done


#cleanup
# rm nvdcve-1.0-recent.json.zip
# rm nvdcve-1.0-recent.json 
