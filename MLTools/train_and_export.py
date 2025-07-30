import os
import numpy as np
import tensorflow as tf
from tensorflow.keras import layers, models
import coremltools as ct
from coremltools.converters.mil import ClassifierConfig

# 📥 Загрузка данных
X = np.load("dataset/X.npy")            # shape (N, 32, 2)
y = np.load("dataset/y.npy")            # shape (N,)
classes = np.load("dataset/classes.npy").tolist()  # ['fire', 'ice', 'lightning']

print(f"📊 X: {X.shape}, y: {y.shape}, classes: {classes}")

# 🧠 Построение модели
model = models.Sequential([
    # 🟦 Входной слой: последовательность из 32 точек (x, y)
    layers.Input(shape=(32, 2)),

    # 🧠 Свёрточный слой: 64 фильтра, размер ядра 3, активация ReLU
    # Извлекает локальные шаблоны из траектории рун
    layers.Conv1D(64, 3, activation='relu'),

    # 🧊 MaxPooling: уменьшает размерность, выбирая максимум в каждом окне
    # Делает модель менее чувствительной к смещениям
    layers.MaxPooling1D(),

    # 🧱 "Разворачивает" 2D фичи в 1D вектор (flatten)
    layers.Flatten(),

    # 🔗 Полносвязный слой: 64 нейрона, ReLU
    # Интегрирует всю информацию в обобщённые признаки
    layers.Dense(64, activation='relu'),

    # 🎯 Выходной слой: по одному нейрону на каждый класс
    # Применяет softmax для получения вероятностей
    layers.Dense(len(classes), activation='softmax')
])


model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)

# 🚂 Обучение
model.fit(X, y, epochs=100, validation_split=0.2, verbose=1)

# 💾 Сохраняем как SavedModel
saved_model_path = "saved_model"
model.save(saved_model_path, save_format="tf")
print(f"✅ SavedModel сохранён: {saved_model_path}/")

# 🧠 Конфигурация классификатора
config = ClassifierConfig(class_labels=classes)

# 🔁 Конвертация в CoreML с меткой
mlmodel = ct.convert(
    saved_model_path,
    source="tensorflow",
    inputs=[ct.TensorType(name="input_1", shape=(1, 32, 2))],
    classifier_config=config,
    convert_to="mlprogram"
)

# 🏷 Добавляем метаданные
output_name = mlmodel._spec.description.output[0].name
mlmodel.output_description[output_name] = "Predicted rune label"
mlmodel.user_defined_metadata["classes"] = ",".join(classes)

# Дополнительно — общие поля
mlmodel.short_description = "Rune gesture recognizer for magic tower defense"
mlmodel.author = "Juri Breslauer"
mlmodel.license = "MIT"
mlmodel.version = "1.0"

# 💾 Сохраняем .mlpackage
mlmodel.save("RuneModel.mlpackage")
print("✅ CoreML модель сохранена: RuneModel.mlpackage")