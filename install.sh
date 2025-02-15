#!/bin/bash

# بررسی نصب بودن GitHub CLI؛ در صورت عدم وجود، نصب می‌شود.
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI یافت نشد. در حال نصب..."
    sudo apt update
    sudo apt install -y curl gpg
    # افزودن مخزن رسمی GitHub CLI
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
fi

# دریافت نام کاربری و رمز عبور از کاربر
read -p "لطفاً نام کاربری GitHub خود را وارد کنید: " GH_USERNAME
read -sp "لطفاً رمز عبور GitHub خود را وارد کنید: " GH_PASSWORD
echo

# بررسی نصب بودن expect؛ در صورت عدم وجود، نصب می‌شود.
if ! command -v expect &> /dev/null; then
    echo "برنامه expect یافت نشد. در حال نصب..."
    sudo apt update
    sudo apt install -y expect
fi

# استفاده از expect برای انجام احراز هویت در GitHub CLI
expect <<EOF
spawn gh auth login
# انتخاب حساب: GitHub.com
expect "*What account do you want to log into?*"
send "GitHub.com\r"
# انتخاب پروتکل: HTTPS
expect "*preferred protocol for Git operations?*"
send "HTTPS\r"
# تایید استفاده از اعتبارنامه GitHub برای احراز هویت
expect "*Authenticate Git with your GitHub credentials?*"
send "Y\r"
# انتخاب روش احراز هویت: ورود با نام کاربری و رمز عبور (گزینه ۳)
expect "*How would you like to authenticate?*"
send "3\r"
# ارسال نام کاربری
expect "*Username*:"
send "$GH_USERNAME\r"
# ارسال رمز عبور
expect "*Password*:"
send "$GH_PASSWORD\r"
expect eof
EOF

echo "فرآیند احراز هویت تکمیل شد."
