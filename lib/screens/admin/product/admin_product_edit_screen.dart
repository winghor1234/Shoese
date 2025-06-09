import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shop/server/server.dart'; // Assuming your Dio instance is here
import 'package:shop/screens/admin/product/admin_product_list_screen.dart'; // For AdminProduct model if needed for typing
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File
import 'dart:convert';

class AdminProductEditScreen extends StatefulWidget {
  final String? productId; // Null if adding a new product

  const AdminProductEditScreen({super.key, this.productId});

  @override
  State<AdminProductEditScreen> createState() => _AdminProductEditScreenState();
}

class _AdminProductEditScreenState extends State<AdminProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  // Add controllers for other fields your backend expects: sellingPrice, purchasePrice, size, quantity, color, branch

  bool _isEditMode = false;
  bool _isLoading = false; // To manage loading state for API calls
  XFile? _imageFile; // To store the selected image file

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.productId != null;

    // Initialize controllers
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _imageUrlController = TextEditingController();
    _categoryController = TextEditingController();
    // Initialize other controllers here
    // _sellingPriceController = TextEditingController();
    // _purchasePriceController = TextEditingController();
    // _sizeController = TextEditingController();
    // _quantityController = TextEditingController();
    // _colorController = TextEditingController();
    // _branchController = TextEditingController();

    if (_isEditMode) {
      _fetchProductDetails();
    }
  }

  Future<void> _fetchProductDetails() async {
    if (widget.productId == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // Assuming your API endpoint for fetching a single product is /admin/products/:id
      final response = await useServer.get(
        '/admin/products/${widget.productId}',
      );
      if (response.statusCode == 200 && response.data != null) {
        final productData =
            response.data['product']; // Adjust key based on your API
        _nameController.text = productData['name'] ?? '';
        _descriptionController.text = productData['description'] ?? '';
        // Your backend `adminAddProductMany` uses sellingPrice, purchasePrice etc.
        // The current form has a generic `price`. Adjust accordingly.
        // For now, I'll assume `price` maps to `sellingPrice` for simplicity.
        // _sellingPriceController.text = (productData['sellingPrice'] ?? 0.0).toString();
        // _purchasePriceController.text = (productData['purchasePrice'] ?? 0.0).toString();
        // _sizeController.text = productData['size'] ?? '';
        // _quantityController.text = (productData['quantity'] ?? 0).toString();
        // _colorController.text = productData['color'] ?? '';
        // _branchController.text = productData['branch'] ?? '';
        _priceController.text = (productData['price'] ?? 0.0).toString();
        _imageUrlController.text =
            productData['imageUrl'] ?? ''; // Or 'images' if it's a list
        _categoryController.text = productData['category'] ?? '';
        // If you have more fields like stock, brand, etc., populate them here
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load product details: ${response.statusMessage}',
            ),
          ),
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error fetching product: ${e.response?.data?['message'] ?? e.message}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    // Dispose other controllers
    // _sellingPriceController.dispose();
    // _purchasePriceController.dispose();
    // _sizeController.dispose();
    // _quantityController.dispose();
    // _colorController.dispose();
    // _branchController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Response response;
        String successMessage;

        if (_isEditMode) {
          // --- EDIT PRODUCT LOGIC ---
          // Update existing product
          // Assuming endpoint is /admin/products/:id
          // This part needs a different backend endpoint than adminAddProductMany
          // as adminAddProductMany is for creation.
          // For now, this will send the text fields. Image update would need separate handling.
          Map<String, dynamic> productUpdateData = {
            'name': _nameController.text,
            'description': _descriptionController.text,
            // Map to your backend's expected fields for update
            'sellingPrice':
                double.tryParse(_priceController.text) ??
                0.0, // Assuming price is sellingPrice
            'category': _categoryController.text,
            'imageUrl':
                _imageUrlController.text, // If you allow updating URL directly
            // Add other fields: purchasePrice, size, quantity, color, branch
          };
          // If _imageFile is not null and you want to allow replacing image during edit,
          // you'd need to handle file upload here too, likely with FormData.
          // This typically requires a dedicated PUT endpoint that can handle multipart/form-data.

          response = await useServer.put(
            '/admin/products/${widget.productId}',
            data: productUpdateData,
          );
          successMessage = 'Product updated successfully!';
        } else {
          // --- CREATE NEW PRODUCT LOGIC ---
          if (_imageFile == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select an image for the new product.'),
              ),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          // Prepare product data as expected by your AdminManyProductDto (for a single product)
          List<Map<String, dynamic>> productsArray = [
            {
              'name': _nameController.text,
              'description': _descriptionController.text,
              'sellingPrice':
                  double.tryParse(_priceController.text) ??
                  0.0, // Assuming form's price is sellingPrice
              'purchasePrice': 0.0, // Add a field for this or set a default
              'category': _categoryController.text,
              'size': 'M', // Add a field for this or set a default
              'quantity': 1, // Add a field for this or set a default
              'color': 'Default', // Add a field for this or set a default
              'branch': 'Main', // Add a field for this or set a default
            },
          ];

          String productsJson = productsArray.map((p) => p).toList().toString();
          try {
            productsJson = Uri.encodeComponent(jsonEncode(productsArray));
          } catch (e) {
            print("Error encoding JSON: $e");
            // Handle error appropriately
          }

          FormData formData = FormData.fromMap({
            // The backend expects the JSON string in a field, often 'data' or similar.
            // Adjust 'req.body?.data || req?.body' in your backend if needed.
            'data': jsonEncode(
              productsArray,
            ), // Send as a JSON string of an array of products
            // The backend expects files like images[productIndex][imageIndex]
            // For a single product (index 0) and single image (index 0)
            'images[0][0]': await MultipartFile.fromFile(
              _imageFile!.path,
              filename: _imageFile!.name,
            ),
          });

          // POST to an endpoint that can trigger your adminAddProductMany logic
          // This might be a new endpoint or an existing one adapted.
          // For example, if '/admin/products/many' is your endpoint for adminAddProductMany
          response = await useServer.post(
            '/admin/products/many',
            data: formData,
          );
          successMessage = 'Product created successfully!';
        }

        if (!mounted) return;

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data?['message'] ?? successMessage),
            ),
          );
          Navigator.pop(
            context,
            true,
          ); // Pop and indicate success to refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to save product: ${response.data?['message'] ?? response.statusMessage}',
              ),
            ),
          );
        }
      } on DioException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error saving product: ${e.response?.data?['message'] ?? e.message}',
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      } finally {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
        _imageUrlController.text =
            selectedImage.name; // Show file name in the URL field
      });
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Product' : 'Add New Product'),
        backgroundColor: Colors.orange,
      ),
      body:
          _isLoading &&
              _isEditMode // Show loader only when fetching details for edit mode
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    _buildTextField(_nameController, 'Product Name'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      _descriptionController,
                      'Description',
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      _priceController,
                      'Price',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // For existing products, show the image URL. For new, show picked file name.
                    if (_isEditMode && (_imageFile == null))
                      _buildTextField(
                        _imageUrlController,
                        'Image URL (Existing)',
                      ),
                    if (!_isEditMode || _imageFile != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _imageFile == null
                                ? "No image selected"
                                : "Selected image: ${_imageFile!.name}",
                            style: TextStyle(
                              color: _imageFile == null
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          if (_imageFile != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Image.file(
                                File(_imageFile!.path),
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          TextButton.icon(
                            icon: const Icon(Icons.image),
                            label: Text(
                              _isEditMode && _imageFile == null
                                  ? 'Change Product Image'
                                  : 'Select Product Image',
                            ),
                            onPressed: _pickImage,
                          ),
                        ],
                      ),
                    const SizedBox(height: 12),
                    _buildTextField(_categoryController, 'Category'),
                    // Add more TextFormFields here for: purchasePrice, size, quantity, color, branch
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _saveProduct, // Disable button when loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              _isEditMode ? 'Update Product' : 'Add Product',
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
