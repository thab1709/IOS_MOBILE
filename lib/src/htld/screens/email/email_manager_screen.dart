// @dart=2.9
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/models/email_model.dart';
import 'package:evnmobile/src/htld/screens/email/email_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmailManagerScreen extends StatefulWidget {
  const EmailManagerScreen({Key key}) : super(key: key);

  @override
  State<EmailManagerScreen> createState() => _EmailManagerScreenState();
}

class _EmailManagerScreenState extends State<EmailManagerScreen> {
  final controller = Get.put(EmailManagerController());
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), controller.fetchEmails);
  }

  Future<void> _onRefresh() async {
    await controller.fetchEmails();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Email'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.emails.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.emails.isEmpty) {
          return SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
              refresh: Container(),
              complete: const Icon(
                Icons.done,
                color: AppColor.highlightColor70,
              ),
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: const Center(child: Text('Chưa có email nào')),
          );
        }
        return SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(
            refresh: Container(),
            complete: const Icon(
              Icons.done,
              color: AppColor.highlightColor70,
            ),
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.separated(
            itemCount: controller.emails.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final email = controller.emails[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.grey.shade300,
                  shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    0,
                  ),
                  title: Text(
                    email.email ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteDialog(email),
                  ),
                  // onLongPress: () {
                  //   _showDeleteDialog(email);
                  // },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEmailDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEmailDialog() {
    final emailController = TextEditingController();
    Get.defaultDialog(
      title: "Thêm Email",
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "Nhập Email",
            border: OutlineInputBorder(),
          ),
        ),
      ),
      confirm: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColor.highlightColor70,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text("Thêm", style: TextStyle(color: Colors.white)),
        ),
        onPressed: () {
          Get.back();
          Future.delayed(const Duration(milliseconds: 200), () {
            controller.addEmail(emailController.text.trim());
          });
        },
      ),
      cancel: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child:
              Text("Hủy", style: TextStyle(color: AppColor.highlightColor70)),
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  void _showDeleteDialog(EmailModel email) {
    Get.defaultDialog(
      title: "Xóa Email",
      middleText: "Bạn có muốn xóa email ${email.email} không?",
      confirm: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: AppColor.highlightColor70,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text("Xóa", style: TextStyle(color: Colors.white)),
        ),
        onPressed: () {
          Get.back();
          Future.delayed(const Duration(milliseconds: 200), () {
            if (email.id != null) {
              controller.deleteEmail(email.id);
            }
          });
        },
      ),
      cancel: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child:
              Text("Hủy", style: TextStyle(color: AppColor.highlightColor70)),
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}

