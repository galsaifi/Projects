# Fashion MNIST Classification with PyTorch

This repository contains a simple deep learning model implemented in PyTorch to classify images from the **Fashion MNIST dataset**. The dataset consists of grayscale images of clothing items categorized into 10 different classes.

## Features
- Loads the **Fashion MNIST dataset** from Zalando's research repository.
- Implements a **custom PyTorch Dataset class** to handle IDX-formatted data.
- Defines a **fully connected neural network (SimpleFashionNet)** for classification.
- Uses **SGD optimizer with CrossEntropyLoss** for training.
- Provides **training and evaluation loops** to track model performance.
- Saves and loads trained models for future inference.

## Dataset
The dataset is loaded directly from the official **Fashion MNIST** GitHub repository:
- **Training images**: [train-images-idx3-ubyte.gz](https://github.com/zalandoresearch/fashion-mnist/raw/master/data/fashion/train-images-idx3-ubyte.gz)
- **Training labels**: [train-labels-idx1-ubyte.gz](https://github.com/zalandoresearch/fashion-mnist/raw/master/data/fashion/train-labels-idx1-ubyte.gz)
- **Test images**: [t10k-images-idx3-ubyte.gz](https://github.com/zalandoresearch/fashion-mnist/raw/master/data/fashion/t10k-images-idx3-ubyte.gz)
- **Test labels**: [t10k-labels-idx1-ubyte.gz](https://github.com/zalandoresearch/fashion-mnist/raw/master/data/fashion/t10k-labels-idx1-ubyte.gz)

## Installation
To run the project, install the required dependencies:

```bash
pip install torch torchvision pandas numpy requests plotly
