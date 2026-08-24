import 'package:flutter/material.dart';
import 'package:evnmobile/app_env.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FileAttachmentBlock extends StatelessWidget {
  final String title;
  final String fileName;
  final String filePath;
  final String signedFilePath;
  final String fileSize;
  final VoidCallback onDownload;
  final VoidCallback onView;

  const FileAttachmentBlock({
    Key key,
    @required this.title,
    @required this.fileName,
    this.filePath,
    this.signedFilePath,
    this.fileSize,
    this.onDownload,
    this.onView,
  }) : super(key: key);

  void _viewFile() async {
    if (onView != null) {
      onView();
      return;
    }
    String path = signedFilePath ?? filePath;
    if (path == null || path.isEmpty) {
      SnackBarHUD.show('Chưa có file đính kèm');
      return;
    }
    if (!path.startsWith('http')) {
      if (!path.startsWith('/')) {
        path = '/$path';
      }
     path = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
    }
    
    if (!path.contains('access_token=')) {
      final token = AppShared.instance.getUserToken();
      final separator = path.contains('?') ? '&' : '?';
      path = '$path${separator}access_token=$token';
    }

    debugPrint('--- FileAttachmentBlock _viewFile: $path ---');

    final nameLower = (fileName ?? path).toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');
    
    if (isImage) {
      Get.to(() => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(fileName ?? 'Ảnh đính kèm', style: const TextStyle(fontSize: 16)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: PhotoView(
          imageProvider: NetworkImage(path),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ));
      return;
    }

    final isPdf = nameLower.endsWith('.pdf');
    if (isPdf) {
      Get.to(() => RPdfScreen(
            code: fileName ?? 'PDF',
            link: path,
          ));
      return;
    }

    final url = Uri.parse(path);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể mở đường dẫn file này');
    }
  }

  void _downloadFile() async {
    if (onDownload != null) {
      onDownload();
      return;
    }
    String path = filePath ?? signedFilePath;
    if (path == null || path.isEmpty) {
      SnackBarHUD.show('Chưa có file đính kèm');
      return;
    }
    if (!path.startsWith('http')) {
      if (!path.startsWith('/')) {
        path = '/$path';
      }
      path = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
    }

    if (!path.contains('access_token=')) {
      final token = AppShared.instance.getUserToken();
      final separator = path.contains('?') ? '&' : '?';
      path = '$path${separator}access_token=$token';
    }

    if (!path.contains('isDownload=')) {
      path = '$path&isDownload=true';
    }

    debugPrint('--- FileAttachmentBlock _downloadFile: $path ---');
    final url = Uri.parse(path);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể tải file này');
    }
  }

  IconData _getFileIcon() {
    final name = (fileName ?? filePath ?? '').toLowerCase();
    if (name.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (name.endsWith('.doc') || name.endsWith('.docx')) return Icons.description;
    if (name.endsWith('.xls') || name.endsWith('.xlsx')) return Icons.table_chart;
    if (name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.jpeg')) return Icons.image;
    return Icons.insert_drive_file;
  }

  Widget _buildFileThumbnail() {
    final nameLower = (fileName ?? filePath ?? '').toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');

    if (isImage) {
      String path = signedFilePath ?? filePath;
      if (path != null && path.isNotEmpty) {
        if (!path.startsWith('http')) {
          if (!path.startsWith('/')) {
            path = '/$path';
          }
          path = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
        }
        
        if (!path.contains('access_token=')) {
          final token = AppShared.instance.getUserToken();
          final separator = path.contains('?') ? '&' : '?';
          path = '$path${separator}access_token=$token';
        }

        return GestureDetector(
          onTap: _viewFile,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: path,
              httpHeaders: {
                'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
              },
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                  width: 40, height: 40, color: Colors.grey.shade200, child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))),
              errorWidget: (context, url, error) => Icon(_getFileIcon(), size: 40, color: Colors.blue),
            ),
          ),
        );
      }
    }
    return Icon(_getFileIcon(), size: 40, color: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    if ((filePath == null || filePath.isEmpty) && (signedFilePath == null || signedFilePath.isEmpty)) {
      return const SizedBox();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFileThumbnail(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName ?? (filePath?.split('/')?.last ?? 'File đính kèm'),
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (fileSize != null && fileSize.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        fileSize,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.visibility,
                label: 'Xem',
                onTap: _viewFile,
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.download,
                label: 'Tải xuống',
                onTap: _downloadFile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({@required IconData icon, @required String label, @required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

class FileItemModel {
  final String fileName;
  final String filePath;
  final String signedFilePath;
  final String fileSize;
  final VoidCallback onDownload;
  final VoidCallback onView;

  FileItemModel({
    @required this.fileName,
    this.filePath,
    this.signedFilePath,
    this.fileSize,
    this.onDownload,
    this.onView,
  });
}

class FileAttachmentGroupBlock extends StatelessWidget {
  final String title;
  final List<FileItemModel> files;

  const FileAttachmentGroupBlock({
    Key key,
    @required this.title,
    @required this.files,
  }) : super(key: key);

  void _viewFile(FileItemModel file) async {
    if (file.onView != null) {
      file.onView();
      return;
    }
    String path = file.signedFilePath ?? file.filePath;
    if (path == null || path.isEmpty) {
      SnackBarHUD.show('Chưa có file đính kèm');
      return;
    }
    if (!path.startsWith('http')) {
      if (!path.startsWith('/')) {
        path = '/$path';
      }
     path = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
    }
    if (!path.contains('access_token=')) {
      final token = AppShared.instance.getUserToken();
      final separator = path.contains('?') ? '&' : '?';
      path = '$path${separator}access_token=$token';
    }

    debugPrint('--- FileAttachmentGroupBlock _viewFile: $path ---');

    final nameLower = (file.fileName ?? path).toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');
    
    if (isImage) {
      Get.to(() => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(file.fileName ?? 'Ảnh đính kèm', style: const TextStyle(fontSize: 16)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        body: PhotoView(
          imageProvider: NetworkImage(path, headers: {
            'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
          }),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ));
      return;
    }

    final url = Uri.parse(path);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể mở đường dẫn file này');
    }
  }

  void _downloadFile(FileItemModel file) async {
    if (file.onDownload != null) {
      file.onDownload();
      return;
    }
    String path = file.filePath;
    if (path == null || path.isEmpty) {
      SnackBarHUD.show('Chưa có file đính kèm');
      return;
    }
    if (!path.startsWith('http')) {
      if (!path.startsWith('/')) {
        path = '/$path';
      }
      path = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
    }

    if (!path.contains('access_token=')) {
      final token = AppShared.instance.getUserToken();
      final separator = path.contains('?') ? '&' : '?';
      path = '$path${separator}access_token=$token';
    }

    debugPrint('--- FileAttachmentGroupBlock _downloadFile: $path ---');
    final url = Uri.parse(path);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      SnackBarHUD.show('Không thể tải file này');
    }
  }

  IconData _getFileIcon(FileItemModel file) {
    final name = (file.fileName ?? file.filePath ?? '').toLowerCase();
    if (name.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (name.endsWith('.doc') || name.endsWith('.docx')) return Icons.description;
    if (name.endsWith('.xls') || name.endsWith('.xlsx')) return Icons.table_chart;
    if (name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.jpeg')) return Icons.image;
    return Icons.insert_drive_file;
  }

  Widget _buildFileThumbnail(FileItemModel file) {
    final nameLower = (file.fileName ?? file.filePath ?? '').toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');

    if (isImage) {
      String path = file.signedFilePath ?? file.filePath;
      if (path != null && path.isNotEmpty) {
        if (!path.startsWith('http')) {
          if (!path.startsWith('/')) {
            path = '/$path';
          }
          path = '${AppEnv.getServerUrl().replaceAll('/api', '')}$path';
        }
        
        if (!path.contains('access_token=')) {
          final token = AppShared.instance.getUserToken();
          final separator = path.contains('?') ? '&' : '?';
          path = '$path${separator}access_token=$token';
        }

        return GestureDetector(
          onTap: () => _viewFile(file),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: path,
              httpHeaders: {
                'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
              },
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                  width: 40, height: 40, color: Colors.grey.shade200, child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))),
              errorWidget: (context, url, error) => Icon(_getFileIcon(file), size: 40, color: Colors.blue),
            ),
          ),
        );
      }
    }
    return Icon(_getFileIcon(file), size: 40, color: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    final validFiles = files.where((f) => (f.filePath != null && f.filePath.isNotEmpty) || (f.signedFilePath != null && f.signedFilePath.isNotEmpty)).toList();
    if (validFiles.isEmpty) {
      return const SizedBox();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          ...validFiles.map((file) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                _buildFileThumbnail(file),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.fileName ?? (file.filePath?.split('/')?.last ?? 'File đính kèm'),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (file.fileSize != null && file.fileSize.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          file.fileSize,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ]
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  icon: Icons.visibility,
                  label: 'Xem',
                  onTap: () => _viewFile(file),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.download,
                  label: 'Tải xuống',
                  onTap: () => _downloadFile(file),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButton({@required IconData icon, @required String label, @required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade700),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

