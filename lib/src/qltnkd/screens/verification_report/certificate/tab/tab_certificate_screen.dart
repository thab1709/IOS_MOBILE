// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/item_certificate.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/delegate/view_list_pdf_delegate.dart';
import 'package:evnmobile/src/qltnkd/dialog/dialog_view_list_pdf.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/pdf_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'tab_certificate_controller.dart';

class TabCertificateScreen extends StatefulWidget {
  final String statusCertificate;
  bool isFilter;

  TabCertificateScreen({
    this.statusCertificate,
    this.isFilter = false,
  });

  @override
  State<StatefulWidget> createState() {
    return TabCertificateState();
  }
}

class TabCertificateState extends State<TabCertificateScreen>
    with AutomaticKeepAliveClientMixin<TabCertificateScreen>
    implements ListDelegate, ViewListPDFDelegate {
  final _controller = TabReportController();
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    _controller.viewListPDFDelegate = this;
    _controller.statusCertificate = widget.statusCertificate;
    _controller.renderTextBtn();
    Future.delayed(const Duration(milliseconds: 100),
        () => {_controller.getCertificate(ListTypeLoad.load)});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Column(
        children: [
          _buildBody(),
          Row(
            children: [
              if (_controller.isHasReject)
                Expanded(
                  child: RButton(
                      title: 'Từ chối',
                      borderRadius: 0,
                      color: RAppColor.colorOrange,
                      action: _controller.actionReject),
                ),
              if (_controller.isHasApproval)
                Expanded(
                  child: RButton(
                      title: _controller.textBtn,
                      borderRadius: 0,
                      action: _controller.actionApproval),
                )
            ],
          )
        ],
      ),
    );
  }

  Widget doFilter() {
    Future.delayed(const Duration(milliseconds: 100),
        () => {_controller.getCertificate(ListTypeLoad.load)});
    widget.isFilter = false;
    return Container();
  }

  Widget _buildBody() {
    return Expanded(child: Obx(() {
      if (_controller.isShowLoading.value) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(top: 30),
              child: const CircularProgressIndicator(),
            )
          ],
        );
      } else {
        return Stack(
          children: [
            if (widget.isFilter) doFilter(),
            if (_controller?.certificates?.obs?.value?.isEmpty == true &&
                _controller.isFirstLoad)
              const Center(
                child: Text(
                  RAppStrings.emptyData,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            _renderList()
          ],
        );
      }
    }));
  }

  Widget _renderList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _controller.isHasLoadMore.value ?? false,
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
      onLoading: _onLoadMore,
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Container(

            margin: const EdgeInsets.symmetric(horizontal: 16),
          );
        },
        itemBuilder: (context, index) {
          final certificate = _controller.certificates[index];
          return ItemCertificate(
            certificateModel: certificate,
            isHasCheckBox: _controller.isHasApproval,
            isLast: index == _controller.certificates.length -1,
            onSelect: (reportId, isSelected) {
              _controller.selectItem(reportId, isSelected: isSelected);
            },
            reloadData: () {
              _controller.getCertificate(ListTypeLoad.refresh);
            },
            signatureCertificate: () {
              _controller.signatureCertificate(certificate.id, certificate.code);
            },
            index: index,
          );
        },
        itemCount: _controller.certificates.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _controller.getCertificate(ListTypeLoad.refresh);
  }

  Future<void> _onLoadMore() async {
    await _controller.getCertificate(ListTypeLoad.loadMore);
  }

  @override
  void onLoadMoreSuccess() {
    _refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _refreshController.refreshCompleted();
  }

  @override
  bool get wantKeepAlive => false;

  @override
  Future showListPDF(List<PDFModel> listPDF) async {
    await showDialogListPDF(type: 2, context: context, listPDF: listPDF);
  }
}

