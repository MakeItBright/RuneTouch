# 🔮 RuneRecognizer ML Pipeline

Пайплайн для обучения и экспорта модели распознавания рун в формате CoreML.

---

## 📁 Структура входных данных

В папке `runes_data/` лежат `.json` файлы такого вида:

```json
{
  "label": "fire",         // имя руны
  "points": [x0, y0, x1, y1, x2, y2, ...] // список координат
}
```

---

## 🧪 Этапы обучения

### 1. 📊 Просмотр и проверка рун

```bash
python inspect_runes.py
```

- Сохраняет `runes_preview.png` с примерами
- Показывает статистику по классам

---

### 2. 🧹 Подготовка датасета

```bash
python prepare_dataset.py
```

Создаёт папку `dataset/`:

```
X.npy         # shape (N, 32, 2)
y.npy         # метки классов
classes.npy   # список имён классов
```

---

### 3. 🧠 Обучение и экспорт

```bash
python train_and_export.py
```

Результат:

- `saved_model/` — TensorFlow SavedModel
- `RuneModel.mlpackage` — CoreML модель для iOS
- Выходной тензор: `Identity`

---

## ✅ Интеграция в Xcode

1. Добавь `RuneModel.mlpackage` в проект
2. В Swift:

```swift
let model = try RuneModel(configuration: .init())
let input = try MLMultiArray(shape: [1, 32, 2], dataType: .float32)
// Заполни input точками
let output = try model.prediction(input: input)
print(output.Identity) // "fire", "ice", "lightning"
```

---

## 📦 Требования

- Python 3.10
- `tensorflow-macos==2.12.0`
- `coremltools==6.3`
- `scikit-learn<=1.1.2`

---
