import secrets

# Generate a 32-byte (64-character) hex secret
api_secret_hex = secrets.token_hex(32)
print(f"Hex Secret: {api_secret_hex}")

# Generate a URL-safe secret with 32 bytes of entropy (approx. 43 characters)
api_secret_urlsafe = secrets.token_urlsafe(32)
print(f"URL-Safe Secret: {api_secret_urlsafe}")
