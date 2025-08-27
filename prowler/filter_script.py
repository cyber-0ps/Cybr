import json

# Define the path to the JSON file
file_path = '/Users/example/Documents/s3_security_misconfigurations_prowler/output/prowler-output-272281913033-20240614122806.ocsf.json'

# Read and parse the JSON file
with open(file_path, 'r') as file:
    data = json.load(file)

# Filter and extract the desired information
filtered_results = []
for item in data:
    if item['status_code'] == 'FAIL':
        filtered_result = {
            'status_code': item['status_code'],
            'status_detail': item['status_detail'],
            'severity': item['severity'],
            'description': item['finding_info']['desc'],
            'region': item['resources'][0]['region'],
            'name': item['resources'][0]['name'],
            'type': item['resources'][0]['type'],
            'uid': item['resources'][0]['uid'],
            'account_id': item['cloud']['account']['uid']
        }
        filtered_results.append(filtered_result)

# Print the filtered results
print(json.dumps(filtered_results, indent=4))