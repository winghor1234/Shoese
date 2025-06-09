import 'package:flutter/material.dart';
import 'package:shop/screens/admin/user/admin_user_edit_screen.dart';
import 'package:shop/screens/auth/forgot_password.dart';
import 'package:shop/screens/auth/register.dart';
import 'package:shop/screens/auth/reset_password.dart';
import 'package:shop/screens/auth/verify_otp.dart';
import 'package:shop/screens/cart/carts.dart';
import 'package:shop/screens/detail/shoes_detail.dart';
import 'package:shop/screens/home/home_Screen.dart';
import 'package:shop/screens/auth/login.dart';
import 'package:shop/screens/home/welcome.dart';
import 'package:shop/screens/admin/auth/admin_login_screen.dart';
import 'package:shop/screens/admin/auth/admin_register_screen.dart';
import 'package:shop/screens/admin/admin_dashboard_screen.dart';
import 'package:shop/screens/admin/product/admin_product_list_screen.dart';
import 'package:shop/screens/admin/product/admin_product_edit_screen.dart';
import 'package:shop/screens/admin/user/admin_user_list_screen.dart';



class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String register = '/register';
  static const String welcome = '/welcome';
  static const String productDetail = '/productDetail';
  static const String carts = '/carts';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String verifyOTP = '/verifyOTP';
  static const String adminLogin = '/admin/login';
  static const String adminRegister = '/admin/register';
  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminProductList = '/admin/products';
  static const String adminProductAdd = '/admin/products/add';
  static const String adminProductEdit = '/admin/products/edit'; // Will take an ID as argument
  static const String adminUserList = '/admin/users';
  static const String adminUserEdit = '/admin/users/edit'; // Will take a user ID as argument


  static Route<dynamic> generateRoute(RouteSettings settings, ) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case productDetail:
        return MaterialPageRoute(builder: (_) => ProductDetailPage());
      case carts:
        return MaterialPageRoute(builder: (_) => ShoppingCartScreen());
        case forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case verifyOTP:
        return MaterialPageRoute(builder: (_) => VerifyOTPScreen());
      
      // Admin Auth Routes
      case adminLogin:
        return MaterialPageRoute(builder: (_) => AdminLoginScreen());
      case adminRegister:
        return MaterialPageRoute(builder: (_) => AdminRegisterScreen());

      // Admin Routes
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => AdminDashboardScreen());
      case adminProductList:
        return MaterialPageRoute(builder: (_) => AdminProductListScreen());
      case adminProductAdd:
         return MaterialPageRoute(builder: (_) => AdminProductEditScreen());
      case adminProductEdit:
        final productId = settings.arguments as String?; // Or your product object
        return MaterialPageRoute(builder: (_) => AdminProductEditScreen(productId: productId));
      case adminUserList:
        return MaterialPageRoute(builder: (_) => AdminUserListScreen());
      case adminUserEdit:
        final userId = settings.arguments as String?; // Or your user object
        return MaterialPageRoute(builder: (_) => AdminUserEditScreen(userId: userId));

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ), 
        );
    }
  }
}
