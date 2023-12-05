import 'package:flutter/material.dart';
import 'package:productsearch/provvv.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        title: 'Product Search App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SearchScreen(),
      ),
    );
  }
}


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).fetchProduct();
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String ?value){
                final query = _searchController.text;
                if(query.length>0) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .fetchProducts(query);
                }
              },
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final query = _searchController.text;
                    Provider.of<ProductProvider>(context, listen: false).fetchProducts(query);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, _) {
                final products = productProvider.products;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text('${product!.title}'),
                      subtitle: Text('${product!.title}'),
                      // Add more details as needed
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
