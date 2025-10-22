import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import userRoutes from "./routes/user_routes.js";
import { connectDB } from "./lib/mongodb_connect.js";
import adminRouter from "./routes/admins_routes.js";
import productRouter from "./routes/products_routes.js";

dotenv.config();

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// Connect to database
connectDB();

// Routes
app.use("/api/user", userRoutes);
app.use("/api/admin", adminRouter);
app.use("/api/products", productRouter);

app.get("/", (req, res) => {
  res.status(200).json({
    status: "active",
    message: "Backend Server is running",
    timestamp: new Date().toISOString(),
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "active",
    message: "Server is running",
    timestamp: new Date().toISOString(),
  });
});

// For local development
if (process.env.NODE_ENV !== "production") {
  const PORT = process.env.PORT || 5001;
  app.listen(PORT, () => {
    console.log(`Server is connected to port ${PORT}`);
  });
}

// Export for Vercel
export default app;
