// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/violate_popup/violate_popup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../app_common/utils/utils.dart';
import '../../../../../../common/components/app_bar_common.dart';
import '../../../../../../common/components/button_40.dart';
import '../../../../../../common/constance/app_color.dart';
import '../../../../../../common/constance/app_icon.dart';
import '../../../../../../common/constance/inspection_type.dart';
import '../../../../../../common/constance/option_type.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/enum/ticket_enum.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/day_night/tba_content_check.dart';
import '../../../../../../models/line/popups/violate_inspection_model.dart';
import '../../../../containers/e_button.dart';
import '../../../../containers/e_single_drop_down.dart';
import '../../../../periodic_inspection_plan/periodic_inspection_plan_controller.dart';
import '../violate_inspection_list/violate_inspection_list_controller.dart';

class ViolateInspectionListScreen extends StatefulWidget {
  @override
  State<ViolateInspectionListScreen> createState() =>
      _ViolateInspectionListScreenState();
}

class _ViolateInspectionListScreenState
    extends State<ViolateInspectionListScreen> implements HistoryCheckDelegate {
  final ViolateInspectionListController _controller =
      Get.put(ViolateInspectionListController());
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormFieldState> _keyStatus = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    final violateCounts = Get.arguments as ViolateCounts;
    _controller.violateName = violateCounts.vioLateName;
    _controller.typeViolation = violateCounts.typeViolation;
    Future.delayed(const Duration(milliseconds: 100), () async {
      await _controller.getListViolate();
    });
  }

  Future<void> _onRefresh() async {
    await _controller.refreshList();
  }

  Future<void> _onLoadMore() async {
    await _controller.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: _renderAppbar(),
        body: Column(
          children: [
            _buildTitle(),
            Expanded(child: _buildContent()),
          ],
        )));
  }

  Widget _renderAppbar() {
    if (!_controller.isSearching.value) {
      return AppBarCommon(
        title: 'Danh sách vi phạm',
        actions: [
          GestureDetector(
            onTap: () {
              _controller.isSearching.value = true;
            },
            child: Container(
                color: Colors.white.withAlpha(0),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ),
          GestureDetector(
            onTap: () {
              _showFilter();
            },
            child: Container(
                color: Colors.white.withAlpha(0),
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  HighElectricAppIcon.filter,
                  color: _controller.hasFilter()
                      ? HighElectricAppColor.orange
                      : Colors.white,
                )),
          ),
          if (_controller.transformerTicketController.actionTicketType !=
              ActionTicketType.view)
            GestureDetector(
              onTap: () async {
                await Get.to(() => ViolatePopup(
                    typeViolation: _controller.typeViolation,
                    tiketType: ActionTicketType.create,
                    nameViolate: _controller.violateName));
                await _controller.getListViolate();
              },
              child: Container(
                  color: Colors.white.withAlpha(0),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(HighElectricAppIcon.add)),
            )
          else
            Container(
              padding: const EdgeInsets.only(right: 8),
            ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: HighElectricAppColor.primary10,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: HighElectricAppColor.nature01,
          ),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Padding(
                padding:
                    EdgeInsets.only(left: 15, right: 5, top: 11, bottom: 11),
                child: Icon(
                  Icons.search,
                  color: HighElectricAppColor.nature05,
                ),
              ),
              Expanded(
                  child: TextFormField(
                style: const TextStyle(color: Colors.black87),
                cursorHeight: 0,
                cursorWidth: 0,
                focusNode: _focusNode,
                autofocus: true,
                onChanged: (value) {
                  _controller.searchTerm.value = value;
                },
                onEditingComplete: () {
                  _focusNode.unfocus();
                  _controller.getListViolate();
                  _controller.isSearching.value = false;
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: HighElectricAppColor.nature04,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  hintText: 'Nhập thông tin tìm kiếm',
                ),
              )),
              GestureDetector(
                  onTap: () {
                    _controller.searchTerm.value = '';
                    _controller.getListViolate();
                    _controller.isSearching.value = false;
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 19, vertical: 11),
                    child: Icon(
                      Icons.close,
                      color: HighElectricAppColor.nature05,
                    ),
                  ))
            ],
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
      );
    }
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Loại vi phạm',
            style: titleStyle(),
          ),
          Text(
            _controller.violateName,
            style: normalStyle(),
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_controller?.violateList?.isNotEmpty == true) {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: _controller.isHasLoadMore.value ?? false,
        header: WaterDropHeader(
          refresh: Container(),
          complete: const Icon(
            Icons.done,
            color: HighElectricAppColor.highlightColor70,
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
        controller: _controller.refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              height: 0.5,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            );
          },
          itemBuilder: (_, index) {
            if (_controller.typeViolation ==
                ViolateInspectionType.violateLobby) {
              return _violateLobbyInfoItem(_controller.violateList[index]);
            } else if (_controller.typeViolation ==
                ViolateInspectionType.violateRoadworks) {
              return _violateRoadworksInfoItem(_controller.violateList[index]);
            } else {
              return _violateCorridorTreeInfoItem(
                  _controller.violateList[index]);
            }
          },
          itemCount: _controller.violateList.length,
        ),
      );
    } else {
      if (_controller.isFirstLoad) {
        return Container();
      }
      return const Center(
        child: Text(HighElectricStrings.emptyList),
      );
    }
  }

  Widget _violateLobbyInfoItem(ViolateModel violateItem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                violateItem.nameViolate,
                style: titleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await Get.to(() => ViolatePopup(
                            typeViolation: _controller.typeViolation,
                            tiketType: ActionTicketType.view,
                            nameViolate: _controller.violateName,
                            id: violateItem.id,
                          ));
                    },
                    child: Button40(
                      child: SvgPicture.asset(
                        HighElectricAppIcon.copy,
                        width: 18,
                        height: 20,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (_controller
                          .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                    InkWell(
                      onTap: () async {
                        await Get.to(() => ViolatePopup(
                              typeViolation: _controller.typeViolation,
                              tiketType: ActionTicketType.edit,
                              nameViolate: _controller.violateName,
                              id: violateItem.id,
                            ));
                        if(_controller.transformerTicketController.isHasPermissionEdit()){
                          await _controller.getListViolate();
                        }
                      },
                      child: Button40(
                        child: const Icon(Icons.edit,
                            color: HighElectricAppColor.nature01),
                      ),
                    ),
                  if (_controller
                          .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                    const SizedBox(
                      width: 10,
                    ),
                  if (_controller
                      .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                    InkWell(
                      onTap: () async {
                        await rShowMyDialogOkCancel(
                          HighElectricStrings.confirmDelete,
                          secondFunction: () {
                            _controller.deleteViolate(id: violateItem.id);
                          },
                        );
                      },
                      child: Button40(
                        child: const Icon(Icons.delete_outline,
                            color: HighElectricAppColor.nature01),
                      ),
                    )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đối tượng vi phạm',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.subjectViolate,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khoảng cột',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.aboutColumn,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Địa chỉ', style: normalStyle(), textAlign: TextAlign.left),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: Text(violateItem?.address ?? '',
                style: titleStyle(), softWrap: true, textAlign: TextAlign.left),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời điểm vi phạm',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.timeViolate.fromFormatUtcToFormatLocal(
                          HighElectricStrings.ddmmyyyyHHmm),
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời điểm kết thúc',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    if (!violateItem.endViolate.isNullOrEmpty())
                      Text(
                        violateItem.endViolate.fromFormatUtcToFormatLocal(
                            HighElectricStrings.ddmmyyyyHHmm),
                        style: titleStyle(),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _violateRoadworksInfoItem(ViolateModel violateItem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                violateItem.nameViolate??'',
                style: titleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await Get.to(() => ViolatePopup(
                            typeViolation: _controller.typeViolation,
                            tiketType: ActionTicketType.view,
                            nameViolate: _controller.violateName,
                            id: violateItem.id,
                          ));
                    },
                    child: Button40(
                      child: SvgPicture.asset(
                        HighElectricAppIcon.copy,
                        width: 18,
                        height: 20,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (_controller
                      .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                  InkWell(
                    onTap: () async {
                      await Get.to(() => ViolatePopup(
                            typeViolation: _controller.typeViolation,
                            tiketType: ActionTicketType.edit,
                            nameViolate: _controller.violateName,
                            id: violateItem.id,
                          ));
                      if(_controller.transformerTicketController.isHasPermissionEdit()){
                        await _controller.getListViolate();
                      }
                    },
                    child: Button40(
                      child: const Icon(Icons.edit,
                          color: HighElectricAppColor.nature01),
                    ),
                  ),
                  if (_controller
                      .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                  const SizedBox(
                    width: 10,
                  ),
                  if (_controller
                      .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                  InkWell(
                    onTap: () async {
                      await rShowMyDialogOkCancel(
                        HighElectricStrings.confirmDelete,
                        secondFunction: () {
                          _controller.deleteViolate(id: violateItem.id);
                        },
                      );
                    },
                    child: Button40(
                      child: const Icon(Icons.delete_outline,
                          color: HighElectricAppColor.nature01),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên công trường',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.constructionName,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khoảng cột',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.aboutColumn,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời điểm vi phạm',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.timeViolate.fromFormatUtcToFormatLocal(
                          HighElectricStrings.ddmmyyyyHHmm),
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời điểm kết thúc',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    if (!violateItem.endViolate.isNullOrEmpty())
                      Text(
                        violateItem.endViolate.fromFormatUtcToFormatLocal(
                            HighElectricStrings.ddmmyyyyHHmm),
                        style: titleStyle(),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _violateCorridorTreeInfoItem(ViolateModel violateItem) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                violateItem.nameViolate,
                style: titleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await Get.to(() => ViolatePopup(
                            typeViolation: _controller.typeViolation,
                            tiketType: ActionTicketType.view,
                            nameViolate: _controller.violateName,
                            id: violateItem.id,
                          ));
                    },
                    child: Button40(
                      child: SvgPicture.asset(
                        HighElectricAppIcon.copy,
                        width: 18,
                        height: 20,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (_controller
                      .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                  InkWell(
                    onTap: () async {
                      await Get.to(() => ViolatePopup(
                            typeViolation: _controller.typeViolation,
                            tiketType: ActionTicketType.edit,
                            nameViolate: _controller.violateName,
                            id: violateItem.id,
                          ));
                      if(_controller.transformerTicketController.isHasPermissionEdit()){
                        await _controller.getListViolate();
                      }
                    },
                    child: Button40(
                      child: const Icon(Icons.edit,
                          color: HighElectricAppColor.nature01),
                    ),
                  ),
                  if (_controller
                      .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                  const SizedBox(
                    width: 10,
                  ),
                  if (_controller
                      .transformerTicketController.actionTicketType !=
                      ActionTicketType.view)
                  InkWell(
                    onTap: () async {
                      await rShowMyDialogOkCancel(
                        HighElectricStrings.confirmDelete,
                        secondFunction: () {
                          _controller.deleteViolate(id: violateItem.id);
                        },
                      );
                    },
                    child: Button40(
                      child: const Icon(Icons.delete_outline,
                          color: HighElectricAppColor.nature01),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loại cây',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.treeType,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khoảng cột',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.aboutColumn,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chiều cao(m)',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.height,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khoảng cách gần nhất (m):',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.distanceNearest,
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời điểm vi phạm',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      violateItem.timeViolate.fromFormatUtcToFormatLocal(
                          HighElectricStrings.ddmmyyyyHHmm),
                      style: titleStyle(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thời điểm kết thúc',
                      style: normalStyle(),
                    ),
                    const SizedBox(height: 10),
                    if (!violateItem.endViolate.isNullOrEmpty())
                      Text(
                        violateItem.endViolate.fromFormatUtcToFormatLocal(
                            HighElectricStrings.ddmmyyyyHHmm),
                        style: titleStyle(),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final arrDateSearch = await showTimePickerSearch(
        context,
        _controller.fromDateTime ??
            DateTime(DateTime.now().year, DateTime.now().month, 1),
        _controller.toDateTime ??
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0));
    if (arrDateSearch != null) {

      _controller.fromDateTime = arrDateSearch.start;
      _controller.toDateTime = arrDateSearch.end;
      _controller.fromDate.value = arrDateSearch.start.formatFirstDate();
      _controller.toDate.value = arrDateSearch.end.formatSecondDate();
      _controller.timeController.value.text =
      '${arrDateSearch.start.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${arrDateSearch.end.toStringFormat(HighElectricStrings.ddMMyyyy)}';
      _controller.timeController.refresh();
      if (Get.context.isTablet) {
        await _controller.getListViolate();
      }
    }
  }

  void _showFilter() {
    if (_controller.fromDateTime != null && _controller.toDateTime != null) {
      _controller.timeController.value.text =
          '${_controller.fromDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)} - ${_controller.toDateTime.toStringFormat(HighElectricStrings.ddMMyyyy)}';
    } else {
      _controller.timeController.value.text = null;
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Obx(() => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)), //this right here
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bộ lọc',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ESingleDropDown(
                        OptionsType.following_finished.getOptions,
                        padding: 0,
                        value: _controller.trackingStatus.value == 0
                            ? null
                            : _controller.trackingStatus.value,
                        hint: 'Chọn Trạng Thái',
                        keyDropdown: _keyStatus,
                        contentHorizontalPadding: 10,
                        onSelected: (option) {
                          _controller.trackingStatus.value = int.parse(option);
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                          onTap: () async {
                            await _showTimePicker(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade300)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Obx(()=> TextField(
                                      controller: _controller.timeController.value,
                                      decoration: const InputDecoration(
                                        enabled: false,
                                        border: InputBorder.none,
                                        hintText: 'Chọn khoảng thời gian',
                                        isDense: true,
                                      ),
                                    ),),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: HighElectricAppColor.nature05,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ))),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              _controller.toDateTime = null;
                              _controller.fromDateTime = null;
                              _controller.toDate.value = '';
                              _controller.fromDate.value = '';
                              _controller.timeController.value.text = '';
                              _keyStatus.currentState.reset();
                              _controller.trackingStatus.value = null;
                              _controller.isFilter.value = false;
                              _controller.getListViolate();
                            },
                            child: EButtonWidget(
                              width: MediaQuery.of(context).size.width / 3.2,
                              text: 'Bỏ lọc',
                              bgColor: Colors.white,
                              textColor: HighElectricAppColor.primary10,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                                _controller.isFilter.value = true;
                                _controller.getListViolate();
                              },
                              child: EButtonWidget(
                                width: MediaQuery.of(context).size.width / 3.2,
                                text: 'Lọc',
                                bgColor: HighElectricAppColor.primary10,
                                textColor: Colors.white,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  TextStyle titleStyle() {
    return const TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff0F0F1A));
  }

  TextStyle normalStyle() {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xff696973),
    );
  }

  @override
  void onLoadMoreSuccess() {
    _controller.refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _controller.refreshController.refreshCompleted();
  }
}

