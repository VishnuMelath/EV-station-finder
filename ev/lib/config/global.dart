import 'dart:io';

Future printIps() async {
  for (var interface in await NetworkInterface.list()) {
    for (var _ in interface.addresses) {
      if (interface.name == "wlp0s20f3") {
        return (interface.addresses).toString().split('\'')[1];
      }
    }
  }
}

var endPointBase = printIps();
