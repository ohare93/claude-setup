#!/bin/bash
# Stop hook to display context, cache, and cost information in ccstatusline

# Read the JSON data from stdin
json_data=$(cat)

# Extract usage information using jq
input_tokens=$(echo "$json_data" | jq -r '.usage.input_tokens // 0')
output_tokens=$(echo "$json_data" | jq -r '.usage.output_tokens // 0')
cache_read=$(echo "$json_data" | jq -r '.usage.cache_read_input_tokens // 0')
cache_creation=$(echo "$json_data" | jq -r '.usage.cache_creation_input_tokens // 0')

# Calculate total tokens and context
total_input=$((input_tokens + cache_read + cache_creation))
total_tokens=$((total_input + output_tokens))

# Calculate cost (Claude Sonnet 4.5 pricing)
# Input: $3 per million tokens
# Output: $15 per million tokens
# Cache write: $3.75 per million tokens
# Cache read: $0.30 per million tokens
input_cost=$(echo "scale=6; $input_tokens * 3 / 1000000" | bc)
output_cost=$(echo "scale=6; $output_tokens * 15 / 1000000" | bc)
cache_write_cost=$(echo "scale=6; $cache_creation * 3.75 / 1000000" | bc)
cache_read_cost=$(echo "scale=6; $cache_read * 0.30 / 1000000" | bc)
total_cost=$(echo "scale=6; $input_cost + $output_cost + $cache_write_cost + $cache_read_cost" | bc)

# Format numbers with commas for readability
format_number() {
    printf "%'d" "$1" 2>/dev/null || echo "$1"
}

# Build status line
status_line=""

# Context info (total tokens)
ctx_formatted=$(format_number $total_tokens)
status_line="${status_line}ctx: ${ctx_formatted} | "

# Cache info
if [ "$cache_read" -gt 0 ] || [ "$cache_creation" -gt 0 ]; then
    cache_read_formatted=$(format_number $cache_read)
    cache_creation_formatted=$(format_number $cache_creation)
    status_line="${status_line}cache: r:${cache_read_formatted} w:${cache_creation_formatted} | "
fi

# Cost info
status_line="${status_line}cost: \$${total_cost}"

# Output to ccstatusline
echo "$status_line"
