import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report
from sklearn.model_selection import train_test_split

# Загрузка данных
X = np.load("dataset/X.npy")
y = np.load("dataset/y.npy")
classes = np.load("dataset/classes.npy")

# Делим на train/test
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Загружаем модель
model = tf.keras.models.load_model("saved_model")

# Предсказания
y_pred_probs = model.predict(X_test)
y_pred = np.argmax(y_pred_probs, axis=1)

# Отчёт
print("📊 Classification Report:")
print(classification_report(y_test, y_pred, target_names=classes))

# Матрица ошибок
cm = confusion_matrix(y_test, y_pred)
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=classes)
disp.plot(cmap=plt.cm.Blues, xticks_rotation=45)
plt.title("🔍 Confusion Matrix")
plt.tight_layout()
plt.savefig("confusion_matrix.png")
print("✅ Матрица ошибок сохранена: confusion_matrix.png")
