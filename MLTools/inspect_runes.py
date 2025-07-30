import matplotlib
matplotlib.use("Agg")  # 💡 отключает macOS GUI / Tkinter
import os
import zipfile
import json
import numpy as np
import matplotlib.pyplot as plt

# 📁 Пути
ZIP_PATH = "runes_export.zip"
EXTRACT_DIR = "runes_data"

# 📦 Распаковка архива
def unzip_data():
    if not os.path.exists(EXTRACT_DIR):
        with zipfile.ZipFile(ZIP_PATH, 'r') as zip_ref:
            zip_ref.extractall(EXTRACT_DIR)
        print(f"[✓] Распаковано в папку: {EXTRACT_DIR}")
    else:
        print(f"[i] Папка уже существует: {EXTRACT_DIR}")

# 📖 Загрузка и отрисовка
def visualize_samples(max_per_class=3):
    rune_by_class = {}
    files = [f for f in os.listdir(EXTRACT_DIR) if f.endswith('.json')]

    for f in files:
        try:
            with open(os.path.join(EXTRACT_DIR, f), 'r') as file:
                data = json.load(file)
                rune_type = data.get("label", "unknown")  # 👈 поменяли на 'label'
                raw_points = data.get("points", [])

                if not raw_points or len(raw_points) % 2 != 0:
                    continue  # должно быть чётное количество

                # 👇 превращаем [x0, y0, x1, y1, ...] в [[x0, y0], [x1, y1], ...]
                points = np.array(raw_points).reshape(-1, 2)

                if rune_type not in rune_by_class:
                    rune_by_class[rune_type] = []
                rune_by_class[rune_type].append(points)

        except Exception as e:
            print(f"⚠️ Ошибка при обработке {f}: {e}")

    if not rune_by_class:
        print("⚠️ Нет валидных рун для отображения")
        return

    print("📊 Статистика:")
    for rtype, samples in rune_by_class.items():
        print(f"  • {rtype}: {len(samples)} рун")

    # 🎨 Отрисовка
    plt.close("all")
    plt.figure(figsize=(12, len(rune_by_class) * 2))

    for i, (rune_type, samples) in enumerate(rune_by_class.items()):
        for j, points in enumerate(samples[:max_per_class]):
            x, y = points[:, 0], points[:, 1]
            plt.subplot(len(rune_by_class), max_per_class, i * max_per_class + j + 1)
            plt.plot(x, y, marker='o')
            plt.title(f"{rune_type} #{j+1}")
            plt.axis('equal')
            plt.axis('off')

    plt.tight_layout()
    plt.subplots_adjust(top=0.95, bottom=0.05)

    try:
        plt.savefig("runes_preview.png")
        print("✅ График сохранён в runes_preview.png")
    except Exception as e:
        print(f"❌ Ошибка при сохранении изображения: {e}")
# 🚀 Старт
if __name__ == "__main__":
    unzip_data()
    visualize_samples()
