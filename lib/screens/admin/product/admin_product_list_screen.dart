import 'package:flutter/material.dart';
import 'package:shop/route/app_route.dart';

// Placeholder Product Model for Admin
class AdminProduct {
  final String id;
  final String name;
  final double price;
  final String category;

  AdminProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });
}

class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  // Placeholder data - replace with actual data fetching
  final List<AdminProduct> _products = List.generate(
    5,
    (index) => AdminProduct(
      id: 'prod${index + 1}',
      name: 'Product Name ${index + 1}',
      price: (index + 1) * 19.99,
      category: 'Category A',
    ),
  );

  void _deleteProduct(String productId) {
    setState(() {
      _products.removeWhere((product) => product.id == productId);
      // TODO: Add API call to delete product from backend
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product $productId deleted (placeholder)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text(
                'Price: \$${product.price.toStringAsFixed(2)} - Category: ${product.category}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.adminProductEdit,
                        arguments: product.id,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(product.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.adminProductAdd);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
