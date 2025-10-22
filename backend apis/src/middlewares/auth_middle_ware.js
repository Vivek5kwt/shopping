import { request, response } from "express";
import jwt from "jsonwebtoken";

import User from "../models/user.js";
export const protectRoute = async (req, res, next) => {
  try {
    // Check for token in Authorization header (Bearer token)
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized - No token provided",
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized - No token provided",
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.userId).select("-password");

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized - User not found",
      });
    }

    req.user = user;
    next();
  } catch (error) {
    console.log(`Error in protectRoute middleware: ${error.message}`);

    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({
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
