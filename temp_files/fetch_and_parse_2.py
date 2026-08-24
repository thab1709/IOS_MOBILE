import urllib.request
import json
import sys

url = 'http://125.212.226.94:5006/api/formreport/b7339d28-21b0-473c-8de5-36876add9421'
headers = {
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI2OWJkNzE0Zi05NTc2LTQ1YmEtYjViNy1mMDA2NDliZTAwZGUiLCJhY3RvcnQiOiJBZG1pbmlzdHJhdG9yIiwicm9sZSI6IkFkbWluIiwiVGltZXpvbmVPZmZzZXQiOiItNDIwIiwianRpIjoiNDY3OWQ1YzAtYmQ4MC00OWM2LTg4NGYtMjkyMzYyOWJiOWFkIiwiUGVybWlzc2lvbiI6ImFsbCIsIlVuaXRJZCI6IjA3ODIzNGIwLTViMGQtNDY3YS1hNjcwLTUyZmY5M2Y4YzIyMyIsIlRpY2tldCI6IiIsIm5iZiI6MTc4MjgxMDU5NiwiZXhwIjoxNzgyODk2OTk2LCJpYXQiOjE3ODI4MTA1OTYsImlzcyI6Imh0dHA6Ly93d3cuZXZuLmNvbSIsImF1ZCI6Imh0dHA6Ly93d3cuZXZuLmNvbSJ9.VfNRegzx9OY7N9Ag4_hOi5ijCO-lEfEUHaPnOe6StyE'
}

try:
    req = urllib.request.Request(url, headers=headers)
    res = urllib.request.urlopen(req)
    data = json.loads(res.read().decode('utf-8'))
    
    found = []
    def search(obj):
        if isinstance(obj, dict):
            if obj.get('fieldType') == 22:
                found.append(obj)
            for k, v in obj.items():
                search(v)
        elif isinstance(obj, list):
            for v in obj:
                search(v)
                
    search(data)
    
    print("Found FieldType 22:")
    print(json.dumps(found, indent=2, ensure_ascii=False))
    
    print("\n--- Tab 3 structure ---")
    fields = data.get('data', {}).get('fieldsModel', [])
    if len(fields) > 0 and len(fields[0].get('children', [])) > 2:
        tab3 = fields[0]['children'][2]
        print(json.dumps(tab3, indent=2, ensure_ascii=False))
        
except Exception as e:
    print(f"Error: {e}")
