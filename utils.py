from PIL import Image
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import io

ASCII_CHARS = ["@", "#", "S", "%", "?", "*", "+", ";", ":", ",", "."]

def take_screenshot(url):
    chrome_options = Options()
    chrome_options.add_argument("--headless") 
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--window-size=1200,1000")
    
    try:
        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=chrome_options)
        
        driver.set_page_load_timeout(20) # 20 saniyede açılmazsa iptal et
        driver.get(url)
        screenshot = driver.get_screenshot_as_png()
        driver.quit()
        return io.BytesIO(screenshot)
    except Exception as e:
        # Hata olsa bile driver'ı kapatmayı dene
        try:
            driver.quit()
        except:
            pass
        raise e

def image_to_ascii(image_stream, new_width=100):
    image = Image.open(image_stream)
    width, height = image.size
    aspect_ratio = height / width
    new_height = int(aspect_ratio * new_width * 0.55)
    image = image.resize((new_width, new_height))
    image = image.convert("L")
    pixels = image.getdata()
    new_pixels = [ASCII_CHARS[pixel // 25] for pixel in pixels]
    new_pixels = ''.join(new_pixels)
    new_pixels_count = len(new_pixels)
    ascii_image = "\n".join([new_pixels[index:(index + new_width)] for index in range(0, new_pixels_count, new_width)])
    return ascii_image
