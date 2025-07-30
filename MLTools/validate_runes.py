import os
import json

DATA_DIR = "runes_data"

def validate_json_files():
    files = [f for f in os.listdir(DATA_DIR) if f.endswith('.json')]
    if not files:
        print("❌ Нет .json файлов в runes_data/")
        return

    total = 0
    valid = 0
    errors = []

    for f in files:
        path = os.path.join(DATA_DIR, f)
        total += 1
        try:
            with open(path, 'r') as file:
                data = json.load(file)
            label = data.get("label", None)
            points = data.get("points", [])

            if not isinstance(label, str):
                errors.append((f, "Нет или нестроковый label"))
                continue

            if not isinstance(points, list) or len(points) % 2 != 0:
                errors.append((f, "Некорректный список points"))
                continue

            if len(points) < 4:
                errors.append((f, "Слишком мало точек"))
                continue

            valid += 1
        except Exception as e:
            errors.append((f, f"Ошибка чтения: {e}"))

    print(f"🔍 Проверено файлов: {total}")
    print(f"✅ Валидных: {valid}")
    print(f"⚠️ Проблемных: {len(errors)}")
    for name, reason in errors:
        print(f"  - {name}: {reason}")

if __name__ == "__main__":
    validate_json_files()
