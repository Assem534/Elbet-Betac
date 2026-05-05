import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_real_estate/Widget/Navidation_bar.dart';
import '../providers/AuthProvider.dart';
import '../providers/estate_provider.dart';
import '../providers/favourite_provider.dart';
import '../Widget/estate_card_2D.dart';

class Personal_Profile_Screen extends StatefulWidget {
  const Personal_Profile_Screen({super.key});

  @override
  State<Personal_Profile_Screen> createState() =>
      _Personal_Profile_ScreenState();
}

class _Personal_Profile_ScreenState extends State<Personal_Profile_Screen> {
  int selectedTab = 0;

  static const Color _green = Color(0xFF8BC34A);
  static const Color _navy = Color(0xFF252B5C);
  static const Color _bg = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final estateProvider = context.watch<EstateProvider>();
    final favProvider = context.watch<FavouriteProvider>();

    final List<dynamic> rawProperties = auth.currentUser?['my_properties'] ??
        auth.currentUser?['listingProperties'] ?? [];

    final List<String> myPropertiesIds = rawProperties.map((p) {
      if (p is Map) return p['id']?.toString() ?? '';
      return p.toString();
    }).where((id) => id.isNotEmpty).toList();

    final myProperties = estateProvider.getPropertiesByIds(myPropertiesIds);
    final favList = favProvider.favourites;

    final currentList = selectedTab == 0 ? myProperties : favList;

    final w = MediaQuery.of(context).size.width;
    final double scale = (w / 375).clamp(0.85, 1.3);
    double r(double s) => s * scale;

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: r(240),
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: _buildBackButton(context, r),
            actions: [_buildLogoutButton(auth, context, r)],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderBackground(auth, r),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(r(16), r(20), r(16), 0),
              child: Row(
                children: [
                  _statCard(myProperties.length.toString(), 'My Listings', r),
                  SizedBox(width: r(10)),
                  _statCard(favList.length.toString(), 'Favourites', r),
                  SizedBox(width: r(10)),
                  _statCard(
                    (auth.currentUser?['notifications'] as List? ?? []).length.toString(),
                    'Notifications',
                    r,
                  ),
                ],
              ),
            ),
          ),

          // ── ACTION BUTTONS ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(r(16), r(20), r(16), 0),
              child: Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.add_home_outlined,
                      label: 'Add Property',
                      filled: true,
                      r: r,
                      onTap: () => Navigator.pushNamed(context, '/add_image'),
                    ),
                  ),
                  SizedBox(width: r(12)),
                  Expanded(
                    child: _actionBtn(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      filled: false,
                      r: r,
                      onTap: () => Navigator.pushNamed(context, '/NotificationScreen'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── TAB BAR ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(r(16), r(24), r(16), r(12)),
              child: Container(
                padding: EdgeInsets.all(r(4)),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(r(30)),
                ),
                child: Row(
                  children: [
                    _tabBtn('My Listings', 0, r),
                    _tabBtn('Favourites', 1, r),
                  ],
                ),
              ),
            ),
          ),

          // ── GRID DISPLAY ─────────────────────────────────────────────
          currentList.isEmpty
              ? _buildEmptyState(r)
              : SliverPadding(
            padding: EdgeInsets.fromLTRB(r(16), 0, r(16), r(30)),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => EstateCard2D(item: currentList[i]),
                childCount: currentList.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: r(12),
                mainAxisSpacing: r(12),
                childAspectRatio: 0.78,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bottom_Navigation_Bar(context, 3),
    );
  }

  // --- مكونات واجهة المستخدم الفرعية ---

  Widget _buildBackButton(BuildContext context, double Function(double) r) {
    return Padding(
      padding: EdgeInsets.all(r(8)),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(r(10))),
          child: Icon(Icons.arrow_back_ios_new, color: _navy, size: r(16)),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AuthProvider auth, BuildContext context, double Function(double) r) {
    return IconButton(
      icon: Icon(Icons.logout, color: _navy, size: r(20)),
      onPressed: () {
        auth.logout();
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      },
    );
  }

  Widget _buildHeaderBackground(AuthProvider auth, double Function(double) r) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A3460), Color(0xFF254F6C)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: r(40)),
            CircleAvatar(
              radius: r(46),
              backgroundColor: _green,
              child: CircleAvatar(
                radius: r(43),
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(auth.userImage),
              ),
            ),
            SizedBox(height: r(10)),
            Text(auth.userName, style: TextStyle(color: Colors.white, fontSize: r(18), fontWeight: FontWeight.bold)),
            Text(auth.userEmail, style: TextStyle(color: Colors.white70, fontSize: r(12))),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double Function(double) r) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(r(60)),
        child: Column(
          children: [
            Icon(Icons.home_outlined, size: r(60), color: Colors.grey.shade300),
            SizedBox(height: r(12)),
            Text('No estates found in this section', style: TextStyle(color: Colors.grey, fontSize: r(14))),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label, double Function(double) r) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: r(14)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r(16)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r(16),
                    color: _navy)),
            SizedBox(height: r(4)),
            Text(label,
                style: TextStyle(
                    color: Colors.grey, fontSize: r(10)),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required bool filled,
    required double Function(double) r,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: r(52),
        decoration: BoxDecoration(
          color: filled ? _green : Colors.white,
          borderRadius: BorderRadius.circular(r(14)),
          border: filled ? null : Border.all(color: _green, width: 1.5),
          boxShadow: filled
              ? [
                  BoxShadow(
                      color: _green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: filled ? Colors.white : _green, size: r(18)),
            SizedBox(width: r(8)),
            Flexible(
              child: Text(label,
                  style: TextStyle(
                    color: filled ? Colors.white : _green,
                    fontWeight: FontWeight.bold,
                    fontSize: r(13),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String title, int index, double Function(double) r) {
    final bool sel = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: r(10)),
          decoration: BoxDecoration(
            color: sel ? _green : Colors.transparent,
            borderRadius: BorderRadius.circular(r(30)),
          ),
          child: Center(
            child: Text(title,
                style: TextStyle(
                  color: sel ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: r(13),
                )),
          ),
        ),
      ),
    );
  }
}
