import 'dart:async';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inlovewithher/global.dart';
import 'package:inlovewithher/permission_service.dart';
import 'package:inlovewithher/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress_ds/video_compress_ds.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import 'dialog_utils.dart';
import 'models/image_picker_model.dart';

const int minContentLengthTicket = 20;
const int maxFileImageSizeMB = 10;
const int maxFileVideoSizeMB = 100;
const int maxVideoSeconds = 40;

class CameraHelper {
  static final CameraHelper _instance = CameraHelper._internal();

  CameraHelper._internal();

  factory CameraHelper() {
    return _instance;
  }

  List<CameraDescription> cameras = [];

  Future<bool> _checkPhotoPermission() async {
    try {
      PermissionStatus status = await PermissionsService().listenForPermissionStatus(Permission.photos, true);
      if (status != PermissionStatus.granted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          openAppSettings();
        });
      }
      return status == PermissionStatus.granted;
    } catch (err) {
      openAppSettings();
      return false;
    }
  }

  Future<List<ImagesPickerModel>> pickMedia(
    BuildContext context, {
    List<ImagesPickerModel>? currentListFile,
    int maxAssetSelect = 9,
    RequestType requestType = RequestType.image,
    bool showCamera = true,
    bool enabledRecording = false,
  }) async {
    if (showCamera) {
      cameras = await availableCameras();
    }
    List<ImagesPickerModel> result = [];
    if (!await _checkPhotoPermission()) {
      return [];
    }
    List<AssetEntity> listPicked = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            // selectedAssets: selectedAssets,
            maxAssets: maxAssetSelect - (currentListFile ?? []).length,
            requestType: requestType,
            filterOptions: FilterOptionGroup(
              imageOption: const FilterOption(),
              videoOption: const FilterOption(
                durationConstraint: DurationConstraint(max: Duration(seconds: maxVideoSeconds)),
              ),
            ),
            textDelegate: const NPAssetPickerTextDelegate(),
            specialItemBuilder: (_, __, ___) {
              if (cameras.isNotEmpty) {
                return DisplayCamera(
                  enabledRecording: enabledRecording,
                  onCaptured: (picked) {
                    result.add(picked);
                    globalContext.pop();
                  },
                );
              }
              return const SizedBox.shrink();
            },
            specialItemPosition: SpecialItemPosition.prepend,
          ),
          permissionRequestOption: const PermissionRequestOption(),
        ) ??
        [];
    Loading().show();
    if (listPicked.isNotEmpty) {
      await Future.forEach<AssetEntity>(listPicked, (element) async {
        if (element.type == AssetType.image) {
          File? fileImage = await element.originFile;
          if (fileImage != null) {
            double fileSizeMB = fileImage.lengthSync() / 1024 / 1024; // Byte
            if (fileSizeMB < maxFileImageSizeMB) {
              ImagesPickerModel picked =
                  ImagesPickerModel(media: fileImage.path, url: '', state: 'none', asset: element);
              result.add(picked);
            } else {
              showToast('Dung lượng file quá lớn');
            }
          }
        } else if (element.type == AssetType.video) {
          File? fileVideo = await element.originFile;
          if (fileVideo != null) {
            double sizeMB = fileVideo.lengthSync() / 1024 / 1024;
            String path = fileVideo.path;
            if (!Platform.isIOS) {
              MediaInfo? media = await compressVideo(fileVideo.path);
              if (media != null) {
                sizeMB = (media.filesize ?? 0) / 1024 / 1024;
                path = media.path ?? "";
              }
            }
            if (sizeMB < maxFileVideoSizeMB) {
              ImagesPickerModel picked = ImagesPickerModel(media: path, url: '', state: 'none', asset: element);
              result.add(picked);
            } else {
              showToast('Dung lượng file quá lớn');
            }
          }
        }
      });
    }
    Loading().dismiss();
    return result;
  }

  Future<ImagesPickerModel?> openCamera({
    bool enabledRecording = false,
  }) async {
    ImagesPickerModel? picked;
    try {
      final AssetEntity? entity = await CameraPicker.pickFromCamera(
        globalContext,
        pickerConfig: CameraPickerConfig(
          enableRecording: enabledRecording,
          textDelegate: const NPCameraPickerTextDelegate(),
          maximumRecordingDuration: const Duration(seconds: maxVideoSeconds),
          shouldDeletePreviewFile: true,
        ),
      );
      File? file = await entity?.originFile;
      if (entity != null && file != null) {
        int fileSize = file.lengthSync(); // Byte
        int maxFileSize = 0;
        if (entity.type == AssetType.image) {
          maxFileSize = maxFileImageSizeMB * 1024 * 1024;
        }
        if (entity.type == AssetType.video) {
          maxFileSize = maxFileVideoSizeMB * 1024 * 1024;
        }
        if (fileSize > maxFileSize) {
          showToast("Dung lượng file quá lớn");
          return null;
        } else {
          picked = ImagesPickerModel(media: file.path, url: '', state: 'none', asset: entity);
        }
      }
      return picked;
    } catch (e) {
      return null;
    }
  }

  Future<MediaInfo?> compressVideo(String path) async {
    MediaInfo? media = await VideoCompress.compressVideo(
      path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false, // It's false by default
    );
    return media;
  }
}

