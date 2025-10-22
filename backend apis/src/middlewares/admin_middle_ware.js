import express from "express";
import jwt from "jsonwebtoken";
import User from "../models/user.js";

export const adminProtectedRoute = async (request, response, next) => {
  try {
    // Check for token in Authorization header (Bearer token)
    const authHeader = request.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return response.status(401).json({
        success: false,
        message: "Unauthorized - No token provided",
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    if (!token) {
      return response.status(401).json({
        success: false,
        message: "Unauthorized - No token provided",
      });
    }

    const verified = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(verified.userId).select("-password");

    if (!user) {
      return response.status(401).json({
        success: false,
        message: "Unauthorized - User not found",
      });
    }
    if (user.type == "user" || user.type == "seller") {
      return response.status(401).json({
        success: false,
        message: "Unauthorized - You're not an admin!",
      });
    }

    request.user = user;
    next();
  } catch (error) {
    console.log(`Error in admin middleware: ${error.message}`);

    if (error.name === "JsonWebTokenError") {
      return response.status(401).json({
        success: false,
        message: "Unauthorized - Invalid token",
      });
    }

    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        message: "Unauthorized - Token expired",
      });
    }

    res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
};
