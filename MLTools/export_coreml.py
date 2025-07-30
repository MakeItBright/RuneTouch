import coremltools as ct
import numpy as np
import tensorflow as tf

# 📥 Загрузка Keras-модели
keras_model = tf.keras.models.load_model("rune_model.keras")
print("✅ Модель загружена: rune_model.keras")

# ℹ️ Уточняем входную форму
input_shape = (1, 32, 2)  # Один пример, 32 точки, 2 координаты (x, y)

# 🔤 Загружаем список классов
classes = np.load("dataset/classes.npy").tolist()  # ['lightning', ...]

# 🧠 Конвертация в CoreML
mlmodel = ct.convert(
    keras_model,
    source="tensorflow",  # 👈 обязательно, особенно на TensorFlow-MacOS
    inputs=[ct.TensorType(name="input", shape=input_shape)],
    convert_to="mlprogram"  # Используется для совместимости с iOS 15+
)

# 📎 Добавим описание и метаданные
mlmodel.output_description["output"] = "Predicted rune class"
mlmodel.user_defined_metadata["classes"] = ",".join(classes)

# 💾 Сохраняем .mlmodel
mlmodel.save("RuneModel.mlmodel")
print("✅ CoreML модель сохранена: RuneModel.mlmodel")
