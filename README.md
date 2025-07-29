# 🪄 RuneTouch

**RuneTouch** — это аркадная игра на iOS, в которой ты отражаешь нападающих врагов с помощью магических жестов. Рисуй руны, чтобы активировать заклинания и защищать башню.

---

## 📱 Скриншоты (в будущем)

_Тут будут гифки и скрины с геймплеем_

---

## ✨ Особенности

- 🎮 Рисуй символы пальцем, чтобы уничтожать врагов
- 🧠 Чистая архитектура: Clean Architecture + Swift Packages
- 🔧 Создано на базе `SpriteKit` + `SwiftUI`
- 🪄 Поддержка 10+ магических рун
- ⚡️ Эффекты, очки, гейм-овер, прогрессия
- 📱 Оптимизировано под iPhone

---

## 🧱 Архитектура

Проект построен на Clean Architecture и разделён на пакеты:

```
RuneTouch/
├── GameDomain/          # Бизнес-сущности: GameSession, Symbol и т.д.
├── GameUseCases/        # Игровая логика: проверки, прогресс
├── GamePresentation/    # ViewModel, UI State
├── GameUI/              # SpriteKit-сцена, HUD и SwiftUI
├── SettingsFeature/     # Темы, звук
├── MonetizationFeature/ # Реклама, rewarded ads
├── SharedResources/     # Ассеты: спрайты, цвета, звуки
├── App/                 # Запуск, роутинг, сцены
```

---

## 🚧 TODO (основные задачи)

- [x] Инициализация проекта
- [x] Подключение SpriteKit и SwiftUI
- [ ] Игровая сцена с падающими врагами
- [ ] Обработка жестов и рун
- [ ] Уничтожение врагов при совпадении
- [ ] Game Over экран
- [ ] HUD: очки, жизни
- [ ] Настройки (звук, тема)
- [ ] Интеграция рекламы (AdMob / Unity Ads)
- [ ] Анимации, эффекты, частицы
- [ ] Готовые ассеты и иконки
- [ ] Публикация в TestFlight

---

## 🛠️ Технологии

- Swift 5.9+
- Xcode 15+
- SpriteKit
- SwiftUI
- Swift Package Manager (SPM)
- Clean Architecture (по Uncle Bob)

---

## 📦 Установка

```bash
git clone https://github.com/MakeItBright/RuneTouch.git
cd RuneTouch
open RuneTouch.xcodeproj
```

---

## 🧙 Автор

Создано с магией и Swift — [@MakeItBright](https://github.com/MakeItBright)

---

## 📜 Лицензия

MIT — свободно для использования и обучения.

