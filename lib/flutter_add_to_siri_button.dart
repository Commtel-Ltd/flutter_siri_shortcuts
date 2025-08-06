/// Native iOS "Add to Siri" Button Widget
/// 
/// This file provides the [AddToSiriButton] widget which renders
/// the native iOS "Add to Siri" button component.
library flutter_add_to_siri_button;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AddToSiriButton extends StatelessWidget {
  final String title;
  final String id;
  final double? height;

  const AddToSiriButton({
    super.key,
    required this.title,
    required this.id,
    this.height = 44.0,
  });

  @override
  Widget build(BuildContext context) {
    const String viewType = 'AddToSiriButton';
    Map<String, dynamic> creationParams = <String, dynamic>{
      'title': title,
      'id': id,
    };

    return SizedBox(
      height: height ?? 44.0,
      child: UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
