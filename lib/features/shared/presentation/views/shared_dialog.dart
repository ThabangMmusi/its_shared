import 'package:flutter/material.dart';
import 'package:its_shared/features/shared/presentation/views/base_shared_view.dart';
import 'package:its_shared/styles.dart';

import '../../../../widgets/my_dialog_box.dart';

class SharedFileDialog extends StatelessWidget {
  const SharedFileDialog({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return CustomDialogNew(
      showCloseButton: true,
      content: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 201),
          child: Padding(
            padding: EdgeInsets.only(top: Insets.xl),
            child: const BaseSharedView(),
          )),
    );
  }
}
