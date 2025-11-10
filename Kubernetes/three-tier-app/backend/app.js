const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");

const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect(mongoURL)
  .then(() => console.log("✅ Connected to MongoDB"))
  .catch(err => console.error("❌ MongoDB connection error:", err));


// User model
const User = mongoose.model("User", new mongoose.Schema({ name: String }));
app.use((req, res, next) => {
  res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
  res.setHeader('Pragma', 'no-cache');
  res.setHeader('Expires', '0');
  res.setHeader('Surrogate-Control', 'no-store');
  res.removeHeader('ETag'); // prevent 304
  next();
});


app.get("/api/users", async (req, res) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

app.post("/api/users", async (req, res) => {
  try {
    const newUser = new User({ name: req.body.name });
    await newUser.save();
    res.json(newUser);
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
});

app.listen(5000, () => console.log("Backend running on port 5000"));
