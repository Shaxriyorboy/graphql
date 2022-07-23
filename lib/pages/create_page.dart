import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_test/graph_ql/graphqul_config.dart';
import 'package:graphql_test/graph_ql/query_mutation.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtRocket = TextEditingController();
  TextEditingController txtTwitter = TextEditingController();

  _insertNewUser(String name, String rocket, String twitter) async {
    QueryMutation queryMutation = QueryMutation();
    print(queryMutation.insertUser(name, rocket, twitter));

    GraphQLClient client = graphQLConfiguration.clientToQuery();
    QueryResult result = await client.mutate(MutationOptions(
        document: gql(queryMutation.insertUser(name, rocket, twitter))));

    if (!result.hasException) {
      txtName.clear();
      txtRocket.clear();
      txtTwitter.clear();
      Navigator.of(context).pop();
    } else {
      print(result.exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Insert user"),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: [
                Container(
                  child: TextField(
                    maxLength: 40,
                    controller: txtName,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.text_format),
                      labelText: "Name",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtRocket,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.text_decrease),
                      labelText: "Rocket",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 160.0),
                  child: TextField(
                    maxLength: 40,
                    controller: txtTwitter,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Twitter",
                      icon: Icon(Icons.person_add),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
        MaterialButton(
          child: const Text("Insert"),
          onPressed: () async {
            var name = txtName.text.toString().trim();
            var rocket = txtRocket.text.toString().trim();
            var twitter = txtTwitter.text.toString().trim();
            _insertNewUser(name, rocket, twitter);
          },
        )
      ],
    );
  }
}
