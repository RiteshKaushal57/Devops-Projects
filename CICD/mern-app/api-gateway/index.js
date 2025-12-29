const express = require("express");
const app = express();

app.get("/health", (req, res) => {
  res.send("Api Gateway healthy");
});

app.listen(3000, () => {
  console.log("Api Gateway running on port 3000");
});
