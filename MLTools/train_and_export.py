import os
import numpy as np
import tensorflow as tf
from tensorflow.keras import layers, models
import coremltools as ct

# 📥 Загрузка данных
X = np.load("dataset/X.npy")            # shape (N, 32, 2)
y = np.load("dataset/y.npy")            # shape (N,)
classes = np.load("dataset/classes.npy").tolist()  # ['fire', 'ice', 'lightning']

print(f"📊 X: {X.shape}, y: {y.shape}, classes: {classes}")

# 🧠 Построение модели
model = models.Sequential([
    layers.Input(shape=(32, 2)),
    layers.Conv1D(64, 3, activation='relu'),
    layers.MaxPooling1D(),
    layers.Flatten(),
    layers.Dense(64, activation='relu'),
    layers.Dense(len(classes), activation='softmax')
])

model.compile(
    optimizer='adam',
    loss='sparse_categorical_crossentropy',
    metrics=['accuracy']
)


# 🚂 Обучение
model.fit(X, y, epochs=20, validation_split=0.2, verbose=1)

# 💾 Сохраняем в формате SavedModel
saved_model_path = "saved_model"
model.save(saved_model_path, save_format="tf")
print(f"✅ SavedModel сохранён: {saved_model_path}/")

# 🔁 Конвертация в CoreML
# mlmodel = ct.convert(
#     saved_model_path,
#     source="tensorflow",
#     inputs=[ct.TensorType(name="input", shape=(1, 32, 2))],
#     convert_to="mlprogram"
# )
for layer in model.layers:
    print(f"🧩 Layer: {layer.name}")
mlmodel = ct.convert(
    saved_model_path,
    source="tensorflow",
    inputs=[ct.TensorType(name="input_1", shape=(1, 32, 2))],
    convert_to="mlprogram"
)


# Определяем имя выхода
output_name = mlmodel._spec.description.output[0].name
print(f"✅ Настоящее имя выхода: {output_name}")

mlmodel.output_description[output_name] = "Predicted rune class"
mlmodel.user_defined_metadata["classes"] = ",".join(classes)

mlmodel.save("RuneModel.mlpackage")
print("✅ CoreML модель сохранена: RuneModel.mlmodel")
