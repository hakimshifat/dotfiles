import os
import re
import shutil
import sys
import subprocess
import urllib.parse

# --- CONFIGURATION ---
PRIVATE_VAULT_PATH = "/home/sifat/Documents/ob_vault" 
ATTACHMENTS_FOLDER = "attachments"
PUBLIC_REPO_PATH = "/home/sifat/Documents/Public-Archive" 
PUBLIC_IMG_PATH = "assets"  
# ---------------------

def process_single_note(source_path):
    """Processes a single markdown file, copies images, and updates links."""
    print(f"Processing: {source_path}")

    try:
        with open(source_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {source_path}: {e}")
        return False

    # 2. IMAGE DETECTION
    md_links = re.findall(r'(!\[.*?\]\((.*?)\))', content)
    wiki_links = re.findall(r'!..\[(.*?)(?:\|.*?)?\]..', content)

    all_images = []

    # Process Standard MD Links
    for full_tag, raw_path in md_links:
        decoded_path = urllib.parse.unquote(raw_path)
        filename = os.path.basename(decoded_path)
        all_images.append({'filename': filename, 'original_text': full_tag})

    # Process Wikilinks
    for filename in wiki_links:
        all_images.append({'filename': filename, 'original_text': f"![[{filename}]]"})

    if all_images:
        print(f"Found {len(all_images)} images. Processing...")

    # 3. PROCESS IMAGES
    public_img_full_path = os.path.join(PUBLIC_REPO_PATH, PUBLIC_IMG_PATH)
    os.makedirs(public_img_full_path, exist_ok=True)

    for img in all_images:
        fname = img['filename']
        src_img = os.path.join(PRIVATE_VAULT_PATH, ATTACHMENTS_FOLDER, fname)
        
        if os.path.exists(src_img):
            shutil.copy(src_img, os.path.join(public_img_full_path, fname))
            
            # URL Encode the filename for GitHub compatibility
            encoded_fname = urllib.parse.quote(fname)
            new_link = f"![]({PUBLIC_IMG_PATH}/{encoded_fname})"
            
            content = content.replace(img['original_text'], new_link)
            print(f" -> Migrated: {fname}")
        else:
            print(f" -> Warning: Image '{fname}' not found at {src_img}")

    # 4. WRITE FILE
    dest_filename = os.path.basename(source_path)
    dest_path = os.path.join(PUBLIC_REPO_PATH, dest_filename)

    try:
        with open(dest_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Note '{dest_filename}' copied and links updated.")
        return True
    except Exception as e:
        print(f"Error writing to {dest_path}: {e}")
        return False

def git_push(message):
    """Commit and push changes in the public repository."""
    original_cwd = os.getcwd()
    try:
        os.chdir(PUBLIC_REPO_PATH)
        subprocess.run(["git", "add", "."])
        # Check if there are changes to commit
        status = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True)
        if status.stdout.strip():
            subprocess.run(["git", "commit", "-m", message])
            subprocess.run(["git", "push"])
            print("Pushed to GitHub.")
        else:
            print("No changes to commit.")
    finally:
        os.chdir(original_cwd)

def publish(path_arg):
    # --- 0. CLEANUP INPUT ---
    path_arg = path_arg.replace('\\', '')

    # 1. SMART FIND LOGIC
    if os.path.exists(path_arg):
        source_path = os.path.abspath(path_arg)
    else:
        # Try finding in vault
        source_path = os.path.join(PRIVATE_VAULT_PATH, path_arg)
        if not os.path.exists(source_path):
            print(f"Searching for '{path_arg}' in vault...")
            found_path = None
            for root, dirs, files in os.walk(PRIVATE_VAULT_PATH):
                if path_arg in files:
                    found_path = os.path.join(root, path_arg)
                    break
                if path_arg in dirs:
                    found_path = os.path.join(root, path_arg)
                    break
            if found_path:
                source_path = found_path
            else:
                print(f"Error: '{path_arg}' not found.")
                return

    if os.path.isdir(source_path):
        print(f"Publishing directory: {source_path}")
        any_success = False
        for root, _, files in os.walk(source_path):
            for file in files:
                if file.endswith(".md"):
                    file_path = os.path.join(root, file)
                    if process_single_note(file_path):
                        any_success = True
        if any_success:
            git_push(f"Update directory {os.path.basename(source_path)}")
    else:
        if process_single_note(source_path):
            git_push(f"Update {os.path.basename(source_path)}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python publish.py <NoteName.md or Directory>")
    else:
        publish(sys.argv[1])