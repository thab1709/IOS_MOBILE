import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('swagger.json', 'r', encoding='utf-16') as f:
    data = json.load(f)

for path, methods in data.get('paths', {}).items():
    if 'surveyreport' in path.lower():
        print(f"Path: {path}")
        for method, details in methods.items():
            print(f"  Method: {method}")
            print(f"  Summary: {details.get('summary', '')}")
            if 'parameters' in details:
                for param in details['parameters']:
                    if isinstance(param, dict) and 'name' in param:
                        print(f"    Param: {param.get('name')} in {param.get('in')}")
            if 'requestBody' in details:
                print(f"    Body: {details['requestBody']}")
