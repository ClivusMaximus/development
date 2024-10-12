""" Animation module for creating a gif from a series of images. """
import glob
import os
from PIL import Image
import cv2

def create_animation(image_files):
    """ Creates an animation from a series of images. """
    image_paths = sorted(image_files, key=lambda f: os.path.getmtime(f))
    images = []
    image_count = len(image_paths)
    for image_path in image_paths:
        image = Image.open(image_path)
        images.append(image)
        image_count -= 1
        print(f"Got {image_count} images left for animation.")

    last_image = Image.open(image_paths[len(image_paths)-1])
    animation = Image.new("RGB", (last_image.width, last_image.height))
    animation.save("./animation.gif", save_all=True, append_images=images, duration=250, loop=1)

    for image in images:
        image.close()


def create_video(image_files):
    """ Creates a video from a series of images. """
    image_paths = sorted(image_files, key=lambda f: os.path.getmtime(f))
    image_count = len(image_paths)

    img = cv2.imread(image_paths[0])
    height, width, layers = img.shape
    frames_per_second = 10
    fourcc = cv2.VideoWriter_fourcc(*"mp4v")
    out = cv2.VideoWriter("./high_quality_animation.mp4", fourcc, frames_per_second, (width, height))

    for image_path in image_paths:
        img = cv2.imread(image_path)
        out.write(img)
        image_count -= 1
        print(f"Got {image_count} images left for video.")

    out.release()

if __name__ == "__main__":
    files = glob.glob("./snaps/*.jpg")
    create_video(files)
    # create_animation(files)
