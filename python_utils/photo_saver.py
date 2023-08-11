import sys
import os
import base64

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

