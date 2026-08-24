// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../common/base/base_delegate.dart';
import '../../common/components/button_40.dart';
import '../../common/constance/app_icon.dart';
import '../../common/themes/colorx.dart';
import '../../models/option_model.dart';
import '../grid_management/containers/e_single_drop_down.dart';
import 'list_location_controller.dart';
import 'map_page.dart';
import 'models/subtation_address.dart';

class ListLocationScreen extends StatefulWidget {
  const ListLocationScreen({Key key}) : super(key: key);

  @override
  _ListLocationScreenState createState() => _ListLocationScreenState();
}

class _ListLocationScreenState extends State<ListLocationScreen>
    implements BaseDelegate {
  final _controller = ListLocationController();
  final FocusNode _focusNode = FocusNode();
  final _refreshController = RefreshController(initialRefresh: false);
  RxBool isSearching = false.obs;
  final options = [OptionModel('Trạm biến áp', 0), OptionModel('Đường dây', 1)];

  @override
  void initState() {
    _controller.initData();
    Future.delayed(const Duration(milliseconds: 100), _controller.getData);
    super.initState();
    _controller.delegate = this;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: _renderAppbar(),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Obx(
                () => SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: _controller.isHasLoadMore.value ?? false,
                  header: WaterDropHeader(
                    refresh: Container(),
                    complete: const Icon(
                      Icons.done,
                      color: AppColor.highlightColor70,
                    ),
                  ),
                  footer: const ClassicFooter(
                    loadStyle: LoadStyle.HideAlways,
                    loadingText: '',
                    noDataText: '',
                    canLoadingText: '',
                    failedText: '',
                    idleText: '',
                  ),
                  onRefresh: () {
                    _controller.getData(animation: false);
                  },
                  onLoading: () {
                    _controller.loadMore();
                  },
                  controller: _refreshController,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      final item = _controller.substationAddress[index];
                      return _renderHistoryItem(item);
                    },
                    itemCount: _controller.substationAddress.length,
                  ),
                ),
              )),
            ],
          ),
        )));
  }

  Widget _renderHistoryItem(SubstationAddress model) {
    return GestureDetector(
      // onTap: () {
      //   _controller.selectItem(model);
      // },
      child: Container(
        margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    model.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  )),
                  GestureDetector(
                    onTap: () {
                      // if ((model.latitude == null || model.longitude == null) &&
                      //     _controller.optionType == 0) {
                      //   hShowDialogOneButton('Không tìm thấy tọa độ nào');
                      // } else {
                      Get.to(() => MapPage(
                            address: model,
                            type: _controller.optionType,
                          ));
                      // }
                    },
                    child: Container(
                      width: 60,
                      height: 40,
                      child: const Icon(
                        Icons.map,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mã',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          model.code,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thuộc',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          model?.lineName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 16, right: 16, bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Người quản lý',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          model?.users?.join(',\n') ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: model.isExpand ? null : 3,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Phòng/đội',
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(model?.userGroups?.join(', ') ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500))
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(model.isExpand
            //         ? Icons.keyboard_arrow_up
            //         : Icons.keyboard_arrow_down)
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  AppBar _renderAppbar() {
    if (isSearching.value) {
      return AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Expanded(
                  child: TextFormField(
                style: const TextStyle(color: Colors.black),
                focusNode: _focusNode,
                autofocus: true,
                cursorColor: AppColor.highlightColor,
                onChanged: (value) {
                  _controller.searchTerm = value;
                },
                onEditingComplete: () {
                  _focusNode.unfocus();
                  _controller.getData();
                },
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: AppColor.highlightColor70,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: 'Tìm kiếm',
                    border: InputBorder.none),
              )),
              GestureDetector(
                  onTap: () {
                    _controller.searchTerm = '';
                    _controller.getData();
                    isSearching.value = false;
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ))
            ],
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
      );
    } else {
      return AppBar(
        backgroundColor: AppColor.highlightColor70,
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Vị trí'),
        actions: [
          GestureDetector(
            onTap: () {
              isSearching.value = true;
              _focusNode.requestFocus();
            },
            child: Container(
                color: Colors.white.withAlpha(0),
                padding: const EdgeInsets.all(0),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
          GestureDetector(
            onTap: () {
              _showFilter();
            },
            child: Button40(
                child: Container(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                HighElectricAppIcon.filter,
                color: _controller.hasFilter()
                    ? HighElectricAppColor.orange
                    : Colors.white,
              ),
            )),
          ),
        ],
      );
    }
  }

  void _showFilter() {
    final groupId = _controller.groupId;
    final teamId = _controller.teamId;
    final optionType = _controller.optionType;
    final substationId = _controller.substationId.value;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), //this right here
            child: Container(
              height: 380,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lọc thông tin',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                              _controller.setGroupId(groupId);
                              _controller.substationId.value = substationId;
                              _controller.teamId = teamId;
                              _controller.setOptionType(optionType.toString());
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    E2SingleDropDown(
                      _controller.listGroupsOption,
                      value: _controller.groupId,
                      padding: 0,
                      hint: 'Vui lòng chọn đội/phòng',
                      contentHorizontalPadding: 10,
                      onSelected: (option) {
                        _controller.setGroupId(option);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => E2SingleDropDown(
                        _controller.listTeamOption.value,
                        value: _controller.teamId,
                        padding: 0,
                        hint: 'Vui lòng chọn tổ',
                        contentHorizontalPadding: 10,
                        onSelected: (option) {
                          _controller.teamId = option;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ESingleDropDown(
                      options,
                      value: _controller.optionType,
                      padding: 0,
                      contentHorizontalPadding: 10,
                      onSelected: (option) {
                        _controller.setOptionType(option);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => E2SingleDropDown(
                        _controller.listTBAorLineOption.value,
                        value: _controller.substationId.value,
                        padding: 0,
                        hint: _controller.optionType == 0
                            ? 'Vui lòng chọn trạm biến áp'
                            : 'Vui lòng chọn đường dây',
                        contentHorizontalPadding: 10,
                        onSelected: (option) {
                          _controller.substationId.value = option;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                            _controller.clearFilter();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.backgroundColorGray,
                                  borderRadius: BorderRadius.circular(6)),
                              height: 45,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: const Text(
                                'Bỏ lọc',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                            _controller.getData();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.highlightColor70,
                                  borderRadius: BorderRadius.circular(6)),
                              height: 45,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: const Text(
                                'Lọc',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void loadFailed(String message) {
    _refreshController.loadFailed();
    _refreshController.refreshCompleted();
  }

  @override
  void loadSuccess() {
    _refreshController.loadComplete();
    _refreshController.refreshCompleted();
  }

  @override
  void onLoading() {}
}

