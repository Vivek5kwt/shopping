import express from "express";
import {
  addToCart,
  checkAuth,
  getOrders,
  getUser,
  login,
  orderProduct,
  removeFromCart,
  saveUserAddress,
  signup,
  updateUserProfilePic,
  socialLogin,
} from "../controller/user_controller.js";
import { protectRoute } from "../middlewares/auth_middle_ware.js";

const userRoutes = express.Router();

userRoutes.post("/signup", signup);
userRoutes.post("/login", login);
userRoutes.post("/social-login", socialLogin);
userRoutes.get("/check", protectRoute, checkAuth);
userRoutes.post("/add-to-cart", protectRoute, addToCart);
userRoutes.delete("/remove-from-cart/:id", protectRoute, removeFromCart);
userRoutes.post("/save-address", protectRoute, saveUserAddress);
userRoutes.post("/order", protectRoute, orderProduct);
userRoutes.get("/getUser/:id", protectRoute, getUser);
userRoutes.get("/getOrders/me", protectRoute, getOrders);
userRoutes.post("/update-profilePic", protectRoute, updateUserProfilePic);

export default userRoutes;
