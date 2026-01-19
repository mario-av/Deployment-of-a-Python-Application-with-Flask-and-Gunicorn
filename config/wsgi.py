try:
    # Try importing from the Azure sample's default file (usually app.py)
    from app import app
except ImportError:
    # Fallback to the previous default
    from application import app

if __name__ == '__main__':
    app.run(debug=False)
