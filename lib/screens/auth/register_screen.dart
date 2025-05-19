import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for each input
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // For dropdown & detection
  final List<String> _locations = [
    "Bumadeya", "Budalangi Central", "Budubusi", "Mundere", "Musoma",
    "Sibuka", "Sio Port", "Rukala", "Mukhweya", "Sigulu Island",
    "Siyaya", "Nambuku", "West Bunyala", "East Bunyala", "South Bunyala"
  ];
  String? _selectedLocation;
  bool _locationDetected = false;

  // Password visibility
  bool _showPass = false, _showConfirm = false;
  bool _isSubmitting = false;

  // Geolocate and reverse-geocode
  // Future<void> _detectLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Fluttertoast.showToast(msg: "Enable location services");
  //     return;
  //   }
  //   LocationPermission perm = await Geolocator.checkPermission();
  //   if (perm == LocationPermission.denied) {
  //     perm = await Geolocator.requestPermission();
  //     if (perm == LocationPermission.denied) {
  //       Fluttertoast.showToast(msg: "Location permission denied");
  //       return;
  //     }
  //   }
  //   Position pos = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   // TODO: call your reverse-geocoding API here to get city/town
  //   setState(() {
  //     _selectedLocation = "Detected Town"; // replace with real result
  //     _locationDetected = true;
  //   });
  //   Fluttertoast.showToast(msg: "Location detected: $_selectedLocation");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                // Username
                TextFormField(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: const InputDecoration(
                      labelText: "Phone Number",
                      hintText: "+2547XXXXXXXX"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _showPass = !_showPass),
                    ),
                  ),
                  obscureText: !_showPass,
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmCtrl,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    suffixIcon: IconButton(
                      icon: Icon(_showConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _showConfirm = !_showConfirm),
                    ),
                  ),
                  obscureText: !_showConfirm,
                ),
                const SizedBox(height: 16),

                // Location dropdown + detect button
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        items: _locations
                            .map((loc) =>
                            DropdownMenuItem(value: loc, child: Text(loc)))
                            .toList(),
                        onChanged: _locationDetected
                            ? null
                            : (val) => setState(() {
                          _selectedLocation = val;
                        }),
                        decoration:
                        const InputDecoration(labelText: "Location"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ElevatedButton(
                    //   onPressed: _locationDetected ? null : _detectLocation,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.green[600], // bg-green-600
                    //   ),
                    //   child: const Text("Detect"),
                    // ),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : () {/* TODO: call API */},
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.blue[600], // bg-blue-600
                      foregroundColor: Colors.white),
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text("Register"),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
}
