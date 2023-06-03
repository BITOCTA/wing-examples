bring cloud;


let low_priority_bucket = new cloud.Bucket() as "low_priority_bucket";
let high_priority_bucket = new cloud.Bucket() as "high_priority_bucket";
let queue = new cloud.Queue(timeout: 10s);

enum Priority {
    Low,
    High
  }

struct Message {
    body: str;
    priority: Priority;
    id: str;
}



let handler = inflight (body: str /* string arg */): str => {
  let json_body = Json.parse(body);

  let var priority = Priority.High;

  if json_body.get("priority") == "Low" {
    priority = Priority.Low;
  }
  
  let msg = Message {
    body: str.fromJson(json_body.get("body")),
    priority: priority,
    id: str.fromJson(json_body.get("id"))
  };

  log("${json_body.get("body")}");

  if msg.priority == Priority.Low {
    low_priority_bucket.put("${msg.id}.txt", msg.body);
  } else {
    high_priority_bucket.put("${msg.id}.txt", msg.body);
  }

};

queue.addConsumer(handler);
