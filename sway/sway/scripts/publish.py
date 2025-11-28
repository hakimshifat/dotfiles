import os
import re
import shutil
import sys
import subprocess
import urllib.parse

# --- CONFIGURATION ---
# Check your path: "Documents" vs "Docuements"
PRIVATE_VAULT_PATH = "/home/sifat/Docuements/ob_vault" 
ATTACHMENTS_FOLDER = "attachments"
PUBLIC_REPO_PATH = "/home/sifat/Docuements/Public-Archive" 
PUBLIC_IMG_PATH = "assets"  # Changed to 'assets' to match your screenshot
# ---------------------

import os
import re
import shutil
import sys
import subprocess
import urllib.parse

# --- CONFIGURATION ---
# Kept your path spelling "Docuements" as per your logs
PRIVATE_VAULT_PATH = "/home/sifat/Docuements/ob_vault" 
ATTACHMENTS_FOLDER = "attachments"
PUBLIC_REPO_PATH = "/home/sifat/Docuements/Public-Archive" 
PUBLIC_IMG_PATH = "assets"  
# ---------------------

def publish_note(note_filename):
    # --- 0. CRITICAL FIX: CLEANUP INPUT ---
    # Obsidian Shell Commands plugin adds backslashes (e.g., "\/home\/user"). 
    # We strip them to get the real path.
    note_filename = note_filename.replace('\\', '')

    # 1. SMART FIND LOGIC
    if os.path.exists(note_filename):
        source_path = os.path.abspath(note_filename)
    else:
        source_path = os.path.join(PRIVATE_VAULT_PATH, note_filename)
        if not os.path.exists(source_path):
            print(f"Searching for '{note_filename}' in vault...")
            found_path = None
            for root, dirs, files in os.walk(PRIVATE_VAULT_PATH):
                if note_filename in files:
                    found_path = os.path.join(root, note_filename)
                    break
            if found_path:
                source_path = found_path
            else:
                print(f"Error: Note '{note_filename}' not found.")
                return

    print(f"Processing: {source_path}")

    with open(source_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 2. IMAGE DETECTION
    md_links = re.findall(r'(!\[.*?\]\((.*?)\))', content)
    wiki_links = re.findall(r'!\[\[(.*?)(?:\|.*?)?\]\]', content)

    all_images = []

    # Process Standard MD Links
    for full_tag, raw_path in md_links:
        decoded_path = urllib.parse.unquote(raw_path)
        filename = os.path.basename(decoded_path)
        all_images.append({'filename': filename, 'original_text': full_tag})

    # Process Wikilinks
    for filename in wiki_links:
        all_images.append({'filename': filename, 'original_text': f"![[{filename}]]"})

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

    with open(dest_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print("Note copied and links updated.")

    # 5. GIT PUSH
    os.chdir(PUBLIC_REPO_PATH)
    subprocess.run(["git", "add", "."])
    subprocess.run(["git", "commit", "-m", f"Update {dest_filename}"])
    subprocess.run(["git", "push"])
    print("Pushed to GitHub.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python publish.py <NoteName.md>")
    else:
        publish_note(sys.argv[1])
