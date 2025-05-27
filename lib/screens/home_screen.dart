import 'dart:async';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Color theme
const Color primaryColor = Color(0xFF1E3A8A); // blue-900
const Color secondaryColor = Color(0xFF06B6D4); // cyan-500
const Color backgroundColor = Color(0xFFF0F9FF); // blue-50
const Color textDark = Color(0xFF1F2937); // gray-800
const Color textLight = Color(0xFF4B5563); // gray-600

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Carousel state
  int _currentSlide = 0;
  final List<String> _heroImages = [
    'assets/images/Budalangi1.jpeg',
    'assets/images/Budalangi3.jpg',
    'assets/images/Budalangi8.jpeg',
    'assets/images/Budalangi9.jpeg',
    'assets/images/Budalangi6.jpeg',
  ];
  late PageController _pageController;
  Timer? _timer;

  // Subscription form state
  String _subscriptionMethod = '';
  String _contact = '';
  List<String> _selectedLocations = [];
  bool _isSubmitting = false;

  // FAQ state
  int? _openFAQ;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentSlide);
    _startCarousel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startCarousel() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentSlide = (_currentSlide + 1) % _heroImages.length;
        _pageController.animateToPage(
          _currentSlide,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      });
    });
  }

  Future<void> _submitSubscription() async {
    if (_subscriptionMethod.isEmpty || _contact.isEmpty || _selectedLocations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All fields are required')));
      return;
    }
    // Basic validation
    if (_subscriptionMethod == 'email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_contact)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email format')));
      return;
    }
    if (_subscriptionMethod == 'sms' && !RegExp(r'^\+2547\d{8}$').hasMatch(_contact)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid phone format (+2547XXXXXXXX)')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/subscriptions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'method': _subscriptionMethod,
          'contact': _contact,
          'locations': _selectedLocations,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subscription successful')));
        setState(() {
          _subscriptionMethod = '';
          _contact = '';
          _selectedLocations = [];
        });
      } else {
        throw Exception('Failed to subscribe');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildHeroSection(),
          _buildWhatWeDoSection(),
          _buildDonateSection(),
          _buildSubscriptionSection(),
          _buildReportNowSection(),
          _buildPublicationsSection(),
          _buildFAQSection(),
          _buildImpactSection(),
          _buildContactSection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _heroImages.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _heroImages[index],
                fit: BoxFit.cover,
              );
            },
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Flood Monitoring and Alert System',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Stay informed, stay safe. Real-time flood monitoring and alerts for your community.',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGradientButton('Donate Now', '/donate'),
                    const SizedBox(width: 16),
                    _buildGradientButton('View Alerts', '/alerts', reverseGradient: true),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _heroImages.map((image) {
                int index = _heroImages.indexOf(image);
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentSlide == index ? Colors.white : Colors.white.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatWeDoSection() {
    final items = [
      {'title': 'Flood Monitoring', 'icon': Icons.location_on, 'image': 'assets/images/floodMonitoring.png', 'text': 'Real-time monitoring of flood-prone areas.'},
      {'title': 'Flood Alerts', 'icon': Icons.notifications, 'image': 'assets/images/alert.png', 'text': 'Timely alerts to keep you informed.'},
      {'title': 'Resource Allocation', 'icon': Icons.favorite, 'image': 'assets/images/resourceAllocation.png', 'text': 'Efficient distribution of resources.'},
      {'title': 'Flood Response', 'icon': Icons.security, 'image': 'assets/images/floodResponse.png', 'text': 'Coordinated response efforts.'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white.withOpacity(0.9),
      child: Column(
        children: [
          const Text('What We Do', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 1,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Image.asset(item['image']!, height: 100, fit: BoxFit.contain),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(item['icon'] as IconData, size: 48, color: primaryColor),
                    ),
                    Text(item['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item['text']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: textLight)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDonateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.bottomRight, end: Alignment.topLeft)),
      child: Column(
        children: [
          const Text('Support Our Cause', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          const Text(
            'Your donation helps us provide critical resources and support to flood-affected communities.',
            style: TextStyle(fontSize: 18, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildGradientButton('Donate Now', '/donate'),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    final locations = [
      "Bumadeya", "Budalangi Central", "Budubusi", "Mundere", "Musoma", "Sibuka", "Sio Port", "Rukala",
      "Mukhweya", "Sigulu Island", "Siyaya", "Nambuku", "West Bunyala", "East Bunyala", "South Bunyala",
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Column(
        children: [
          const Text('Subscribe to Alerts', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 16),
          Form(
            child: Column(
              children: [
                if (_subscriptionMethod == 'sms')
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.yellow[100],
                    child: const Text('Dial *456*9*5# to subscribe via SMS', style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
                  ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Subscription Method', border: OutlineInputBorder()),
                  value: _subscriptionMethod.isNotEmpty ? _subscriptionMethod : null,
                  items: ['email', 'sms'].map((method) => DropdownMenuItem(value: method, child: Text(method.toUpperCase()))).toList(),
                  onChanged: (value) => setState(() => _subscriptionMethod = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: _subscriptionMethod == 'email' ? 'Email' : 'Phone Number',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => _contact = value,
                ),
                const SizedBox(height: 16),
                MultiSelectDialogField(
                  items: locations.map((loc) => MultiSelectItem(loc, loc)).toList(),
                  title: const Text('Select Locations'),
                  selectedColor: secondaryColor,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                  buttonText: const Text('Select Locations'),
                  onConfirm: (values) => setState(() => _selectedLocations = values.cast<String>()),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitSubscription,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [secondaryColor, primaryColor]),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Subscribe', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportNowSection() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/Budalangi3.jpg'), fit: BoxFit.cover),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Report a Flood Now', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              const Text('Help us respond quickly by reporting floods in your area.', style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 16),
              _buildGradientButton('Report Now', '/report'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPublicationsSection() {
    final publications = [
      {'title': 'Flood Handbook', 'image': 'assets/images/flood.png', 'desc': 'A guide to flood preparedness.', 'link': '/pdfs/EmergencyPlan.pdf'},
      {'title': 'Flood Tutorial', 'image': 'assets/images/alert.png', 'desc': 'Video on flood safety.', 'link': 'https://www.youtube.com/watch?v=i906ouUW-hw'},
      {'title': 'Emergency Protocol', 'image': 'assets/images/Budalangi3.jpg', 'desc': 'Emergency response plan.', 'link': 'https://reliefweb.int/report/kenya/kenya-el-nino-floods-2023-emergency-appeal-mdrke058'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          const Text('Publications & Videos', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
              childAspectRatio: 0.7,
            ),
            itemCount: publications.length,
            itemBuilder: (context, index) {
              final pub = publications[index];
              return Card(
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(pub['image']!, height: 100, fit: BoxFit.contain),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(pub['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(pub['desc']!, style: const TextStyle(fontSize: 14, color: textLight)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {}, // Replace with actual link handling if needed
                            style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildGradientButton('View More', '/userResources'),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {'question': 'What is FMAS?', 'answer': 'FMAS is a flood monitoring and alert system.'},
      {'question': 'How can I subscribe to alerts?', 'answer': 'You can subscribe via email or SMS.'},
      {'question': 'How do I report a flood?', 'answer': 'Use the report feature in the app.'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Column(
        children: [
          const Text('Frequently Asked Questions', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 16),
          ...faqs.asMap().entries.map((entry) => ExpansionTile(
            title: Text(entry.value['question']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [Padding(padding: const EdgeInsets.all(16), child: Text(entry.value['answer']!))],
            onExpansionChanged: (expanded) => setState(() => _openFAQ = expanded ? entry.key : null),
          )),
          const SizedBox(height: 16),
          _buildGradientButton('Learn More', '/faq'),
        ],
      ),
    );
  }

  Widget _buildImpactSection() {
    final stats = [
      {'label': 'County Branches', 'value': '12', 'icon': Icons.map, 'image': 'assets/images/regional.png'},
      {'label': 'Regional Offices', 'value': '20', 'icon': Icons.group, 'image': 'assets/images/volunti.png'},
      {'label': 'Members & Volunteers', 'value': '5k+', 'icon': Icons.group, 'image': 'assets/images/volunteer.png'},
      {'label': 'Beneficiaries Supported', 'value': '1k+', 'icon': Icons.favorite, 'image': 'assets/images/beneficiary.png'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.bottomRight, end: Alignment.topLeft)),
      child: Column(
        children: [
          const Text('Our Impact', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 1,
              childAspectRatio: 0.8,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return Card(
                elevation: 4,
                child: Column(
                  children: [
                    Image.asset(stat['image']!, height: 100, fit: BoxFit.contain),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(stat['icon'] as IconData, size: 48, color: primaryColor),
                    ),
                    Text(stat['value']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(stat['label']!, style: const TextStyle(fontSize: 14, color: textLight)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Column(
        children: [
          const Text('Contact Us', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 16),
          const Text('Have questions or need support? Reach out to us.', style: TextStyle(fontSize: 18, color: textLight)),
          const SizedBox(height: 16),
          _buildGradientButton('Contact Us', '/contact'),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text, String route, {bool reverseGradient = false}) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: reverseGradient ? [primaryColor, secondaryColor] : [secondaryColor, primaryColor],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );1
  }
}