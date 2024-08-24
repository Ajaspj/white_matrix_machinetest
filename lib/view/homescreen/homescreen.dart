import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:whitematrix/constants/colorconstants.dart/colorconstants.dart';
import 'package:whitematrix/controller/homescreencontroller.dart';
import 'package:whitematrix/model/productmodel.dart';
import 'package:whitematrix/view/Adddatascreen/adddatascreen.dart';
import 'package:whitematrix/view/cartscreen/cartscreen.dart';
import 'package:whitematrix/view/favouritescreen/favoritescreen.dart';
import 'package:whitematrix/view/homescreen/widgets/productcard.dart';
import 'package:whitematrix/view/homescreen/widgets/searchbar.dart';
import 'package:whitematrix/view/loginscreen/loginscreen.dart';
import 'package:whitematrix/view/orderscreen/orderscreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var collectionRef = FirebaseFirestore.instance.collection("products");
  TextEditingController searchController = TextEditingController();

  void setSearchText(String text) {
    context.read<Homescreencontroller>().setSearchText(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: FadeInDown(
          duration: Duration(milliseconds: 500),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Discover",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryBlack,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favoritescreen()),
                  );
                },
                icon: Icon(
                  Icons.favorite_border,
                  size: 28,
                  color: ColorConstants.primaryBlack,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                  color: ColorConstants.primaryBlack,
                ),
              ),
              PopupMenuButton<int>(
                icon: Icon(
                  Icons.more_vert,
                  size: 28,
                  color: ColorConstants.primaryBlack,
                ),
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text('My Orders'),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text('Add Data'),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text('Logout'),
                  ),
                ],
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: const Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorConstants.primaryGreen,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No products found',
                style: TextStyle(
                  color: ColorConstants.primaryBlack,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return Consumer<Homescreencontroller>(
            builder: (BuildContext context, Homescreencontroller value,
                Widget? child) {
              // Filter products based on the search text
              final filteredDocs = snapshot.data!.docs.where((doc) {
                final product =
                    ProductModel.fromMap(doc.data() as Map<String, dynamic>);
                return product.title
                    .toLowerCase()
                    .contains(context.read<Homescreencontroller>().searchText);
              }).toList();

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInRight(
                      duration: Duration(milliseconds: 500),
                      child: searchBar(
                        searchController: searchController,
                        onSearch: setSearchText,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle("Hot Offers", ""),
                    SizedBox(height: 10),
                    _buildHorizontalProductList(filteredDocs),
                    SizedBox(height: 20),
                    _buildSectionTitle("Special For You", "See all"),
                    SizedBox(height: 10),
                    _buildGridProductList(filteredDocs),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Orderscreen()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AdddataScreen()),
        );
        break;
      case 2:
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
        break;
    }
  }

  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryBlack,
          ),
        ),
        if (actionText.isNotEmpty)
          Text(
            actionText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: ColorConstants.accentBlue,
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalProductList(List<QueryDocumentSnapshot> docs) {
    int itemCount = docs.length < 5 ? docs.length : 5;

    return AnimationLimiter(
      child: Container(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            var map = docs[index].data() as Map<String, dynamic>;
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: ProductCard(
                    product: ProductModel.fromMap(map),
                    isHorizontal: true,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridProductList(List<QueryDocumentSnapshot> docs) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: docs.length,
        itemBuilder: (context, index) {
          var map = docs[index].data() as Map<String, dynamic>;
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: Duration(milliseconds: 500),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: ProductCard(
                  product: ProductModel.fromMap(map),
                  isHorizontal: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
