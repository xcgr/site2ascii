from django.shortcuts import render
from .utils import take_screenshot, image_to_ascii

def home(request):
    ascii_art = None
    target_url = None
    error_msg = None

    if request.method == "POST":
        target_url = request.POST.get('url')
        if target_url:
            if not target_url.startswith(('http://', 'https://')):
                target_url = 'https://' + target_url
            
            try:
                img_stream = take_screenshot(target_url)
                ascii_art = image_to_ascii(img_stream, new_width=120)
            except Exception as e:
                error_msg = f"Hata oluştu: {str(e)}"

    return render(request, 'index.html', {
        'ascii_art': ascii_art, 
        'target_url': target_url,
        'error_msg': error_msg
    })
