// @dart=2.12
import 'dart:io';

void main() {
  var file = File('lib/src/app_common/login/select_module.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
    'const Color(0xff1F59DE)),',
    'const Color(0xff1F59DE), hasSparkle: true),'
  );
  content = content.replaceAll(
    'const Color(0xff7F15D1)),',
    'const Color(0xff7F15D1), hasSparkle: true),'
  );
  content = content.replaceAll(
    'Color.fromARGB(255, 184, 8, 178)),',
    'Color.fromARGB(255, 184, 8, 178), hasSparkle: true),'
  );

  content = content.replaceAll(
    '''Widget _buildItem(
      String icon, String title, Function() onTap, Color bgColor) {''',
    '''Widget _buildItem(
      String icon, String title, Function() onTap, Color bgColor, {bool hasSparkle = false}) {'''
  );

  var originalCardChild = '''          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: isLargeScreenSize ? 20 : 16,
                horizontal: isLargeScreenSize ? 20 : 12),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(
                      icon,
                      color: Colors.white,
                    )),
                Expanded(
                    child: Text(
                  title ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SvgPicture.asset(
                    ImagesCommon.icBack,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),''';

  var newCardChild = '''          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: isLargeScreenSize ? 20 : 16,
                    horizontal: isLargeScreenSize ? 20 : 12),
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SvgPicture.asset(
                          icon,
                          color: Colors.white,
                        )),
                    Expanded(
                        child: Text(
                      title ?? '',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SvgPicture.asset(
                        ImagesCommon.icBack,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              if (hasSparkle)
                const Positioned(
                  top: -5,
                  right: 10,
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
          ),''';

  content = content.replaceAll(originalCardChild, newCardChild);
  
  file.writeAsStringSync(content);
}
