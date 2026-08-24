// @dart=2.9
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/choose_line/list_line_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../../app_env.dart';
import '../../../../app_common/shared/app_shared.dart';
import '../../../common/constance/work_status_type.dart';
import '../../../models/day_night/ticket.dart';
import 'list_line_controller.dart';

class ListLineHTView extends StatefulWidget {
  const ListLineHTView(
      {this.lineModel,
      this.chooseLineEnum,
      this.lineBranchInfo,
      this.listBranchSelected});
  final LineModel lineModel;
  final ChooseLineEnum chooseLineEnum;
  final LineBranchInfo lineBranchInfo;
  final List<String> listBranchSelected;
  @override
  State<StatefulWidget> createState() {
    return ListLineHTViewState();
  }
}

class ListLineHTViewState extends State<ListLineHTView> {
  final ListLineController _controller = ListLineController();
  bool _canEdit = true;
  final scrollControllerAll = ScrollController();
  final scrollControllerBranch = ScrollController();
  final scrollControllerNode = ScrollController();
  final scrollControllerDevice = ScrollController();
  final LineTicketController lineTicketController = Get.find();
  bool isNight = false;
  @override
  void initState() {
    super.initState();
    _controller.lineBranchInfo = widget.lineBranchInfo;
    _controller.listBranchSelected = widget.listBranchSelected;
    if (widget.lineModel.id != null && widget.lineBranchInfo == null) {
      debugPrint('haudau123 1111');
      // Trường hợp chọn line từ ô search
      // Sẽ truyền lineModel vào để lấy ra lineChild và node
      _controller.lineModel = widget.lineModel;
      Future.delayed(const Duration(milliseconds: 100), _controller.fetchData);
    } else if (lineTicketController.argument.workModel != null &&
        widget.lineBranchInfo == null) {
      debugPrint('haudau123 2222');
      Future.delayed(const Duration(milliseconds: 100), () {
        _controller
            .getLineDetailFromWork(lineTicketController.argument.workModel);
      });
    } else if (lineTicketController.argument.inspectionModel != null &&
        widget.lineBranchInfo == null) {
      debugPrint('haudau123 3333');
      // Trường hợp getLine từ lịch sử phiếu đã tạo
      Future.delayed(const Duration(milliseconds: 100), () {
        _controller.getSelectedLine(
            lineTicketController.argument.inspectionModel.substationId);
      });
      _canEdit = lineTicketController.argument.inspectionModel.canEdit;

      //case edit branch
    } else if (widget.lineBranchInfo != null) {
      debugPrint('haudau123 4444');
      _controller.menus.assignAll(widget.lineBranchInfo.selectedBranchModel
          .map((e) => LineModel(id: e.id, name: e.name))
          .toList());
      Future.delayed(const Duration(milliseconds: 100), () async {
        await _controller.getSelectedLine(widget.lineBranchInfo.lineBranchId);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    var createButton = '';

    if (lineTicketController.argument.workModel?.entityId == null &&
        lineTicketController.argument.inspectionModel == null &&
        widget.chooseLineEnum == ChooseLineEnum.createTicket) {
      createButton = 'Khởi tạo';
    } else if (widget.chooseLineEnum == ChooseLineEnum.addNewBranch) {
      createButton = AppShared.instance.getAppType() == AppType.HTLDHT
          ? 'Thêm nút'
          : 'Thêm nhánh';
    } else if (widget.chooseLineEnum == ChooseLineEnum.editBranch) {
      createButton = AppShared.instance.getAppType() == AppType.HTLDHT
          ? 'Cập nhật nút'
          : 'Cập nhật nhánh';
    } else {
      if (AppShared.instance.getAppType() == AppType.HTLDHT &&
          lineTicketController.argument.workModel.workStatus ==
              WorkStatusType.New) {
        createButton = 'Khởi tạo';
      }
    }

    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollControllerAll,
            thickness: 8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              controller: scrollControllerAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (_controller.menus.isNotEmpty &&
                        widget.chooseLineEnum == ChooseLineEnum.createTicket) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: AppShared.instance.getAppType() == AppType.HTLDHT
                            ? const SizedBox.shrink()
                            : Row(
                                children: [
                                  Expanded(
                                      child: RadioListTile(
                                    title: Text(
                                        AppShared.instance.getAppType() ==
                                                AppType.HTLDHT
                                            ? 'Theo nút'
                                            : 'Theo nhánh'),
                                    onChanged: (value) {
                                      _controller.setDataType(value);
                                    },
                                    groupValue: _controller.groupValue.value,
                                    value: ListLineController.branchValue,
                                  )),
                                  Expanded(
                                      child: RadioListTile(
                                    title: const Text('Cả đường dây'),
                                    onChanged: (value) {
                                      _controller.setDataType(value);
                                    },
                                    groupValue: _controller.groupValue.value,
                                    value: ListLineController.allBranchValue,
                                  )),
                                ],
                              ),
                      );
                    } else {
                      return Container();
                    }
                  }),

