// This script will run once inside MongoDB container to seed data
db = db.getSiblingDB("userdb");

db.users.insertMany([
  { name: "Ritesh" },
  { name: "Alex" },
  { name: "Sam" },
  { name: "Jordan" }
]);
