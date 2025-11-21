# Use official Python 3.8 image
FROM python:3.8-slim

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Initialize the database
RUN python init_db.py

# Expose port 3111
EXPOSE 3111

# Run the application
CMD ["python", "app.py"]
