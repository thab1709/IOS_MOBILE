import json
import sys

try:
    with open('form_data.json', 'r', encoding='utf-8-sig') as f:
        data = json.load(f)
        
    found = []
    def walk(lst):
        if not lst: return
        for item in lst:
            if item.get('fieldType') == 22:
                found.append(item)
            walk(item.get('children', []))
            
    walk(data.get('data', {}).get('fieldsModel', []))
    
    print(json.dumps(found, indent=2, ensure_ascii=False))
except Exception as e:
    print(f"Error: {e}")
