import express, { response } from "express";
import { request } from "http";
import { Product } from "../models/products.js";

export const getAllProduct = async (request, response) => {
  try {
    const products = await Product.find({});
    response.status(200).json(products);
  } catch (error) {
    console.log(`Error in get Product Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};
export const getCategoriesProducts = async (request, response) => {
  try {
    console.log(request.query.category);
    const product = await Product.find({ category: request.query.category });

    return response.status(200).json(product);
  } catch (error) {
    console.log(
      `Error in getting Categories Products Controller: ${error.message}`
    );
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

// Get favorite products by IDs
export const getFavoriteProducts = async (request, response) => {
  try {
    const { productIds } = request.body;

    // Validate input
    if (!productIds || !Array.isArray(productIds) || productIds.length === 0) {
      return response.status(400).json({
        success: false,
        message: "Product IDs array is required and cannot be empty",
      });
    }

    // Find products by IDs
    const products = await Product.find({
      _id: { $in: productIds },
    });

    return response.status(200).json({
      success: true,
      count: products.length,
      data: products,
    });
  } catch (error) {
    console.log(`Error in get Favorite Products Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const searchProducts = async (request, response) => {
  try {
    console.log(request.params.name);
    const product = await Product.find({
      name: { $regex: request.params.name, $options: "i" },
    });

    return response.status(200).json(product);
  } catch (error) {
    console.log(
      `Error in getting Search Products Controller: ${error.message}`
    );
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const updateRating = async (request, response) => {
  try {
    console.log(`request.user in Rating ${request.user.id}`);
    const { id, rating } = request.body;
    console.log(`User in Rating id ${id}`);
    // Find the product by ID
    let productToUpdate = await Product.findById(id);

    // Remove existing rating from the same user
    for (let i = 0; i < productToUpdate.ratings.length; i++) {
      if (productToUpdate.ratings[i].userId == request.user) {
        productToUpdate.ratings.splice(i, 1);
        break;
      }
    }

    // Create new rating object
    const ratingSchema = {
      userId: request.user.id,
      rating,
    };

    // Add the new rating
    productToUpdate.ratings.push(ratingSchema);

    // Save the updated product
    const updatedProduct = await productToUpdate.save();

    return response.status(200).json(updatedProduct);
  } catch (error) {
    console.log(`Error in Rating Products Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};
