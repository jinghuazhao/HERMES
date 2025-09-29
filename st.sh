#!/usr/bin/bash

git add .gitignore
git commit -m '.gitignore'
git add README.md
git commit -m "README"
git add 0_setup.sh
git commit -m "setup"
git add 1_lookup.sh
git commit -m "lookup"
git add 2_lz.sh
git commit -m "locuszoom"
git add results/
git commit -m "results"
git add st.sh
git commit -m "st.sh"
git push
