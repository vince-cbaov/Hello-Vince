# Hello World Demo Project

This repository demonstrates two simple ways to display a “Hello” message with an icon:

1.  A **static web page** (`index.html`)
2.  A **Python desktop application** (`app.py`) using Tkinter

Both examples use the same image asset (`assets/globe.png`) to keep the UI consistent.

***

## Project Structure

    .
    ├── index.html
    ├── app.py
    └── assets/
        └── globe.png

***

## index.html (Web Version)

`index.html` is a minimal HTML5 page that shows an icon and a greeting message centered on the screen.

### What it does

*   Uses standard HTML and CSS only (no JavaScript)
*   Centers content vertically and horizontally using Flexbox
*   Displays an image (`globe.png`) above a text greeting
*   Uses system fonts for a native, clean appearance

### Layout overview

*   `<html>` and `<body>` are set to full height
*   A `.container` div uses Flexbox for centering
*   The image is fixed at 32×32 pixels
*   The greeting text (“Hello, Vince!”) appears below the icon

### Viewing in a browser

You **can** open `index.html` directly by double‑clicking it, but using a local web server is recommended (see below), especially if you later expand the project.

***

## Running the Web Version with a Local Server

### Why use `python -m http.server`?

Running a local web server:

*   Mimics how files are served in real environments
*   Avoids browser security restrictions (`file://`)
*   Makes relative paths (like `assets/globe.png`) behave correctly
*   Is ideal for testing and demos

### How to use it

From the **root directory of this project**, run:

```bash
python -m http.server 8000
```

### What this command does

*   `python -m http.server`  
    Starts Python’s built‑in HTTP server module
*   `8000`  
    Specifies the port number

By default, it serves **the current directory** over HTTP.

### Accessing the page

After running the command, open your browser and go to:

    http://localhost:8000

Then click `index.html`, or go directly to:

    http://localhost:8000/index.html

You should see:

*   The globe icon
*   The text **“Hello, Vince!”**
*   Content centered on a white background

To stop the server, press **Ctrl + C** in the terminal.

***

## app.py (Desktop App Version)

`app.py` is a small Python desktop application built with **Tkinter**, using **Pillow (PIL)** for image handling.

### What it does

*   Opens a window titled **“Test Repo”**
*   Loads and resizes the globe image
*   Displays the image above a text label
*   Centers content inside the window

### Key components

*   **Tkinter** (`tk`) creates the GUI window
*   **Pillow** (`PIL`) loads and resizes the PNG image
*   A `Frame` acts as a container for layout
*   `Label` widgets display the image and text

The image reference is preserved to prevent Python’s garbage collection from removing it.

***

## Running the Desktop App

### Requirements

Install Pillow if it’s not already installed:

```bash
pip install pillow
```

### Run the app

```bash
python app.py
```

A window will open displaying:

*   A 64×64 globe icon
*   The text **“Hello, World!”**
*   Centered layout in a 300×200 window

***

## Assets

*   `assets/globe.png`  
    Shared image used by both the web and desktop versions.

***

## Purpose

This project is intended for:

*   UI layout experimentation
*   Learning basic HTML/CSS
*   Learning basic Python GUI development
*   Comparing web vs desktop rendering approaches
*   Simple testing or onboarding demos
