import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Detail',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: ProductDetailPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedSize = 'M';
  int selectedColorIndex = 0;

  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  final List<Color> colors = [
    Colors.grey[400]!,
    Colors.pink[600]!,
    Colors.blue[800]!,
    Colors.brown[600]!,
    Colors.green[600]!,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Product Image Section
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&h=800&fit=crop',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // children: [
                      // Container(
                      //   padding: EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //     color: Colors.orange,
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      //   child: Icon(
                      //     Icons.grid_view,
                      //     color: Colors.white,
                      //     size: 20,
                      //   ),
                      // ),
                      // CircleAvatar(
                      //   radius: 20,
                      //   backgroundImage: NetworkImage(
                      //     'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
                      //   ),
                      // ),
                    // ],
                  ),
                ),
              ),
            ),
          ),

          // Product Details Section
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Acrylic Sweater',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '\$88.00',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),

                  // Size Section
                  Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: sizes.map((size) => _buildSizeOption(size)).toList(),
                  ),

                  SizedBox(height: 30),

                  // Color Section
                  Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: colors
                        .asMap()
                        .entries
                        .map((entry) => _buildColorOption(entry.key, entry.value))
                        .toList(),
                  ),

                  Spacer(),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // _showAddToCartSnackbar(context);
                        Navigator.pushNamed(context, '/carts');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add To Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(int index, Color color) {
    bool isSelected = selectedColorIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColorIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 15),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black87 : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
            : null,
      ),
    );
  }

  void _showAddToCartSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added to cart: Acrylic Sweater (Size: $selectedSize)',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}