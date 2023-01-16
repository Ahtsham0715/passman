import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TermsAndPrivacyPolicyPage extends StatefulWidget {
  @override
  _TermsAndPrivacyPolicyPageState createState() =>
      _TermsAndPrivacyPolicyPageState();
}

class _TermsAndPrivacyPolicyPageState extends State<TermsAndPrivacyPolicyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms and Privacy Policy',
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: 'majalla',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0XFFd66d75),
                Color(0XFFe29587),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: TextStyle(
            fontSize: 25.0,
            fontFamily: 'majalla',
          ),
          tabs: [
            Tab(text: 'Terms'),
            Tab(text: 'Privacy Policy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTerms(),
          _buildPrivacyPolicy(),
        ],
      ),
    );
  }

  Widget _buildTerms() {
    return ListView(
      controller: _scrollController,
      children: [
        Container(
          height: 300,
          child: Image.asset('assets/terms.jpg'),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms of Service',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 8),
              Text(
                'By using the password manager app, you agree to the following terms of service:',
              ),
              SizedBox(height: 16),
              Text(
                '- You are responsible for any activity that occurs under your account.\n- You must keep your account password secure.\n- You must not abuse, harass, or spam other users of the app.\n- You must not attempt to access the app using unauthorized means.',
              ),
              SizedBox(height: 16),
              Text(
                'Modification of These Terms',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'We reserve the right to modify these terms at any time. If we do so, we will post the revised terms on this page and update the "Last Updated" date at the top of this page.',
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions about these terms, please contact us at info@passwordmanager.com.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyPolicy() {
    return ListView(
      controller: _scrollController,
      children: [
        Container(
          height: 300,
          child: Image.asset('assets/privacy.jpg'),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 8),
              Text(
                'This privacy policy applies to the password manager app and explains how we collect, use, and share information about you when you use our app.',
              ),
              SizedBox(height: 16),
              Text(
                'Information We Collect',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'We collect information about you when you create an account and use the app. This includes your name, email address, and any passwords you store in the app.',
              ),
              SizedBox(height: 8),
              Text(
                'We also collect information about your use of the app, such as your activity history and the devices you use to access the app.',
              ),
              SizedBox(height: 16),
              Text(
                'How We Use Your Information',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'We use the information we collect about you to provide, maintain, and improve the app, and to personalize your experience. We may also use your information for research and analytics purposes, or to contact you about the app or our other products.',
              ),
              SizedBox(height: 16),
              Text(
                'Sharing Your Information',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'We do not share your personal information with third parties, except in the following cases:',
              ),
              SizedBox(height: 8),
              Text(
                '- With your consent: We may share your information if you have given us explicit permission to do so.\n- For legal reasons: We may share your information if we are required to do so by law or if we believe that such action is necessary to comply with legal processes.',
              ),
              SizedBox(height: 16),
              Text(
                'Data Security',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'We take reasonable steps to protect your personal information from unauthorized access or tampering. However, we cannot guarantee the security of your information, and you use the app at your own risk.',
              ),
              SizedBox(height: 16),
              Text(
                'Changes to this Privacy Policy',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'We may update this privacy policy from time to time. If we make changes, we will post the revised policy on this page and update the "Last Updated" date at the top of this page. We encourage you to review the privacy policy whenever you access the app to stay informed about our information practices and your choices.',
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions about this privacy policy, please contact us at info@passwordmanager.com.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
