db = db.getSiblingDB("usersdb"); // ✅ match backend
db.users.insertMany([
  { name: "Ritesh" },
  { name: "Alex" },
  { name: "Sam" },
  { name: "Jordan" }
]);
