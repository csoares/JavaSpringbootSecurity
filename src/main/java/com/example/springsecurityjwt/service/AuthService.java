package com.example.springsecurityjwt.service;

import com.example.springsecurityjwt.dto.JwtResponse;
import com.example.springsecurityjwt.dto.LoginRequest;
import com.example.springsecurityjwt.dto.MessageResponse;
import com.example.springsecurityjwt.dto.SignupRequest;

public interface AuthService {
    JwtResponse authenticateUser(LoginRequest loginRequest);
    MessageResponse registerUser(SignupRequest signUpRequest);
} 