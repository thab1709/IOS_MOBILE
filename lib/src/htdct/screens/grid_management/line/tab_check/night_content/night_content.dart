// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../../htld/common/utils/snack_bar_h_u_d.dart';
import '../../../../../common/components/app_button.dart';
import '../../../../../common/constance/app_color.dart';
import '../../../../../common/constance/image_problems.dart';
import '../../../../../common/constance/option_type.dart';
import '../../../../../common/enum/ticket_enum.dart';
import '../../../../../common/themes/colorx.dart';
import '../../../../../common/themes/styles.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../models/line/line_content_night_time_model.dart';
import '../../../../../models/weirdo_message.dart';
import '../../../containers/e_single_drop_down.dart';
import '../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';
import 'night_content_controller.dart';

class NightContent extends StatefulWidget {
  const NightContent();

  @override
  State<NightContent> createState() => _NightContentState();
}

class _NightContentState extends State<NightContent> with AutomaticKeepAliveClientMixin {
  final _controller = NightContentController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 200), _controller.getData);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      color: HighElectricAppColor.nature01,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          if(_controller?.transformerTicketController?.actionTicketType != ActionTicketType.view)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                EButton(
                    title: 'Xác nhận vị trí',
                    action: () async {
                      await hShowMyDialogOkCancel('Xác nhận vị trí kiểm tra',
                          secondFunction: () async {
                            final result = await _controller.transformerTicketController
                                .sendLocation(isAwait: true, isCheckIn: true);
                            if (result == true) {
                              SnackBarHUD.show('Xác nhận vị trí kiểm tra thành công');
                            }
                          });
                    }),
                const SizedBox(width: 20,)
              ],
            ),
          const SizedBox(height: 10,),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              'Thông tin kiểm tra',
              style: Styles.textTitleContent,
            ),
          ),
          Expanded(
            child: Obx(_buildContent),
          ),
          if (_controller.transformerTicketController.actionTicketType !=
              ActionTicketType.view)
            _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final model = _controller.dataModel.value as ContentNightTimeModel;
    return SingleChildScrollView(
      child: Column(
        children: [
          ExpansionWidget(
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
             final result = await _controller.addImage(files, ImageProblems.muc1_0);
             return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_0),
            isHeader: true,
            allImage: _controller.getListImage(),
            invalid: _controller.invalid.value,
            isCamera: true,
            title: '1. Kiểm tra',
            children: <Widget>[
              // kết luận
              ESingleDropDown(
                OptionsType.normal_weirdo.getOptions,
                value: model.checkNight,
                isDisable: true,
              ),
              //1.1. Kiểm tra sự phát hiện mối nối
              if(_controller.transformerTicketController.checkAbnormalNotify(model.checkSplice,abnormal: model.checkSpliceAbnormal))
                CheckWidget(
                    abnormalOptions: _controller.abnormalOptions,
                    onSelectedAbnormalOption: ({value, title}) {
                      model.setAbnormal(
                        Abnormals(
                          abnormalId: value,
                          categoryIndex: ImageProblems.muc1_1,
                          childCategory: title,
                          parentCategory: '1. Kiểm tra',
                          description: model.checkSpliceAbnormal,
                        ),
                      );
                      _controller.viewRefresh();
                    },
                    addAbnormalOption: (value) async {
                      await _controller.addAbnormalOption(name: value);
                      _controller.invalid.refresh();
                    },
                    initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_1).abnormalId,

                    removeImage: (file) {
                    _controller.removeImage(file);
                  },
                  addImage: (files) {
                    _controller.addImage(files, ImageProblems.muc1_1);
                  },
                  listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
                  title: '1.1. Kiểm tra sự phát hiện mối nối',
                  optionsDefaultValue: model.checkSplice,
                  onSelectChange: (value) {
                    model.checkSplice = value.toIntOrNull();
                    _controller.checkValidPattern(ImageProblems.muc1_0);
                    if (value.toIntOrNull() ==
                        OptionsType.normal_weirdo.getOptions.first.value) {
                      _controller.removeImageOfProblem(ImageProblems.muc1_1);
                      model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
                    }
                  },
                  invalid: _controller.invalid.value,
                  onChangeInput: (value) {
                    model.checkSpliceAbnormal = value;
                    model.setAbnormal(Abnormals(
                      categoryIndex: ImageProblems.muc1_1,
                      description: value,
                    ),isSetDescription: true);
                  },
                  onChangeWeirdoMessage: (weirdoMessage) {
                    model.setUnusually(
                        WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
                  },
                  defaultAbnormal: model.checkSpliceAbnormal,
                  options: OptionsType.normal_weirdo.getOptions),

              //1.2.Kiểm tra hiện tượng phóng điện đường dây, chuỗi cách điện và phụ kiện
              if(_controller.transformerTicketController.checkAbnormalNotify(model.checkDischarges,abnormal: model.checkDischargesAbnormal))
                CheckWidget(
                    abnormalOptions: _controller.abnormalOptions,
                    onSelectedAbnormalOption: ({value, title}) {
                      model.setAbnormal(
                        Abnormals(
                          abnormalId: value,
                          categoryIndex: ImageProblems.muc1_2,
                          childCategory: title,
                          parentCategory: '1. Kiểm tra',
                          description: model.checkDischargesAbnormal,
                        ),
                      );
                      _controller.viewRefresh();
                    },
                    addAbnormalOption: (value) async {
                      await _controller.addAbnormalOption(name: value);
                    },
                    initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_2).abnormalId,

                    removeImage: (file) {
                    _controller.removeImage(file);
                  },
                  addImage: (files) {
                    _controller.addImage(files, ImageProblems.muc1_2);
                  },
                  listImage: _controller.getImageByProblem(ImageProblems.muc1_2),
                  title: '1.2.Kiểm tra hiện tượng phóng điện đường dây, chuỗi cách điện và phụ kiện',
                  optionsDefaultValue: model.checkDischarges,
                  onSelectChange: (value) {
                    model.checkDischarges = value.toIntOrNull();
                    _controller.checkValidPattern(ImageProblems.muc1_0);
                    if (value.toIntOrNull() ==
                        OptionsType.normal_weirdo.getOptions.first.value) {
                      _controller.removeImageOfProblem(ImageProblems.muc1_2);
                      model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
                    }
                  },
                  invalid: _controller.invalid.value,
                  onChangeInput: (value) {
                    model.checkDischargesAbnormal = value;
                    model.setAbnormal(Abnormals(
                      categoryIndex: ImageProblems.muc1_2,
                      description: value,
                    ),isSetDescription: true);
                  },
                  onChangeWeirdoMessage: (weirdoMessage) {
                    model.setUnusually(
                        WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
                  },
                  defaultAbnormal: model.checkDischargesAbnormal,
                  options: OptionsType.normal_weirdo.getOptions),

              //1.3.Các hiện tượng bất thường khác
              if(_controller.transformerTicketController.checkAbnormalNotify(model.other,abnormal: model.otherAbnormal))
                CheckWidget(
                    abnormalOptions: _controller.abnormalOptions,
                    onSelectedAbnormalOption: ({value, title}) {
                      model.setAbnormal(
                        Abnormals(
                          abnormalId: value,
                          categoryIndex: ImageProblems.muc1_3,
                          childCategory: title,
                          parentCategory: '1. Kiểm tra',
                          description: model.otherAbnormal,
                        ),
                      );
                      _controller.viewRefresh();
                    },
                    addAbnormalOption: (value) async {
                      await _controller.addAbnormalOption(name: value);
                    },
                    initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_3).abnormalId,

                    removeImage: (file) {
                    _controller.removeImage(file);
                  },
                  addImage: (files) {
                    _controller.addImage(files, ImageProblems.muc1_3);
                  },
                  listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
                  title: '1.3.Các hiện tượng bất thường khác',
                  optionsDefaultValue: model.other,
                  onSelectChange: (value) {
                    model.other = value.toIntOrNull();
                    _controller.checkValidPattern(ImageProblems.muc1_0);
                    if (value.toIntOrNull() ==
                        OptionsType.normal_weirdo.getOptions.first.value) {
                      _controller.removeImageOfProblem(ImageProblems.muc1_3);
                      model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
                    }
                  },
                  invalid: _controller.invalid.value,
                  onChangeInput: (value) {
                    model.otherAbnormal = value;
                    model.setAbnormal(Abnormals(
                      categoryIndex: ImageProblems.muc1_3,
                      description: value,
                    ),isSetDescription: true);
                  },
                  onChangeWeirdoMessage: (weirdoMessage) {
                    model.setUnusually(
                        WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
                  },
                  defaultAbnormal: model.otherAbnormal,
                  options: OptionsType.normal_weirdo.getOptions),

              //1.4.Kiểm tra ánh sáng cột vượt (nếu có)
              if(_controller.transformerTicketController.checkAbnormalNotify(model.checkLight,abnormal: model.checkLightAbnormal))
                CheckWidget(
                    abnormalOptions: _controller.abnormalOptions,
                    onSelectedAbnormalOption: ({value, title}) {
                      model.setAbnormal(
                        Abnormals(
                          abnormalId: value,
                          categoryIndex: ImageProblems.muc1_4,
                          childCategory: title,
                          parentCategory: '1. Kiểm tra',
                          description: model.checkLightAbnormal,
                        ),
                      );
                      _controller.viewRefresh();
                    },
                    addAbnormalOption: (value) async {
                      await _controller.addAbnormalOption(name: value);
                    },
                    initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_4).abnormalId,

                    removeImage: (file) {
                    _controller.removeImage(file);
                  },
                  addImage: (files) {
                    _controller.addImage(files, ImageProblems.muc1_4);
                  },
                  listImage: _controller.getImageByProblem(ImageProblems.muc1_4),
                  title: '1.4.Kiểm tra ánh sáng cột vượt (nếu có)',
                  optionsDefaultValue: model.checkLight,
                  onSelectChange: (value) {
                    model.checkLight = value.toIntOrNull();
                    _controller.checkValidPattern(ImageProblems.muc1_0);
                    if (value.toIntOrNull() ==
                        OptionsType.normal_weirdo.getOptions.first.value) {
                      _controller.removeImageOfProblem(ImageProblems.muc1_4);
                      model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
                    }
                  },
                  invalid: _controller.invalid.value,
                  onChangeInput: (value) {
                    model.checkLightAbnormal = value;
                    model.setAbnormal(Abnormals(
                      categoryIndex: ImageProblems.muc1_4,
                      description: value,
                    ),isSetDescription: true);
                  },
                  onChangeWeirdoMessage: (weirdoMessage) {
                    model.setUnusually(
                        WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
                  },
                  defaultAbnormal: model.checkLightAbnormal,
                  options: OptionsType.normal_weirdo.getOptions),

            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: EButton(
          title: 'Lưu và tiếp tục',
          action: () {
            _controller.updateData();
          }),
    );
  }

  @override
  bool get wantKeepAlive => !_controller.transformerTicketController.isHasPermissionEdit();
}
class NightContentNotify extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: (){Get.back();},
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: AppColor.highlightColor70,
        title: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Kiểm tra đường dây đêm',
            style: TextStyle(fontSize: 18),
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: const NightContent(),
    );
  }
}