                  //Menu
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: Obx(
                        () => Scrollbar(
                          controller: scrollControllerBranch,
                          thumbVisibility: true,
                          child: ListView.separated(
                            controller: scrollControllerBranch,
                            itemCount: _controller.menus?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return renderMenuItem(index);
                            },
                            separatorBuilder: (context, index) {
                              return Container(
                                width: 24,
                                child: const Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      )),

                  //Line
                  Obx(() {
                    if (_controller.lines.isNotEmpty) {
                      return Column(
                        children: [
                          const SizedBox(height: 8),
                          if (AppShared.instance.getAppType() ==
                                  AppType.HTLDHT &&
                              lineTicketController.argument.ticketType ==
                                  TicketType.incidentDay)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Text("Sự cố ngày"),
                                  Checkbox(
                                      value: !isNight,
                                      onChanged: (value) {
                                        setState(() {
                                          isNight = !value;
                                        });
                                      })
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Text(
                              AppShared.instance.getAppType() == AppType.HTLDHT
                                  ? 'Danh sách các nút'
                                  : 'Chọn nhánh đường dây',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Obx(
                                () => Scrollbar(
                                  controller: scrollControllerNode,
                                  thumbVisibility: true,
                                  child: ListView.builder(
                                      controller: scrollControllerNode,
                                      // physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _controller.lines.length,
                                      itemBuilder: (context, index) {
                                        return renderLineItem(index);
                                      }),
                                ),
                              )),
                        ],
                      );
                    }
                    return Container();
                  }),

                  //Kink nút
                  if (AppShared.instance.getAppType() != AppType.HTLDHT)
                    Obx(() {
                      if (_controller.kinks.isNotEmpty) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Obx(() => Text(
                                  'Chọn nút muốn kiểm tra trên ${_controller.selectedLine?.value?.name}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height / 3,
                              ),
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Obx(
                                    () => Column(
                                      children: [
                                        Expanded(
                                          child: Scrollbar(
                                            thumbVisibility: true,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    _controller.kinks.length,
                                                itemBuilder: (context, index) {
                                                  return renderKinkItem(index);
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        );
                      }
                      return Container();
                    }),

                  Obx(() {
                    if (_controller.equipments.isNotEmpty) {
                      return renderEquipmentView();
                    }
                    return Container();
                  }),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: EButton(
              title: createButton,
              maxSize: true,
              action: () {
                if (widget.chooseLineEnum == ChooseLineEnum.createTicket) {
                  _createTicket();
                } else if (widget.chooseLineEnum ==
                    ChooseLineEnum.addNewBranch) {
                  _addOneBranch();
                } else if (widget.chooseLineEnum == ChooseLineEnum.editBranch) {
                  _updateBranch();
                } else {}
              }),
        )
      ],
    );
  }

  // NOTE(hau) : create ticket
  void _createTicket() {
    final lineArgument = LineArgument(
      line: _controller.lineModel,
      branch: _controller.getBranchSelected(),
      kinks: _controller.getKinkSelected(),
      equipments: _controller.equipments(),
      isNight: isNight,
    );

    // if (_controller.equipments.isEmpty) {
    //   SnackBarHUD.show(
    //       'Không tìm thấy thiết bị nào trên đường dây. Vui lòng chọn đường dây khác');
    //   return;
    // }

    // if (_controller.groupValue.value == ListLineController.allBranchValue) {
    //   _controller.createWithAllNode(lineArgument);
    //   return;
    // }

    _controller.create(lineArgument);
    //Get.to(() => LineTicketScreen(lineTicketArgument: argument,));
  }

  void _addOneBranch() {
    final lineArgument = LineArgument(
      line: _controller.lineModel,
      branch: _controller.getBranchSelected(),
      kinks: _controller.getKinkSelected(),
      equipments: _controller.equipments(),
    );

    if (_controller.equipments.isEmpty) {
      SnackBarHUD.show(
          'Không tìm thấy thiết bị nào trên đường dây. Vui lòng chọn đường dây khác');
      return;
    }

    _controller.addOneBranch(lineArgument);
  }

  void _updateBranch() {
    final lineArgument = LineArgument(
      line: _controller.lineModel,
      branch: _controller.getBranchSelected(),
      kinks: _controller.getKinkSelected(),
      equipments: _controller.equipments(),
    );

    if (_controller.equipments.isEmpty) {
      SnackBarHUD.show(
          'Không tìm thấy thiết bị nào trên đường dây. Vui lòng chọn đường dây khác');
      return;
    }

    _controller.updateBranch(lineArgument);
  }

  GestureDetector renderMenuItem(int index) {
    final model = _controller.menus[index];
    return GestureDetector(
      onTap: () {
        if (_canEdit &&
            widget.lineBranchInfo == null &&
            _controller.groupValue.value == ListLineController.branchValue) {
          _controller.chooseMenu(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Text(model?.name ?? ''),
      ),
    );
  }

  Widget renderKinkItem(int index) {
    final model = _controller.kinks[index];
    final selectedIndex = _controller.getSelected().indexOf(model);

    if (model.id == null && _controller.isNodeHasLoadMore.value) {
      return Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: RoundedLoadingButton(
          width: 100,
          height: 30,
          color: AppColor.highlightColor70,
          controller: _controller.btnControllerNode,
          onPressed: () {
            if (AppShared.instance.getAppType() == AppType.HTLDHT) {
              _controller.getAllNodesInLine(
                  pageIndex: _controller.nodePageIndex + 1,
                  isChecked: _controller.groupValue.value ==
                      ListLineController.allBranchValue);
            } else {
              _controller.getAllNodesInLine(
                  pageIndex: _controller.nodePageIndex + 1);
            }
          },
          child: const Text('Tải thêm'),
        ),
      );
    }
    return Container(
      height: 50,
      child: Row(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: 1,
                  color: (selectedIndex != 0 && model.isChecked)
                      ? Colors.black
                      : Colors.black.withOpacity(0),
                ),
              ),
              GestureDetector(
                onLongPress: () {
                  _controller.chooseSingleKink(index);
                },
                onTap: () {
                  if (_canEdit &&
                      _controller.groupValue.value ==
                          ListLineController.branchValue) {
                    _controller.chooseKink(index);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 30,
                  color: Colors.white.withOpacity(0),
                  child: Stack(
                    children: [
                      const Icon(
                        CupertinoIcons.circle,
                        size: 24,
                        color: Colors.black87,
                      ),
                      Icon(
                        CupertinoIcons.circle_fill,
                        size: 24,
                        color: model.isChecked
                            ? Colors.black87
                            : Colors.black87.withOpacity(0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 1,
                  color:
                      (selectedIndex != _controller.getSelected().length - 1 &&
                              model.isChecked)
                          ? Colors.black87
                          : Colors.black87.withOpacity(0),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: const Text(
              'Nút',
              style: TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Text(model.name,
                  overflow: TextOverflow.ellipsis, maxLines: 2)),
        ],
      ),
    );
  }

  Container renderLineItem(int index) {
    final lineModel = _controller.lines[index];
    final isSelected = widget?.listBranchSelected?.firstWhere(
                (element) => element == lineModel.id,
                orElse: () => null) !=
            null ??
        false;
    return Container(
      height: 50,
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () {
          //     if (!isSelected) {
          //       if (_canEdit) {
          //         _controller.chooseLine(index, isEdit: false);
          //         // _controller.getEquipmentInLine();
          //       }
          //     }
          //   },
          //   child: Container(
          //     width: 40,
          //     height: 40,
          //     alignment: Alignment.center,
          //     color: Colors.white.withOpacity(0),
          //     child: Stack(children: [
          //       Icon(
          //         CupertinoIcons.circle,
          //         size: 24,
          //         color: isSelected ? Colors.grey : Colors.black87,
          //       ),
          //       Icon(
          //         CupertinoIcons.circle_fill,
          //         size: 24,
          //         color: isSelected
          //             ? Colors.grey
          //             : lineModel.isChecked
          //                 ? Colors.black87
          //                 : Colors.black87.withOpacity(0),
          //       )
          //     ]),
          //   ),
          // ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (AppShared.instance.getAppType() == AppType.HTLDHT) {
                  if (!isSelected) {
                    if (_canEdit) {
                      _controller.chooseLine(index, isEdit: false);
                    }
                  }
                } else {
                  _controller.getLineDetail(index);
                }
              },
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      AppShared.instance.getAppType() == AppType.HTLDHT
                          ? "Nút"
                          : 'ĐD',
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Text(
                    lineModel.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  if (AppShared.instance.getAppType() == AppType.HTLDHT)
                    const SizedBox.shrink()
                  else
                    const Icon(CupertinoIcons.chevron_forward,
                        size: 24, color: Colors.grey),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget renderEquipmentView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: const Text('Danh sách thiết bị',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Expanded(
                flex: 1,
                child: Text('Mã thiết bị'),
              ),
              if (AppShared.instance.getAppType() == AppType.HTLDHT)
                const Spacer()
              else
                const Expanded(flex: 1, child: Text('Cột')),
              const Expanded(
                flex: 1,
                child: Text('Tên thiết bị'),
              )
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 3,
          ),
          child: Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            child: Scrollbar(
              controller: scrollControllerDevice,
              thumbVisibility: true,
              child: ListView.separated(
                  controller: scrollControllerDevice,
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 1,
                      color: Colors.grey.shade100,
                    );
                  },
                  itemCount: _controller.equipments.length,
                  shrinkWrap: true,
                  // padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (ctx, index) {
                    final model = _controller.equipments[index];
                    final isHTLDHT =
                        AppShared.instance.getAppType() == AppType.HTLDHT;
                    if (model.id == null &&
                        _controller.isEquipmentHasLoadMore.value) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: RoundedLoadingButton(
                          width: 100,
                          height: 30,
                          color: AppColor.highlightColor70,
                          controller: _controller.btnControllerEquipment,
                          onPressed: () {
                            _controller.getAllEquipmentInLine(
                                pageIndex: _controller.equipmentPageIndex + 1);
                          },
                          child: const Text('Tải thêm'),
                        ),
                      );
                    }

                    return Container(
                      height: 50,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('${model.code}'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          if (isHTLDHT)
                            const Spacer()
                          else
                            Expanded(
                              flex: 1,
                              child: Text(model?.nodeName ?? ''),
                            ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(model.name),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}

