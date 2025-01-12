function notes() {
	fd --extension md | while IFS= read -r file; do echo -e "### BEGIN $(basename $(pwd))/$file\n"; cat "$file"; echo -e "\n### END\n"; done > /tmp/Roi-Sorcier.txt
}
