#!/bin/bash
# Clear the screen
clear
echo "Cover Letter"
echo ""
sleep 1
# -------------------- User Inputs --------------------
read -rp "Recipient Name: " recipient_name
read -rp "Recipient Address (Company, Street, City, State, ZIP): " recipient_address
read -rp "Your Name: " sender_name
read -rp "Your Address (Street, City, State, ZIP): " sender_address
read -rp "Position you are applying for (optional): " position
echo "Please enter the content for your cover letter sections."
read -rp "1. Introduction: " introduction
read -rp "2. Body Paragraph 1: " body1
read -rp "3. Body Paragraph 2: " body2
read -rp "4. Closing: " closing
# -------------------- File Paths --------------------
output_dir="$(pwd)"
output_name="cover_letter"
pdf_file="$output_dir/${output_name}.pdf"
temp_tex="$output_dir/${output_name}_temp.tex"
# -------------------- LaTeX Template --------------------
cat > "$temp_tex" <<EOF
\documentclass[12pt]{letter}
\usepackage{helvet}
\renewcommand{\familydefault}{\sfdefault}
\raggedbottom
\signature{$sender_name}
\address{$sender_address}
\begin{document}
\begin{letter}{$recipient_name\\$recipient_address}
\opening{Dear $recipient_name,}
$introduction
$body1
$body2
$closing
\closing{Sincerely,}
\end{letter}
\end{document}
EOF
#PDF Silent
pdflatex -interaction=nonstopmode -output-directory="$output_dir" "$temp_tex" > /dev/null 2>&1
# Cleanup
rm -f "$temp_tex"
rm -f "$output_dir/${output_name}.aux" "$output_dir/${output_name}.log"
# Done
echo "saved to - "
echo "$pdf_file"
echo "🎉"
exit 0
