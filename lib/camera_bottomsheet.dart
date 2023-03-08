import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraBottomSheet extends StatefulWidget {
  const CameraBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraBottomSheet> createState() => CameraBottomSheetState();
}

class CameraBottomSheetState extends State<CameraBottomSheet> {
  List<String> titleList = [
    'Camera bilan rasm olish',
    'Video olish',
    'Galerydan tanlash',
  ];
  List<ImageSource> sources = [
    ImageSource.camera,
    ImageSource.camera,
    ImageSource.gallery,
  ];

  int selectedCamera = 0;
  late final ValueChanged<ImageSource> imageType;

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              const Text("Tanlang"),
              const Spacer(),
              IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Colors.red,
            ),
            itemCount: 3,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => _ItemSelect(
              index: index,
              text: titleList[index],
              imageType: sources[index],
              onTapImageType: (index) {
                Navigator.of(context).pop(index);
              },
            ),
          ),
        ]),
      );
}

class _ItemSelect extends StatelessWidget {
  final String text;
  final ValueChanged<int> onTapImageType;
  final ImageSource imageType;
  final int index;

  const _ItemSelect({
    required this.text,
    required this.imageType,
    required this.onTapImageType,
    required this.index,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onTapImageType(index),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      );
}
