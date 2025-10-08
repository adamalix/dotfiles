#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract data from JSON input
model_name=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get git information
if git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null; then
    # Get current branch
    git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")
    
    # Get git status information
    git_status=$(git -C "$cwd" status --porcelain 2>/dev/null)
    
    # Count additions and deletions
    adds=0
    removes=0
    modifications=0
    untracked=0
    
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            status="${line:0:2}"
            case "$status" in
                "A "* | " A"*) ((adds++)) ;;
                "D "* | " D"*) ((removes++)) ;;
                "M "* | " M"* | "MM"*) ((modifications++)) ;;
                "??"*) ((untracked++)) ;;
                "R "* | " R"*) ((modifications++)) ;;  # Renamed files count as modifications
            esac
        fi
    done <<< "$git_status"
    
    # Build git info string
    git_info=""
    if [[ $adds -gt 0 ]]; then git_info+="+${adds}"; fi
    if [[ $removes -gt 0 ]]; then 
        if [[ -n "$git_info" ]]; then git_info+=" "; fi
        git_info+="-${removes}"
    fi
    if [[ $modifications -gt 0 ]]; then 
        if [[ -n "$git_info" ]]; then git_info+=" "; fi
        git_info+="~${modifications}"
    fi
    if [[ $untracked -gt 0 ]]; then 
        if [[ -n "$git_info" ]]; then git_info+=" "; fi
        git_info+="?${untracked}"
    fi
    
    if [[ -n "$git_info" ]]; then
        git_section=" | ${git_branch} (${git_info})"
    else
        git_section=" | ${git_branch}"
    fi
else
    git_section=""
fi

# Get just the directory name (not full path)
dir_name=$(basename "$cwd")

# Color definitions
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
MAGENTA="\033[35m"
CYAN="\033[36m"
DIM="\033[2m"
RESET="\033[0m"

# Colorize git section based on status
if [[ -n "$git_info" ]]; then
    # Color the git info based on what changes exist
    colored_git_info=""
    if [[ $adds -gt 0 ]]; then 
        colored_git_info+="${GREEN}+${adds}${RESET}"
    fi
    if [[ $removes -gt 0 ]]; then 
        if [[ -n "$colored_git_info" ]]; then colored_git_info+=" "; fi
        colored_git_info+="${RED}-${removes}${RESET}"
    fi
    if [[ $modifications -gt 0 ]]; then 
        if [[ -n "$colored_git_info" ]]; then colored_git_info+=" "; fi
        colored_git_info+="${YELLOW}~${modifications}${RESET}"
    fi
    if [[ $untracked -gt 0 ]]; then 
        if [[ -n "$colored_git_info" ]]; then colored_git_info+=" "; fi
        colored_git_info+="${MAGENTA}?${untracked}${RESET}"
    fi
    
    git_section=" ${DIM}|${RESET} ${CYAN}${git_branch}${RESET} ${DIM}(${RESET}${colored_git_info}${DIM})${RESET}"
else
    git_section=" ${DIM}|${RESET} ${CYAN}${git_branch}${RESET}"
fi

# Output the colorful status line with explicit echo -e to interpret escape sequences
echo -e "${BLUE}${dir_name}${RESET} ${DIM}|${RESET} ${MAGENTA}${model_name}${RESET}${git_section}"