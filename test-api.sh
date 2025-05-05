#!/bin/bash

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Spring Security JWT API Testing Script${NC}\n"

BASE_URL="http://localhost:8080"

# Function to make API calls and display results
call_api() {
    local description=$1
    local method=$2
    local endpoint=$3
    local data=$4
    local auth_header=$5

    echo -e "\n${GREEN}Testing: ${description}${NC}"
    echo "Endpoint: ${method} ${endpoint}"
    
    if [ -n "$data" ]; then
        echo "Request Body: ${data}"
    fi

    if [ -n "$auth_header" ]; then
        echo "Auth Header: ${auth_header}"
    fi

    echo -e "\nResponse:"
    if [ -n "$data" ]; then
        if [ -n "$auth_header" ]; then
            curl -s -X "${method}" "${BASE_URL}${endpoint}" \
                -H "Content-Type: application/json" \
                -H "${auth_header}" \
                -d "${data}"
        else
            curl -s -X "${method}" "${BASE_URL}${endpoint}" \
                -H "Content-Type: application/json" \
                -d "${data}"
        fi
    else
        if [ -n "$auth_header" ]; then
            curl -s -X "${method}" "${BASE_URL}${endpoint}" \
                -H "${auth_header}"
        else
            curl -s -X "${method}" "${BASE_URL}${endpoint}"
        fi
    fi
    echo -e "\n"
}

echo -e "${BLUE}1. Testing Public Endpoints${NC}"
call_api "Access public content" "GET" "/api/test/all"

echo -e "${BLUE}2. Creating Regular User${NC}"
USER_RESPONSE=$(curl -s -X POST "${BASE_URL}/api/auth/signup" \
    -H "Content-Type: application/json" \
    -d '{
        "username": "testuser",
        "email": "testuser@example.com",
        "password": "password123",
        "role": ["user"]
    }')
echo "Response: ${USER_RESPONSE}"

echo -e "\n${BLUE}3. Creating Admin User${NC}"
ADMIN_RESPONSE=$(curl -s -X POST "${BASE_URL}/api/auth/signup" \
    -H "Content-Type: application/json" \
    -d '{
        "username": "adminuser",
        "email": "admin@example.com",
        "password": "admin123",
        "role": ["admin"]
    }')
echo "Response: ${ADMIN_RESPONSE}"

echo -e "\n${BLUE}4. Testing Regular User Authentication${NC}"
USER_TOKEN_RESPONSE=$(curl -s -X POST "${BASE_URL}/api/auth/signin" \
    -H "Content-Type: application/json" \
    -d '{
        "username": "testuser",
        "password": "password123"
    }')
USER_TOKEN=$(echo ${USER_TOKEN_RESPONSE} | sed 's/.*"token":"\([^"]*\)".*/\1/')
echo "User Token: ${USER_TOKEN}"

echo -e "\n${BLUE}5. Testing Admin User Authentication${NC}"
ADMIN_TOKEN_RESPONSE=$(curl -s -X POST "${BASE_URL}/api/auth/signin" \
    -H "Content-Type: application/json" \
    -d '{
        "username": "adminuser",
        "password": "admin123"
    }')
ADMIN_TOKEN=$(echo ${ADMIN_TOKEN_RESPONSE} | sed 's/.*"token":"\([^"]*\)".*/\1/')
echo "Admin Token: ${ADMIN_TOKEN}"

echo -e "\n${BLUE}6. Testing Protected Endpoints with Regular User${NC}"
call_api "Access user content with user token" "GET" "/api/test/user" "" "Authorization: Bearer ${USER_TOKEN}"
call_api "Try to access admin content with user token" "GET" "/api/test/admin" "" "Authorization: Bearer ${USER_TOKEN}"

echo -e "\n${BLUE}7. Testing Protected Endpoints with Admin User${NC}"
call_api "Access user content with admin token" "GET" "/api/test/user" "" "Authorization: Bearer ${ADMIN_TOKEN}"
call_api "Access admin content with admin token" "GET" "/api/test/admin" "" "Authorization: Bearer ${ADMIN_TOKEN}"

echo -e "\n${BLUE}8. Testing Invalid Scenarios${NC}"
# Test with invalid token
call_api "Access protected endpoint with invalid token" "GET" "/api/test/user" "" "Authorization: Bearer invalid_token"

# Test signup with existing username
call_api "Try to register existing username" "POST" "/api/auth/signup" '{
    "username": "testuser",
    "email": "another@example.com",
    "password": "password123",
    "role": ["user"]
}'

# Test login with wrong password
call_api "Try to login with wrong password" "POST" "/api/auth/signin" '{
    "username": "testuser",
    "password": "wrongpassword"
}'

echo -e "${GREEN}Testing completed!${NC}" 