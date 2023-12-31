import 'dart:convert';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:github_search_users/models/user.dart';
import 'package:github_search_users/services/home_service.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildSearchBox(),
            SizedBox(height: 20),
            _buildSearchButton(),
            SizedBox(height: 20),
            _buildDivider(),
            SizedBox(height: 20),
            _buildTotalUsersFound(),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: _isLoading ? _buildShimmerLoading() : _buildUserList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/usersLogo.png",
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10),
            Text(
              "USERVERSE",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Compact',
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _searchController,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'SF Compact',
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: 'Search User',
          labelStyle: TextStyle(color: Colors.black, fontFamily: 'SF Compact', fontSize: 16,fontWeight: FontWeight.bold),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return BouncingWidget(
      onPressed: _searchUsers,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            "SEARCH",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'SF Compact',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 100,
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Colors.black38,
      ),
    );
  }

  Widget _buildTotalUsersFound() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xff50bcfd),
      ),
      child: Center(
        child: Text(
          "TOTAL USERS FOUND - ${_users.length}",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SF Compact',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: Image.asset("assets/images/userDetailLogo.png", width: 30, height: 30,),
            trailing: Icon(
              Icons.verified,
              color: Colors.green,
            ),
            title: Container(
              width: double.infinity,
              height: 18,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserList() {
    if (_users.isEmpty) {
      return _searchController.text.isNotEmpty
          ? Center(
        child: Text(
          'No users found.',
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'SF Compact',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      )
          : Center(
        child: Text(
          'SEARCH TO GET RESULTS',
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'SF Compact',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2
                  )
                ]
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(_users[index].avatarUrl.toString(), width: 30, height: 30,))),
          trailing: Icon(
            Icons.verified,
            color: Colors.green,
          ),
          title: Text(
            _users[index].login.toString().toUpperCase(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'SF Compact',
            ),
          ),
        );
      },
    );
  }

  Future<void> _searchUsers() async {
    setState(() {
      _users.clear();
      _isLoading = true;
    });

    try {
      if (_searchController.text.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        debugPrint("Please enter a search query");
        return;
      }
      HomeService homeService = HomeService();
      List<User> users = await homeService.getSpecificUser(_searchController.text);
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Some exception occurred: " + e.toString());
    }
  }

}
