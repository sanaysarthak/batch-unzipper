import os
import zipfile
import tarfile
import gzip
import shutil
import py7zr
import rarfile

def extract_zip(zip_file, extract_to):
    with zipfile.ZipFile(zip_file, 'r') as zip_ref:
        zip_ref.extractall(extract_to)
        print(f'Extracted: {zip_file} to {extract_to}')

def extract_tar(tar_file, extract_to):
    with tarfile.open(tar_file, 'r') as tar_ref:
        tar_ref.extractall(extract_to)
        print(f'Extracted: {tar_file} to {extract_to}')

def extract_gz(gz_file, extract_to):
    with gzip.open(gz_file, 'rb') as f_in:
        output_file = os.path.join(extract_to, os.path.basename(gz_file).replace('.gz', ''))
        with open(output_file, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
            print(f'Extracted: {gz_file} to {output_file}')

def extract_7z(seven_zip_file, extract_to):
    with py7zr.SevenZipFile(seven_zip_file, mode='r') as archive:
        archive.extractall(path=extract_to)
        print(f'Extracted: {seven_zip_file} to {extract_to}')

def extract_rar(rar_file, extract_to):
    with rarfile.RarFile(rar_file) as rar_ref:
        rar_ref.extractall(extract_to)
        print(f'Extracted: {rar_file} to {extract_to}')

def extract_files_in_directory(directory):
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)
        if filename.endswith('.zip'):
            extract_zip(filepath, directory)
        elif filename.endswith('.tar') or filename.endswith('.tar.gz'):
            extract_tar(filepath, directory)
        elif filename.endswith('.gz'):
            extract_gz(filepath, directory)
        elif filename.endswith('.7z'):
            extract_7z(filepath, directory)
        elif filename.endswith('.rar'):
            extract_rar(filepath, directory)

if __name__ == "__main__":
    directory = input("Enter the path of the directory containing compressed files: ")
    
    if os.path.isdir(directory):
        extract_files_in_directory(directory)
        print("All files have been extracted!")
    else:
        print("The specified path is not a valid directory.")
