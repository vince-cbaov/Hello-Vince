import tkinter as tk
from PIL import Image, ImageTk

def main():
    root = tk.Tk()
    root.title("Test Repo")
    root.geometry("300x200")

    container = tk.Frame(root)
    container.pack(expand=True)

    image = Image.open("assets/globe.png")
    image = image.resize((64, 64))
    photo = ImageTk.PhotoImage(image)

    icon = tk.Label(container, image=photo)
    icon.image = photo  # prevents garbage collection
    icon.pack(pady=5)

    text = tk.Label(container, text="Hello, World!", font=("Arial", 20))
    text.pack()

    root.mainloop()

if __name__ == "__main__":
    main()