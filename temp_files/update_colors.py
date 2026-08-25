import re

file_path = r'lib\src\app_common\login\select_module.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    text = f.read()

# Replace method signature
text = re.sub(
    r'Widget _buildItem\([^)]+Color bgColor(?:,\s*\{bool hasSparkle = false\})?\) \{',
    r'Widget _buildItem(\n      String icon, String title, Function() onTap, List<Color> gradientColors, {bool hasSparkle = false}) {',
    text
)

# Replace the Card wrapper with Container + LinearGradient
old_card = r'''        child: Card\(
          color: bgColor,
          clipBehavior: Clip\.antiAlias,
          child: Stack\('''
new_card = r'''        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack('''
text = re.sub(old_card, new_card, text)

# Replace the method calls
text = text.replace('const Color(0xff008000)', '[const Color(0xFF4CAF50), const Color(0xFF2E7D32)]')
text = text.replace('const Color(0xff1F59DE)', '[const Color(0xFF42A5F5), const Color(0xFF1565C0)]')
text = text.replace('const Color(0xff7F15D1)', '[const Color(0xFFAB47BC), const Color(0xFF6A1B9A)]')
text = text.replace('Color.fromARGB(255, 184, 8, 178)', '[const Color(0xFFEC407A), const Color(0xFFAD1457)]')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(text)
