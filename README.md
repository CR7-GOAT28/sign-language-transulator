# 🤟 AI Sign Language Translator

An AI-powered mobile application that translates **hand sign language into readable text and speech in real-time** using computer vision and machine learning.

The system uses a **Flutter mobile frontend** to capture camera frames and a **Python backend powered by OpenCV and MediaPipe** to detect hand gestures and convert them into meaningful words and sentences.

---

# 📌 Project Overview

Communication barriers exist between people who use sign language and those who do not understand it. This project aims to bridge that gap by creating a **real-time sign language translation system**.

The application captures hand gestures using the device camera and processes them through an AI-based backend that recognizes gestures and converts them into **text and speech output**.

---

# 🚀 Features

• Real-time hand gesture recognition
• Converts sign language to readable text
• Builds complete sentences from detected words
• Text-to-speech support for spoken output
• Camera-based gesture detection
• Clean and simple mobile interface

---

# 🏗 System Architecture

```
Mobile Camera (Flutter)
        ↓
Capture Frames
        ↓
Send Image to Backend API
        ↓
Python Backend (Flask)
        ↓
Hand Detection (MediaPipe)
        ↓
Gesture Recognition Logic
        ↓
Sentence Builder
        ↓
Text + Speech Output
```

---

# 🛠 Technologies Used

## Frontend

• Flutter
• Dart
• Camera Plugin
• HTTP API Communication

## Backend

• Python
• Flask
• OpenCV
• MediaPipe

## Other Tools

• Git & GitHub
• Android Studio
• VS Code

---

# 📂 Project Structure

```
sign-language-translator
│
├── android
├── ios
├── lib
├── web
├── windows
│
├── AI_SIGN_LANGUAGE-TRANSLATOR_
│     └── SIGN_LANGUAGE_TRANSLATOR_
│          ├── main.py
│          ├── detector.py
│          ├── motion_tracker.py
│          ├── word_engine.py
│          ├── gestures_rules.py
│          ├── sentence_build.py
│          ├── config.py
│          └── vocabulary.py
│
└── README.md
```

---

# ⚙️ How to Run the Project

## 1️⃣ Backend Setup

Navigate to the backend folder

```
cd SIGN_LANGUAGE_TRANSLATOR_
```

Install required dependencies

```
pip install flask opencv-python mediapipe numpy
```

Run the backend server

```
python main.py
```

The server will start at:

```
http://localhost:5000
```

---

## 2️⃣ Frontend Setup

Navigate to the Flutter project folder

```
cd Project1
```

Install dependencies

```
flutter pub get
```

Run the app

```
flutter run
```

---

# 📷 Sample Output

The system detects hand gestures and displays:

```
Detected Word: HELLO
Sentence: HELLO HOW ARE YOU
```

It can also convert the sentence into **speech output**.

---

# ⚠️ Limitations

• Limited vocabulary set
• Works best with clear lighting
• Requires proper hand positioning
• Currently supports single-hand gestures

---

# 🔮 Future Improvements

• Support full sign language dictionary
• Improve gesture recognition accuracy
• Deploy backend to cloud server
• Add multilingual translation
• Improve real-time processing speed

---

# 🎓 Academic Use

This project was developed as part of an academic project to demonstrate the use of **Artificial Intelligence, Computer Vision, and Mobile Development** in assistive technology.

---

# 👨‍💻 Authors

Rohith Krishna
Sriram

GitHub
https://github.com/CR7-GOAT28

---

# ⭐ If you like this project

Give it a star on GitHub ⭐
