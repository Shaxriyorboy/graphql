import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/graph_ql/graphqul_config.dart';
import 'package:graphql_test/graph_ql/query_mutation.dart';
import 'package:graphql_test/models/user_model.dart';
import 'package:graphql_test/pages/create_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  List<User> users = [];
  bool isLoading = false;

  void apiUserList() async {
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(
          queryMutation.userList(20),
        ),
      ),
    );

    if (!result.hasException) {
      for (var i = 0; i < result.data!["users"].length; i++) {
        setState(() {
          users.add(User(
            result.data?["users"][i]["id"] ?? "",
            result.data?["users"][i]["name"] ?? "no name",
            result.data?["users"][i]["rocket"] ?? "no rocket",
            result.data?["users"][i]["twitter"] ?? "no twitter",
          ));
        });
      }
      print(users.length.toString());
    } else {
      print("Error nima uchun");
    }
  }

  _insertUser(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          CreatePage createPage = CreatePage();
          return createPage;
        }).whenComplete(() {
      users.clear();
      apiUserList();
    });
  }

  _updateUser(context,User user) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          CreatePage createPage = CreatePage(user: user,);
          return createPage;
        }).whenComplete(() {
      users.clear();
      apiUserList();
    });
  }

  _deleteUser(String id) async {
    setState(() {
      isLoading = true;
    });
    QueryMutation queryMutation = QueryMutation();
    GraphQLClient _clinet = graphQLConfiguration.clientToQuery();

    QueryResult result = await _clinet
        .mutate(MutationOptions(document: gql(queryMutation.deleteUser(id))));
    if (!result.hasException) {
      debugPrint("Success");
      users.clear();
      apiUserList();
      setState(() {
        isLoading = false;
      });
    } else {
      debugPrint("Error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    apiUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GraphQL"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              _insertUser(context);
            },
            tooltip: "Insert User",
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          _updateUser(context, users[index]);
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          _deleteUser(users[index].id);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(users[index].name),
                          Text(users[index].rocket),
                          Text(users[index].twitter)
                        ],
                      ),
                    ),
                  ),
                );
              }),
          isLoading
              ? const LinearProgressIndicator(color: Colors.red,)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
