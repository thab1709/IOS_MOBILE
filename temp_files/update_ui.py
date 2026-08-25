import re
with open('lib/src/app_common/login/select_module.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = re.sub(
    r'(Widget _buildItem\([^)]+Color bgColor\)) \{',
    r'\1, {bool hasSparkle = false}) {',
    text
)

old_card = '''        child: Card(
          color: bgColor,
          child: Container('''
new_card = '''        child: Card(
          color: bgColor,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container('''
text = text.replace(old_card, new_card)

old_end = '''              ],
            ),
          ),
        ),
      ),
    );'''
new_end = '''              ],
            ),
          ),
          if (hasSparkle)
            const Positioned(
              top: 0,
              right: 15,
              child: Text(
                '✨⚡️',
                style: TextStyle(fontSize: 26, shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.yellow,
                    offset: Offset(0, 0),
                  ),
                ]),
              ),
            ),
        ],
      ),
    ),
  ),
);'''
text = re.sub(r'              \],\s*\),\s*\),\s*\),\s*\),\s*\);', new_end, text)

with open('lib/src/app_common/login/select_module.dart', 'w', encoding='utf-8') as f:
    f.write(text)
