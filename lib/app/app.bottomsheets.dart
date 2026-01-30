// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/map_selection_sheet.dart';
import '../ui/bottom_sheets/payment_method_sheet.dart';

enum BottomSheetType {
  mapSelection,
  paymentMethod,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.mapSelection: (context, request, completer) =>
        MapSelectionSheet(request: request, completer: completer),
    BottomSheetType.paymentMethod: (context, request, completer) =>
        PaymentMethodSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
