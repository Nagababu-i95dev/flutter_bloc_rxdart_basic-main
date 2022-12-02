import 'package:geocoding/geocoding.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc {
//  final position = BehaviorSubject<Position>();
  final address = BehaviorSubject<String>();
  fetchAddressFromLatLong(double lat, double lng) async {
    String currentAddress;
    try {
      await placemarkFromCoordinates(lat, lng)
          .then((List<Placemark> placeMarks) {
        Placemark place = placeMarks[0];
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        address.sink.add(currentAddress);
      });
    } catch (e) {
      address.sink.addError(e);
    }
  }

  Stream<String> get currentAddress => address.stream;
}

final locationBloc = LocationBloc();
