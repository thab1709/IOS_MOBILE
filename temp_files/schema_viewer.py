import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

with open('swagger.json', 'r', encoding='utf-16') as f: data = json.load(f)

def print_schema(ref):
    if not ref: return
    name = ref.split('/')[-1]
    schema = data.get('definitions', {}).get(name)
    if not schema: return
    print('Schema:', name)
    for p, v in schema.get('properties', {}).items():
        print(f"  {p}: {v.get('type')} {v.get('$ref', '')}")

def get_ref(path, method):
    try:
        params = data['paths'][path][method].get('parameters', [])
        for param in params:
            if param.get('in') == 'body':
                schema = param.get('schema', {})
                if '$ref' in schema:
                    print(f"== {method.upper()} {path} ==")
                    print_schema(schema['$ref'])
    except Exception as e:
        print(f"Error for {path} {method}: {e}")

get_ref('/api/surveyreport/{id}', 'put')
get_ref('/api/surveyreport/approve', 'post')
get_ref('/api/surveyreport/reject', 'post')
