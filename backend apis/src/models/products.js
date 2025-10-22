import mongoose from "mongoose";
import ratingSchema from "./ratings.js";

const productSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  descriptions: {
    type: String,
    required: true,
    trim: true,
  },
  images: [
    {
      type: String,
      required: true,
    },
  ],
  price: {
    type: Number,
    required: true,
  },
  quantity: {
    type: Number,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  ratings: [ratingSchema],
});

const Product = mongoose.model("Products", productSchema);

// Option 1: Named exports (Recommended)
export { Product, productSchema };
