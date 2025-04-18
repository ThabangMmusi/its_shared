import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../commands/app/authenticate_desktop_command.dart';
import '../../cubits/cubits_enum.dart';
import '../../cubits/desktop_auth/desktop_auth_cubit.dart';
import '../../styles.dart';
import '../../widgets/my_dialog_box.dart';
import '../app_logo.dart';

class AwaitAuthDialog extends StatefulWidget {
  const AwaitAuthDialog({super.key});

  @override
  State<AwaitAuthDialog> createState() => _AwaitAuthDialogState();
}

class _AwaitAuthDialogState extends State<AwaitAuthDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialogNew(
      content: BlocBuilder<DesktopAuthCubit, DesktopAuthState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status == CubitStatus.submitting
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            backgroundColor: Colors.black12,
                          )),
                      VSpace.med,
                      const Text(
                        "Finalizing...",
                      )
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogoWidget(showSlogan: false),
                      VSpace(Insets.med),
                      Text(
                        "Login using browser...",
                        style: TextStyles.h1,
                      ),
                      VSpace(Insets.xl),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyles.h3,
                          children: <TextSpan>[
                            TextSpan(
                              text: "Not seeing the browser tab? ",
                              style:
                                  TextStyles.h3.copyWith(color: Colors.black45),
                            ),
                            TextSpan(
                                text: 'Try Again',
                                style:
                                    TextStyles.h3.copyWith(color: Colors.black),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    await AuthenticateDesktopCommand()
                                        .openLoginTab();
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
      //todo: verify if constraints are still required on this desktop and also manage them;
      // constraints: const BoxConstraints(maxHeight: 280, maxWidth: 500),
    );
  }
}
