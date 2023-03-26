import 'package:boap_app/screens/history_screen.dart';
import 'package:boap_app/screens/send_money_screen.dart';
import 'package:boap_app/screens/shop_screen.dart';
import 'package:boap_app/services/shop_details.dart';
import 'package:boap_app/services/user_details.dart';
import 'package:boap_app/utils/widget_extensions.dart';
import 'package:boap_app/widgets/primary_button.dart';
import 'package:boap_app/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/secure_service.dart';
import '../utils/custom_colors.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  ShopDetails? nearbyShop;
  bool declined = false;

  @override
  void initState() {
    loadShop();
    super.initState();
  }

  Future loadShop() async {
    late double long, lat;
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position currentPosition = position;
    print(currentPosition.latitude);
    print(currentPosition.longitude);
    SecureService service = SecureService();
    final response = await service.getShops(currentPosition.latitude.toString(),
        currentPosition.longitude.toString());
    if (response.shopName != '') {
      nearbyShop = response;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Scaffold(
            backgroundColor: CustomColors.backgroundBlack,
            body: const CircularProgressIndicator().wrapCenter(),
          )
        : Scaffold(
            key: scaffoldKey,
            backgroundColor: CustomColors.backgroundBlack,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Hello ${UserDetails.currentUser.firstName}',
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      if (scaffoldKey.currentState!.isEndDrawerOpen) {
                        scaffoldKey.currentState!.closeEndDrawer();
                      } else {
                        scaffoldKey.currentState!.openEndDrawer();
                      }
                    },
                    icon: const Icon(
                      Icons.account_circle_outlined,
                      size: 36,
                    )).paddingForOnly(right: 10)
              ],
            ),
            endDrawer: Drawer(
              backgroundColor: CustomColors.backgroundBlack,
              elevation: 8,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  secondaryButton(context,
                          onPressed: () {}, label: 'Transaction History')
                      .paddingForOnly(left: 20, right: 20, bottom: 8, top: 150),
                  secondaryButton(context, onPressed: () {}, label: 'Settings')
                      .paddingWithSymmetry(horizontal: 20, vertical: 8),
                  primaryButton(context, onPressed: () {
                    SecureService service = SecureService();
                    service.clearStorage();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  }, label: 'Logout', processing: false)
                      .paddingWithSymmetry(horizontal: 20, vertical: 8),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              height: 50,
              width: 200,
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SendMoneyScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text('Send Money'),
                    Icon(Icons.attach_money_outlined)
                  ],
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (nearbyShop != null && declined != true)
                    ? Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Color(0xFF8F22CD),
                                  Color(0xFFB32295),
                                  Color(0xFFC1237E)
                                ]),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Text('Are you in ${nearbyShop!.shopName}?',
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700))
                                .paddingWithSymmetry(vertical: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShopScreen(
                                                  details: nearbyShop!)));
                                    },
                                    child: Text('Yes',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500))),
                                const Text(
                                  '|',
                                  style: TextStyle(
                                      fontSize: 26, color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      declined = true;
                                    });
                                  },
                                  child: Text('No',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      // elevation: 8,
                      color: CustomColors.backgroundBlack,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: const Color(0xFF202E34),
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.library_books_outlined,
                                color: Colors.white,
                                size: 36,
                              ).paddingForOnly(bottom: 8),
                              Text(
                                'Balance and History',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ).asButton(onTap: () async {
                            SecureService secure = SecureService();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Loading')));
                            final res = await secure.getHistory();
                            if (res.balance != '') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HistoryScreen(
                                          balance: res.balance,
                                          paymentHistory: res.history)));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error')));
                            }
                          }),
                        ).paddingWithSymmetry(horizontal: 10),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: const Color(0xFF202E34),
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.currency_exchange,
                                color: Colors.white,
                                size: 36,
                              ).paddingForOnly(bottom: 8),
                              Text(
                                'Pending settlements',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                        ).paddingWithSymmetry(horizontal: 10),
                      ),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: const Color(0xFF202E34),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_outlined,
                                color: Colors.white,
                                size: 36,
                              ).paddingForOnly(bottom: 8),
                              Text(
                                'Add Money',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                        ).paddingWithSymmetry(horizontal: 10),
                      )
                    ],
                  ),
                ).paddingForOnly(top: 20, bottom: 10),
                Row(
                  children: [
                    Text("Your Daily Streak",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            (index < 2)
                                ? Image.asset(
                                    'Assets/streak.png',
                                    width: 48,
                                    height: 48,
                                  )
                                : const Icon(
                                    Icons.lock_outline,
                                    size: 48,
                                  ),
                            Text(
                              'Day ${index + 1}',
                              style: GoogleFonts.roboto(
                                  color: Colors.white
                                      .withOpacity((index < 2) ? 1 : 0.25),
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700),
                            ).wrapCenter()
                          ],
                        ).paddingWithSymmetry(horizontal: 16, vertical: 8);
                      }),
                ),
                Text("Expense Tracker",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700))
                    .paddingWithSymmetry(vertical: 10),
              ],
            ).paddingForOnly(left: 20, right: 20, top: 50),
          );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
