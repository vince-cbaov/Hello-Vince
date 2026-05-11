import tkinter as tk
from PIL import Image, ImageTk

def show_text():
    text_label.pack()

def main():
    root = tk.Tk()
    root.title("Hello World App")
    root.geometry("300x250")

    container = tk.Frame(root)
    container.pack(expand=True)

    # Load image
    image = Image.open("assets/globe.png")
    image = image.resize((64, 64))
    photo = ImageTk.PhotoImage(image)

    icon = tk.Label(container, image=photo)
    icon.image = photo  # prevent garbage collection
    icon.pack(pady=10)

    # Button
    button = tk.Button(
        container,
        text="Push Button",
        command=show_text,
        bg="#0078d4",
        fg="white"
    )
    button.pack(pady=10)

    # Hidden text (initially not packed)
    global text_label
    text_label = tk.Label(
        container,
        text="DevOps Engineer!",
        font=("Arial", 28)
    )

    root.mainloop()

if __name__ == "__main__":
    main()
