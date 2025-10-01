import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String token = "33a8acc3d96b7cc78891a50b6b2e0b8fb0a5ec58";
const String defaultCity = "bangkok";

class AqiExample extends StatefulWidget {
  const AqiExample({super.key});

  @override
  State<AqiExample> createState() => _AqiExampleState();
}

class _AqiExampleState extends State<AqiExample> {
  bool loading = true;
  int? aqi;
  String? cityName;
  double? tempC;
  double? humidity;
  double? wind;
  double? pressure;
  double? pm25;
  double? pm10;
  String? updateText;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      loading = true;
      error = null;
    });

    final url = "https://api.waqi.info/feed/$defaultCity/?token=$token";

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) throw Exception("HTTP ${res.statusCode}");

      final body = json.decode(res.body);
      if (body["status"] != "ok")
        throw Exception("API status: ${body["status"]}");

      final data = body["data"];
      setState(() {
        aqi = data["aqi"] ?? 0;
        cityName = data["city"]?["name"] ?? defaultCity;
        tempC = (data['iaqi']?['t']?['v'] as num?)?.toDouble();
        humidity = (data['iaqi']?['h']?['v'] as num?)?.toDouble();
        wind = (data['iaqi']?['w']?['v'] as num?)?.toDouble();
        pressure = (data['iaqi']?['p']?['v'] as num?)?.toDouble();
        pm25 = (data['iaqi']?['pm25']?['v'] as num?)?.toDouble();
        pm10 = (data['iaqi']?['pm10']?['v'] as num?)?.toDouble();

        final ts = data['time']?['s'] as String?;
        if (ts != null) updateText = prettyTime(ts);

        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String prettyTime(String s) {
    final parts = s.split(' ');
    final datePart = parts[0];
    final timePart = parts[1].substring(0, 5);
    final date = DateTime.parse("$datePart $timePart:00");
    const weekdays = [
      'วันจันทร์',
      'วันอังคาร',
      'วันพุธ',
      'วันพฤหัสบดี',
      'วันศุกร์',
      'วันเสาร์',
      'วันอาทิตย์',
    ];
    return 'อัปเดตล่าสุด: ${weekdays[date.weekday - 1]} เวลา $timePart';
  }

  Map<String, dynamic> aqiStyle(int? aqi) {
    aqi ??= 0;
    if (aqi <= 50) {
      return {
        "color": Colors.blue,
        "emoji": "🌱",
        "label": "Good",
        "gradient": [Colors.lightBlue.shade300, Colors.lightBlue.shade100],
      };
    }
    if (aqi <= 100) {
      return {
        "color": Colors.green,
        "emoji": "🙂",
        "label": "Moderate",
        "gradient": [Colors.green.shade400, Colors.yellow.shade200],
      };
    }
    if (aqi <= 150) {
      return {
        "color": Colors.orange,
        "emoji": "😷",
        "label": "Unhealthy SG",
        "gradient": [Colors.orange.shade600, Colors.orange.shade200],
      };
    }
    if (aqi <= 200) {
      return {
        "color": Colors.red,
        "emoji": "🤒",
        "label": "Unhealthy",
        "gradient": [Colors.red.shade600, Colors.red.shade300],
      };
    }
    if (aqi <= 300) {
      return {
        "color": Colors.purple,
        "emoji": "💀",
        "label": "Very Unhealthy",
        "gradient": [Colors.deepPurple.shade700, Colors.purple.shade300],
      };
    }
    return {
      "color": Colors.black,
      "emoji": "☠️",
      "label": "Hazardous",
      "gradient": [Colors.brown.shade900, Colors.black],
    };
  }

  Widget observationCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ข้อมูลสภาพอากาศ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            infoRow("🌡️ อุณหภูมิ", tempC != null ? "$tempC °C" : "-"),
            infoRow("💧 ความชื้น", humidity != null ? "$humidity %" : "-"),
            infoRow("🌬️ ความเร็วลม", wind != null ? "$wind m/s" : "-"),
            infoRow(
              "📈 ความดันอากาศ",
              pressure != null ? "$pressure hPa" : "-",
            ),
            infoRow("🟤 PM2.5", pm25 != null ? "$pm25 µg/m³" : "-"),
            infoRow("🟠 PM10", pm10 != null ? "$pm10 µg/m³" : "-"),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = aqiStyle(aqi);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: style["gradient"],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                "${aqi ?? '-'}",
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: style["color"],
                ),
              ),
              Text(
                "${style["emoji"]} ${style["label"]}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: style["color"],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "📍 $cityName",
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              if (updateText != null)
                Text(
                  updateText!,
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 20),

              // Observation Card
              Expanded(child: SingleChildScrollView(child: observationCard())),

              // Refresh Button
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: fetchData,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
