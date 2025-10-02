import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

enum EventTarget { firmEvent, newClient, caseMeeting }

extension EventTargetX on EventTarget {
  String label(BuildContext context) {
    switch (this) {
      case EventTarget.firmEvent:
        return context.tr('companyEvent');
      case EventTarget.newClient:
        return context.tr('newClient');
      case EventTarget.caseMeeting:
        return context.tr('caseMeeting');
    }
  }

  String get apiValue {
    switch (this) {
      case EventTarget.firmEvent:
        return "FIRM_EVENT";
      case EventTarget.newClient:
        return "NEW_CLIENT";
      case EventTarget.caseMeeting:
        return "CASE_MEETING";
    }
  }

  static EventTarget fromString(String? value) {
    switch (value?.toUpperCase()) {
      case "FIRM_EVENT":
        return EventTarget.firmEvent;
      case "NEW_CLIENT":
        return EventTarget.newClient;
      case "CASE_MEETING":
        return EventTarget.caseMeeting;
      default:
        throw ArgumentError("Unknown EventTarget: $value");
    }
  }
}
