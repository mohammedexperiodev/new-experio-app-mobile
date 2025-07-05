import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:taskez/Screens/Auth/new_workspace.dart';
import 'package:taskez/Values/values.dart';
// import 'package:taskez/widgets/DarkBackground/darkRadialBackground.dart';
// import 'package:taskez/widgets/Navigation/back.dart';
import 'package:taskez/Screens/Dashboard/timeline.dart';

class Login extends StatefulWidget {
  final String email;

  const Login({Key? key, required this.email}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isMobile = screenWidth < 600;
    final maxWidth = isMobile ? double.infinity : 400.0;

    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(

      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HexColor.fromHex("#181a1f"),
            HexColor.fromHex("#357ABD"),
            HexColor.fromHex("#357ABD"),

            // HexColor.fromHex("#87CEEB"), // Light blue
            // HexColor.fromHex("#4A90E2"), // Slightly darker blue
            // HexColor.fromHex("#357ABD"), // Even darker blue
            // HexColor.fromHex("#4A90E2"), // Slightly darker blue
            

          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),

        child: Column(
          children: [
            // Logo Section
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: [
                //       // HexColor.fromHex("#87CEEB"), // Light blue
                //       // HexColor.fromHex("#4A90E2"), // Slightly darker blue
                //       // HexColor.fromHex("#357ABD"), // Even darker blue
        
                //       HexColor.fromHex("#357ABD"),
                //       HexColor.fromHex("#181a1f"),
                //       HexColor.fromHex("#357ABD"),
                //       // HexColor.fromHex("#181a1f"),
                //     ],
                //     stops: const [0.0, 0.6, 1.0],
                //   ),
                // ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 230,
                          height: 170,
                          child: Image.asset(
                            'assets/logo_experio.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
            // Login Form Section
            Expanded(
              flex: 3,
              child: Transform.translate(
                offset: Offset(0, -30),
                child: Container(
                  width: double.infinity,
                  // padding: EdgeInsets.only(top: 30),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(30),
                  //     topRight: Radius.circular(30),
                  //   ),
                  // ),
                  child: SingleChildScrollView(
                    // reverse: true,
                    padding: EdgeInsets.all(isMobile ? 30.0 : 40.0),
                    child: Center(
                      child: Container(
                        width: maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
        
                            // Title - Centered
                            Center(
                              child: Text(
                                'Connexion',
                                style: GoogleFonts.lato(
                                  // color: HexColor.fromHex("#181a1f"),
                                  color: Colors.white,
                                  fontSize: isMobile ? 32 : 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
        
                            // Welcome message
                            Text(
                              "Bienvenue ! Veuillez saisir vos coordonnées",
                              style: GoogleFonts.lato(
                                // color: HexColor.fromHex("#181a1f"),
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 30),
        
                            // Email input field
                            _buildStyledFormInput(
                              label: "Adresse e-mail",
                              placeholder: "Saisissez votre e-mail",
                              controller: _nameController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                            ),
        
                            SizedBox(height: 20),
        
                            // Password input field
                            _buildStyledFormInput(
                              label: "Votre mot de passe",
                              placeholder: "Saisissez votre mot de passe",
                              controller: _passController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscurePassword,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: HexColor.fromHex("#4A90E2"),
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
        
                            SizedBox(height: isMobile ? 40 : 50),
        
                            // Sign In button
                            Container(
                              width: double.infinity,
                              height: isMobile ? 56 : 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    HexColor.fromHex("#4A90E2"),
                                    HexColor.fromHex("#357ABD"),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: HexColor.fromHex("#4A90E2")
                                        .withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  try {
                                    HapticFeedback.lightImpact();
                                  } catch (e) {
                                    // Haptic feedback not available, continue without it
                                  }
                                  Get.to(() => Timeline());
                                },
                                style: ElevatedButton.styleFrom(
                                  // backgroundColor: Colors.transparent,
                                  backgroundColor: Colors.black,
                                  // backgroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Se connecter',
                                  style: GoogleFonts.lato(
                                    fontSize: isMobile ? 18 : 20,
                                    color: Colors.white,
                                    // color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledFormInput({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool obscureText = false,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: GoogleFonts.lato(
              // color: HexColor.fromHex("#181a1f"),
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Text field container
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: GoogleFonts.lato(
              color: Colors.grey[800],
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.lato(
                color: Colors.grey[500],
                fontSize: 16,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: HexColor.fromHex("#4A90E2"),
                      size: 22,
                    )
                  : null,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: HexColor.fromHex("#4A90E2").withOpacity(0.6),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
