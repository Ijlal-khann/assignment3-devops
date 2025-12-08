"""
Configuration file for Selenium tests
"""

# Test URL - Docker host IP when running in container
TEST_URL = "http://172.17.0.1:8000"

# Timeout settings (seconds)
TIMEOUT = 10
PAGE_LOAD_TIMEOUT = 30

# Chrome options
HEADLESS = True
WINDOW_SIZE = "1920,1080"

# Test settings
IMPLICIT_WAIT = 10
SCREENSHOT_ON_FAILURE = True

