import express, { request, response } from "express";
import { Product } from "../models/products.js";
import Order from "../models/order.js";
import User from "../models/user.js";

export const addProduct = async (request, response) => {
  try {
    const { name, descriptions, price, quantity, images, category } =
      request.body;
    let product = new Product({
      name,
      descriptions,
      price,
      quantity,
      images,
      category,
    });
    product = await product.save();
    return response.status(201).json(product);
  } catch (error) {
    console.log(`Error in addProduct Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const getProduct = async (request, response) => {
  try {
    const products = await Product.find({});
    response.status(200).json(products);
  } catch (error) {
    console.log(`Error in Admin get Product Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const deleteProduct = async (request, response) => {
  try {
    const { id } = request.body;
    let product = await Product.findByIdAndDelete(id);
    response.status(200).json(product);
  } catch (error) {
    console.log(`Error in Amdin delete Product Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const getOrder = async (request, response) => {
  try {
    console.log(`Admin get Orders called:`);
    const orders = await Order.find({});
    // Return the orders (note: it will be an array)
    response.status(200).json({
      success: true,
      message: "Orders retrieved successfully",
      orders: orders, // Changed from 'order' to 'orders' since it's an array
    });
  } catch (error) {
    console.log(`Error in Admin get Orders Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const changeOrderStatus = async (request, response) => {
  try {
    console.log(`change Orders Status called:`);
    const { id, status } = request.body;
    let orders = await Order.findById(id);
    orders.status = status;
    orders = await orders.save();

    // Return the orders (note: it will be an array)
    response.status(200).json({
      success: true,
      message: "Orders status changed successfully",
      orders: orders, // Changed from 'order' to 'orders' since it's an array
    });
  } catch (error) {
    console.log(`Error in Orders changed status Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const productAnalytics = async (request, response) => {
  try {
    console.log(`Analytics called:`);
    const orders = await Order.find({});
    let totalEarnings = 0;
    for (let i = 0; i < orders.length; i++) {
      for (let j = 0; j < orders[i].products.length; j++) {
        totalEarnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      }
    }
    // Categories Wise Orders Fetchings...
    let sportsEarnings = await fetchCategoriesWiseProducts("Sports");
    let clothesEarnings = await fetchCategoriesWiseProducts("Clothing");
    let electronicsEarnings = await fetchCategoriesWiseProducts("Electronics");
    let cosmeticsEarnings = await fetchCategoriesWiseProducts("Cosmetics");
    let booksEarnings = await fetchCategoriesWiseProducts("Books");
    let othersEarnings = await fetchCategoriesWiseProducts("Others");
    let earnings = {
      totalEarnings,
      sportsEarnings,
      clothesEarnings,
      electronicsEarnings,
      cosmeticsEarnings,
      booksEarnings,
      othersEarnings,
    };
    response.status(200).json({
      success: true,
      message: "Earnings retrieved successfully",
      earnings: earnings, // Changed from 'order' to 'orders' since it's an array
    });
  } catch (error) {
    console.log(`Error in Analytics Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

async function fetchCategoriesWiseProducts(category) {
  let categoriesOrder = await Order.find({
    "products.product.category": category,
  });
  let earnings = 0;
  for (let i = 0; i < categoriesOrder.length; i++) {
    for (let j = 0; j < categoriesOrder[i].products.length; j++) {
      earnings +=
        categoriesOrder[i].products[j].quantity *
        categoriesOrder[i].products[j].product.price;
    }
  }
  return earnings;
}

export const getAllUsers = async (request, response) => {
  try {
    // Just get the count, not all user data
    const userCount = await User.countDocuments({});

    response.status(200).json({
      success: true,
      count: userCount,
    });
  } catch (error) {
    console.log(`Error in admin get all users Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};
