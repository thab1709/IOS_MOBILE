// @dart=2.9
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:flutter/material.dart';

class ContentCheckListButton extends StatelessWidget {
  const ContentCheckListButton(this.equipmentModel,
      {this.onTap, this.isCompleted = false});

  final EquipmentModel equipmentModel;
  final Function onTap;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(
              equipmentModel.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )),
            if (equipmentModel.isChecked)
              Icon(
                Icons.check,
                color: Colors.green.shade700,
                size: 24,
              )
          ],
        ),
      ),
    );
  }
}

class ContentCheckListDayButton extends StatelessWidget {
  const ContentCheckListDayButton(this.popupsDataModel,
      {this.onTap, this.marginHorizontal});

  final PopupsDataModel popupsDataModel;
  final Function onTap;
  final double marginHorizontal;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.symmetric(
            vertical: 8, horizontal: marginHorizontal ?? 16),
        decoration: BoxDecoration(
            color:
                popupsDataModel.isSaved ?? false ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200, blurRadius: 2, spreadRadius: 1)
            ]),
        child: Row(
          children: [
            Expanded(
                child: Text(
              popupsDataModel.getPopupName(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: popupsDataModel.isSaved ?? false
                      ? Colors.white
                      : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            )),
            if (popupsDataModel.abnormalCount > 0)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    popupsDataModel.abnormalCount.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            if (popupsDataModel.isSaved)
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              )
            else
              const Icon(
                Icons.chevron_right,
                color: Colors.black54,
                size: 24,
              )
          ],
        ),
      ),
    );
  }
}

