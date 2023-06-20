import 'package:flutter/material.dart';


class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // First color
              Color(0xFF07abb8), // Second color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Terms and conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          fontFamily: 'Sora'
                        ),
                      ),
                      const SizedBox(height: 16.0),
                        _buildSubheading('Terms of Service for Gogobook\nLast Updated: May 21, 2023\n\n'),
                        _buildText('Welcome to Gogobook! Before using our app, we kindly ask you to carefully read the following Terms of Service. These terms govern your use of the Gogobook app and establish the rights and obligations of both the user and Gogobook. By using the app, you unconditionally accept these Terms of Service.\n\n'),
                        _buildHeading('1. Collection and Use of Data'),
                        _buildSubheading('1.1 Collection of Personal Data'),
                        _buildText('Gogobook collects and uses users\' personal data in order to provide a personalized and high-quality reading experience. The personal data collected may include, but is not limited to, information such as name, email address, reading preferences, and other data related to your reading habits.\n\n'),
                        _buildSubheading('1.2 Use of Personal Data'),
                        _buildText('Gogobook uses the collected personal data to provide targeted book recommendations, suggestions, and related services. Personal data may also be used to enhance and personalize the user experience within the app.\n\n'),
                        _buildHeading('2. Protection of Minors'),
                        _buildSubheading('2.1 Use by Minors'),
                        _buildText('Gogobook is exclusively intended for individuals aged 18 or above. The use of the app by minors is only permitted with the consent of parents or a legal guardian. Gogobook does not knowingly collect personal data from minors without verifiable parental consent. If we become aware of personal data collected from minors without parental consent, we will promptly delete such data.\n\n'),
                        _buildHeading('3. Copyright Issues'),
                        _buildSubheading('3.1 Copyright Compliance'),
                        _buildText('Gogobook is committed to respecting the intellectual property rights of others, including copyrights. If you encounter any copyright issues regarding any content within the app, please contact us immediately with relevant information. We will take appropriate measures to address the matter and, if necessary, remove the infringing content.\n\n'),
                        _buildSubheading('3.2 User-Generated Content'),
                        _buildText('Gogobook encourages users to share their opinions and reading suggestions. However, users are responsible for the content they post within the app. Gogobook disclaims any liability for any copyright violations or other legal issues arising from user-generated content. In case of copyright infringement reports related to user-generated content, we will take appropriate actions.\n\n'),
                        _buildHeading('4. Changes to the Terms of Service'),
                        _buildSubheading('4.1 Updates to the Terms of Service'),
                        _buildText('Gogobook reserves the right to make changes to these Terms of Service at any time without prior notice. Please periodically check this page to stay informed of any updates. Your continued use of the app after the publication of changes constitutes your acceptance of such changes.\n\n'),
                        _buildHeading('5. Contact Us'),
                        _buildText('If you have any questions, comments, or reports regarding these Terms of Service, please contact us via email at [insert email address]. We will do our best to respond to your inquiries in a timely manner.\n\nThank you for choosing Gogobook! We hope you enjoy an extraordinary reading experience with our app.\n'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }


  Widget _buildHeading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        fontFamily: 'Sora'
      ),
    );
  }

  Widget _buildSubheading(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
          fontFamily: 'Sora'
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
          fontFamily: 'Sora'
      ),
    );
  }
}
