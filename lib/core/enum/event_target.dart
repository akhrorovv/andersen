enum EventTarget { firmEvent, newClient, caseMeeting }

extension EventTargetX on EventTarget {
  String get label {
    switch (this) {
      case EventTarget.firmEvent:
        return "Company Event";
      case EventTarget.newClient:
        return "New Client";
      case EventTarget.caseMeeting:
        return "Case Meeting";
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
