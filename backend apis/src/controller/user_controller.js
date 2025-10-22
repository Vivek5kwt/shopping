import express, { response } from "express";
import User from "../models/user.js";
import bcrypt from "bcrypt";
import { generateToken } from "../lib/jwt_token.js";
import { Product } from "../models/products.js";
import { request } from "http";

import Order from "../models/order.js";
export const signup = async (request, response) => {
  const { name, email, password, type } = request.body; // Added type
  try {
    if (!name || !email || !password) {
      return response.status(400).json({
        success: false,
        message: "All fields are required",
      });
    }

    if (password.length < 6) {
      return response.status(400).json({
        success: false,
        message: "Password must be at least 6 characters",
      });
    }

    const user = await User.findOne({ email });
    if (user) {
      return response.status(400).json({
        success: false,
        message: "Email already exists!",
      });
    }

    // hashing the password..
    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(password, salt);

    // Create new user with type field
    const newUser = new User({
      name,
      email,
      password: hashPassword,
      type: type || "user", // Use provided type or default to 'user'
    });

    if (newUser) {
      await newUser.save();

      // generate jwt token...
      const token = generateToken(newUser._id);

      return response.status(201).json({
        success: true,
        message: "User created successfully",
        token: token,
        user: {
          _id: newUser._id,
          name: newUser.name,
          email: newUser.email,
          type: newUser.type, // Include type in response
          profilePic: newUser.profilePic,
        },
      });
    } else {
      response.status(400).json({
        success: false,
        message: "Invalid user data",
      });
    }
  } catch (error) {
    console.log(`Error in signup Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

// login...api..

export const login = async (request, response) => {
  const { email, password } = request.body;
  try {
    const user = await User.findOne({ email });

    if (!user) {
      return response.status(400).json({
        success: false,
        message: "Inavlid Credentials",
      });
    }
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return response.status(400).json({
        success: false,
        message: "Inavlid Credentials",
      });
    }
    // Generate JWT token
    const token = generateToken(user._id);

    response.status(200).json({
      success: true,
      message: "Login successful",
      token: token,
      user: {
        _id: user._id,
        name: user.name,
        email: user.email,
          type: user.type, // Include type in response
        profilePic: user.profilePic,
      },
    });
  } catch (error) {
    console.log(`Error in login Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const checkAuth = (request, response) => {
  try {
    console.log("Check is Called");
    response.status(200).json({
      success: true,
      message: "User authenticated",
      user: {
        _id: request.user._id,
        name: request.user.name,
        email: request.user.email,
        profilePic: request.user.profilePic,
        type: request.user.type,
        address: request.user.address,
        cart: request.user.cart,
      },
    });
  } catch (error) {
    console.log(`Error in checkAuth Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const getUser = async (request, response) => {
  try {
    console.log("getting user is Called");
    const { id } = request.params;
    const user = await User.findById(id);
    response.status(200).json({
      success: true,
      message: "User fetched",
      user: user,
    });
  } catch (error) {
    console.log(`Error in getting Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};

export const updateUserProfilePic = async (request, response) => {
  try {
    console.log(`update profilepic called`);
    console.log("Request body:", request.body); // Add this
    console.log("profilePic value:", request.body.profilePic); // Add this

    const { profilePic } = request.body;

    if (!profilePic) {
      return response.status(400).json({
        success: false,
        message: "profilePic is required",
      });
    }

    let user = await User.findById(request.user.id);

    if (!user) {
      return response.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    user.profilePic = profilePic;
    user = await user.save();

    response.status(200).json({
      success: true,
      message: "Update profilePic successfully",
      user: user,
    });
  } catch (error) {
    console.log(
      `Error in updating user Profilepic Controller: ${error.message}`
    );
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
      error: error.message,
    });
  }
};

export const addToCart = async (request, response) => {
  try {
    console.log("Add to cart is called");
    const { id } = request.body;
    console.log(`user id : ${request.user.id}`);

    const product = await Product.findById(id);

    if (!product) {
      return response.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    let user = await User.findById(request.user.id);

    if (!user) {
      return response.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let updateProduct = user.cart.find((prod) =>
          prod.product._id.equals(product._id)
        );
        updateProduct.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }

    // FIX: Add await here!
    user = await user.save();

    console.log(`Cart updated successfully. Cart length: ${user.cart.length}`);

    // Return the updated user with cart
    response.status(200).json({
      success: true,
      message: "Product added to cart successfully",
      cart: user.cart,
      user: user,
    });
  } catch (error) {
    console.log(`Error in add to cart Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
      error: error.message,
    });
  }
};

export const removeFromCart = async (request, response) => {
  try {
    console.log("Remove from cart is called");
    const { id } = request.params;
    console.log(`user id : ${request.user.id}`);

    const product = await Product.findById(id);

    if (!product) {
      return response.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    let user = await User.findById(request.user.id);

    if (!user) {
      return response.status(404).json({
        success: false,
        message: "User not found",
      });
    }
    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }

    // FIX: Add await here!
    user = await user.save();

    console.log(`Cart updated successfully. Cart length: ${user.cart.length}`);

    // Return the updated user with cart
    response.status(200).json({
      success: true,
      message: "Product remove from cart successfully",
      cart: user.cart,
      user: user,
    });
  } catch (error) {
    console.log(`Error in remove from cart Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
      error: error.message,
    });
  }
};

export const saveUserAddress = async (request, response) => {
  try {
    const { address } = request.body;
    let user = await User.findById(request.user.id);
    user.address = address;

    user = await user.save();
    console.log(`address added successfully: ${user.address}`);

    // Return the updated user with cart
    response.status(200).json({
      success: true,
      message: "Address added successfully",
      address: user.address,
      user: user,
    });
  } catch (error) {
    console.log(`Error in adding user address Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
      error: error.message,
    });
  }
};

export const orderProduct = async (request, response) => {
  try {
    const { cart, totalPrice, address } = request.body;

    let products = [];
    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      if (product.quantity >= cart[i].quantity) {
        product.quantity -= cart[i].quantity;
        products.push({ product, quantity: cart[i].quantity });
        await product.save();
      } else {
        return response.status(400).json({
          success: false,
          message: `${product.name} is out of stock`,
        });
      }
    }

    let user = await User.findById(request.user.id);
    user.cart = [];
    user = await user.save();
    let order = new Order({
      products,
      totalPrice,
      address,
      userId: request.user.id,
      orderedAt: new Date().getTime(),
    });
    order = await order.save();

    console.log(`order placed  successfully`);

    // Return the updated user with cart
    response.status(200).json({
      success: true,
      message: "Order placed successfully",
      order: order,
    });
  } catch (error) {
    console.log(`Error in ordering user products Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
      error: error.message,
    });
  }
};

export const getOrders = async (request, response) => {
  try {
    // Use find() instead of findById() since we're querying by userId
    const orders = await Order.find({ userId: request.user.id });

    console.log(`Orders retrieved successfully`);

    // Return the orders (note: it will be an array)
    response.status(200).json({
      success: true,
      message: "Orders retrieved successfully",
      orders: orders, // Changed from 'order' to 'orders' since it's an array
    });
  } catch (error) {
    console.log(`Error in getting user orders Controller: ${error.message}`);
    response.status(500).json({
      success: false,
      message: "Internal Server Error",
      error: error.message,
    });
  }
};
