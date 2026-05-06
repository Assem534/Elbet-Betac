import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/estate_request.dart';
import '../providers/estate_provider.dart';
import '../service/ApiService.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? agentProfile;
  bool isLoading = true;
  int selectedTab = 0; // 0: Listings, 1: Sold

  static const Color _green = Color(0xFF8BC34A);
  static const Color _navy = Color(0xFF252B5C);
  static const Color _bg = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _fetchAgentData();
  }

  Future<void> _fetchAgentData() async {
    try {
      final userData = await ApiService.getUserById(widget.userId);
      if (mounted) {
        setState(() {
          agentProfile = User.fromJson(userData);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching agent: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final double scale = (w / 375).clamp(0.85, 1.3);
    double r(double s) => s * scale;
    final estateProvider = context.watch<EstateProvider>();
    if (estateProvider.isLoading || isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: _green)),
      );
    }

    if (agentProfile == null) {
      return Scaffold(
        appBar: AppBar(elevation: 0, leading: _backBtn(context, r)),
        body: const Center(child: Text('Agent profile not found')),
      );
    }

    final List<Estate> listingProperties = estateProvider.getPropertiesByIds(
      agentProfile?.listingProperties ?? [],
    );
    final List<Estate> soldProperties = estateProvider.getPropertiesByIds(
      agentProfile?.soldProperties ?? [],
    );

    final currentList = selectedTab == 0 ? listingProperties : soldProperties;

    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: r(240),
            pinned: true,
            backgroundColor: _navy,
            leading: _backBtn(context, r),
            flexibleSpace: FlexibleSpaceBar(background: _buildHeader(r)),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: r(16), vertical: r(20)),
              child: Row(
                children: [
                  _statCard(
                    agentProfile!.rating.toStringAsFixed(1),
                    'Rating',
                    r,
                  ),
                  SizedBox(width: r(10)),
                  _statCard(listingProperties.length.toString(), 'Listings', r),
                  SizedBox(width: r(10)),
                  _statCard(soldProperties.length.toString(), 'Sold', r),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: r(16)),
              child: Container(
                padding: EdgeInsets.all(r(4)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(r(30)),
                ),
                child: Row(
                  children: [_tabBtn('Listing', 0, r), _tabBtn('Sold', 1, r)],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.all(r(16)),
            sliver: currentList.isEmpty
                ? SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: r(60)),
                  Icon(Icons.house_siding_rounded, size: r(64), color: Colors.grey.withOpacity(0.3)),
                  Text(
                    "No properties found",
                    style: TextStyle(color: Colors.grey, fontSize: r(16), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: r(12),
                      crossAxisSpacing: r(12),
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _propertyCard(currentList[index], r, estateProvider),
                      childCount: currentList.length,
                    ),
                  ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: r(30))),
        ],
      ),
    );
  }

  Widget _buildHeader(double Function(double) r) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_navy, Color(0xFF1A3460)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: r(20)),
          CircleAvatar(
            radius: r(45),
            backgroundColor: Colors.white24,
            backgroundImage: _getImageProvider(agentProfile!.image),
          ),
          SizedBox(height: r(12)),
          Text(
            agentProfile!.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: r(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            agentProfile!.email,
            style: TextStyle(color: Colors.white70, fontSize: r(12)),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String? path) {
    if (path == null || path.isEmpty)
      return const AssetImage('assets/images/images.png');
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }

  Widget _tabBtn(String title, int index, double Function(double) r) {
    bool isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: r(10)),
          decoration: BoxDecoration(
            color: isSelected ? _green : Colors.transparent,
            borderRadius: BorderRadius.circular(r(25)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: r(13),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _propertyCard(
    Estate estate,
    double Function(double) r,
    EstateProvider provider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(r(15))),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image(
                      image: _getImageProvider(estate.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(r(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estate.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r(12),
                    color: _navy,
                  ),
                ),
                SizedBox(height: r(2)),
                Text(
                  estate.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: r(10), color: Colors.grey),
                ),
                SizedBox(height: r(4)),
                Text(
                  "\$${provider.formatPrice(estate.price)}",
                  style: TextStyle(
                    color: _green,
                    fontWeight: FontWeight.bold,
                    fontSize: r(13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, double Function(double) r) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: r(15)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r(12)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _navy,
                fontSize: r(16),
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: r(10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backBtn(BuildContext context, double Function(double) r) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: r(16)),
      ),
    );
  }
}
