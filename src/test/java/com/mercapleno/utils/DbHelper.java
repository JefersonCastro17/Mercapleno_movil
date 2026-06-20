package com.mercapleno.utils;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DbHelper {
    private static final String URL = "jdbc:mysql://localhost:3306/mercapleno";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static String getVerificationCodeForEmail(String email) {
        String hash = getHashFromDb(email, "email_verification_code");
        if (hash == null) {
            throw new RuntimeException("No verification hash found in DB for email: " + email);
        }
        return bruteForceSixDigitCode(hash);
    }

    public static String getPasswordResetCodeForEmail(String email) {
        String hash = getHashFromDb(email, "password_reset_code");
        if (hash == null) {
            throw new RuntimeException("No password reset hash found in DB for email: " + email);
        }
        return bruteForceSixDigitCode(hash);
    }

    private static String getHashFromDb(String email, String column) {
        String query = "SELECT " + column + " FROM usuarios WHERE email = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                 PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, email);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getString(column);
                    }
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Database error retrieving " + column + ": " + e.getMessage(), e);
        }
        return null;
    }

    private static String bruteForceSixDigitCode(String targetHash) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            for (int i = 100000; i <= 999999; i++) {
                String codeStr = String.valueOf(i);
                byte[] hashBytes = digest.digest(codeStr.getBytes("UTF-8"));
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) {
                    sb.append(String.format("%02x", b));
                }
                if (sb.toString().equals(targetHash)) {
                    return codeStr;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Brute force error: " + e.getMessage(), e);
        }
        throw new RuntimeException("Failed to brute force verification code for hash: " + targetHash);
    }
}
