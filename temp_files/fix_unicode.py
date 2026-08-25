import re

file_path = r'lib\src\app_common\login\select_module.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Replace any ??? or previously mangled emoji with the exact unicode characters
text = re.sub(r"child: Text\(\s*'[^']*'", lambda m: "child: Text('✨⚡️'", text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
