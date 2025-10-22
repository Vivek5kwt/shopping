import express from "express";
import { adminProtectedRoute } from "../middlewares/admin_middle_ware.js";
import {
  addProduct,
  changeOrderStatus,
  deleteProduct,
  getAllUsers,
  getOrder,
  getProduct,
  productAnalytics,
} from "../controller/amdin_controller.js";

const adminRouter = express.Router();

adminRouter.post("/add-products", adminProtectedRoute, addProduct);
adminRouter.get("/get-products", adminProtectedRoute, getProduct);
adminRouter.post("/delete-products", adminProtectedRoute, deleteProduct);
adminRouter.get("/get-orders", adminProtectedRoute, getOrder);
adminRouter.post(
  "/change-order-status",
  adminProtectedRoute,
  changeOrderStatus
);
adminRouter.get("/analytics", adminProtectedRoute, productAnalytics);
adminRouter.get("/customer", adminProtectedRoute, getAllUsers);

export default adminRouter;
