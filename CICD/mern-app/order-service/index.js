const express = require("express");
const app = express();

app.get("/health", (req, res) => {
  res.send("Order service healthy");
});

app.listen(3000, () => {
  console.log("Order service running on port 3000");
});
