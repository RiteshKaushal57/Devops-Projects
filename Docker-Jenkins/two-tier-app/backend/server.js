const express = require("express");
const app = express();
const PORT = 5000;

app.get("/api", (req, res) => {
  res.json({ message: "Hello from Node.js backend!" });
});

app.listen(PORT, () => console.log(`Backend running on port ${PORT}`));
