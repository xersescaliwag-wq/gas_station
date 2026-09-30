/// Talks to the Raspberry Pi at the station.
/// The calls are simulated - swap them for real HTTP / MQTT requests.
class PiService {
  /// e.g. 192.168.1.20 (Pi runs its API on :5000)
  final String host;
  const PiService({this.host = '192.168.1.20'});

  /// Replace with: http.get(Uri.parse('http://$host:5000/ping'))
  Future<bool> ping() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }

  /// Replace with:
  /// http.post(Uri.parse('http://$host:5000/prices'), body: jsonEncode(prices))
  Future<bool> pushPrices(Map<String, double> prices) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return true;
  }
}
