import os
import json
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split

EXTRACT_DIR = "runes_data"
OUTPUT_DIR = "dataset"
TARGET_LENGTH = 32  # длина траектории после паддинга/интерполяции

os.makedirs(OUTPUT_DIR, exist_ok=True)

def load_data():
    samples = []
    labels = []

    for f in os.listdir(EXTRACT_DIR):
        if not f.endswith(".json"): continue

        with open(os.path.join(EXTRACT_DIR, f), 'r') as file:
            data = json.load(file)
            label = data.get("label", "unknown")
            raw_points = data.get("points", [])

            if not raw_points or len(raw_points) % 2 != 0:
                continue

            points = np.array(raw_points).reshape(-1, 2)
            samples.append(points)
            labels.append(label)

    return samples, labels

def normalize_points(points):
    # нормализуем в [0, 1] по X и Y отдельно
    min_xy = points.min(axis=0)
    max_xy = points.max(axis=0)
    range_xy = np.where((max_xy - min_xy) == 0, 1, max_xy - min_xy)
    return (points - min_xy) / range_xy

def resize_points(points, target_len=32):
    if len(points) == target_len:
        return points
    elif len(points) > target_len:
        idx = np.linspace(0, len(points)-1, target_len).astype(int)
        return points[idx]
    else:
        pad_len = target_len - len(points)
        pad = np.tile(points[-1], (pad_len, 1))
        return np.concatenate([points, pad], axis=0)

def prepare():
    print("📥 Загрузка данных...")
    samples, labels = load_data()
    print(f"  → загружено {len(samples)} рун")

    X = []
    for p in samples:
        p = normalize_points(p)
        p = resize_points(p, TARGET_LENGTH)
        X.append(p)

    X = np.array(X)  # shape: (N, 32, 2)

    label_encoder = LabelEncoder()
    y = label_encoder.fit_transform(labels)  # 0, 1, 2, ...

    np.save(os.path.join(OUTPUT_DIR, "X.npy"), X)
    np.save(os.path.join(OUTPUT_DIR, "y.npy"), y)
    np.save(os.path.join(OUTPUT_DIR, "classes.npy"), label_encoder.classes_)

    print(f"✅ Сохранено в {OUTPUT_DIR}/")
    print(f"   X shape: {X.shape}")
    print(f"   y shape: {y.shape}")
    print(f"   classes: {label_encoder.classes_.tolist()}")

if __name__ == "__main__":
    prepare()
