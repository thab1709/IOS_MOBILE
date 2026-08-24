// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/certificate_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/histories/certificate_history.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/pdf/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_button.dart';
import 'field_infor_item.dart';

class ItemCertificate extends StatelessWidget {
  const ItemCertificate(
      {@required this.certificateModel,
        this.isHasCheckBox = true,
        this.onSelect,
        this.index,
        this.isLast = false,
        this.reloadData,
        this.showMap,
        this.signatureCertificate,
        Key key})
      : super(key: key);
  final CertificateModel certificateModel;
  final bool isHasCheckBox;
  final int index;
  final bool isLast;
  final Function() reloadData;
  final Function() showMap;
  final Function() signatureCertificate;

  final Function(String, bool) onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.to(() => RPdfCertificateScreen(
          id: certificateModel.id,
          code: certificateModel.code,
        ));
        if(reloadData != null) {
          reloadData();
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            top: index == 0 ? 20 : 10, bottom: isLast ? 16: 8, left: 16, right: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            _buildHeader(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  FieldInfoItem(
                    titleFirst: 'Đơn vị yêu cầu',
                    valueFirst: certificateModel?.unitRequest,
                    titleSecond: RAppStrings.location,
                    valueSecond: certificateModel?.location,
                  ),
                  FieldInfoItem(
                    titleFirst: 'VTTB',
                    valueFirst: certificateModel?.equipmentName,
                    titleSecond: RAppStrings.equipmentDetail,
                    valueSecond: certificateModel?.equipmentDetail,
                  ),
                  FieldInfoItem(
                    titleFirst: 'Trung tâm',
                    valueFirst: certificateModel?.department,
                    titleSecond: RAppStrings.team,
                    valueSecond: certificateModel?.team,
                  ),
                  FieldInfoItem(
                    titleFirst: RAppStrings.performer,
                    valueFirst: certificateModel.userImp,
                    titleSecond: 'Ngày tạo',
                    valueSecond: certificateModel?.getCreateDate(),
                  ),
                  FieldInfoItem(
                    titleFirst: RAppStrings.status,
                    valueFirst: certificateModel.statusName,
                  ),
                 // _buildButtonSignature(certificateModel.isAlowSign, signatureCertificate)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            if (isHasCheckBox)
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: certificateModel.isSelected,
                  activeColor: RAppColor.highlightColor70,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  onChanged: (value) {
                    onSelect(certificateModel.id, value);
                  },
                ),
              ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  certificateModel?.code ?? '',
                  style: const TextStyle(
                      fontSize: TextSize.big,
                      color: RAppColor.highlightColor70,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(onPressed: () {
              Get.to(() => CertificateApprovalHistoryScreen(
                certificateId: certificateModel.id,
              ));
            }, icon: const Icon(Icons.history))
          ],
        ),
        const Divider(
          thickness: 1,
          height: 30,
        ),
      ],
    );
  }

  Widget _buildButtonSignature(bool isShowButton, Function() action) {
    if (!isShowButton) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: RButton(
        maxSize: true,
        action: () async {
          if (action != null) {
            await rShowMyDialogOkCancel('Bạn có chắc muốn kí giấy chứng nhận này', secondFunction: () {
              action();
            });
          }
        },
        title: 'Ký số',
      ),
    );
  }
}

