// @dart=2.9
abstract class BaseDelegate {
  void onLoading();
  void loadSuccess();
  void loadFailed(String message);
}