class DisplayCamera extends StatefulWidget {
  const DisplayCamera({
    Key? key,
    this.enabledRecording = false,
    this.onCaptured,
  }) : super(key: key);
  final bool enabledRecording;
  final Function(ImagesPickerModel pikced)? onCaptured;

  @override
  State<DisplayCamera> createState() => _DisplayCameraState();
}

class _DisplayCameraState extends State<DisplayCamera> with AfterLayoutMixin, RouteAware {
  late final CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(CameraHelper().cameras[0], ResolutionPreset.medium);
    _initController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void _initController() {
    if (controller.value.isInitialized) {
      return;
    }
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
      onTap: () async {
        var captured = await CameraHelper().openCamera(enabledRecording: widget.enabledRecording);
        _initController();
        await controller.resumePreview();
        if (captured != null) {
          widget.onCaptured?.call(captured);
        }
      },
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            CameraPreview(controller),
            const Icon(Icons.camera_alt, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    throw UnimplementedError();
  }
}

class NPAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const NPAssetPickerTextDelegate();

  @override
  String get languageCode => 'vn';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Huỷ';

  @override
  String get edit => 'Sửa';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get original => 'Origin';

  @override
  String get preview => 'Xem trước';

  @override
  String get select => 'Select';

  @override
  String get emptyList => 'Danh sách trống';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';

  @override
  String get unableToAccessAll => 'Unable to access all assets on the device';

  @override
  String get viewingLimitedAssetsTip => 'Only view assets and albums accessible to app.';

  @override
  String get changeAccessibleLimitedAssets => 'Click to update accessible assets';

  @override
  String get accessAllTip => 'App can only access some assets on the device. '
      'Go to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Go to system settings';

  @override
  String get accessLimitedAssets => 'Continue with limited access';

  @override
  String get accessiblePathName => 'Accessible assets';

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Image';

  @override
  String get sTypeVideoLabel => 'Video';

  @override
  String get sTypeOtherLabel => 'Other asset';

  @override
  String get sActionPlayHint => 'play';

  @override
  String get sActionPreviewHint => 'xem';

  @override
  String get sActionSelectHint => 'chọn';

  @override
  String get sActionSwitchPathLabel => 'đổi đường dẫn';

  @override
  String get sActionUseCameraHint => 'sử dụng camera';

  @override
  String get sNameDurationLabel => 'thời lượng';

  @override
  String get sUnitAssetCountLabel => 'số lượng';
}

class NPCameraPickerTextDelegate extends CameraPickerTextDelegate {
  const NPCameraPickerTextDelegate();

  @override
  String get languageCode => 'vn';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get shootingTips => 'Chọn để chụp ảnh.';

  @override
  String get shootingWithRecordingTips => 'Chọn để chụp ảnh. Nhấn và giữ để quay video.';

  @override
  String get shootingOnlyRecordingTips => 'Nhấn và giữ để quay video.';

  @override
  String get shootingTapRecordingTips => 'Chọn để quay video.';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get loading => 'Loading...';

  @override
  String get saving => 'Saving...';

  @override
  String get sActionManuallyFocusHint => 'manually focus';

  @override
  String get sActionPreviewHint => 'Xem trước';

  @override
  String get sActionRecordHint => 'record';

  @override
  String get sActionShootHint => 'take picture';

  @override
  String get sActionShootingButtonTooltip => 'shooting button';

  @override
  String get sActionStopRecordingHint => 'stop recording';

  @override
  String sCameraLensDirectionLabel(CameraLensDirection value) => value.name;

  @override
  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return '${sCameraLensDirectionLabel(value)} camera preview';
  }

  @override
  String sFlashModeLabel(FlashMode mode) => 'Flash mode: ${mode.name}';

  @override
  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) =>
      'Switch to the ${sCameraLensDirectionLabel(value)} camera';
}
