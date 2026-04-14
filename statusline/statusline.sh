#!/usr/bin/env bash

# Claude Code Custom Status Line
# Line 1: Context bricks | percentage | tokens
# Line 2: [Model] repo | session excerpts

# Read JSON from stdin
input=$(cat)

# Parse Claude data
model=$(echo "$input" | jq -r '.model.display_name // "Claude"' | sed 's/Claude //')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // env.PWD')

# Get repo/directory name
cd "$current_dir" 2>/dev/null || cd "$HOME"
if git rev-parse --git-dir > /dev/null 2>&1; then
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
fi
# Fall back to current directory name
if [[ -z "$repo_name" ]]; then
    repo_name=$(basename "$current_dir")
fi
# Show worktree context (e.g. "nixfiles/echo" instead of just "echo")
if [[ "$current_dir" =~ worktrees/([^/]+/[^/]+) ]]; then
    repo_name="${BASH_REMATCH[1]}"
fi

# Extract transcript path from JSON
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')

# Get model ID for context limit detection
model_id=$(echo "$input" | jq -r '.model.id // ""')

# Determine context limit based on model
case "$model_id" in
    *"opus-4"*) total_tokens=150000 ;;
    *"sonnet-4"*|*"sonnet-3-7"*) total_tokens=150000 ;;
    *"haiku"*) total_tokens=150000 ;;
    *) total_tokens=150000 ;;
esac

# Parse transcript for token usage
if [[ -f "$transcript_path" && -s "$transcript_path" ]]; then
    last_usage=$(grep '"type":"assistant"' "$transcript_path" 2>/dev/null | \
                 tail -1 | \
                 jq -r '.message.usage // null' 2>/dev/null)

    if [[ -n "$last_usage" && "$last_usage" != "null" ]]; then
        used_tokens=$(echo "$last_usage" | jq '
            (.input_tokens // 0) +
            (.cache_read_input_tokens // 0) +
            (.cache_creation_input_tokens // 0) +
            (.output_tokens // 0)
        ')
    else
        used_tokens=0
    fi

    if [[ ! "$used_tokens" =~ ^[0-9]+$ ]]; then
        used_tokens=0
    fi
else
    used_tokens=0
fi

free_tokens=$((total_tokens - used_tokens))
usage_pct=$(( (used_tokens * 100) / total_tokens ))

# Convert to 'k' format
used_k=$(( used_tokens / 1000 ))
total_k=$(( total_tokens / 1000 ))
free_k=$(( free_tokens / 1000 ))

# Line 1: Context brick bar (25 bricks, no prefix)
total_bricks=25
used_bricks=$(( (used_tokens * total_bricks) / total_tokens ))
free_bricks=$((total_bricks - used_bricks))

# Color the used portion based on usage level
if [[ $usage_pct -ge 80 ]]; then
    used_color="\033[1;31m"   # red when high
elif [[ $usage_pct -ge 50 ]]; then
    used_color="\033[0;33m"   # yellow when moderate
else
    used_color="\033[0;36m"   # cyan when low
fi

# Line 1: Repo + Model + Context bricks
line1=""
if [[ -n "$repo_name" ]]; then
    line1+="\033[1;32m$repo_name\033[0m "
fi
line1+="\033[1;36m[$model]\033[0m "

line1+="["
for ((i=0; i<used_bricks; i++)); do
    line1+="${used_color}■\033[0m"
done
for ((i=0; i<free_bricks; i++)); do
    line1+="\033[2;37m□\033[0m"
done
line1+="] \033[1m${usage_pct}%\033[0m (${used_k}k/${total_k}k) \033[1;32m${free_k}k free\033[0m"

# Line 2: Session topic (first and latest user messages)
session_line=""
if [[ -f "$transcript_path" && -s "$transcript_path" ]]; then
    # Extract user messages, handling both string and array content types
    # Use NUL delimiter to avoid multiline prompt issues
    user_msgs=$(grep '"type":"user"' "$transcript_path" 2>/dev/null | \
                jq -r '.message.content | if type == "string" then .
                    elif type == "array" then map(select(.type == "text") | .text) | join(" ")
                    else empty end' 2>/dev/null)

    # Count messages by records (one per jq output), not lines
    msg_count=0
    first_msg=""
    latest_msg=""
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            msg_count=$((msg_count + 1))
            # Collapse multiline to single line for display
            clean=$(echo "$line" | tr '\n' ' ' | cut -c1-40)
            if [[ $msg_count -eq 1 ]]; then
                first_msg="$clean"
            fi
            latest_msg="$clean"
        fi
    done < <(grep '"type":"user"' "$transcript_path" 2>/dev/null | \
             jq -r '.message.content | if type == "string" then .
                 elif type == "array" then map(select(.type == "text") | .text) | join(" ")
                 else empty end' 2>/dev/null)

    if [[ $msg_count -gt 0 ]]; then

        session_line+="\033[1;37m\"${first_msg}\"\033[0m"
        if [[ "$msg_count" -gt 1 && "$first_msg" != "$latest_msg" ]]; then
            session_line+=" \033[1;33m»\033[0m \033[0;37m\"${latest_msg}\"\033[0m"
        fi
        session_line+=" \033[2;37m(${msg_count})\033[0m"
    fi
fi

# Output
echo -e "$line1"
if [[ -n "$session_line" ]]; then
    echo -e "$session_line"
fi
