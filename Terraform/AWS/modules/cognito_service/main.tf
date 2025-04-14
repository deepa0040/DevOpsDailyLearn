resource "aws_cognito_user_pool" "simple_pool" {
  name = "my-hardcoded-users" # Hardcoded name

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_symbols = false
    require_uppercase = true
    temporary_password_validity_days = 7
  }

  mfa_configuration = "OFF"

  username_attributes = ["email"]

  tags = { # Hardcoded tags
    Environment = "testing"
    Project     = "simple-auth-hardcoded"
    Location    = "Sukteri, Haryana, India" # Passing current location
  }
}

resource "aws_cognito_user_pool_client" "simple_client" {
  name = "my-hardcoded-app" # Hardcoded client name
  user_pool_id = aws_cognito_user_pool.simple_pool.id # Referencing another resource attribute
  allowed_oauth_flows = ["implicit", "code"]
  allowed_oauth_scopes = ["openid", "profile", "email"]
  callback_urls = ["https://myapp.example.com/callback"] # Hardcoded callback URL
  logout_urls = ["https://myapp.example.com/logout"]   # Hardcoded logout URL
  generate_secret = false
}

# Output the User Pool ID and Client ID
output "user_pool_id" {
  value = aws_cognito_user_pool.simple_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.simple_client.id
}