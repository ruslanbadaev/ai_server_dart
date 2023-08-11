import sys
import os
import base64
import numpy as np

def save_image_from_base64(base64_string, filename):
    try:
        # Декодируем base64 строку в бинарные данные
        image_data = base64.b64decode(base64_string)

        # Создаем папку inputs, если она не существует
        os.makedirs("inputs", exist_ok=True)

        # Полный путь к файлу
        filepath = os.path.join("inputs", filename)

        # Сохраняем изображение в файл
        with open(filepath, "wb") as file:
            file.write(image_data)
        
        print(f"Изображение успешно сохранено в {filepath}")
    except Exception as e:
        print(f"Ошибка: {str(e)}")
        

def start_gen(filename, prompt, strength):
    seed = np.random.randint(86400)
    script = f'python3 ./generator/scripts/img2img.py --prompt="{prompt}" --ckpt="/Users/ruslan/projects/ai_server_dart/generator/models/ldm/stable-diffusion-v1/dreamshaper_5BakedVae.ckpt" --seed="{seed}" --outdir="outputs/{filename}" --strength="{strength}" --skip_save --n_samples 1 --n_iter=1'
    print(script)
    os.system(script)
    
if __name__ == "__main__":
    # Получаем аргументы командной строки
    base64_string = sys.argv[1]
    filename = sys.argv[2]
    print("base64_string:")
    print(base64_string)
    print("filename:")
    print(filename)
    # Вызываем функцию сохранения изображения
    save_image_from_base64(base64_string, filename)
    start_gen(filename=filename, prompt="dancing cat with hat", strength='0.6')

