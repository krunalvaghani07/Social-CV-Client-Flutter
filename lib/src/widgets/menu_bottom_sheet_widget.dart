import 'package:flutter/material.dart';
import 'package:social_cv_client_flutter/src/localizations/cv_localization.dart';
import 'package:social_cv_client_flutter/src/utils/navigation.dart';
import 'package:social_cv_client_flutter/src/widgets/account_tile_widget.dart';
import 'package:social_cv_client_flutter/src/widgets/theme_switch_tile_widget.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({
    Key key,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.only(
        topLeft: const Radius.circular(10.0),
        topRight: const Radius.circular(10.0)),
  }) : super(key: key);

  final Color backgroundColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Wrap(
        children: <Widget>[
          AccountTile(),
          Divider(),
          ThemeSwitchTile(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(CVLocalizations.of(context).settingsCTA),
            onTap: () => navigateToSettings(context),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text(CVLocalizations.of(context).menuPPCTA),
                onPressed: null,
              ),
              Text(CVLocalizations.of(context).middleDot),
              MaterialButton(
                child: Text(CVLocalizations.of(context).menuToSCTA),
                onPressed: null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
