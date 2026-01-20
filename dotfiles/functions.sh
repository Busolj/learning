gpush() {
    local DIRS=(
        "/home/busolj/Documents/my/learning/"
    )

    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "[!] Not a git repository"
        return 1
    fi

    local VALID_DIR=false
    for dir in "${DIRS[@]}"; do
        if [ -d "$dir" ]; then
            VALID_DIR=true
            break
        fi
    done

    if [ "$VALID_DIR" = false ]; then
        echo "[!] None of the configured directories exist in this repository"
        return 1
    fi

    local DATE
    DATE=$(date +"%Y-%m-%d")

    echo "[+] Adding configured directories..."
    for dir in "${DIRS[@]}"; do
        if [ -d "$dir" ]; then
            git add "$dir"
        fi
    done

    if git diff --cached --quiet; then
        echo "[i] No changes to commit in the configured directories"
        return 0
    fi

    echo "[+] Creating commit..."
    git commit -m "auto commit ${DATE}"

    echo "[+] Pushing to remote..."
    git push
}
