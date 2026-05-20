import secrets
import string

def generate_api_key(length: int = 32) -> str:
    """
    Generates a cryptographically secure, URL-safe API key.

    Args:
        length (int): The length of the API key in characters.

    Returns:
        str: A secure, randomly generated API key.
    """
    # Define the alphabet of allowed characters
    alphabet = string.ascii_letters + string.digits
    # Generate the key using secrets.choice for cryptographic strength
    api_key = ''.join(secrets.choice(alphabet) for _ in range(length))
    return api_key

# Example usage:
new_key = generate_api_key()
print(f"Generated API Key: {new_key}")

