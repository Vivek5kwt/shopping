import express from "express";
import {
  getAllProduct,
  getCategoriesProducts,
  getFavoriteProducts,
  searchProducts,
  updateRating,
} from "../controller/products_controller.js";
import { protectRoute } from "../middlewares/auth_middle_ware.js";

const productRouter = express.Router();

productRouter.get(
  "/get-category-products",

  getCategoriesProducts
);
productRouter.get("/search/:name", searchProducts);
productRouter.get("/getallproducts", getAllProduct);
productRouter.post("/getfavoriteproducts", getFavoriteProducts);
productRouter.post("/rating", protectRoute, updateRating);
export default productRouter;
