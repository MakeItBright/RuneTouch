import numpy as np
import tensorflow as tf
from tensorflow.keras import layers, models

# 📥 Загрузка данных
X = np.load("dataset/X.npy")  # shape: (N, 32, 2)
y = np.load("dataset/y.npy")  # shape: (N,)
classes = np.load("dataset/classes.npy")  # ['lightning']

print(f"📊 Данные: X.shape = {X.shape}, y.shape = {y.shape}, classes = {classes}")

# 🧠 Модель
model = models.Sequential([
    layers.Input(shape=(32, 2)),
    layers.Conv1D(64, 3, activation='relu'),
    layers.MaxPooling1D(),
    layers.Flatten(),
    layers.Dense(64, activation='relu'),
    layers.Dense(len(classes), activation='softmax')  # <= даже если 1 класс
])

model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# 🚂 Обучение
history = model.fit(
    X, y,
    epochs=20,
    validation_split=0.2,
    verbose=1
)

# 💾 Сохраняем модель
model.save("saved_model/", save_format="tf")
model.save("rune_model.keras")

print("✅ Модель сохранена: rune_model.keras")
