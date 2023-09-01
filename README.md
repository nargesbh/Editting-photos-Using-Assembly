# Assembly Image Processing

This GitHub repository contains assembly code for performing image processing tasks. The code is designed to manipulate image files, specifically in the BMP (bitmap) format. It provides functionality for opening, reading, modifying, and saving BMP image files.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [File Structure](#file-structure)
- [Contributing](#contributing)

## Introduction

This assembly code is designed to work with BMP image files and provides several image processing capabilities. It uses Linux system calls to interact with files and directories, allowing you to perform the following operations:

- **Creating a File**: Creates a new file with read and write permissions.
- **Opening a File**: Opens an existing file for reading and writing.
- **Writing to a File**: Writes data to an open file.
- **Reading from a File**: Reads data from an open file.
- **Closing a File**: Closes an open file.
- **Opening a Directory**: Opens a directory for further operations.
- **Creating a Directory**: Creates a new directory.
- **Listing Directory Contents**: Retrieves information about files and directories within an opened directory.

Additionally, this code includes functionality to process BMP images. It can detect BMP files, extract image dimensions, find pixel padding, and modify pixel values.

## Prerequisites

Before using this code, ensure you have the following:

- A Linux environment: This code is designed to run on Linux systems.
- NASM (Netwide Assembler): You need NASM to assemble the code.
- GCC (GNU Compiler Collection): You may need GCC to link the assembled code.
- Basic knowledge of x86 assembly language: Familiarity with assembly programming is recommended.

## File Structure

- `image_processing.asm`: The main assembly code for image processing.
- `in_out.asm`: External assembly code for input and output operations.
- `README.md`: This README file.

## Contributing

Contributions to this project are welcome. If you'd like to enhance the code or add new features, please fork the repository and submit a pull request.
