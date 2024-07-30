#!/bin/zsh

# import colors
# shellcheck source=colors.zsh
PATH_TO_COLORS=$(dirname "$0")/colors.zsh
source "$PATH_TO_COLORS"

# Print the table header
print_header() {
    printf "${CYAN}%-30s %-20s %-30s${NC}\n" "File" "Status" "Reason"
}

# Check if the README file needs to be generated
needs_generation() {
    local file="$1"
    local mdfile="$2"

    if [ ! -f "$mdfile" ]; then
        printf "%-30s ${GREEN}%-20s${NC} ${RED}%-30s${NC}\n" "$file" "Generating" "File does not exist"
        return 0
    elif [ "$file" -nt "$mdfile" ]; then
        printf "%-30s ${YELLOW}%-20s${NC} ${CYAN}%-30s${NC}\n" "$file" "Generating" "Source file is newer"
        return 0
    elif [ ! -s "$mdfile" ] || [ -z "$(grep -v '^[[:space:]]*$' "$mdfile")" ]; then
        printf "%-30s ${YELLOW}%-20s${NC} ${RED}%-30s${NC}\n" "$file" "Generating" "README is empty"
        return 0
    else
        printf "%-30s ${BLUE}%-20s${NC} ${CYAN}%-30s${NC}\n" "$file" "Skipping" "README is up to date"
        return 1
    fi
}

# Generate the README file
generate_readme() {
    local file="$1"
    local mdfile="$2"
    cargo readme -i "$file" -o "$mdfile"
}

# Process each file
process_file() {
    local file="$1"
    local mdfile="docs/$(basename "$file" .rs).md"

    if needs_generation "$file" "$mdfile"; then
        generate_readme "$file" "$mdfile"
    fi
}

if [ ! -d docs ]; then
    mkdir docs
fi

# Print the table header
print_header

# Generate README files for Rust source files in src directory
# Skip lib.rs files and binaries under src/bin
#
# find src -name '*.rs' ! -name 'lib.rs' ! -path 'src/bin/*' | while read -r file; do
find src -name '*.rs' ! -name 'lib.rs' ! -path 'src/bin/*' | while read -r file; do
    process_file "$file"
done
