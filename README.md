# 💪 Zest Mobile – Fitness App

Zest Mobile is a modern **fitness app** built with Flutter, designed to help users achieve their health and fitness goals in a structured and seamless way. It offers features like activity tracking, and wellness guides — all wrapped in a responsive and clean UI/UX experience.

---

## 🚀 Tech Stack

| Tech                | Version     |
|---------------------|-------------|
| **Flutter**         | 3.19.5      |
| **Dart**            | 3.3.3       |
| **State Management**| GetX 4.7.2  |

---

## 📁 Folder Structure (Clean Architecture)

```bash
lib/
├── app/
│   ├── core/              # Constants, theme, global widgets
│   │   ├── themes/
│   │   ├── values/
│   │   └── widgets/
│   ├── data/              # Models and API services
│   │   ├── models/
│   │   └── providers/
│   ├── modules/           # Feature-based modular folders
│   │   └── home/
│   │       ├── bindings/
│   │       ├── controllers/
│   │       ├── views/
│   │       └── widgets/
│   ├── routes/            # Routing (app_pages and app_routes)
│   └── app.dart           # Root of the app
├── main.dart              # Application entry point
```

---

## ⚙️ How to Install & Run the Project

To get started locally, follow these steps:

1. **Clone the repository**
   ```bash
   git clone https://github.com/hafizc8/zest_mobile.git
   cd zest_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 🤝 Contribution

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

