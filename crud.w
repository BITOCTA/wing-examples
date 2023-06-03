bring cloud;

let api = new cloud.Api() as "users_api";
let table = new cloud.Table(
    name: "users", 
    primaryKey: "id", 
    columns: {
        "id": cloud.ColumnType.STRING,
        "email": cloud.ColumnType.STRING,
        "name": cloud.ColumnType.STRING
    }
) as "users_table";

struct User {
    id: str;
    email: str;
    name: str;
}

class Utils {
  init() {}
  extern "./helpers.js" static inflight makeId(): str;
  extern "./helpers.js" static inflight getIdFromPath(path : str): str;
  extern "./helpers.js" static inflight isUndefined(t : Json): bool;

}

let userExists = inflight (id: str): bool => {
    let usr = table.get(id);
    if (!Utils.isUndefined(usr)){
        return true;
    }
    else {
        return false;
    }
};

api.get("/users", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {

  let ids = MutArray<str>[];
  
  for i in table.list() {
    ids.push(str.fromJson(i.get("id")));
  }

  return cloud.ApiResponse {
    status: 200,
    body: ids
  };
});

api.post("/users", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
  let usr = User {
    id: Utils.makeId(),
    email: str.fromJson(req.body?.get("email")),
    name:  str.fromJson(req.body?.get("name")),
  };
  table.insert(usr.id, usr);
  return cloud.ApiResponse {
    status: 201,
    body: usr.id
  };
});

api.get("/users/{id}", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
  if (userExists(Utils.getIdFromPath(req.path))){
    return cloud.ApiResponse {
        status: 201,
        body: table.get(Utils.getIdFromPath(req.path))
    };
  }
  else {
    return cloud.ApiResponse {
        status: 404,
        body: "User not found"
    };
  }
});

api.delete("/users/{id}", inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
  if (userExists(Utils.getIdFromPath(req.path))){
    table.delete(Utils.getIdFromPath(req.path));
    return cloud.ApiResponse {
      status: 204
    };
  }
  else {
    return cloud.ApiResponse {
        status: 404,
        body: "User not found"
    };
  }
});