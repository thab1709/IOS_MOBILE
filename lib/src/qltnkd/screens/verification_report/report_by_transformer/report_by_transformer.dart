// @dart=2.9
import 'package:evnmobile/src/qltnkd/screens/verification_report/report_by_transformer/report_by_transformer_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report_by_transformer/widgets/item_report_by_transformer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../htdct/common/constance/app_color.dart';
import '../../../common/components/drawer_app.dart';
import '../../../common/constance/r_user_role_type.dart';
import '../../../common/constance/report_work_status_type.dart';
import '../../../common/themes/colorx.dart';
import '../../../models/qr_report_result.dart';
import '../list_report/filter_report/filter_report_screen.dart';
import '../list_work/scan_qr/scan_qr_report_screen.dart';
import '../detail_report/detail_report_screen.dart';

class ReportByTransformer extends StatefulWidget {
  const ReportByTransformer({Key key}) : super(key: key);

  @override
  State<ReportByTransformer> createState() => _ReportByTransformerState();
}

class _ReportByTransformerState extends State<ReportByTransformer>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(ReportByTransformerController());
  final _refreshController = RefreshController(initialRefresh: false);
  AnimationController controller;
  Animation<double> animation;
  final searchFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    if (RUserRole.isPresidentCenter) {
      _controller.statusReport =
          ReportStatusType.WaitingForCenterApproval.toString();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getUnits();
      _controller.getRoleOperationApprove();
      _controller.getListPresidentCenter();
      _controller.getListPresidentCompanies();
      _controller.getDataEquipmentReport();
      
      final args = Get.arguments;
      if (args is Map && args['formReportId'] != null) {
        final formReportId = args['formReportId'] as String;
        _controller.searchByFormReportId(formReportId);
      } else {
        _controller.getWorkMerge();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            color: Colors.white,
            icon: AnimatedIcons.menu_close,
            progress: controller,
          ),
          onPressed: () {
            if (_controller.isSearching.value) {
              controller.reverse();
              textEditingController.text = '';
              _controller.searchTerm.value = textEditingController.text;
              if (_controller.isSearched) {
                _controller.isSearched = false;
                _controller.getWorkMerge();
              }
              _controller.isSearching.value = !_controller.isSearching.value;
            } else {
              scaffoldKey.currentState.openDrawer();
            }
          },
        ),
        title: LayoutBuilder(builder: (context, constrains) {
          return Obx(() => Row(
                children: [
                  if (!_controller.isSearching.value)
                    const Expanded(child: Text('Danh sách biên bản')),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width:
                        _controller.isSearching.value ? constrains.maxWidth : 0,
                    child: _controller.isSearching.value
                        ? TextFormField(
                            style: const TextStyle(color: Colors.black87),
                            focusNode: searchFocus,
                            controller: textEditingController,
                            onFieldSubmitted: (value) {
                              _controller.searchTerm.value = value;
                              searchFocus.unfocus();
                              _controller.isSearched = true;
                              _controller.getWorkMerge();
                            },
                            decoration: const InputDecoration(
                              isDense: true,
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(12, 12, 50, 12),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                  color: HighElectricAppColor.nature03,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  color: HighElectricAppColor.nature04,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              hintText: 'Nhập từ khóa',
                            ),
                          )
                        : const SizedBox(),
                  )
                ],
              ));
        }),
        actions: [
          Obx(() {
            if (_controller.isSearching.value) {
              return const SizedBox();
            }
            return IconButton(
              tooltip: 'Quét mã QR',
              icon: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
              onPressed: () async {
                final result = await Get.to(() => const ScanQRReportScreen());
                if (result is QRReportResult) {
                  final searchValue = result.searchValue;
                  final match = RegExp(r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}')
                          .firstMatch(searchValue ?? '');
                  final uuid = match?.group(0);
                  
                  if (result.reportId?.trim()?.isNotEmpty == true || uuid != null) {
                    _controller.searchByFormReportId(result.reportId?.isNotEmpty == true ? result.reportId : uuid);
                  } else if (searchValue?.isNotEmpty == true) {
                    _controller.clearQrSearch();
                    _controller.searchTerm.value = searchValue;
                    _controller.statusReport = result.statusReport ?? ReportStatusType.all.toString();
                    await _controller.getWorkMerge();
                  }
                } else if (result is String && result.isNotEmpty) {
                  _controller.clearQrSearch();
                  _controller.searchTerm.value = result;
                  await _controller.getWorkMerge();
                }
              },
            );
          }),
          Obx(() {
            if (_controller.isSearching.value) {
              return const SizedBox();
            }
            return IconButton(
              tooltip: 'Tìm kiếm',
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                _controller.isSearching.value = !_controller.isSearching.value;
                searchFocus.requestFocus();
                controller.forward();
              },
            );
          }),
          IconButton(
              tooltip: 'Bộ lọc',
              onPressed: () async {
                final result = await Get.to(() => FilterReportScreen());
                if (result == true) {
                  _controller.clearQrSearch();
                  await _controller.getWorkMerge();
                }
              },
              icon: Obx(() => Icon(
                Icons.filter_list,
                color: _controller.isFilter.value ? Colors.orange : Colors.white,
              ))),
          Obx(() => IconButton(
              onPressed: () {
                _controller.isNewToOld.value = !_controller.isNewToOld.value;
                _controller.clearQrSearch();
                _controller.getWorkMerge();
              },
              icon: Tooltip(
                message: _controller.isNewToOld.value
                    ? 'Xắp xếp từ mới -> cũ'
                    : 'Xắp xếp từ cũ -> mới',
                child: Icon(
                  _controller.isNewToOld.value
                      ? Icons.arrow_circle_down_rounded
                      : Icons.arrow_circle_up_rounded,
                  color: Colors.white,
                ),
              ))),
        ],
      ),
      drawer: AppDrawer(
        index: CategoryMenu.reportBySubstation,
      ),
      body: Obx(() {
        if (_controller.listReportByTransformerModel.isEmpty ??
            true && _controller.isFirstLoad) {
          return const Center(
            child: Text('Danh sách trống'),
          );
        }
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(
            refresh: Container(),
            complete: const Icon(
              Icons.done,
              color: RAppColor.highlightColor70,
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
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: () {},
          child: ListView.builder(
              itemCount: _controller.listReportByTransformerModel.length,
              itemBuilder: (context, index) => ItemReportByTransformer(
                    model: _controller.listReportByTransformerModel[index],
                    index: index,
                    exportCertificate: (id, type, workMergeModel) {
                      _controller.exportCertificate(id, type, workMergeModel);
                    },
                    checkSubstation: (trans) {
                      _controller.checkSubstation(trans);
                    },
                    checkEquipment: (trans, work) {
                      _controller.checkEquipment(trans, work);
                    },
                    recall: (id) {
                      _controller.recall(id);
                    },
                    cancelReport: (id) {
                      _controller.cancelReport(id);
                    },
                    sendReport: (work) {
                      _controller.showApproval(work: work);
                    },
                    rejectReport: (work) {
                      _controller.showReject(work: work);
                    },
                    approveReport: (work) {
                      _controller.showApproval(work: work);
                    },
                    getDetail: (work) {
                      _controller.getDetailWork(work);
                    },
                  )),
        );
      }),
    );
  }

  void _onRefresh() {
    _controller.clearQrSearch();
    _controller.getWorkMerge();
    _refreshController.refreshCompleted();
  }
}

