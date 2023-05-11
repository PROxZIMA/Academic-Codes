import argparse
import contextlib
from pathlib import Path

import matplotlib.pyplot as plt
import torch
from colorizers import eccv16, load_img, postprocess_tens, preprocess_img, siggraph17
from matplotlib.colors import LogNorm

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--img_path", type=str, default="imgs/ansel_adams3.jpg")
parser.add_argument("--gpu", action="store_true", default=False, help="Whether to use GPU")
parser.add_argument(
    "--basic", action="store_true", default=False, help="Use basic class i.e. without pretrained models"
)
opt = parser.parse_args()

# load colorizers
if not opt.basic:
    print("Loading Pretrained models")
colorizer_eccv16 = eccv16(pretrained=not opt.basic).eval()
colorizer_siggraph17 = siggraph17(pretrained=not opt.basic).eval()
if opt.gpu:
    print("Using GPU")
    colorizer_eccv16.cuda()
    colorizer_siggraph17.cuda()

# default size to process images is 256x256
# grab L channel in both original ("orig") and resized ("rs") resolutions
img = load_img(opt.img_path)
(tens_l_orig, tens_l_rs) = preprocess_img(img, hw=(256, 256))
if opt.gpu:
    tens_l_rs = tens_l_rs.cuda()

# colorizer outputs 256x256 ab map
# resize and concatenate to original L channel
img_bw = postprocess_tens(tens_l_orig, torch.cat((0 * tens_l_orig, 0 * tens_l_orig), dim=1))
out_img_eccv16 = postprocess_tens(tens_l_orig, colorizer_eccv16(tens_l_rs).cpu())
out_img_siggraph17 = postprocess_tens(tens_l_orig, colorizer_siggraph17(tens_l_rs).cpu())

with contextlib.suppress(ValueError):
    plt.imsave(f"imgs_out/{Path(opt.img_path).stem}_eccv16.png", out_img_eccv16)
    plt.imsave(f"imgs_out/{Path(opt.img_path).stem}_siggraph17.png", out_img_siggraph17)

    # plt.figure(figsize=(12, 8))
    fig, ax = plt.subplots(2, 2)
    fig.suptitle("Colorizing Old B&W Images", fontsize=20)

    ax[0, 0].imshow(img, aspect="auto")
    ax[0, 0].set_title("Original")
    ax[0, 0].axis("off")

    ax[0, 1].imshow(img_bw, aspect="auto")
    ax[0, 1].set_title("Input")
    ax[0, 1].axis("off")

    ax[1, 0].imshow(out_img_eccv16, aspect="auto")
    ax[1, 0].set_title("Output (ECCV 16)")
    ax[1, 0].axis("off")

    ax[1, 1].imshow(out_img_siggraph17, aspect="auto")
    ax[1, 1].set_title("Output (SIGGRAPH 17)")
    ax[1, 1].axis("off")

    plt.show()
