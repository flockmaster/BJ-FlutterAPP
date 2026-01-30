// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedDialogGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/dialogs/booking_success_dialog.dart';

enum DialogType {
  bookingSuccess,
}

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final Map<DialogType, DialogBuilder> builders = {
    DialogType.bookingSuccess: (context, request, completer) =>
        BookingSuccessDialog(request: request, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}
