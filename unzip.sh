#!/bin/bash

# baseline code for future updates, needs some updates and furnishing

# function to check if required commands are available
check_dependencies() {
    local missing_deps=()
    
    if ! command -v unzip >/dev/null 2>&1; then
        missing_deps+=("unzip")
    fi
    if ! command -v tar >/dev/null 2>&1; then
        missing_deps+=("tar")
    fi
    if ! command -v gunzip >/dev/null 2>&1; then
        missing_deps+=("gzip")
    fi
    if ! command -v 7z >/dev/null 2>&1; then
        missing_deps+=("p7zip")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Error: Missing required dependencies: ${missing_deps[*]}"
        echo "Please install them using your package manager."
        exit 1
    fi
}

# function to extract zip files
extract_zip() {
    local zip_file="$1"
    local extract_to="$2"
    if ! unzip -q -t "$zip_file" >/dev/null 2>&1; then
        echo "Error: Invalid or corrupted zip file: $zip_file"
        return 1
    fi
    if ! unzip "$zip_file" -d "$extract_to"; then
        echo "Error: Failed to extract $zip_file"
        return 1
    fi
    echo "Extracted: $zip_file to $extract_to"
}

# function to extract tar files
extract_tar() {
    local tar_file="$1"
    local extract_to="$2"
    if ! tar -tf "$tar_file" >/dev/null 2>&1; then
        echo "Error: Invalid or corrupted tar file: $tar_file"
        return 1
    fi
    if ! tar -xf "$tar_file" -C "$extract_to"; then
        echo "Error: Failed to extract $tar_file"
        return 1
    fi
    echo "Extracted: $tar_file to $extract_to"
}

# function to extract gz files
extract_gz() {
    local gz_file="$1"
    local extract_to="$2"
    if ! gzip -t "$gz_file" >/dev/null 2>&1; then
        echo "Error: Invalid or corrupted gz file: $gz_file"
        return 1
    fi
    if ! gunzip -c "$gz_file" > "$extract_to/$(basename "$gz_file" .gz)"; then
        echo "Error: Failed to extract $gz_file"
        return 1
    fi
    echo "Extracted: $gz_file to $extract_to/$(basename "$gz_file" .gz)"
}

# function to extract 7z files
extract_7z() {
    local seven_zip_file="$1"
    local extract_to="$2"
    if ! 7z t "$seven_zip_file" >/dev/null 2>&1; then
        echo "Error: Invalid or corrupted 7z file: $seven_zip_file"
        return 1
    fi
    if ! 7z x "$seven_zip_file" -o"$extract_to"; then
        echo "Error: Failed to extract $seven_zip_file"
        return 1
    fi
    echo "Extracted: $seven_zip_file to $extract_to"
}

# function to process files in the specified directory
extract_files_in_directory() {
    local directory="$1"
    local extraction_failed=0

    # checks if directory is empty
    if [ -z "$(ls -A "$directory")" ]; then
        echo "Warning: Directory is empty"
        return 0
    fi

    for filename in "$directory"/*; do
        # skip if not a regular file
        [ -f "$filename" ] || continue
        
        case "$filename" in
            *.zip)   extract_zip "$filename" "$directory" || ((extraction_failed++)) ;;
            *.tar)   extract_tar "$filename" "$directory" || ((extraction_failed++)) ;;
            *.tar.gz|*.tgz) extract_tar "$filename" "$directory" || ((extraction_failed++)) ;;
            *.gz)    extract_gz "$filename" "$directory" || ((extraction_failed++)) ;;
            *.7z)    extract_7z "$filename" "$directory" || ((extraction_failed++)) ;;
            *.rar)   echo "Warning: RAR extraction not supported. Skipping: $filename" ;;
            *)       echo "Warning: Unsupported file type: $filename" ;;
        esac
    done

    return $extraction_failed
}

# main code block
main() {
    # check requirements first
    check_dependencies

    read -p "Enter the path of the directory containing compressed files: " directory

    if [ ! -d "$directory" ]; then
        echo "Error: The specified path is not a valid directory."
        exit 1
    fi

    if [ ! -w "$directory" ]; then
        echo "Error: No write permission in the specified directory."
        exit 1
    fi 

    extract_files_in_directory "$directory"
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo "All files have been processed successfully!"
    else
        echo "Warning: Failed to extract $exit_code file(s)"
        exit 1
    fi
}

# calling main function
main