class QueryMutation{
  String userList(int page){
    return """
      query{
        users(limit: $page, order_by:{timestamp: desc}){
          id
          name
          rocket
          twitter
        }
      }
    """;
  }

  String insertUser(String name, String rocket, String twitter) {
    return """
      mutation {
        insert_users(objects: {name: "$name", rocket: "$rocket", twitter: "$twitter"}) {
          affected_rows
        }
      }
    """;
  }

  String deleteUser(String id) {
    return """
      mutation {
        delete_users(where: {id: {_eq: "$id"}}) {
          affected_rows
        }
      }
    """;
  }

  String updateUser(String name,String rocket,String twitter,String id) {
    return """
      mutation {
        update_users(_set: {
          name: "$name",
          rocket: "$rocket",
          twitter: "$twitter" 
        }
        where: {id: {_eq: "$id"}}) {
          affected_rows
        }
      }
    """;
  }
}